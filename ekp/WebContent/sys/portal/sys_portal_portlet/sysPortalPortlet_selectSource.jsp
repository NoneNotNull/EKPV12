<%@page import="com.landray.kmss.sys.portal.util.SysPortalConfig"%>
<%@page import="com.landray.kmss.sys.ui.util.SysUiConstant"%>
<%@page import="com.landray.kmss.sys.portal.util.SysPortalUtil"%>
<%@page import="com.landray.kmss.util.MD5Util"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.util.ArrayUtil"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@ page import="org.apache.commons.beanutils.PropertyUtils"%>
<%@ page import="com.landray.kmss.sys.ui.xml.model.*"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="sysPortalPortlet" list="${queryPage.list }">
		<list:data-column property="fdId" title="ID">
		</list:data-column>
		<list:data-column property="fdName" title="${ lfn:message('portlet.fdName') }">
		</list:data-column>
		<list:data-column property="fdModule" title="${ lfn:message('portlet.fdModule') }">
		</list:data-column>
		<list:data-column property="fdDescription" title="${ lfn:message('portlet.fdDescription') }">
		</list:data-column>
		<list:data-column property="fdSource">
		</list:data-column>
		<list:data-column col="fdServer">
			<%
				if (pageContext.getAttribute("sysPortalPortlet") != null) {
					String fdId = PropertyUtils.getProperty(
										pageContext.getAttribute("sysPortalPortlet"),
										"fdSource").toString();
					if(fdId.indexOf(SysUiConstant.SEPARATOR)>0){
						String server = fdId.substring(0,fdId.indexOf(SysUiConstant.SEPARATOR));
						out.print(SysPortalConfig.getServerName(server));
					}else{
						out.print("当前服务器");
					}
				}
			%>
		</list:data-column>
		<list:data-column col="fdFormat" title="数据格式">
			<%
				if (pageContext.getAttribute("sysPortalPortlet") != null) {
					String fdId = PropertyUtils.getProperty(
										pageContext.getAttribute("sysPortalPortlet"),
										"fdSource").toString();
								out.print(SysUiPluginUtil.getSourceById(fdId)
										.getFdFormat());
				}
			%>
		</list:data-column>
		<list:data-column col="fdFormats" title="数据格式s">
			<%
				if (pageContext.getAttribute("sysPortalPortlet") != null) {
					String fdId = PropertyUtils.getProperty(
										pageContext.getAttribute("sysPortalPortlet"),
										"fdSource").toString();
								out.print(ArrayUtil.concat(SysUiPluginUtil.getSourceById(fdId)
										.getFdFormats(),';'));
				}
			%>
		</list:data-column>
		<list:data-column col="fdRenderId">
			<%
				if (pageContext.getAttribute("sysPortalPortlet") != null) {
					String fdId = PropertyUtils.getProperty(
										pageContext.getAttribute("sysPortalPortlet"),
										"fdId").toString();
								SysUiRender render = SysUiPluginUtil
										.getPorgletSourceDefaultRender(fdId);
								out.print(render.getFdId());
				}
			%>
		</list:data-column>
		<list:data-column col="fdRenderName">
			<%
				if (pageContext.getAttribute("sysPortalPortlet") != null) {
					String fdId = PropertyUtils.getProperty(
							pageContext
									.getAttribute("sysPortalPortlet"),
							"fdId").toString();
					SysUiRender render = SysUiPluginUtil
							.getPorgletSourceDefaultRender(fdId);
					out.print(render.getFdName());
				}
			%>
		</list:data-column>
		<list:data-column col="operations" escape="false">
			<%
			if (pageContext.getAttribute("sysPortalPortlet") != null) {
				JSONArray json = new JSONArray();
				String fdId = PropertyUtils.getProperty(
						pageContext.getAttribute("sysPortalPortlet"),
						"fdId").toString();
				SysUiPortlet portlet = SysUiPluginUtil.getPortletById(fdId);
				List opts = portlet.getFdOperations();
				if (opts != null && opts.size() > 0) {
					for(int i=0;i<opts.size();i++){
						SysUiOperation opt = (SysUiOperation)opts.get(i);
						JSONObject obj = new JSONObject();
						obj.put("name",ResourceUtil.getMessage(opt.getName()));
						obj.put("key",MD5Util.getMD5String(opt.getHref()));
						json.add(obj);
					}
				} 
				out.print(json.toString());
			}
			%>
		</list:data-column>
	</list:data-columns>

	<list:data-paging page="${queryPage}" />
</list:data>