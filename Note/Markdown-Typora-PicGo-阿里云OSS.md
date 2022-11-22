# Markdown教程

markdown语法+PicGo+阿里云OSS存储图片


---

## 一、基本语法

轻量级标记语言（本质：html）

![image-20220908155216235](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220908155216235.png)


[点击进入 Markdown 教程 (Ctrl+左键打开)](https://www.runoob.com/markdown/md-tutorial.html)

- 标题

- 段落

- 列表

    - 可以嵌套

- 区块

    - 可以嵌套

- 代码

    - 可以实现代码高亮（写出语言种类）

        ```python
        from nltk.stem import WordNetLemmatizer
        
        input_words = ['writing', 'calves', 'be', 'branded', 'horse', 'randomize', 
                'possibly', 'provision', 'hospital', 'kept', 'scratchy', 'code']
        
        # Create lemmatizer object 
        lemmatizer = WordNetLemmatizer()
        
        # Create a list of lemmatizer names for display
        lemmatizer_names = ['NOUN LEMMATIZER', 'VERB LEMMATIZER']
        formatted_text = '{:>24}' * (len(lemmatizer_names) + 1)
        print('\n', formatted_text.format('INPUT WORD', *lemmatizer_names), 
                '\n', '='*75)
        ```

        python代码为例

- 链接
    - 按ctrl+鼠标左键打开网页(地址写全https://www.baidu.com)
    - [百度](https://www.baidu.com)

- 图片
    - \! 前加空格靠左对齐

- 表格

- 高级技巧



**\\反斜线显示出符号**

\# 不会成为一级标题

\* 不会成为列表

...



## 2.Typora图片上传阿里云OSS



### (1) 开通OSS服务，创建Bucket

[阿里云官网](https://www.aliyun.com/)

 ![image-20220908160610875](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220908160610875.png)

点击 “立即开通”

 ![image-20220908162635290](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220908162635290.png)

开通之后点击 “折扣套餐”

![image-20220908162850569](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220908162850569.png)

一年9块（双11 ￥7.x）

购买成功之后管理控制台

 ![image-20220908163016137](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220908163016137.png)

![image-20220908163232692](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220908163232692.png)

 ![image-20220908170826628](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220908170826628.png)

点确认创建

![image-20220908171024438](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220908171024438.png)



 ![image-20220908171124225](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220908171124225.png)

点击创建

 ![image-20220908171203958](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220908171203958.png)

需要手机验证码

![image-20220908171355607](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220908171355607.png)

记录这两个值

### (2) 使用PicGo

安装PicGo，打开

 ![image-20220908171557595](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220908171557595.png)

 ![image-20220908171808050](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220908171808050.png)

以深圳为例

![image-20220908172016389](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220908172016389.png)

指定路径：可写可不写

![image-20220908172222580](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220908172222580.png)



可以下载官方图形化管理工具方便使用

![image-20220908172402785](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220908172402785.png)

![image-20220908172500247](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220908172500247.png)

![image-20220908172518460](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220908172518460.png)

### (3) Typora开启上传图片功能

打开偏好设置 --> 图像 选择PicGo

![image-20220908173047728](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220908173047728.png)

选择PicGo安装目录

 ![image-20220908173152858](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220908173152858.png)



## 注意

==一些语法要在偏好设置里打开才能生效==

==修改偏好设置需要重新启动Typora才能生效==

 ![image-20220908173341111](https://typora3366.oss-cn-shenzhen.aliyuncs.com/img_for_typora/image-20220908173341111.png)
