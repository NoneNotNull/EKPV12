<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="java.util.*"%>
<%@page import="com.landray.kmss.util.*"%>
<%@page import="com.landray.kmss.sys.portal.service.*"%>
<%@page import="com.landray.kmss.sys.portal.util.*"%>
<%@page import="com.landray.kmss.sys.portal.model.*"%>
<%
	String id = PortalUtil.getPortalInfo(request).getPortalPageId();
	if(StringUtil.isNotNull(id)){ 
%>
<div class="lui_portal_nav_frame">
	<%-- 路径导航和切换门户 --%>
	<div class="lui_portal_nav_body" style="width:${param['width']};display:none;"> 
			<ui:dataview>
				<ui:source type="AjaxJson">
					{"url":"/sys/portal/sys_portal_main/sysPortalMain.do?method=pages&portalId=<%= PortalUtil.getPortalInfo(request).getPortalId() %>&pageId=<%= PortalUtil.getPortalPageId(request) %>"}
				</ui:source>
				<ui:render ref="sys.ui.picMenu.portalpage" var-target="auto" var-showMore="false" />
			</ui:dataview>		
	</div>
	<div class="lui_portal_nav_switch_off">
		<div id="lui_portal_nav_switch_button" class="lui_portal_nav_switch_down" onclick="portal_nav_page_switch(this)"></div>
	</div>
</div>
<script>
	function portal_nav_page_switch(obj,type){	
		var rsizePortalHeader = function(){ 
			LUI.$(".lui_portal_header_zone_frame_h").height(LUI.$(".lui_portal_header_zone_frame").height());
		};	
		if(type){
			if(type== "close"){
				if(obj.className == "lui_portal_nav_switch_up"){
					LUI.$(".lui_portal_nav_body").slideUp(rsizePortalHeader);
					obj.className = "lui_portal_nav_switch_down";
					obj.parentNode.className = "lui_portal_nav_switch_off";
				}
			}
			if(type== "open"){
				if(obj.className == "lui_portal_nav_switch_down"){
					LUI.$(".lui_portal_nav_body").slideDown(rsizePortalHeader);
					obj.className = "lui_portal_nav_switch_up";
					obj.parentNode.className = "lui_portal_nav_switch_on";
				}
			}
			return;
		}
		if(obj.className == "lui_portal_nav_switch_up"){
			LUI.$(".lui_portal_nav_body").slideUp(rsizePortalHeader);
			obj.className = "lui_portal_nav_switch_down";
			obj.parentNode.className = "lui_portal_nav_switch_off";
		}else{
			LUI.$(".lui_portal_nav_body").slideDown(rsizePortalHeader);
			obj.className = "lui_portal_nav_switch_up";
			obj.parentNode.className = "lui_portal_nav_switch_on";
		}
	}
	if("${param['scene']}"=="portal"){
		LUI.ready(function(){
			seajs.use(['theme!portal'],function(){
				portal_nav_page_switch(document.getElementById("lui_portal_nav_switch_button"));				
			});			 
			seajs.use(['lui/jquery'],function($){
				$(window).scroll(function(evt) {
					var hh = $(".lui_portal_header_zone_frame").height();
					var sh = $(window).scrollTop();
					var fh = $(".lui_portal_header_zone_content").height();
					if(sh>hh){
						portal_nav_page_switch(document.getElementById("lui_portal_nav_switch_button"),'close');
					}else if(sh<=fh){
						portal_nav_page_switch(document.getElementById("lui_portal_nav_switch_button"),'open');
					}	 
				});
			}); 
		});
	}else{
		LUI.ready(function(){
			LUI.$(".lui_portal_header_zone_frame_h").remove();
			LUI.$(".lui_portal_header_zone_frame").css("position","relative");
		});
	}
</script>
<%
	}
%>
 