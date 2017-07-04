<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@page import="com.landray.kmss.util.DateUtil"%>
<%@page import="java.util.Date"%>
<script type="text/javascript" src='<c:url value="/third/pda/resource/script/mechansm.js"/>'></script>

<c:set var="s_mainForm" value="${requestScope[param.formName]}" />
<c:set var="s_fdModelName" value="${s_mainForm.modelClass.name}"/>
<c:set var="s_fdModelId" value="${s_mainForm.fdId}"/>
<c:set var="sysRelationMainForm" value="${s_mainForm.sysRelationMainForm}" scope="request"/>
<c:if test="${param.showFold==true }">
	<tr class="tr_extendTitle">
		<td class="td_title">
			<bean:message key="sysRelationMain.fdOtherUrl" bundle="sys-relation"/>
		</td><td>&nbsp;</td></tr>
		<tr><td colspan="2" class="td_common">
</c:if>
<div id="div_relation" class="div_operatePanel">
	<div class="div_listArea" id="div_relationData" style="width:100%;margin: 0px;">
		<div style='margin: 10px 0px;'><bean:message key="sysRelationMain.list.loading" bundle="sys-relation"/></div>
	</div>
</div>
	<c:if test="${param.showFold==true }">
		</td></tr>
	</c:if>
<script type="text/javascript">
	function showReleationIframe(){
		var requestUrl='<c:url value="/sys/relation/sys_relation_main/sysRelationMain.do" />?method=view'+
				'&forward=docView&fdId=${sysRelationMainForm.fdId}&currModelId=${s_fdModelId}&currModelName=${s_fdModelName}';
		var dataObj=document.getElementById("div_relationData");
		dataObj.innerHTML="<iframe id=\"relationIframe\" width=\"100%\" frameborder=\"0\" scrolling=\"no\" src=\""+requestUrl+"\"></iframe>";
	}
	
	var tmpConfig={"contentDiv":"div_relation",
		"customRequestData":showReleationIframe,
		"needPage":"false"};
	if(window.addMechansmInfo){
		addMechansmInfo("relation",tmpConfig);
	}else{
		if(window.S_MechansmMap!=null){
			S_MechansmMap.put("relation",tmpConfig);
		}
	}
</script>
