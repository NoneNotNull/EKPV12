<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="kmSmissiveMain" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column col="docSubject" title="${ lfn:message('km-smissive:kmSmissiveMain.docSubject') }" style="text-align:left" escape="false">
		 <a class="com_subject" title="${kmSmissiveMain.docSubject}" href="${LUI_ContextPath}/km/smissive/km_smissive_main/kmSmissiveMain.do?method=view&fdId=${kmSmissiveMain.fdId}" target="_blank">
		   <c:out value="${kmSmissiveMain.docSubject}"/>
		 </a>
		</list:data-column>
		<list:data-column headerStyle="width:180px" property="fdFileNo" title="${ lfn:message('km-smissive:kmSmissiveMain.fdFileNo') }">
		</list:data-column> 
		<list:data-column headerStyle="width:60px" col="docAuthor.fdName" title="${ lfn:message('km-smissive:kmSmissiveMain.docAuthorId') }" escape="false">
		   <ui:person personId="${kmSmissiveMain.docCreator.fdId}" personName="${kmSmissiveMain.docCreator.fdName}"></ui:person> 
		</list:data-column>
		<list:data-column headerStyle="width:100px" property="fdMainDept.fdName" title="${ lfn:message('km-smissive:kmSmissiveMain.fdMainDeptId') }">
		</list:data-column>
		<list:data-column headerStyle="width:80px" col="docPublishTime" title="${ lfn:message('km-smissive:kmSmissiveMain.docPublishTime') }">
		    <kmss:showDate value="${kmSmissiveMain.docPublishTime}" type="date"/>
		</list:data-column>
		<list:data-column headerStyle="width:60px" col="docStatus" title="${ lfn:message('km-smissive:kmSmissiveMain.docStatus') }">
			<sunbor:enumsShow
				value="${kmSmissiveMain.docStatus}"
				enumsType="common_status" />
		</list:data-column>
	</list:data-columns>
</list:data>
