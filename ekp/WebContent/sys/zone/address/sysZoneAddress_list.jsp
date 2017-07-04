<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<list:data>
	<list:data-columns var="item" list="${queryPage.list }" varIndex="status">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column col="index">
		      ${status+1}
		</list:data-column >
		<list:data-column styleClass="com_author" property="fdName" title="${lfn:message('sys-zone:sysZonePersonInfo.username')}"  
			headerStyle="with:15%" style="width:147px;">
		</list:data-column>
		<list:data-column col="fdSex" headerStyle="with:8%" 
			title="${lfn:message('sys-zone:sysZonePersonInfo.fdSex')}">
				<sunbor:enumsShow enumsType="sys_org_person_sex" value="${item.fdSex }"/>
		</list:data-column>
		<list:data-column property="fdMobileNo" headerStyle="with:18%"  
			title="${lfn:message('sys-zone:sysZonePersonInfo.fdMobilePhone') }">
		</list:data-column>
		<list:data-column property="fdEmail" headerStyle="with:18%" 
			title="${lfn:message('sys-zone:sysZonePersonInfo.email')}">
		</list:data-column>
		<list:data-column property="fdWorkPhone" headerStyle="with:18%" 
			title="${lfn:message('sys-zone:sysZonePersonInfo.fdCompanyPhone')}">
		</list:data-column>
		<list:data-column property="hbmParent.fdName"  headerStyle="with:18%" 
			title="${lfn:message('sys-zone:sysZonePersonInfo.dep')}">
		</list:data-column>
	</list:data-columns>

	<list:data-paging page="${queryPage }">
	</list:data-paging>
</list:data>