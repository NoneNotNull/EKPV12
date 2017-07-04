<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>

<%--bookmark--%>
<c:import url="/sys/bookmark/include/bookmark_bar_all.jsp"
	charEncoding="UTF-8">
	<c:param name="fdTitleProName" value="docSubject" />
	<c:param name="fdModelName"
		value="com.landray.kmss.sys.news.model.SysNewsMain" />
</c:import>
<c:import url="/resource/jsp/search_bar.jsp" charEncoding="UTF-8">
	<c:param name="fdModelName"
		value="com.landray.kmss.sys.news.model.SysNewsMain" />
</c:import>
<script language="JavaScript">
Com_IncludeFile("dialog.js");

function setTop(isTop){
	if(!List_CheckSelect()){
		return;
	}
	var dayField = document.getElementsByName("fdDays")[0];
	if(isTop){
		var days = Dialog_PopupWindow("sysNewsMain_topday_old.jsp", 400, 200);
		if(days==null)
			return;
		dayField.value = days;
	}else{
		if(!confirm('<bean:message bundle="sys-news" key="news.setTop.confirmCancel" />'))
			return;
		dayField.value = 0;
	}
	document.getElementsByName("fdIsTop")[0].value = isTop;
	Com_Submit(document.sysNewsMainForm, "setTop");
}
function op(optype) {
	if(!List_CheckSelect()){
		return;
	}
	//取消发布确认框
	if(optype==false){
		if(!confirm('<bean:message bundle="sys-news" key="news.publish.confirmCancel" />'))
			return;
	}
	var oInput = document.createElement("input")   
	oInput.type = "hidden";
	oInput.name = "op";
	oInput.value = optype;
	document.sysNewsMainForm.appendChild(oInput);  
	Com_Submit(document.sysNewsMainForm, 'setPublish');
}
Com_AddEventListener(window,'load',function(){
	var newForm = document.forms[0];
	if('autocomplete' in newForm)
		newForm.autocomplete = "off";
	else
		newForm.setAttribute("autocomplete","off");
});
function dyniFrameSize() {
	try {
		// 调整高度
		var arguObj = document.getElementsByTagName("table")[0];
		if (arguObj != null && window.frameElement != null && window.frameElement.tagName == "IFRAME") {
			window.frameElement.style.height = (arguObj.offsetHeight + 20) + "px";
		}
	} catch (e) {}
}
window.onload =function (){
	setTimeout(dyniFrameSize,100);
}; 
</script>
<c:import
	url="/sys/right/doc_right_change_button.jsp"
	charEncoding="UTF-8">
	<c:param
		name="modelName"
		value="com.landray.kmss.sys.news.model.SysNewsMain" />
</c:import>

<%-- ------转移分类----- --%>
<c:import
	url="/sys/simplecategory/include/doc_cate_change_button.jsp"
	charEncoding="UTF-8">
	<c:param
		name="modelName"
		value="com.landray.kmss.sys.news.model.SysNewsMain" />
	<c:param
		name="docFkName"
		value="fdTemplate" />
	<c:param
		name="cateModelName"
		value="com.landray.kmss.sys.news.model.SysNewsTemplate" />
</c:import>

