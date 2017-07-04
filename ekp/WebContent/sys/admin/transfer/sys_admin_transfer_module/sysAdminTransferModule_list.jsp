<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/admin/transfer/sys_admin_transfer_module/sysAdminTransferModule.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/admin/transfer/sys_admin_transfer_module/sysAdminTransferModule.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/admin/transfer/sys_admin_transfer_module/sysAdminTransferModule.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/admin/transfer/sys_admin_transfer_module/sysAdminTransferModule.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysAdminTransferModuleForm, 'deleteall');">
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
				<td width="10pt">
					<input type="checkbox" name="List_Tongle">
				</td>
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<sunbor:column property="sysAdminTransferModule.fdName">
					<bean:message bundle="sys-admin-transfer" key="sysAdminTransferModule.fdName"/>
				</sunbor:column>
				<sunbor:column property="sysAdminTransferModule.fdPath">
					<bean:message bundle="sys-admin-transfer" key="sysAdminTransferModule.fdPath"/>
				</sunbor:column>
				<sunbor:column property="sysAdminTransferModule.fdStatus">
					<bean:message bundle="sys-admin-transfer" key="sysAdminTransferModule.fdStatus"/>
				</sunbor:column>
				<sunbor:column property="sysAdminTransferModule.docCreateTime">
					<bean:message bundle="sys-admin-transfer" key="sysAdminTransferModule.docCreateTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysAdminTransferModule" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/admin/transfer/sys_admin_transfer_module/sysAdminTransferModule.do" />?method=view&fdId=${sysAdminTransferModule.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${sysAdminTransferModule.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysAdminTransferModule.fdName}" />
				</td>
				<td>
					<c:out value="${sysAdminTransferModule.fdPath}" />
				</td>
				<td>
					<xform:radio property="fdStatus" showStatus="view" value="${sysAdminTransferModule.fdStatus}">
						<xform:enumsDataSource enumsType="sysAdminTransferModule.fdStatus" />
					</xform:radio>
				</td>
				<td>
					<kmss:showDate value="${sysAdminTransferModule.docCreateTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>