参数配置说明
原有的参数配置：

1.附件保存方式  ：  
	sys.att.dao    fileAttMainDao/dbAttMainDao   文件/数据库

2.加密附件:        
	sys.att.encryption.mode    0/1/2

3.是否开启Flash阅读功能:
	kmss.att.swf.enabled    true

4.是否启用金格控件
	sys.att.isJGEnabled 	true
	金格控件地址:
		sys.att.jg.ocxurl

5.文件路径
	kmss.resource.path

6.单个附件的最大长度
	sys.att.singMaxSize

7.单个文档所有附件的最大长度
	sys.att.totalMaxSize



更改后的配置参数：
1.是否启用大附件上传
	sys.att.useBigAtt
	附件服务器地址
		sys.att.attservurl      为空表示本服务器

2.附件加密方式       
	sys.att.encryption.mode    0/1/2

3.文件路径
	kmss.resource.path

4.是否开启Flash阅读功能
	kmss.att.swf.enabled    true

5.金格控件配置
	是否启用金格
		sys.att.isJGEnabled 	true
	金格控件下载地址
		sys.att.jg.ocxurl

6.小附件的最大长度：
	sys.att.smallMaxSize  100m（默认）

隐藏配置：
 单个附件的最大长度 ：  sys.att.singMaxSize  
单个文档所有附件的最大长度： sys.att.totalMaxSize   
切片大小：sys.att.slice.size     5M（默认）
附件上传有效期：sys.att.expire   30S
未上传完数据保存期限 sys.att.slice.expire   1个月
