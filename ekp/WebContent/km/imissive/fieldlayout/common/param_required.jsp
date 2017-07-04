<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<tr>
	<td class="td_normal_title" width=40%>必填</td>
	<td>
		<c:if test="${param.defaultChecked=='true'}" >
			<input type="checkbox" name="control_required" checked value="true" storage='true' />
		</c:if>
		<c:if test="${param.defaultChecked!='true'}">
			<input type="checkbox" name="control_required" value="true" storage='true' />
		</c:if>
	</td>
</tr>