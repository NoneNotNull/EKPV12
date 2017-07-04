<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("dialog.js", null, "js");
function afterEngineSelect(rtnVal) {
	if(rtnVal!=null) {
		Com_OpenWindow(rtnVal.GetHashMapArray()[0].id, "_self");
	}
}
</script>
<html:form action="/sys/relation/sys_relation_foreign_module/sysRelationForeignModule.do">
	<div id="optBarDiv">
		<c:if test="${requestScope.showInportButton eq 'true'}">
		<input type="button" value='<bean:message key="button.import"/>'
				onclick="Dialog_Tree(false, null, null, null, 'sysRelationForeignModuleImportService&fdValue=!{value}', 
				 	'<bean:message  bundle="sys-relation" key="sysRelationForeignModule.fdSearchEngineBean.selectImport"/>',
				 	 null, afterEngineSelect, null, null,true);">
		</c:if>
		<kmss:auth requestURL="/sys/relation/sys_relation_foreign_module/sysRelationForeignModule.do?method=add" requestMethod="GET">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/relation/sys_relation_foreign_module/sysRelationForeignModule.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/relation/sys_relation_foreign_module/sysRelationForeignModule.do?method=deleteall" requestMethod="GET">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysRelationForeignModuleForm, 'deleteall');">
		</kmss:auth>
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
				
				<sunbor:column property="sysRelationForeignModule.fdModuleName">
					<bean:message  bundle="sys-relation" key="sysRelationForeignModule.fdModuleName"/>
				</sunbor:column>
				<sunbor:column property="sysRelationForeignModule.fdOrder">
					<bean:message  bundle="sys-relation" key="sysRelationForeignModule.fdOrder"/>
				</sunbor:column>				
				<sunbor:column property="sysRelationForeignModule.fdSearchEngineBean">
					<bean:message  bundle="sys-relation" key="sysRelationForeignModule.fdSearchEngineBean"/>
				</sunbor:column>				
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysRelationForeignModule" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/relation/sys_relation_foreign_module/sysRelationForeignModule.do" />?method=edit&fdId=${sysRelationForeignModule.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysRelationForeignModule.fdId}">
				</td>
				<td>${vstatus.index+1}</td>	
							
				<td>
					<c:out value="${sysRelationForeignModule.fdModuleName}" />
				</td>
				<td>
					<c:out value="${sysRelationForeignModule.fdOrder}" />
				</td>
				
				<td>
					<c:out value="${sysRelationForeignModule.fdSearchEngineBean}" />
				</td>
				
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>