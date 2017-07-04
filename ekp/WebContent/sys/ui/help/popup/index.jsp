<%@page import="com.landray.kmss.sys.ui.xml.model.*"%>
<%@page import="java.util.*"%>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="defaultLayoutHelp"
	value="/sys/ui/help/popup/layout-help.jsp" scope="request" />
<template:include file="/sys/ui/help/assembly-help.jsp">

	<template:replace name="elements">
　　
	</template:replace>
	<template:replace name="detail">

		<table width="100%">
			<tr>
				<td width="50px" height="100px"></td>
				<td valign="top" width="50%"><br>
				<br>
				使用样例代码： <br>
				<div id="ptext" style="display: inline-block;">文字<span id="arrow">&#9660;</span></div>
<ui:popup style="background:white;" triggerObject="#arrow" triggerEvent="click" align="top-right" borderWidth="5" positionObject="#ptext">

	<div style="width: 150px; height: 150px;" class="aaa_popup">abc</div>

</ui:popup></td>
				<td valign="top" style="width: 100px;"><br>
				<td valign="top" width="50%">
				<textarea style="width: 100%; height: 300px;">
<c:import url="example.txt" charEncoding="UTF8"></c:import>
	</textarea>
				</td>
			</tr>
		</table>
		<br>

		

	</template:replace>
	<template:replace name="more">
		<ui:content title="参数说明" >
		
		<table border="1">
					<tr>
						<td>属性</td>
						<td>取值</td>
						<td>说明</td>
					</tr>
					<tr>
						<td>align</td>
						<td valign="top">down-left;<br>down-right;<br>top-left;<br>top-right;<br>left-top;<br>left-down;<br>right-top;<br>right-down;</td>
						<td valign="top">下左边对齐<br><br><br><br><br><br><br></td>
					</tr>
					<tr>
						<td>triggerEvent</td>
						<td>mouseover;click</td>
						<td>触发事件</td>
					</tr>
					<tr>
						<td>positionObject</td>
						<td>jq选择权</td>
						<td>某认情况下是当前taglib的上一个Dom元素</td>
					</tr>					
					<tr>
						<td>triggerObject</td>
						<td>jq选择器</td>
						<td>触发对象，可以是一个选择器指定定某个Dom元素,某认情况下为positionObject</td>
					</tr>
					<tr>
						<td>borderWidth</td>
						<td>数字</td>
						<td>边框宽度,默认为1</td>
					</tr>
					<tr>
						<td>borderColor</td>
						<td>颜色英文单词例如red</td>
						<td>边框颜色,默认<div style="background: #3ca0d6;width: 60px; height: 30px;display: inline-block;">#3ca0d6</div></td>
					</tr> 
				</table>
		</ui:content>
	</template:replace>
</template:include>