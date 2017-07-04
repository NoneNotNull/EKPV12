<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<br><br>
<center>
<script>
	function clickOK(){
		var field = document.getElementsByName("fdTopDays")[0];
		if(field.value==""){
			alert("<kmss:message key="errors.required" argKey0="sys-news:news.setTop.topDays" />");
			return;
		}
		var rtn = parseInt(field.value);
		if(isNaN(rtn)){
			alert("<kmss:message key="errors.integer" argKey0="sys-news:news.setTop.topDays" />");
			return;
		}
	    var g = /^[1-9]*[1-9][0-9]*$/;
		if(!g.test(rtn)){
			alert("<kmss:message key="errors.integer" argKey0="sys-news:news.setTop.topDays" />");
			return;
		}
		returnValue  = rtn;
		top.close();
	}
</script>
<bean:message bundle="sys-news" key="news.setTop.topDays" />
<input class="inputsgl" name="fdTopDays" value="7" size="3" onkeydown="if(event.keyCode==13)clickOK();">
<br><br>
<input type="button" value="<bean:message key="button.ok" />" class="btnopt"
	onclick="clickOK();">&nbsp;&nbsp;&nbsp;
<input type="button" value="<bean:message key="button.cancel" />" class="btnopt"
	onclick="top.close();">
</center>
<%@ include file="/resource/jsp/edit_down.jsp"%>
