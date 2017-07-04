<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ page import="com.landray.kmss.sys.relation.util.SysRelationUtil" %>
<%@ page import="com.landray.kmss.sys.relation.forms.SysRelationEntryForm" %>
<%@ page import="com.landray.kmss.sys.relation.forms.SysRelationConditionForm" %>
<%@page import="com.landray.kmss.sys.relation.forms.SysRelationStaticNewForm"%>
<%@page import="java.util.List"%>
<%@page import="net.sf.json.JSONObject"%>
<script type="JavaScript">Com_IncludeFile("util.js", null, "js");</script>
<script type="text/javascript">
var relationMains = {};
<c:forEach items="${mainModelForm.sysRelationMainFormMap}" varStatus="vsMain" var="sysRelationMainForm">
	relationMains["<c:out value='${sysRelationMainForm.key}' />"]={
		fdId:"<c:out value='${sysRelationMainForm.value.fdId}' />",
		fdOtherUrl:"<c:out value='${sysRelationMainForm.value.otherUrlNoPattern}' />",
		fdKey:"<c:out value='${sysRelationMainForm.value.fdKey}' />",
		fdModelName:"<c:out value='${sysRelationMainForm.value.fdModelName}' />",
		fdModelId:"<c:out value='${sysRelationMainForm.value.fdModelId}' />",
		fdParameter:"<c:out value='${sysRelationMainForm.value.fdParameter}' />"
	};
	var relationEntrys = [];// 需要排序，改成数组
	<c:forEach items="${sysRelationMainForm.value.sysRelationEntryFormList}" varStatus="vstatus" var="sysRelationEntryForm">
		var _staticInfos={};
		<%SysRelationEntryForm sysRelationEntryForm = (SysRelationEntryForm) pageContext.getAttribute("sysRelationEntryForm");
			List staticInfoList = sysRelationEntryForm
					.getSysRelationStaticNewFormList();
			JSONObject staticEntry = new JSONObject();
			if (!staticInfoList.isEmpty()) {
				for (int i = 0; i < staticInfoList.size(); i++) {
					JSONObject staticMsg = new JSONObject();
					SysRelationStaticNewForm sysRelationStaticNewForm = (SysRelationStaticNewForm) staticInfoList
					.get(i);
					staticMsg.accumulate("fdId",
					sysRelationStaticNewForm.getFdId());
					staticMsg.accumulate("fdSourceId",
					sysRelationStaticNewForm.getFdSourceId());
					staticMsg.accumulate("fdSourceModelName",
					sysRelationStaticNewForm.getFdSourceModelName());
					staticMsg.accumulate("fdSourceDocSubject",
					sysRelationStaticNewForm.getFdSourceDocSubject());
					staticMsg.accumulate("fdRelatedId",
					sysRelationStaticNewForm.getFdRelatedId());
					staticMsg.accumulate("fdRelatedModelName",
					sysRelationStaticNewForm.getFdRelatedModelName());
					staticMsg.accumulate("fdRelatedUrl",
					sysRelationStaticNewForm.getFdRelatedUrl());
					staticMsg.accumulate("fdRelatedName",
					sysRelationStaticNewForm.getFdRelatedName());
					staticMsg.accumulate("fdRelatedType",
					sysRelationStaticNewForm.getFdRelatedType());
					staticMsg.accumulate("fdEntryId",
					sysRelationStaticNewForm.getFdEntryId());
					staticEntry.accumulate(i+"",staticMsg);
				}
				out
				.println("_staticInfos['"
						+ sysRelationEntryForm.getFdId()
						+ "'] = "
						+ staticEntry.toString() + ";");
			}
		%>
		relationEntrys["${vstatus.index}"] = {
			fdId:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getFdId())%>",
			fdType:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getFdType())%>",
			fdModuleName:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getFdModuleName())%>", //中文模块名
			fdModuleModelName:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getFdModuleModelName())%>",
			fdOrderBy:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getFdOrderBy())%>",
			fdOrderByName:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getFdOrderByName())%>",
			fdPageSize:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getFdPageSize())%>",
			fdParameter:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getFdParameter())%>",
			fdKeyWord:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getFdKeyWord())%>",
			docCreatorId:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getDocCreatorId())%>",
			docCreatorName:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getDocCreatorName())%>",
			fdFromCreateTime:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getFdFromCreateTime())%>",
			fdToCreateTime:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getFdToCreateTime())%>",
			fdSearchScope:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getFdSearchScope())%>",
			fdOtherUrl:"<%=SysRelationUtil.replaceJsonQuotes(sysRelationEntryForm.getOtherUrlNoPattern())%>",
			staticInfos:_staticInfos

		};

	</c:forEach>
	relationMains["<c:out value='${sysRelationMainForm.key}' />"].relationEntrys = relationEntrys;
</c:forEach>
// 弹出框方式查看关联文档，必须传入参数fdKey
function Relation_viewRelation(fdKey,dialogHeight,dialogWidth,dialogLeft,dialogTop){
	if(typeof fdKey =="undefined" || fdKey == null || fdKey == "" ){		
		alert('<bean:message bundle="sys-relation" key="relation.error.required.fdKey"/>');
		return;
	}
	var url = '<c:url value="/sys/relation/sys_relation_main/sysRelationMain.do" />?method=view';
	url = Com_SetUrlParameter(url,"fdKey",fdKey);
	url = Com_SetUrlParameter(url,"currModelId","${mainModelForm.fdId}");
	url = Com_SetUrlParameter(url,"currModelName","${param.currModelName}");
	url = Com_SetUrlParameter(url,"showCreateInfo","${param.showCreateInfo}");
	var sFeatures= "dialogWidth:600px;dialogHeight:280px;resizable:yes;";
	if(dialogHeight !=null)sFeatures+="dialogHeight:"+dialogHeight+";";
	if(dialogWidth !=null)sFeatures+="dialogWidth:"+dialogWidth+";";
	if(dialogLeft !=null)sFeatures+="dialogLeft:"+dialogLeft+";";
	if(dialogTop !=null)dialogTop+="dialogHeight:"+dialogTop+";";
	showModalDialog(url, null, sFeatures);
}
// 验证是否有关联信息
function Relation_checkHasRelation(fdKey) {
	if (fdKey == null || fdKey == "" || relationMains[fdKey] == null) {
		return false;
	}
	return true;
}
// 获取图片参数
function Relation_getImgParam(fdKey) {
	var rtnObj = {imgId : "", imgPos : ""};
	if (fdKey && relationMains[fdKey]) {
		var par = relationMains[fdKey].fdParameter;
		if (par) {
			par = unescape(par);
			var tmp = eval("(" + par + ")");
			rtnObj.imgId = tmp.imgId;
			rtnObj.imgPos = tmp.imgPos;
		}
	}
	return rtnObj;
}
</script>
