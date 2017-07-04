<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/list.tld" prefix="list" %>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@page import="com.landray.kmss.sys.ftsearch.config.LksField"%>
<%@page import="java.util.Map"%>
<%@page import="com.landray.kmss.sys.ftsearch.search.LksHit"%>

<list:data>
	<list:data-columns var="lksHit" list="${queryPage.list}" varIndex="index">
		<list:data-column col="subject" title="${lfn:message('sys-ftsearch-db:search.ftsearch.field.title')}" escape="false">
		<%
			String docSubject="";
			LksHit lksHit =(LksHit)pageContext.getAttribute("lksHit");
			if(lksHit!=null){
				Map lksFieldsMap =lksHit.getLksFieldsMap(); 
				LksField subject = (LksField)lksFieldsMap.get("subject");
				LksField title = (LksField)lksFieldsMap.get("title");
				LksField fileName = (LksField)lksFieldsMap.get("fileName");
				if (subject != null) {
					docSubject = subject.getValue();
				} else if (title != null) {
					docSubject = title.getValue();
				} else if (fileName != null) {
					docSubject = fileName.getValue();
				}
				out.print(docSubject);
			}
		%>
		</list:data-column>
		
		<list:data-column col="creator" title="${lfn:message('sys-ftsearch-db:search.search.creator')}" escape="false">
			${lksHit.lksFieldsMap["creator"].value}
		</list:data-column> 
		
		<list:data-column col="created" title="${lfn:message('sys-ftsearch-db:search.search.createDate')}" escape="false">
			${lksHit.lksFieldsMap['createTime'].value}
		</list:data-column>
		 
		<list:data-column col="moduleName" title="${lfn:message('sys-ftsearch-db:search.search.modelName')}" escape="false">
			${lksHit.lksFieldsMap['modelName'].value}
		</list:data-column> 
		
		<list:data-column col="link" escape="false">
			${lksHit.lksFieldsMap['linkStr'].value }
		</list:data-column> 
	</list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno }" pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
	
</list:data>