<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/lbpmservice/support/lbpm_template/lbpmTemplate.do?fdModelName=${param.fdModelName}&fdKey=${param.fdKey}">
	<div id="optBarDiv">
		<kmss:auth requestURL="/sys/lbpmservice/support/lbpm_template/lbpmTemplate.do?method=updateAuditor&fdModelName=${param.fdModelName}&fdKey=${param.fdKey}" requestMethod="GET">
			<input type="button" value="<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.updateAuditor.button"/>"
				onclick="updateAuditor();">
		</kmss:auth>
		<kmss:auth requestURL="/sys/lbpmservice/support/lbpm_template/lbpmTemplate.do?method=add&fdModelName=${param.fdModelName}&fdKey=${param.fdKey}">
			<input type="button" value="<bean:message key="button.add"/>"
				onclick="Com_OpenWindow('<c:url value="/sys/lbpmservice/support/lbpm_template/lbpmTemplate.do" />?method=add&fdModelName=${param.fdModelName}&fdKey=${param.fdKey}');">
		</kmss:auth>
		<kmss:auth requestURL="/sys/lbpmservice/support/lbpm_template/lbpmTemplate.do?method=deleteall&fdModelName=${param.fdModelName}&fdKey=${param.fdKey}">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.lbpmTemplateForm, 'deleteall');">
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
				<sunbor:column property="lbpmTemplate.fdName">
					<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.fdName"/>
				</sunbor:column>
				<sunbor:column property="lbpmTemplate.fdIsDefault">
					<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.fdIsDefault"/>
				</sunbor:column>
				<sunbor:column property="lbpmTemplate.fdCreator.fdName">
					<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.fdCreator"/>
				</sunbor:column>
				<sunbor:column property="lbpmTemplate.fdCreateTime">
					<bean:message bundle="sys-lbpmservice-support" key="lbpmTemplate.fdCreateTime"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="lbpmTemplate" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/lbpmservice/support/lbpm_template/lbpmTemplate.do" />?method=view&fdModelName=${param.fdModelName}&fdId=${lbpmTemplate.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${lbpmTemplate.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${lbpmTemplate.fdName}" />
				</td>
				<td>
					<c:choose>
					<c:when test="${lbpmTemplate.fdIsDefault==true}">
						<bean:message key="message.yes"/>
					</c:when>
					<c:otherwise>
						<bean:message key="message.no"/>
					</c:otherwise>
					</c:choose>
				</td>
				<td>
					<c:out value="${lbpmTemplate.fdCreator.fdName}" />
				</td>
				<td>
					<kmss:showDate value="${lbpmTemplate.fdCreateTime}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%-- 处理人批量修改 --%>
<script>
function updateAuditor() {
	if(!List_CheckSelect()){
		return;
	}
	var s = "", c = 0;
	var obj = document.getElementsByName("List_Selected");
	for(var i=0; i<obj.length; i++) {
		if(obj[i].checked) {
			if(c>0){
				s+=";";
			}
			c++;
			s += obj[i].value;
		}
	}
	var url='<c:url value="/sys/lbpmservice/support/lbpm_template/lbpmTemplate.do" />?method=updateAuditor&fdModelName=${param.fdModelName}&fdKey=${param.fdKey}';
	url+="&fdIds="+s;
	Com_OpenWindow(url);
}
</script>
<%@ include file="/resource/jsp/list_down.jsp"%>