<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<c:if test="${not empty myNavs }">
<table id="categoriesTable" class="tb_normal detail_table" width="100%">
	<tr class="tr_normal_title">
		<td width="8px" align="center"><input type="checkbox" name="List_Tongle"></td>
		<td width="30px"><bean:message key="page.serial" /></td>
		<td width="*"><bean:message bundle="sys-person" key="sysPersonMyNavCategory.fdName" /></td>
		<td width="*"><bean:message bundle="sys-person" key="sysPersonSysNavCategory.fdShortName" /></td>
		<td width="35px"><bean:message bundle="sys-person" key="sysPersonMyNavCategory.fdStatus" /></td>
		<td width="60px"><bean:message bundle="sys-person" key="sysPersonMyNavCategory.fdType" /></td>
		<td width="120px"><bean:message bundle="sys-person" key="sysPersonMyNavCategory.docCreateTime" /></td>
	</tr>
	<c:forEach items="${myNavs}" var="category" varStatus="vstatus">
	<tr data-url='<c:url value="/sys/person/sys_person_mynav_category/sysPersonMyNavCategory.do?method=edit" />&fdId=${category.fdId }' 
		style="cursor: pointer;"
		data-status="${category.fdStatus }">
		<td align="center" <c:if test="${not empty category.fdSysCategoryId }"> data-syslink="true" </c:if>>
			<input type="checkbox" name="List_Selected" value="${category.fdId }">
		</td>
		<td>
			${vstatus.index + 1}
		</td>
		<td>
			<c:out value="${category.fdName }" />
		</td>
		<td>
			<c:out value="${category.fdShortName }" />
		</td>
		<td align="center">
			<sunbor:enumsShow enumsType="sysPerson_fdStatus" value="${category.fdStatus }" />
		</td>
		<td align="center">
			<c:if test="${not empty category.fdSysCategoryId }"> <bean:message bundle="sys-person" key="sysPersonMyNavCategory.fdType.pushed" /> </c:if>
			<c:if test="${empty category.fdSysCategoryId }"> <bean:message bundle="sys-person" key="sysPersonMyNavCategory.fdType.defined" /> </c:if>
		</td>
		<td align="center">
			<kmss:showDate value="${category.docCreateTime }" type="datetime" />
		</td>
	</tr>
	</c:forEach>
</table>
</c:if>
<c:if test="${empty myNavs }">
<c:import url="/resource/jsp/list_norecord.jsp" charEncoding="utf-8" />
</c:if>