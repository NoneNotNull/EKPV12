<%@page import="com.landray.kmss.sys.portal.util.SysPortalConfig"%>
<%@page import="com.landray.kmss.sys.ui.util.SysUiConstant"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.util.SpringBeanUtil,
				com.landray.kmss.sys.person.service.ISysPersonMyTabCategoryService,
				net.sf.json.JSONObject,
				org.apache.commons.beanutils.PropertyUtils,
				java.util.*,
				com.landray.kmss.sys.ui.plugin.SysUiPluginUtil,
				com.landray.kmss.sys.ui.xml.model.SysUiPortlet,
				com.landray.kmss.sys.ui.xml.model.SysUiOperation" %>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/portal/portal.tld" prefix="portal"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
	<%
	//if (request.getAttribute("navs") == null) {
		ISysPersonMyTabCategoryService service = (ISysPersonMyTabCategoryService) SpringBeanUtil.getBean("sysPersonMyTabCategoryService");
		List myNavs = service.findPersonInEffectTabCategories();
		request.setAttribute("links_navs", myNavs);
	//}
	%>
	<%!
	public static Map buildVarsMap(Map vars) {
		Map result = new HashMap();
		if (vars == null) {
			return result;
		}
		for (Iterator it = vars.entrySet().iterator(); it.hasNext(); ) {
			Map.Entry entry = (Map.Entry) it.next();
			String key = entry.getKey().toString();
			Object value = entry.getValue();
			if (value instanceof Map) {
				value = ((Map) value).get(key);
			}
			result.put(key, value);
		}
		return result;
	}
	public static List getPortalOptions(JSONObject portlet) {
		String sid = portlet.getString("sourceId");
		sid = sid.substring(0, sid.lastIndexOf(".source"));
		SysUiPortlet cfgPortal = SysUiPluginUtil.getPortletById(sid);
		List<SysUiOperation> opts = cfgPortal.getFdOperations();
		if (opts.isEmpty()) {
			return Collections.emptyList();
		}
		List result = new ArrayList();
		List right = new ArrayList();
		for (Iterator it = opts.iterator(); it.hasNext(); ) {
			SysUiOperation opt = (SysUiOperation) it.next();
			if ("left".equals(opt.getAlign())) {
				result.add(opt);
			} else {
				right.add(opt);
			}
		}
		Collections.reverse(right);
		result.addAll(right);
		return result;
	}
	%>
	<%-- <ui:tabpanel> --%>
		<c:forEach items="${links_navs}" var="nav">
			<c:if test="${nav.sysNavCategory != null}">
				<c:set var="nav" value="${nav.sysNavCategory }" scope="page" />
			</c:if>
				
			<c:if test="${nav.fdType eq 'page' }">
			<%
			List pages = (List) PropertyUtils.getProperty(pageContext.getAttribute("nav"), "fdPages");
			if (pages != null && !pages.isEmpty()) {
				JSONObject portalCfg = JSONObject.fromObject(PropertyUtils.getProperty(pages.get(0), "fdConfig"));
				if(portalCfg.getString("sourceId").indexOf(SysUiConstant.SEPARATOR)>0){
					String code = portalCfg.getString("sourceId"); 
					code = code.substring(0, code.indexOf(SysUiConstant.SEPARATOR));
					pageContext.setAttribute("xxserver",code);
				}else{
					pageContext.setAttribute("xxserver","");
				}
				pageContext.setAttribute("portalCfg", portalCfg);
				
				Map sourceVars = buildVarsMap((Map) PropertyUtils.getProperty(portalCfg, "sourceOpt"));
				pageContext.setAttribute("sourceVars", sourceVars);
				
				Map renderVars = buildVarsMap((Map) PropertyUtils.getProperty(portalCfg, "renderOpt"));
				pageContext.setAttribute("renderVars", renderVars);
				
				List options = getPortalOptions(portalCfg);
				pageContext.setAttribute("options", options);
			%>
			<portal:portlet title="${empty nav.fdShortName ? nav.fdName : nav.fdShortName }" cfg-server="${xxserver}">
				<ui:dataview format="${portalCfg.format }">
					<ui:source ref="${portalCfg.sourceId }" vars="${sourceVars }">
					</ui:source>
					<ui:render ref="${portalCfg.renderId }" vars="${renderVars }">
					</ui:render>
				</ui:dataview>
				<c:forEach items="${options }" var="opt">
					<ui:operation href="${opt.href }" name="${opt.name }" align="${opt.align }" icon="${opt.icon }" target="${opt.target }" type="${opt.type }"/>
				</c:forEach>
			</portal:portlet>
			<%}%>
			</c:if>
			
			<c:if test="${nav.fdType != 'page' }">
			<portal:portlet title="${empty nav.fdShortName ? nav.fdName : nav.fdShortName }">
				<ui:dataview format="${nav.fdType eq 'shortcut' ? 'sys.ui.picMenu' : 'sys.ui.textMenu'}">
					<ui:source type="Static">
						[<ui:trim>
							<c:forEach items="${nav.fdLinks}" var="link">
							{
								text: "<c:out value="${link.fdName }" />",
								href: "${link.fdUrl }",
								target: "${nav.fdTarget }",
								icon: "${link.fdIcon }",
								title: "<c:out value="${link.fdName }" />"
							},
							</c:forEach>
						</ui:trim>]
					</ui:source>
					<ui:render ref="${nav.fdType eq 'shortcut' ? 'sys.ui.picMenu.default' : 'sys.ui.textMenu.default'}">
						<ui:var name="target" value="${nav.fdTarget }" />
						<c:if test="${nav.fdType eq 'hotlink' }">
							<ui:var name="cols" value="${nav.fdCols }" />
						</c:if>
					</ui:render>
				</ui:dataview>
			</portal:portlet>
			</c:if>
		</c:forEach>
		
	<%-- </ui:tabpanel> --%>
	<%
	request.removeAttribute("links_navs");
	%>