<%@	page	language="java"	pageEncoding="UTF-8"%>
<%@	include	file="/sys/ui/jsp/common.jsp"%>	
<pre>
//数据格式说明:
[
	{
		"text":"",							//一级菜单标题
		"href":"",							//一级菜单链接
		"children":
			[
				{
					"text":"",				//二级菜单标题
					"href":"",				//二级菜单链接
					"children":
						[
							{
								"text":"",	//三级菜单标题
								"href":""	//三级菜单链接
							}
							....
						]
				}
				....
			]
	}
	....	
]
</pre>