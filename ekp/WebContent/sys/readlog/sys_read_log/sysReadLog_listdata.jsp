<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/list.tld" prefix="list" %>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<list:data>
	<list:data-columns var="item" list="${queryPage.list}" varIndex="index">
		<list:data-column style="width:35px;" col="index" title="${ lfn:message('page.serial') }">
			${index+1}
		</list:data-column>
		<list:data-column property="fdReader.fdName" title="${ lfn:message('sys-readlog:sysReadLog.fdReaderId') }">
		</list:data-column>
		<list:data-column style="width:200px;" property="fdReadTime" title="${ lfn:message('sys-readlog:sysReadLog.fdReadTime') }">
		</list:data-column> 
		<list:data-column style="width:150px;" property="fdReader.fdParent.fdName" title="${ lfn:message('sys-organization:sysOrgElement.dept') }">
		</list:data-column> 
		
		<list:data-column style="width:100px;" col="readType" title="${ lfn:message('sys-readlog:sysReadLog.fdReadType') }">
				<c:if test="${item.readType==1}">					
					<bean:message key="sysReadLog.fdReadType.process" bundle="sys-readlog" />
				</c:if>
				<c:if test="${item.readType!=1}">
					<bean:message key="sysReadLog.fdReadType.publish" bundle="sys-readlog" />
				</c:if>
		</list:data-column> 
	</list:data-columns>
	
	<list:data-paging currentPage="${queryPage.pageno }" pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
	
</list:data>