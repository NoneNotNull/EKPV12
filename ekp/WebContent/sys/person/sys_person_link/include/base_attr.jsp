<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
			<c:set var="base_attr" value="${base_attr == null ? navForm : base_attr}" scope="page" />
			<tr>
				<td class="td_normal_title">
					<bean:message bundle="sys-person" key="sysPersonSysNavCategory.docCreator"/>
				</td>
				<td>
					<c:out value="${base_attr.docCreatorName }" />
				</td>
				<td class="td_normal_title">
					<bean:message bundle="sys-person" key="sysPersonSysNavCategory.docCreateTime"/>
				</td><td>
					<c:out value="${base_attr.docCreateTime }" />
				</td>
			</tr>
			<c:if test="${not empty base_attr.docAlterorName}">
			<tr>
				<td class="td_normal_title">
					<bean:message bundle="sys-person" key="sysPersonSysNavCategory.docAlteror"/>
				</td>
				<td >
					<c:out value="${base_attr.docAlterorName }" />
				</td>
				<td class="td_normal_title">
					<bean:message bundle="sys-person" key="sysPersonSysNavCategory.docAlterTime"/>
				</td><td>
					<c:out value="${base_attr.docAlterTime }" />
				</td>
			</tr>
			</c:if>