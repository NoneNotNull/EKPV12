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
公式定义器帮助
</title>
</head>
<body>
<center>
<div style="width: 750px">
<h1 style="font-size: 13px;">公式定义器帮助</h1>

<table class="tb_normal">
	<tr class="tr_normal_title">
	<td>综述</td>
	</tr>
	<tr>
	<td>
	当我们碰到一些无法预估的业务计算逻辑或该计算逻辑可能会经常发生改变的时候，我们可以通过公式定义器，让用户直接在配置中定义实际的业务计算逻辑，从而达到不修改程序也满足客户需求的目的，使系统的灵活性得到进一步提升。
	</td>
	</tr>
</table>

<table class="tb_normal">
	<tr class="tr_normal_title">
		<td colspan="2">名词解释</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">
			变量
		</td>
		<td>
		参与公式计算时使用到的相关数据，如主文档里面创建时间。<br>
		变量都是JAVA对象，所以在使用变量的时候，就需要注意。<br>
		例如变量是选择的组织架构，那么就是SysOrgElement的子类。<br>
		假如想获取该组织架构的名称就是:<b> $某组织架构$.getFdName()</b><br>
		变量也可能出现为空状态（null），在页面上可能体现为没有选择，假如 <b>$某组织架构$</b> 等于 <b>null</b>，
		那么表达式为：$某组织架构$.getFdName()，将会报错。
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">
			函数
		</td>
		<td>
		运算逻辑公式，如：列表求和<br>
		各种逻辑功能，都可以通过公式来实现。例如在流程中，用来计算处理人，表单中定义初始值。
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">
			表达式
		</td>
		<td>
		在公式编辑框内容，输入的内容将成为表达式，由变量、公式、操作符一起构成。表达式有些特殊要求：<br>
		如，表达式中直接使用字符串，应该使用 英文双引号 "" 扩起来。<br>
		比较是否相等，请使用 $某组织架构$.getFdName()<b>.equals</b>("张三")。<br>
		条件判断使用 if ( 条件.. ) { ... } else { ... } 这样的表达式。<br>
		总的说来，表达式与Java代码一致，类似于写一个Java方法。所以复杂表达式编写要求有一定Java代码经验，或者请使用特定公式来代替。
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">
			
		</td>
		<td>小提示:<br>
		一个“变量”可以看作是一个不带参数的“函数”，所以通过扩展函数也可以达到扩展变量的目的哟，例如：“$时间.当前时间$()”就是一个很好的例子。
		</td>
	</tr>
</table>

<table class="tb_normal">
	<tr class="tr_normal_title">
		<td colspan="2">部署</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">
			前端页面调用
		</td>
		<td><pre>
在jsp页面中引入formula.js文件，代码样例如下：

Com_IncludeFile("formula.js");

在编辑公式字段的地方，调用formula.js中的函数，样例代码如下：

&lt;input type="hidden" name="wf_condition"&gt;

&lt;input style="width:100% " class="inputsgl" readonly name="wf_disCondition"&gt;

&lt;a href="#" 
	onclick="Formula_Dialog(
		'wf_condition', 
		'wf_disCondition',
		Formula_GetVarInfoByModelName(
			'com.landray.kmss.km.review.model.KmReviewMain'),
			'Boolean');"&gt;
    公式定义器
&lt;/a&gt;

其中，函数Formula_Dialog的说明如下：

/******************************************

功能：弹出公式选择对话框

参数：

    idField：id字段，可不传

    nameField：name字段，可不传

    varInfo：变量列表，格式为[{name:name, label:label, type:type},…]，
    		可通过Formula_GetVarInfoByModelName获取数据字典中的变量

    returnType：返回值类型，为数据字典中的类型，可用String[]表示字符串类表，
    		用Object标识不限制返回值类型

    action：回调函数

******************************************/

function Formula_Dialog(idField, nameField, varInfo, returnType, action)
</pre></td>
	</tr>
	<tr>
		<td class="td_normal_title" width="15%">
			后端代码调用
		</td>
		<td><pre>
在您需要解释公式的业务代码中，
调用com.landray.kmss.sys.formula.parser.FormulaParser的相关方法进行解释，样例代码：

//model为公式定义器使用的数据载体，如KmReviewMain的实例

FormulaParser parser = FormulaParser.getInstance(model);

//formula值获取来自前面在jsp页面定义好的公式，注意：不是前端展现的那个字段

Boolean value = (Boolean) parser.parseValueScript(formula, "Boolean");
</pre></td>
	</tr>
</table>

</div>
</center>
</body>
</html>