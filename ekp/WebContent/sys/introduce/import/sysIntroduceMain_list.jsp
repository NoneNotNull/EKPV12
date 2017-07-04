<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/list.tld" prefix="list" %>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/sunbor.tld" prefix="sunbor"%>
<list:data>
	<list:data-columns var="sysIntroduceMain" list="${queryPage.list}">
		<list:data-column property="fdIntroducer.fdName" title="${ lfn:message('sys-introduce:sysIntroduceMain.fdIntroducer') }">
		</list:data-column>
		<list:data-column property="fdIntroduceTime" title="${ lfn:message('sys-introduce:sysIntroduceMain.fdIntroduceTime') }">
		</list:data-column>
		<list:data-column col="introduceType" title="${ lfn:message('sys-introduce:sysIntroduceMain.introduce.type') }">
			<c:if test="${sysIntroduceMain.fdIntroduceToEssence&&(sysIntroduceMain.docStatus eq null or sysIntroduceMain.docStatus==30)}">
				<bean:message key="sysIntroduceMain.introduce.show.type.essence" bundle="sys-introduce" />
			</c:if>
			<c:if test="${sysIntroduceMain.fdIntroduceToNews}">
				<bean:message key="sysIntroduceMain.introduce.show.type.news" bundle="sys-introduce" />
			</c:if>
			<c:if test="${sysIntroduceMain.fdIntroduceToPerson}">
			</c:if>
		</list:data-column>
		<list:data-column property="introduceGoalNames" title="${ lfn:message('sys-introduce:sysIntroduceMain.fdIntroduceTo') }">
		</list:data-column>
		<list:data-column property="fdIntroduceGrade" title="${ lfn:message('sys-introduce:sysIntroduceMain.fdIntroduceGrade') }">
		</list:data-column>
		<list:data-column col="fdIntroduceReason" title="${ lfn:message('sys-introduce:sysIntroduceMain.fdIntroduceReason') }">
			<c:out value="${ sysIntroduceMain.fdIntroduceReason}"></c:out>
		</list:data-column>
	</list:data-columns>
	
	<list:data-paging currentPage="${queryPage.pageno }" pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }"></list:data-paging>
	
</list:data>