<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>
<html>
<head>
<style>
body, td, input, select, textarea{
	font-size: 12px;
	color: #333333;
	line-height: 20px;
}
body{
	margin: 0px;
	padding: 20 0;
}
.tb_normal{
	border-collapse:collapse;
	border: 1px #C0C0C0 solid;
	background-color: #FFFFFF;
	margin-bottom: 20px;
	width: 100%;
}
.td_normal, .tb_normal td{
	border-collapse:collapse;
	border: 1px #C0C0C0 solid;
	padding:3px;
}
.tr_normal_title{
	background-color: #F0F0F0;
	border-collapse:collapse;
	border: 1px #C0C0C0 solid;
	padding:3px;
	text-align:center;
	word-break:keep-all;
}
.td_normal_title{
	background-color: #F0F0F0;
	border-collapse:collapse;
	border: 1px #C0C0C0 solid;
	padding:3px;
	word-break:keep-all;
}
.inputsgl{
	color: #0066FF;
	border-color: #999999;
	border-style: solid;
	border-width: 0px 0px 1px 0px;
}
.btn{
	color: #0066FF; 
	background-color: #F0F0F0; 
	border: 1px #999999 solid; 
	font-weight: normal; 
	padding: 0px 1px 1px 0px;
	height: 18px;
	clip:  rect();
}
</style>
<title>
JSP片段控件帮助
</title>
</head>
<body>
<center>
<div style="width: 750px">
<h1 style="font-size: 13px;">JSP片段控件帮助</h1>

<table class="tb_normal">
	<tr class="tr_normal_title">
	<td>综述</td>
	</tr>
	<tr>
	<td>JSP片段控件是为了提供，在目前控件没提供相关功能前，通过插入JSP片段代码来实现相关功能。
<br>
JSP片段控件由于是把输入内容原封不动，插入到对于表单JSP位置，所以JSP中的内容，完全同JSP一样。在JSP页面能做的事情，JSP片段也一样能做。可以用JDBC访问数据库，可以使用struts,xform标签，可以写javascript代码。
	</td>
	</tr>
</table>

<table class="tb_normal">
	<tr class="tr_normal_title">
		<td colspan="3">访问表单变量</td>
	</tr>
	
	<tr>
		<td class="td_normal_title" width="15%">
			说明
		</td>
		<td colspan="2">
			在表单模板里，能看到所有控件的ID，可以通过ID，直接从form中取得数据。另外表单中有一个隐藏控件，这个控件可以生成数据字典，但在前段本身不会有任何显示，可以通过JSP片段，写xform标签来显示，这样显示的可控性更高。

		</td>
	</tr>
	
	<tr>
		<td class="td_normal_title" width="15%" rowspan="2">
			访问主文档
		</td>
		<td>
			标签
		</td>
		<td>
			<code>
			&lt;xform:text property="docSubject" /&gt;
			</code>
		</td>
	</tr>
	<tr>
		<td>
			Java代码
		</td>
		<td>
			<code>
			&lt;%=mainForm.getDocSubject(); %&gt;
			</code>
		</td>
	</tr>
	
	<tr>
		<td class="td_normal_title" width="15%" rowspan="2">
			访问自定义表单
		</td>
		<td>
			标签
		</td>
		<td>
			<code>
			&lt;xform:text property="extendDataFormInfo.value(fd_xxxxxxxxx)" /&gt;
			</code>
		</td>
	</tr>
	<tr>
		<td>
			Java代码
		</td>
		<td>
			<code>
			&lt;%=mainForm.getExtendDataFormInfo().getValue("fd_xxxxxxxxx"); %&gt;
			</code>
		</td>
	</tr>
	
	<tr>
		<td class="td_normal_title" width="15%">
			访问隐藏控件
		</td>
		<td colspan="2">
			同上
		</td>
	</tr>
	
</table>

<table class="tb_normal">
	<tr class="tr_normal_title">
		<td colspan="2">访问数据库</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">
		JDBC
		</td>
		<td>
		<pre>
