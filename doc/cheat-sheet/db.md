# start 

## direct start
```bash
#centos 6 ubuntu
vim /etc/init.d/docker
other_args="-g /sas5/docker --registry-mirror=http://59ab68c4.m.daocloud.io"

sudo /etc/init.d/docker start
 
# centos 7
vim /etc/systemd/system/docker.service.d/docker.conf
/usr/lib/systemd/system/docker.service

FROM:
ExecStart=/usr/bin/docker daemon -H fd://
TO:
ExecStart=/usr/bin/docker daemon -g /new/path/docker -H fd://

sudo systemctl daemon-reload 
sudo systemctl start docker

# CMD
docker run -ti --rm --entrypoint=bash cassandra
docker image ls
docker ps
docker stop/start/restart/rm
```
## docker

```bash
docker pull postgres
docker run --name some-postgres \
	-e POSTGRES_PASSWORD=mysql \
	-e PGDATA=/var/lib/postgresql/data/pgdata  \
	-v /Users/liyanan/dbs/pgdata:/var/lib/postgresql/data \
	-p 5432:5432 \
	-d -it \
	postgres
docker stop some-postgres
# 删除后，如果本地的volume里有文件，则设置的密码无效，原来的密码有效
docker rm some-postgres

docker pull mysql
docker stop some-mysql
docker rm some-mysql 
docker run --name some-mysql \
	-v /Users/liyanan/dbs/mysql:/var/lib/mysql \
	-v /Users/liyanan/dbs/conf/mysql:/etc/mysql/conf.d \
	-p 3306:3306 \
	-e MYSQL_ROOT_PASSWORD=mysql \
	-d -it \
	mysql
docker run --name some-mysql -v /Users/liyanan/dbs/mysql:/var/lib/mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=mysql -d mysql
docker stop some-mysql
docker rm some-mysql
```


# Operation
```bash
mysqldump -h主机名  -P端口 -u用户名 -p密码 –database 数据库名 > 文件名.sql 
mysqldump  --add-drop-table -uusername -ppassword -database databasename > backupfile.sql
mysqldump -hhostname -uusername -ppassword -database databasename | gzip > backupfile.sql.gz
mysqldump -hhostname -uusername -ppassword databasename specific_table1 specific_table2 > backupfile.sql
mysqldump –no-data –databases databasename1 databasename2 databasename3 > structurebackupfile.sql
mysqldump –all-databases > allbackupfile.sql
mysql -hhostname -uusername -ppassword databasename < backupfile.sql
gunzip < backupfile.sql.gz | mysql -uusername -ppassword databasename

# reset password
# my.cnf
[mysqld]
# (liyanan) for reset root password
skip-grant-tables

# restart mysql
flush privileges;
SET PASSWORD FOR 'root'@'%' = PASSWORD('’);
SET PASSWORD FOR 'root’@'localhost' = PASSWORD('’);
# restart mysql
```

# database url

[username[:password]@][protocol[(address)]]/dbname[?param1=value1&...&paramN=valueN]
username:password@protocol(address)/dbname?param=value

* Connect to database through a socket
    * mysql://user@unix(/path/to/socket)/pear
* Connect to database on a non standard port
    * pgsql://user:pass@tcp(localhost:5555)/pear
* Connect to SQLite on a Unix machine using options
    * sqlite:////full/unix/path/to/file.db?mode=0666
* Connect to SQLite on a Windows machine using options
    * sqlite:///c:/full/windows/path/to/file.db?mode=0666
* Connect to MySQLi using SSL
    * mysqli://user:pass@localhost/pear?key=client-key.pem&cert=client-cert.pem
* Connecting to MS Access sometimes requires admin as the user name
    * odbc(access)://admin@/datasourcename
* Connecting to ODBC with a specific cursor 
    * odbc(access)://admin@/datasourcename?cursor=SQL_CUR_USE_ODBC

# SQL
    
```sql
# user
SELECT user,host FROM mysql.user;
DESCRIBE mysql.user;

CREATE USER 'master'@'%' IDENTIFIED BY 'mypass';
ALTER USER 'master'@'%' IDENTIFIED BY 'mypass';
SET PASSWORD FOR 'jeffrey'@'localhost' = PASSWORD('auth_string');
RENAME USER 'jeffrey'@'localhost' TO 'jeff'@'127.0.0.1';

GRANT SELECT ON db2.invoice TO 'jeffrey'@'localhost';
SHOW GRANTS [FOR user]
REVOKE INSERT ON *.* FROM 'jeffrey'@'localhost';

# database
CREATE TABLESPACE db1;
USE db1;

# table
DESCRIBE mysql.user;

CREATE TABLE new_tbl LIKE orig_tbl;
CREATE TABLE new_tbl AS SELECT * FROM orig_tbl;
CREATE TABLE t1 ( a INT NOT NULL, PRIMARY KEY (a));

ALTER TABLE t1 CHARACTER SET = utf8;
ALTER TABLE t1 ADD COLUMN c1 VARCHAR(12);
ALTER TABLE t1 COMMENT = 'New table comment';
ALTER TABLE t2 DROP COLUMN c, DROP COLUMN d;
ALTER TABLE t1 CHANGE a b BIGINT NOT NULL;
ALTER TABLE t1 MODIFY b INT NOT NULL;

# data
INSERT INTO tbl_name (a,b,c) VALUES(1,2,3),(4,5,6),(7,8,9);
UPDATE t1 SET col1 = col1 + 1, col2 = col1;
DELETE FROM somelog WHERE user = 'jcole';
LOAD DATA INFILE 'data.txt' INTO TABLE db2.my_table;

# tranaction

START TRANSACTION;
SELECT @A:=SUM(salary) FROM table1 WHERE type=1;
UPDATE table2 SET summary=@A WHERE type=1;
COMMIT;
```