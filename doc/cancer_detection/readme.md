# CAMELYON dataset

|subset|all|normal|metastses|
|:----:|-----:|------:|--------:|
|2016|400|240|160|
|2017 train|500|313|187|
|2017 test(no ground truth)|500|?|?|

# Evaluation

癌症分级金标准是`TMN`, 这里评估N, 并且是简化版的N

输入数据是一人五张WSI， 一张WSI对应一个淋巴结，一张WSI可以分为5类:

1. Negative
2. Isolated tumour cells (ITC)
3. Micro-metastases: metastases greater than 0.2 mm or more than 200 cells, but smaller than 2.0 mm
4. Macro-metastases: metastases greater than 2.0 mm

拥有5张WSI的人可以被诊断为5类:

* pN0: No micro-metastases or macro-metastases or ITCs found.
* pN0(i+): Only ITCs found.
* pN1mi: Micro-metastases found, but no macro-metastases found.
* pN1: Metastases found in 1–3 lymph nodes, of which at least one is a macro-metastasis.
* pN2: Metastases found in 4–9 lymph nodes, of which at least one is a macro-metastasis.

最后使用对test集中500个人的5分类的[kappa score](https://www.wikiwand.com/en/Cohen's_kappa)来排名

# 思路

1. 分层，目前看来整个问题域有4层，pixel，patch，WSI，person
2. 简单方法1: 对WSI分类，然后直接根据分类规则，返回结果
3. 简单方法2: 
	1. 对patch分类
	2. 将patch作为一个点，实现对WSI降维，然后对WSI分类
	3. 根据分类规则，返回结果
4. 复杂做法1:
	1. 对patch做semantic segmentation
	2. 降低patch semantic segmentation 模型参数的学习率，对WSI分类
	3. 降低前两步的学习率，对人分类
4. 复杂做法2: end to end
	* pixel level和WSI level的标注都有，segmentation，classification，object detection的模型都可以上，特别是[Learning to Segment Every Thing](https://arxiv.org/abs/1711.10370)
	