Class.forName("oracle.jdbc.driver.OracleDriver").newInstance();
String url = "jdbc:oracle:thin:@localhost:1521:orcl"; // 手写数据链接
Connection conn = DriverManager.getConnection(url,"scott","1");
Statement stmt = conn.createStatement(); 
String sql = "select * from test"; 
ResultSet rs = stmt.executeQuery(sql);
while(rs.next()) {
	...
}
conn.close();</pre>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">
		component.dbop
		</td>
		<td>
		<pre>
DataSet ds = new DataSet("orcl"); // 在SYS下配置的数据源
ds.prepareStatement("select * from test");
ResultSet rs = ds.executeQuery();
while(rs.next()) {
	...
}
ds.close();</pre>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">
		Hibernate
		</td>
		<td>
		<pre>
IXxxDao xxxDao = (IXxxDao) SpringBeanUtil.getBean("xxxDao"); // 直接利用系统DAO、Service
List xxs = xxxDao.findList(" 1 = 1", "xxx.fdName desc");
for (int i = 0; i &lt; xxs.size(); i ++) {
	...
}
		</pre>
		</td>
	</tr>
</table>

<table class="tb_normal">
	<tr class="tr_normal_title">
		<td colspan="2">JS相关函数</td>
	</tr>
	<tr>
		<td colspan="2">在应用中，有时有字段域级联的需求，但目前表单自身无法完成，只能通过JSP片段来完成。
		<pre>
样例：
function XFormOnValueChange() {
	var v = GetXFormFieldValueById('fd_xxxx');
	if (v == '1') {
		SetXFormFieldValueById('fd_xxxx2', 'ok');
	}
}
		</pre>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">
		XFormOnValueChange
		</td>
		<td>
		<pre>
全局值变化监听函数，由使用人员实现。（只能声明一个）
假如在JSP片段中声明此函数，将在表单值发生变化时被调用。</pre>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">
		XFormOnValueChangeFuns
		</td>
		<td>
		<pre>
事件函数队列，可通过 
XFormOnValueChangeFuns.push(function(){...});
来添加监听函数，此队列中的函数将在表单值发生变化时被调用。</pre>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">
		AttachXFormValueChangeEventById
		</td>
		<td>
		<pre>
功能：自定义表单通过控件ID绑定监听值变化方法，仅当ID标识的控件发生值变化时进行调用。

参数：
	id           ：字段的ID
	fun          ：绑定函数
		</pre>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">
		AttachXFormValueChangeEventByLabel
		</td>
		<td>
		<pre>
功能：自定义表单通过显示文字绑定监听值变化方法

参数：
	label        ：显示文字
	fun          ：绑定函数
		</pre>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">
		GetXFormFieldById
		</td>
		<td>
		<pre>
功能：自定义表单根据控件ID获取对象

参数：
	id           ：ID
	nocache      ：不用缓存
返回值：
	Dom对象数组
		</pre>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">
		GetXFormFieldValueById
		</td>
		<td>
		<pre>
功能：自定义表单根据控件ID获取对象值

参数：
	id           ：ID
	nocache      ：不用缓存
返回值：
	值数组
		</pre>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">
		SetXFormFieldValueById
		</td>
		<td>
		<pre>
功能：自定义表单根据控件ID设置对象值

参数：
	id           ：字段的ID
	value        : 值
	nocache      ：不用缓存
		</pre>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">
		GetXFormFieldByLabel
		</td>
		<td>
		<pre>
功能：自定义表单根据显示文字获取对象

参数：
	label        ：字段的显示文字，在dom对象上是对应的subject属性
	nocache      ：不用缓存
返回值：
	Dom对象数组
		</pre>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">
		GetXFormFieldValueByLabel
		</td>
		<td>
		<pre>
功能：自定义表单根据显示文字获取对象

参数：
	label        ：字段的显示文字，在dom对象上是对应的subject属性
	nocache      ：不用缓存
返回值：
	值数组
		</pre>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">
		SetXFormFieldValueByLabel
		</td>
		<td>
		<pre>
功能：自定义表单根据显示文字设置对象值

参数：
	label        ：字段的显示文字，在dom对象上是对应的subject属性
	value        : 值
	nocache      ：不用缓存
		</pre>
		</td>
	</tr>
</table>

</div>
</center>
</body>
</html>