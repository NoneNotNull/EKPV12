<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.dialog">
	<template:replace name="content">
<script type="text/javascript">

seajs.use(['lui/dialog'],function(dialog) {
	//确认
	window.clickOK=function(){
		var sleTemp = document.getElementsByName("sleTemp")[0]; //定位id
		if("${templateList[0].fdId}" != ""&&sleTemp.selectedIndex==-1){
			dialog.alert("请选择一个模板再点确定.");
		}else{
			//var text = sleTemp.options[sleTemp.selectedIndex].text; // 选中文本
			var value = sleTemp.options[sleTemp.selectedIndex].value; // 选中值
			$dialog.hide(value);
		}
	};
});
</script>
<center style="margin-top: 15px;">
<select name="sleTemp" style="width:440px;height:350px;" size="20">
	<c:forEach items="${templateList}" var="template">
		<option value="${template.fdId}">${template.fdName}</option>
	</c:forEach>
</select>
</center>
<div style="float:right;margin-right: 10px;margin-top: 5px;">
	<ui:button text="${lfn:message('button.ok') }"onclick="clickOK();"></ui:button>
	<ui:button style="padding-left:10px"  text="${lfn:message('button.cancel') }" styleClass="lui_toolbar_btn_gray" onclick="Com_CloseWindow();"></ui:button>
</div>
</template:replace>
</template:include>
