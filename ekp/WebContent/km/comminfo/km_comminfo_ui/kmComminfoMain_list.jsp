<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="kmComminfoMain" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column>

		<list:data-column  col="docSubject"  title="${ lfn:message('km-comminfo:kmComminfoMain.docSubject') }" escape="false" style="text-align:left">
			<a href="${LUI_ContextPath}/km/comminfo/km_comminfo_main/kmComminfoMain.do?method=view&fdId=${kmComminfoMain.fdId}" target="_blank">
			   <c:out value="${kmComminfoMain.docSubject}"/>
			</a>  
		</list:data-column>
		<list:data-column headerStyle="100px" col="docCategory" title="${ lfn:message('km-comminfo:kmComminfoMain.docCategoryId')}" style="width:30%"  escape="false">
				<c:out value="${kmComminfoMain.docCategory.fdName}"/>
		</list:data-column>
		<list:data-column headerStyle="100px" col="docCreator" title="${ lfn:message('km-comminfo:kmComminfoMain.docCreatorId')}" style="width:5%"  escape="false">
			<ui:person personId="${kmComminfoMain.docCreator.fdId}" personName="${kmComminfoMain.docCreator.fdName}"></ui:person>
		</list:data-column>
		<list:data-column headerStyle="100px" col="docCreateTime" title="${ lfn:message('km-comminfo:kmComminfoMain.docCreateTime')}" style="width:15%"  escape="false">
			<kmss:showDate value="${kmComminfoMain.docCreateTime}" type="DATE"></kmss:showDate>
		</list:data-column>
	</list:data-columns>
	
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>