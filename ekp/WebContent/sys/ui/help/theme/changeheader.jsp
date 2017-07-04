<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.portal.util.*"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
	SysPortalInfo info = new SysPortalInfo();
	String header = request.getParameter("header");
	info.setPageHeaderId(header==null?"header.default":header);
	String footer = request.getParameter("footer");
	info.setPageFooterId(footer==null?"footer.default":footer);
	info.setUsePortal("false");
	request.setAttribute("sys_portal_page_preview", info);
	request.setAttribute("headers", PortalUtil.getPortalHeaders().values());
	request.setAttribute("footers", PortalUtil.getPortalFooters().values());
%>
<script>
	function switchThemeHelpHeader(){
		seajs.use(['lui/dialog'], function(dialog){
			dialog.build(
				{
					config : {
						width : 300,
						height : 100,
						title : "请选择页眉页脚",
						content : {
							type : "Element",
							elem : '#theme_help_header_footer',
							buttons : [ {
								name : "OK",
								fn : function(value, dialog) {
									var url = location.href;
									url = Com_SetUrlParameter(url, "header", LUI.$('[name=theme_help_header]').val());
									url = Com_SetUrlParameter(url, "footer", LUI.$('[name=theme_help_footer]').val());
									location.href = url;
									dialog.hide();
								}
							}]
						}
					}
				}).show();
		});
	}
</script>
<div style="display:none;">
	<div id="theme_help_header_footer" style="line-height: 30px; padding:10px ">
		页眉：<select name="theme_help_header">
			<c:forEach items="${headers}" var="o">
				<option value="${o.fdId}"><c:out value="${o.fdName}"/></option>
			</c:forEach>
		</select><br>
		页眉：<select name="theme_help_footer">
			<c:forEach items="${footers}" var="o">
				<option value="${o.fdId}"><c:out value="${o.fdName}"/></option>
			</c:forEach>
		</select>
	</div>
	<ui:button text="切换页眉页脚" onclick="switchThemeHelpHeader();" order="2" parentId="theme_help_menu_toolbar" />
</div>