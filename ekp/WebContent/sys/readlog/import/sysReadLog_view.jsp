<%@page import="org.apache.commons.beanutils.PropertyUtils"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysReadLogForm" value="${requestScope[param.formName]}" />
<c:if test="${sysReadLogForm.readLogForm.fdIsShow=='true'}">
	<%
		Integer count = Integer.valueOf(PropertyUtils.getProperty(pageContext.getAttribute("sysReadLogForm"),"readLogForm.fdReadCount").toString());
		if(count==0){
			pageContext.setAttribute("__readlog__",ResourceUtil.getString("sys-readlog:sysReadLog.readRecord"));
		}else{
			pageContext.setAttribute("__readlog__",ResourceUtil.getString("sys-readlog:sysReadLog.readRecord")+"("+count+")");
		}
	%> 
	<ui:content title="${ __readlog__ }"> 
		<ui:event event="show">
			document.getElementById('readLogContent').src = '<c:url value="/sys/readlog/sys_read_log/sysReadLog.do" />?method=view&modelId=${sysReadLogForm.readLogForm.fdModelId}&modelName=${sysReadLogForm.readLogForm.fdModelName}';
		</ui:event>
		
		<table width="100%" ${param.styleValue}>
			<tr> 
				<td><iframe id="readLogContent" width="100%" height="1000" frameborder=0 scrolling=no></iframe></td>
			</tr> 
		</table>
	</ui:content>
</c:if>

