<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/list.tld" prefix="list" %>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="item" list="${listPublishRecord}" varIndex="index">
	    <list:data-column property="fdId">
		</list:data-column >
		<list:data-column style="width:35px;" col="index" title="${ lfn:message('page.serial') }">
			${index+1}
		</list:data-column>
		<list:data-column property="docCreator.fdName" title="${ lfn:message('sys-news:sysNewsPublishMain.submitor') }" style="width:25%">
		</list:data-column>
		<!--提交时间-->
		<list:data-column property="docCreateTime" title="${ lfn:message('sys-news:sysNewsPublishMain.subTime') }" style="width:25%">
		</list:data-column>
		<list:data-column style="width:25%" property="fdTemplate.fdName" title="${ lfn:message('sys-news:sysNewsPublishMain.fdCayegoryName') }">
		</list:data-column>
		<list:data-column style="width:20%;" col="docStatus" escape="false" title="${ lfn:message('sys-news:sysNewsPublishMain.docStatus') }">
		      <sunbor:enumsShow value="${item.docStatus}" enumsType="common_status" />
		</list:data-column>
	</list:data-columns>
</list:data>