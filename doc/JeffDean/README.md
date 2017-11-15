# 如何写一个装得下Jeff Dean的数据库
----------------------------
# 目录
- 存储（lsm，b+ leveldb，rocksdb）
	- skiplist
	- lsm
	- b+
	- cache bloom filter
- OLTP
	- 分片 一致性协议 写
		- hash function
		- round robin
		- virtual buckets
		- consistent hash
		- range partition
		- paxos，raft
		- chubby, etcd
- OLAP
	- life of sql 查
		- spanner 
		- query optimizor
	- analysis
		- DAG
		- MapReduce
		- Parameter Server
		- spark vs tensorflow vs angel
	- 硬件加速 GPU FPGA ASIC
- API
	- sql vs http vs gRPC

# 第一步 存储

## 基础数据结构


### skiplist

### B+ tree

### LSM

### bloom filter


## leveldb 101

* Leveldb是Google开源的一个快速，轻量级的key-value存储引擎
* 提供key-value存储，key和value是任意的二进制数据。
* 数据时按照key有序存储的，可以修改排序规则。
* 只提供了Put/Get/Delete等基本操作接口，支持批量原子操作。
* 支持快照功能。
* 支持数据的正向和反向遍历访问。
* 支持数据压缩功能(Snappy压缩)。
* 支持多线程同步，但不支持多进程同时访问。

### LSM(log-structured-merge)
- 磁盘的性能主要受限于磁盘的寻道时间，优化磁盘数据访问的方法是尽量减少磁盘的IO次数。磁盘数据访问效率取决于磁盘IO次数，而磁盘IO次数又取决于数据在磁盘上的组织方式。
- 磁盘数据存储大多采用B+树类型数据结构，这种数据结构针对磁盘数据的存储和访问进行了优化，减少访问数据时磁盘IO次数。
	- B+树是一种专门针对磁盘存储而优化的N叉排序树，以树节点为单位存储在磁盘中，从根开始查找所需数据所在的节点编号和磁盘位置，将其加载到内存中然后继续查找，直到找到所需的数据。
	- 目前数据库多采用两级索引的B+树，树的层次最多三层。因此可能需要5次磁盘访问才能更新一条记录（三次磁盘访问获得数据索引及行ID，然后再进行一次数据文件读操作及一次数据文件写操作）。
	- 但是由于每次磁盘访问都是随机的，而传统机械硬盘在数据随机访问时性能较差，每次数据访问都需要多次访问磁盘影响数据访问性能。
- LSM树可以看作是一个N阶合并树。
	- 写
		- 数据写操作（包括插入、修改、删除）都在内存中进行，并且都会创建一个新记录（修改会记录新的数据值，而删除会记录一个删除标志）
		- 这些数据在内存中仍然还是一棵排序树，当数据量超过设定的内存阈值后，会将这棵排序树和磁盘上最新的排序树合并
		- 当这棵排序树的数据量也超过设定阈值后，和磁盘上下一级的排序树合并。合并过程中，会用最新更新的数据覆盖旧的数据（或者记录为不同版本）
	- 读
		- 在需要进行读操作时，总是从内存中的排序树开始搜索，如果没有找到，就从磁盘上的排序树顺序查找。
- Leveldb和传统的存储引擎(如Innodb，BerkeleyDb)最大的区别是leveldb的数据存储方式采用的是LSM的实现方法，传统的存储引擎大多采用的是B+树系列的方法。
	- 在LSM树上进行一次数据更新不需要磁盘访问，在内存即可完成，速度远快于B+树。当数据访问以写操作为主，而读操作则集中在最近写入的数据上时，使用LSM树可以极大程度地减少磁盘的访问次数，加快访问速度。

### leveldb detail
- Leveldb采用LSM思想设计存储结构
- 各个存储文件也是分层的(*level*)
- 文件
	- memtable
	- immutable table
	- log 
		- 与memtable，immutable table对应，immutable table与level0合并之后，对应log删除
	- level n的sst文件
	- Manifest 记录sst文件名与key range的对应关系
	- Current 当前Manifest的文件名
	- LOCK文件等，用来保证同一时刻只有一个进程打开该数据库
- 写
	- 新插入的值放在内存表中，称为memtable
		- 内存中的memtable是SkipList(跳表)
		- 空间来换取时间
		- 跳表是平衡树的一种替代的数据结构，但是和红黑树不相同的是，跳表对于树的平衡的实现是基于一种随机化的算法的
		- 如果是说链表是排序的，并且节点中还存储了指向前面第二个节点的指针的话，那么在查找一个节点时，仅仅需要遍历N/2个节点即可。
		- `/db/skiplist.h`
		- 在跳表中，每个节点除了存储指向直接后继的节点之外，还随机的指向后代节点。如果一个节点存在k个向前的指针的话，那么陈该节点是k层的节点。一个跳表的层MaxLevel义为跳表中所有节点中最大的层数。而每个节点的层数是在插入该节点时随机生成的，范围在[0,MaxLevel]。
	- 称为memtable写满时变为immutable table，并建立新的memtable接收写操作
	- 进行minor Compaction， 将immutable table写入level0\
		- level n(n>=0) 以.sst文件存储
		- 文件被划分成默认32K大小的block。每个block中是一系列的记录
			```
				record:=
                        checksum:uint32 //存放该记录data的crc32校验值
                        length:uint16 //data长度
                        type:uint8 //FULL,FIRST,MIDDLE,LAST,记录类型
                        data:uint8[length] //记录内容
			```
			
		- sst
			- 一个sst数据文件包含多个data block,多个种类的metablock,一个metaindex block和一个index block,文件的末尾存放的是一个固定长度的Footer类型。
			```
            				<beginning_of_file>
                              [data block 1]
                              [data block 2]
                              ...
                              [data block N]
                              [meta block 1]
                              ...
                              [meta block K]
                              [metaindex block]
                              [index block]
                              [Footer]       (fixed size; starts at file_size - sizeof(Footer))
                            <end_of_file>
            ```
			
			```
			record:
            
                 shared_bytes: varint32 //key共享前缀长度，完整的key为0
                 unshared_bytes: varint32 //key私有数据长度
                 value_length: varint32 //value数据长度
                 key_delta: char[unshared_bytes] //key私有数据
                 value: char[value_length] //value
            ```
			
	- 进行major Compaction， 将level n(n>=0)与level n+1层合并