<html:form action="/sys/news/sys_news_main/sysNewsMain.do">
	<div id="optBarDiv">
		<!-- “取消置顶”按钮在置顶文档树的显示 -->
		<c:if test="${param.status=='30' && param.top=='true'}">
			<kmss:auth
				requestURL="/sys/news/sys_news_main/sysNewsMain.do?method=setTop&top=true"
				requestMethod="GET">
			<input type="button"
					value="<bean:message bundle="sys-news" key="news.button.setTop"/>"
					onclick="setTop(true);" />
			<input type="button"
					value="<bean:message bundle="sys-news" key="news.button.unSetTop"/>"
					onclick="setTop(false);" />
			</kmss:auth>
		</c:if>
		<!-- 在“发布文档”和“文档维护”目录树下需要显示以下按钮 -->
		<c:if test="${(param.status=='30' || param.method=='manageList')&& param.top!='true'}">
			<%-- ------置顶----- --%>
			<kmss:auth
				requestURL="/sys/news/sys_news_main/sysNewsMain.do?method=setTop&categoryId=${param.categoryId}&nodeType=${param.nodeType}"
				requestMethod="GET">
				<input type="button"
					value="<bean:message bundle="sys-news" key="news.button.setTop"/>"
					onclick="setTop(true);" />
				<input type="button"
					value="<bean:message bundle="sys-news" key="news.button.unSetTop"/>"
					onclick="setTop(false);" />
			</kmss:auth>

			<%-- ------取消发布----- --%>
			<kmss:auth
				requestURL="/sys/news/sys_news_main/sysNewsMain.do?method=setPublish&categoryId=${param.categoryId}&nodeType=${param.nodeType}"
				requestMethod="GET">
				<input type="button"
					value="<bean:message bundle="sys-news" key="news.button.unPublish"/>"
					onclick="op(false);" />
			</kmss:auth>
		</c:if>
		<%-- ------重新发布----- --%>
		<c:if test="${param.status=='40'}">
		<kmss:auth
			requestURL="/sys/news/sys_news_main/sysNewsMain.do?method=setPublish&categoryId=${param.categoryId}&nodeType=${param.nodeType}"
			requestMethod="GET">
			<input type="button"
				value="<bean:message bundle="sys-news" key="news.button.publish"/>"
				onclick="op(true);" />
		</kmss:auth>
		</c:if>
		<%-- ------新建----- --%>
		<kmss:authShow roles="ROLE_SYSNEWS_CREATE">
			<c:if test="${empty param.categoryId}">
				<input
					type="button"
					value="<bean:message key="button.add"/>"
					onclick="Dialog_SimpleCategoryForNewFile('com.landray.kmss.sys.news.model.SysNewsTemplate','<c:url value="/sys/news/sys_news_main/sysNewsMain.do" />?method=add&fdTemplateId=!{id}&fdTemplateName=!{name}&fdModelId=${param.fdModelId}&fdModelName=${param.fdModelName}');">
			</c:if>	
			<c:if test="${not empty param.categoryId}">
			<c:set var="flg" value="no"/>
			<kmss:auth
					requestURL="/sys/news/sys_news_main/sysNewsMain.do?method=add&fdTemplateId=${param.categoryId}"
					requestMethod="GET">
				<input
					type="button"
					value="<bean:message key="button.add"/>"
						onclick="Com_OpenWindow('<c:url value="/sys/news/sys_news_main/sysNewsMain.do" />?method=add&fdTemplateId=${param.categoryId}&fdModelId=${param.fdModelId}&fdModelName=${param.fdModelName}');">
			<c:set var="flg" value="yes"/>
			</kmss:auth>
			<c:if test="${flg eq 'no'}">
			<input type="button" value="<bean:message key="button.add"/>"
			onclick="Dialog_SimpleCategoryForNewFile('com.landray.kmss.sys.news.model.SysNewsTemplate','<c:url value="/sys/news/sys_news_main/sysNewsMain.do" />?method=add&fdTemplateId=!{id}&fdTemplateName=!{name}&fdModelId=${param.fdMoodelId}&fdModelName=${param.fdModelName}');">
			</c:if>
			</c:if>
		</kmss:authShow>
		<%-- ------删除----- --%>
		<kmss:auth
			requestURL="/sys/news/sys_news_main/sysNewsMain.do?method=deleteall&status=${param.status}&categoryId=${param.categoryId}&nodeType=${param.nodeType}"
			requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysNewsMainForm, 'deleteall');">
		</kmss:auth>
		<input type="button" value="<bean:message key="button.search"/>"
			onclick="Search_Show();">
	</div>
