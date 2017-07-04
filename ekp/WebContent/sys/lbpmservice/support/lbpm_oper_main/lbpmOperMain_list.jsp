<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/lbpmservice/support/lbpm_oper_main/lbpmOperMain.do">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/lbpmservice/support/lbpm_oper_main/lbpmOperMain.do?method=add">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/lbpmservice/support/lbpm_oper_main/lbpmOperMain.do" />?method=add');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/lbpmservice/support/lbpm_oper_main/lbpmOperMain.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.lbpmOperMainForm, 'deleteall');">
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
				<sunbor:column property="lbpmOperMain.fdIsDefault">
					<bean:message bundle="sys-lbpmservice-support" key="lbpmOperMain.fdIsDefault"/>
				</sunbor:column>
				<sunbor:column property="lbpmOperMain.fdName">
					<bean:message bundle="sys-lbpmservice-support" key="lbpmOperMain.fdName"/>
				</sunbor:column>
				<sunbor:column property="lbpmOperMain.fdNodeType">
					<bean:message bundle="sys-lbpmservice-support" key="lbpmOperMain.fdNodeType"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="lbpmOperMain" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/lbpmservice/support/lbpm_oper_main/lbpmOperMain.do" />?method=view&fdId=${lbpmOperMain.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${lbpmOperMain.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<sunbor:enumsShow value="${lbpmOperMain.fdIsDefault}" enumsType="common_yesno" />
				</td>
				<td>
					<c:out value="${lbpmOperMain.fdName}" />
				</td>
				<td>
					<xform:select property="fdNodeType" value="${lbpmOperMain.fdNodeType}" showStatus="view">
			            <xform:customizeDataSource className="com.landray.kmss.sys.lbpmservice.support.service.spring.NodeTypeDataSource" />
			        </xform:select>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>