# 第二部 OLTP

# 第三步 OLAP

# 第四步 API


# Reference
## Hallmarks
- [2000 Paxos] The Part-Time Parliament
- [2003 GFS] The Google File System
- [2004 MapReduce] MapReduce: Simplified Data Processing on Large Clusters
- [2007 Dynamo] Dynamo: Amazon’s Highly Available Key-value Store
- [2006 Bigtable] Bigtable: A Distributed Storage System for Structured Data
- [2006 Chubby] The Chubby lock service for loosely-coupled distributed systems
- [2009 RAMCloud] RAMCloud: Scalable High-Performance Storage Entirely in DRAM
- [2010 Percolator] Large-scale Incremental Processing Using Distributed Transactions and Notifications
- [2012 DistBelief] Large Scale Distributed Deep Networks
- [2012 Spanner] Spanner: Google’s Globally-Distributed Database
- [2013 F1] F1: A Distributed SQL Database That Scales
- [2013 Petuum] Petuum: A New Platform for Distributed Machine Learning on Big Data
- [2013 Spark] Resilient Distributed Datasets: A Fault-Tolerant Abstraction for In-Memory Cluster Computing
- [2014 Raft] CONSENSUS: BRIDGING THEORY AND PRACTICE
- [2015 TensorFlow] TensorFlow: Large-Scale Machine Learning on Heterogeneous Distributed Systems
- [2017 Spanner] Spanner: Becoming a SQL System
- [2017 Device Placement] Device Placement Optimization with Reinforcement Learning
- [2017 Amazon] Amazon Aurora: Design Considerations for High Throughput Cloud-Native Relational Databases
- [2017 BOAT] BOAT: Building auto-tuners with structured Bayesian optimization
- [2017 MXNET] Scaling Distributed Machine Learning with System and Algorithm Co-design
## other reference
- [1997] A tutorial on Reed-Solomon coding for fault-tolerance in RAID-like systems
- [2000 Paxos] Revisiting the Paxos Algorithm
- [2001 Paxos] Paxos Made Simple
- [2003 Astrolabe] Astrolabe: A Robust and Scalable Technology For Distributed Systems Monitoring, Management, and Data Mining
- [2006] Data Management for Internet-Scale Single-Sign-On
- [2007 Paxos] Paxos Made Live - An Engineering Perspective
- [2007 Dryad] Dryad: Distributed Data-parallel Programs from Sequential Building Blocks
- [2010 Dremel] Dremel: Interactive Analysis of Web-Scale Datasets
- [2010 Hive] Hive - A Petabyte Scale Data Warehouse using Hadoop
- [2010 Pregel] Pregel: A System for Large-Scale Graph Processing
- [2010 Haystack] Finding a Needle in Haystack: Facebook's Photo Storage
- [2011 Megastore] Megastore: Providing Scalable, Highly Available Storage for Interactive Services
- [2011 ] Scaling up Machine Learning: Parallel and Distributed Approaches
- [2012 Databus] Databus: LinkedIn's Change Data Capture Pipeline
- [2012 PowerGraph] PowerGraph: distributed graph-parallel computation on natural graphs
- [2013 F1] Online, Asynchronous Schema Change in F1
- [2013 MillWheel] MillWheel: Fault-Tolerant Stream Processing at Internet Scale
- [2013 LRC] XORing Elephants: Novel Erasure Codes for Big Data
- [2013 Omega] Omega: flexible, scalable schedulers for large compute clusters
- [2013 YARN] Apache Hadoop YARN: yet another resource negotiator
- [2013 Spark thesis] An Architecture for Fast and General Data Processing on Large Clusters
- [2014 Raft] In Search of an Understandable Consensus Algorithm
- [2015 ZooKeeper] ZooKeeper: Wait-free Coordination for Internet-scale Systems
- [2016 TensorFlow] TensorFlow: A system for large-scale machine learning
- [kafka]
- [storm]
- [2017 angel] Angel: A New Large scale Machine Learning System
- [2017 TencentBoost] TencentBoost: A Gradient Boosting Tree System with Parameter Server
- [2017] Heterogeneity-aware Distributed Parameter Servers
- [2017 ] LDA*: A Robust and Large scale Topic Modeling System
- [2017 ] 微软

