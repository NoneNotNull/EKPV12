<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>

<%@page import="java.util.Map"%>
<%@page import="com.landray.kmss.tib.common.mapping.plugins.TibCommonMappingIntegrationPlugins"%>
<%@page import="com.landray.kmss.tib.common.mapping.constant.Constant"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page import="com.landray.kmss.tib.common.mapping.plugins.IBaseTibCommonMappingIntegration"%>
<%@page import="com.landray.kmss.tib.common.mapping.model.TibCommonMappingFunc"%>
<%@page import="java.util.List"%>
<script type="text/javascript">
Com_IncludeFile("dialog.js|doclist.js|jquery.js");
</script>
<script src="${KMSS_Parameter_ContextPath}tib/common/resource/js/invoke.js"></script>
<!-- 避免重复引入,需要优化 -->
<script type="text/javascript" src="${KMSS_Parameter_ContextPath}tib/common/resource/js/ERP_data.js"></script>
<%
//取得对应扩展点信息
Map<String, String> pluginInfo_sap=TibCommonMappingIntegrationPlugins.getConfigByType(Constant.FD_TYPE_SAP);
if(pluginInfo_sap!=null&&!pluginInfo_sap.isEmpty()){
	//取得代码分离bean
	String beanName=pluginInfo_sap.get(TibCommonMappingIntegrationPlugins.ekpIntegrationBean);
	Object bean =SpringBeanUtil.getBean(beanName);
	if(bean instanceof IBaseTibCommonMappingIntegration){
		List<TibCommonMappingFunc>  funcs=((IBaseTibCommonMappingIntegration)bean).getFormEventIncludeList(request);
		if(funcs!=null&&!funcs.isEmpty()){
			//System.out.println("查找3"+fdTemplateId);
		%>
		<script type="text/javascript">
			//以resource文件夹为准的相对路径..存在风险,避免重复引入脚本\
			commJs();
		</script>
		<script src="${KMSS_Parameter_ContextPath}tib/sap/mapping/sapEkpFormEvent.js"></script>
		
		<% 
			for(int i=0;i<funcs.size();i++){	
				%>
			<%--c:import url="<%=funcs.get(i).getFormEventJspFilePath()%>" charEncoding="UTF-8">
			</c:import>
			--%>
			<%
				String jsp = funcs.get(i).getFdJspSegmentActual().replaceAll("&lt;", "<").replaceAll("&gt;", ">");
			%>
			<c:out value="<%=jsp%>" escapeXml="false"></c:out>
				<%
			}
		}
		
	}
}
%>