<%
	if (((Page) request.getAttribute("queryPage")).getTotalrows() == 0) {
%>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
<%
	} else {
%>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<input type="hidden" name="fdTemplateId" />
	<input type="hidden" name="fdTemplateName" />
	<input type="hidden" name="fdDays" />
	<input type="hidden" name="fdIsTop" />
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<td width="40pt"><bean:message key="page.serial" /></td>
				<sunbor:column property="sysNewsMain.docSubject">
					<bean:message bundle="sys-news" key="sysNewsMain.docSubject" />
				</sunbor:column>
				<sunbor:column property="sysNewsMain.fdImportance">
					<bean:message bundle="sys-news" key="sysNewsMain.fdImportance" />
				</sunbor:column>
				<sunbor:column property="sysNewsMain.docCreator.fdName">
					<bean:message bundle="sys-news" key="sysNewsMain.docCreatorId" />
				</sunbor:column>
				<c:if test="${param.status!='30' && param.status!='40' && param.method!='manageList'}">
					<sunbor:column property="sysNewsMain.docCreateTime">
						<bean:message bundle="sys-news" key="sysNewsMain.docCreateTime" />
					</sunbor:column>
				<sunbor:column property="sysNewsMain.docAlterTime">
						<bean:message bundle="sys-news" key="sysNewsMain.docAlterTime" />
					</sunbor:column>	
				</c:if>
				<c:if test="${param.status=='30' || param.status=='40' || param.method=='manageList'}">
					<sunbor:column property="sysNewsMain.docPublishTime">
						<bean:message bundle="sys-news" key="sysNewsMain.docPublishTime" />
					</sunbor:column>
					<sunbor:column property="sysNewsMain.docAlterTime">
						<bean:message bundle="sys-news" key="sysNewsMain.docAlterTime" />
					</sunbor:column>
					<sunbor:column property="sysNewsMain.docReadCount">
						<bean:message bundle="sys-news" key="sysNewsMain.docHits" />
					</sunbor:column>
				</c:if>
				<c:if test="${param.status=='30'|| param.method=='manageList'}">
					<sunbor:column property="sysNewsMain.fdTopDays">
						<bean:message bundle="sys-news" key="sysNewsMain.fdIsTop" />
					</sunbor:column>	
				</c:if>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysNewsMain"
			varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/news/sys_news_main/sysNewsMain.do" />?method=view&fdId=${sysNewsMain.fdId}">
			<td style="width:10px"><input type="checkbox" name="List_Selected"
				value="${sysNewsMain.fdId}"></td>
			<td style="width:30px">${vstatus.index+1}</td>
			<td style="width:40%" style="text-align: left;"><c:out value="${sysNewsMain.docSubject}" /></td>
			<td style="width:10%">
				<sunbor:enumsShow value="${sysNewsMain.fdImportance}" enumsType="sysNewsMain_fdImportance" />
			</td>
			<td style="width:10%"><c:out value="${sysNewsMain.docCreator.fdName}" /></td>
			<c:if test="${param.status!='30' && param.status!='40' && param.method!='manageList'}">
				<td style="width:20%"><kmss:showDate value="${sysNewsMain.docCreateTime}" type="datetime"/></td>
				<td style="width:20%"><kmss:showDate value="${sysNewsMain.docAlterTime}" type="datetime"/></td>
			</c:if>
			<c:if test="${param.status=='30' || param.status=='40' || param.method=='manageList'}">
				<td style="width:15%"><kmss:showDate value="${sysNewsMain.docPublishTime}" type="date"/></td>	
				<td style="width:15%"><kmss:showDate value="${sysNewsMain.docAlterTime}" type="datetime"/></td>		
				<td style="width:10%">${sysNewsMain.docReadCount }</td>
			</c:if>
			<c:if test="${param.status=='30'|| param.method=='manageList'}">	
				<td style="width:10%">
				<c:if test="${sysNewsMain.fdIsTop=='true'}">
					<img src="${KMSS_Parameter_StylePath}answer/icn_ok.gif" border=0
						title="<bean:message key="news.fdIsTop.true" bundle="sys-news"/>" />
				</c:if>
				</td>
			</c:if>
		</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp"%>
	<%
	}
	%>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
