<%@ page language="java" contentType="text/xml; charset=UTF-8"   pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="
	com.landray.kmss.util.KmssMessageWriter,
	com.landray.kmss.util.StringUtil,
	java.util.List,
	java.util.ArrayList,
	java.util.Iterator,
	com.landray.kmss.sys.attachment.model.SysAttMain,
	com.landray.kmss.util.KmssReturnPage" %>
<%
KmssMessageWriter msgWriter = null;
if(request.getAttribute("KMSS_RETURNPAGE")!=null){
	msgWriter = new KmssMessageWriter(request, (KmssReturnPage)request.getAttribute("KMSS_RETURNPAGE"));
}else{
	msgWriter = new KmssMessageWriter(request, null);
}
List sysAttMains = (ArrayList)request.getAttribute("sysAttMains");
%>
<dataList>
	<data fdKey="${param.fdKey}" message="<%=StringUtil.XMLEscape(msgWriter.DrawMessages())%>" />
	<% if(sysAttMains!=null) {
		for (Iterator it = sysAttMains.iterator(); it.hasNext();) {
			SysAttMain sysAttMain = (SysAttMain) it.next();
	%>
		<data fdKey="<%=sysAttMain.getFdKey()%>" fdId="<%=sysAttMain.getFdId()%>" fdFileName="<%=StringUtil.XMLEscape(sysAttMain.getFdFileName())%>" fdSize="<%=sysAttMain.getFdSize()%>" fdContentType="<%=sysAttMain.getFdContentType()%>"/>
	<%
		}
	}
	%>
</dataList>