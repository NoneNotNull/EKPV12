<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/list.tld" prefix="list" %>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ page import="java.util.List,com.landray.kmss.util.ModelUtil" %>
<list:data>
	<list:data-columns var="item" list="${queryList}" varIndex="index">
		<list:data-column style="width:35px;" col="index" title="${ lfn:message('page.serial') }">
			${index+1}
		</list:data-column>
		<list:data-column property="docSubject" title="${ lfn:message('sys-edition:sysEditionMain.list.subject') }">
		</list:data-column>
		<list:data-column style="width:150px;"  property="docCreator.fdName" title="${ lfn:message('sys-edition:sysEditionMain.list.creator') }">
		</list:data-column>
		<list:data-column style="width:50px;" col="docVersion" title="${ lfn:message('sys-edition:sysEditionMain.list.version') }">
			${item.docMainVersion}.${item.docAuxiVersion}
		</list:data-column>
		<list:data-column style="width:200px;" property="docCreateTime" title="${ lfn:message('sys-edition:sysEditionMain.list.createtime') }">
		</list:data-column>
		<list:data-column col="rowHref" escape="false">
			<% 
				Object obj = pageContext.getAttribute("item");
				if(obj!=null){
					out.print(ModelUtil.getModelUrl(obj)+"&viewPattern=edition");
				}
			%>
		</list:data-column>
	</list:data-columns>
</list:data>