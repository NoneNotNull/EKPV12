<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.dialog">
	<template:replace name="content">	
<br><br>
<center>
<script  type="text/javascript">
		seajs.use([ 'lui/jquery','lui/parser','lui/dialog'],function($,parser,dialog) {
			//确认
			window.clickOK=function(){
				var field = document.getElementsByName("fdTopDays")[0];
				if(field.value==""){
					dialog.alert("<kmss:message key="errors.required" argKey0="sys-news:news.setTop.topDays" />");
					return;
				}
				var rtn = field.value;
			    var g = /^[1-9]*[1-9][0-9]*$/;
				if(!g.test(rtn)){
					dialog.alert("<kmss:message key="errors.integer" argKey0="sys-news:news.setTop.topDays" />");
					return;
				}
				$dialog.hide(rtn);
			};
		});
</script>
<bean:message bundle="sys-news" key="news.setTop.topDays" />
<input class="inputsgl" name="fdTopDays" value="7" size="3" onkeydown="if(event.keyCode==13)clickOK();">
<br><br>
<ui:button text="${lfn:message('button.ok') }"onclick="clickOK();"></ui:button>
<ui:button style="padding-left:10px"  text="${lfn:message('button.cancel') }" styleClass="lui_toolbar_btn_gray" onclick="Com_CloseWindow();"></ui:button>
</center>
</template:replace>
</template:include>
