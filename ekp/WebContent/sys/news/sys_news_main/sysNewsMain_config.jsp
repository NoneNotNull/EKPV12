<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<kmss:windowTitle subjectKey="sys-news:sysNewsMain.param.config" moduleKey="sys-news:news.moduleName" />

<html:form action="/sys/news/sys_news_main/sysNewsConfig.do" onsubmit="return validateAppConfigForm(this);">
	<div id="optBarDiv">
		<kmss:authShow roles="ROLE_SYSNEWS_CATEGORY_MAINTAINER">
			<input type=button value="<bean:message key="button.submit"/>" onclick="Com_Submit(document.sysAppConfigForm, 'update');">
		</kmss:authShow>
		<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
	</div>

	<p class="txttitle">
		<bean:message bundle="sys-news" key="sysNewsMain.param.config" />
	</p>
	<center>
		<table  class="tb_normal" width=95%>
		<tr>
				<td class="td_normal_title" width="20%">
					<bean:message bundle="sys-news" key="sysNewsMain.config.imageWH"/>
				</td>
				<td>
				<div>
				<bean:message bundle="sys-news" key="sysNewsMain.config.imageW"/>: <html:text property="value(fdImageW)" style="width:50px"/>px
				</div>
				<div>
				<bean:message bundle="sys-news" key="sysNewsMain.config.imageH"/>: <html:text property="value(fdImageH)" style="width:50px"/>px
				</div><br>
				<div>
				<bean:message bundle="sys-news" key="sysNewsMain.config.recommended"/>： <font color="red">312px(<bean:message bundle="sys-news" key="sysNewsMain.config.width"/>)*234px(<bean:message bundle="sys-news" key="sysNewsMain.config.height"/>)</font>，<bean:message bundle="sys-news" key="sysNewsMain.config.imageWH.desc"/>
				</div>				
			</td>
		</tr>
	</table>
	</center>
	<html:hidden property="method_GET" />
	<input type="hidden" name="modelName" value="com.landray.kmss.sys.news.model.SysNewsConfig" />
</html:form>
<script>
	function validateAppConfigForm(thisObj){
		var fdNewsExpireDate=document.getElementsByName("value(fdNewsExpireDate)")[0];
		if(fdNewsExpireDate!=null && fdNewsExpireDate.value!=""){
			if(isNaN(fdNewsExpireDate.value)){
				alert('<bean:message bundle="sys-news" key="sysNewsMain.config.hompage.validate"/>');
				fdNewsExpireDate.value="";
				fdNewsExpireDate.focus();
				return false;
			}
		}
		return true;
	}
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>