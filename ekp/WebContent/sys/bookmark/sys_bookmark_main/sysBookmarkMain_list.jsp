<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("common.js|doclist.js|dialog.js");
function showCategoryTreeDialog() {
	var dialog = new KMSSDialog(false, false);
	var node = dialog.CreateTree('<bean:message key="dialog.tree.title" bundle="sys-bookmark"/>');
	node.AppendBeanData("sysBookmarkCategoryTreeService&parentId=!{value}&type=all");
	dialog.winTitle = '<bean:message key="dialog.tree.title" bundle="sys-bookmark"/>';
	dialog.SetAfterShow(SubForm);
	dialog.notNull = true;
	dialog.Show();
	return false;
}
function ToSetCategory() {
	if (!List_CheckSelect()) return;
	showCategoryTreeDialog();
}
function SubForm(rtnData) {
	if (rtnData != null) {
		rtnData = rtnData.GetHashMapArray();
		document.sysBookmarkMainForm.docCategoryId.value = rtnData[0].id;
		Com_Submit(document.sysBookmarkMainForm, 'setCategory');
	}
}
function EditBookmark() {
	if (!List_CheckSelect()) return;
	var select = document.getElementsByName("List_Selected");
	var value = "";
	for(var i=0; i<select.length; i++) {
		if(select[i].checked) {
			value = select[i].value;
			break;
		}
	}
	Com_OpenWindow('sysBookmarkMain.do?method=edit&fdId=' + value,'_blank');
}
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
<%--
<c:import url="/resource/jsp/search_bar.jsp" charEncoding="UTF-8">
	<c:param name="fdModelName"
		value="com.landray.kmss.sys.bookmark.model.SysBookmarkMain" />
</c:import>
 --%>

<c:import url="/sys/bookmark/sys_bookmark_main/search_bar.jsp" charEncoding="UTF-8" />

<html:form action="/sys/bookmark/sys_bookmark_main/sysBookmarkMain.do">
	<html:hidden property="docCategoryId" />
	<div id="optBarDiv">
	<input type="button" value="<bean:message key="button.setCategory" bundle="sys-bookmark"/>"
		onclick="ToSetCategory();">
	<c:if test="${empty param.cateid}" >
	<input type="button" value="<bean:message key="button.add"/>"
		onclick="Com_OpenWindow('<c:url value="/sys/bookmark/sys_bookmark_main/sysBookmarkMain.do" />?method=add');">
	</c:if>
	<c:if test="${not empty param.cateid}" >
	<input type="button" value="<bean:message key="button.add"/>"
		onclick="Com_OpenWindow('<c:url value="/sys/bookmark/sys_bookmark_main/sysBookmarkMain.do?method=add&cateid=${param.cateid}" />');">
	</c:if>
	<!--  <input type="button"
		value="<bean:message key="button.edit"/>"
		onclick="EditBookmark();"> -->
	<input type="button" value="<bean:message key="button.delete"/>"
		onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysBookmarkMainForm, 'deleteall');">
	<input type="button" value="<bean:message key="button.search"/>" 
		onclick="Search_Show();">
	</div>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt"><input type="checkbox" name="List_Tongle"></td>
				<td width="40pt"><bean:message key="page.serial"/></td>
				<sunbor:column property="sysBookmarkMain.docSubject">
					<bean:message bundle="sys-bookmark" key="sysBookmarkMain.docSubject"/>
				</sunbor:column>
				<td><bean:message bundle="sys-bookmark" key="sysBookmarkCategory.fdParentId"/></td>
				<sunbor:column property="sysBookmarkMain.docCreateTime">
					<bean:message bundle="sys-bookmark" key="sysBookmarkMain.docCreateTime"/>
				</sunbor:column>
				<td><bean:message bundle="sys-bookmark" key="sysBookmarkMain.link"/></td>
				<td><bean:message bundle="sys-bookmark" key="sysBookmarkMain.operate"/></td>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysBookmarkMain" varStatus="vstatus">
			<tr>
				<td>
					<input type="checkbox" name="List_Selected" value="${sysBookmarkMain.fdId}">
				</td>
				<td>${vstatus.index+1}</td>
				<td>
					<c:out value="${sysBookmarkMain.docSubject }" />
				</td>
				<td>
					<c:out value="${sysBookmarkMain.docCategory.fdName }" />
				</td>
				<td>
					<kmss:showDate value="${sysBookmarkMain.docCreateTime }" type="datetime" />
				</td>
				<td title="${sysBookmarkMain.fdUrl }">
					<a href="<c:url value="${sysBookmarkMain.fdUrl }" />" target="_blank" ><bean:message key="button.view"/></a>
				</td>
				<td>
					<a href="<c:url value="/sys/bookmark/sys_bookmark_main/sysBookmarkMain.do?method=edit&fdId=${sysBookmarkMain.fdId}" />" target="_blank" ><bean:message key="button.edit"/></a>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>
