<%@page import="com.landray.kmss.util.ArrayUtil"%>
<%@page import="com.landray.kmss.sys.ui.xml.model.SysUiRender"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@page import="com.landray.kmss.util.IDGenerator"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="org.apache.commons.beanutils.BeanUtils"%>
<%@page import="com.landray.kmss.sys.ui.xml.model.SysUiSource"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<template:include ref="default.view" width="95%" sidebar="no">
	<template:replace name="title">Portlet 预览</template:replace>
 	<template:replace name="content">
		<p class="txttitle">系统部件</p>		 
		<table class="tb_normal" width=95%>
			<tr>
				<td class="td_normal_title" width=15%>
					ID
				</td>
				<td width="85%">
					<xform:text property="fdId" style="width:85%" />
				</td>
			</tr>
			<tr>	
				<td class="td_normal_title" width=15%>
					名称
				</td>
				<td width=85%>
					<xform:text property="fdName" style="width:85%" />
				</td>
			</tr>
			<tr>
				<td class="td_normal_title" width=15%>
					所属模块
				</td>
				<td width="85%">
					${ sysPortalPortletForm.fdModule }
				</td>
			</tr>
			<tr>
				<td class="td_normal_title" width=15%>
					预览
				</td>
				<td width="85%">
					<table width="100%">
						<tr>
							<td valign="top">
								<div style="border: 1px red solid;">
									<iframe id="preview_portlet" frameborder="0" width="100%" height="400"></iframe>
								</div>
							</td>
							<td width="20"></td>
							<td valign="top">
								<% 	
									String jsname = "v_"+IDGenerator.generateID(); 
									String sourceId = BeanUtils.getProperty(request.getAttribute("sysPortalPortletForm"),"fdSource");
									SysUiSource source = SysUiPluginUtil.getSourceById(sourceId);
									String renderId = SysUiPluginUtil.getFormatById(source.getFdFormat()).getFdDefaultRender();
									pageContext.setAttribute("sourceId",sourceId);
									pageContext.setAttribute("renderId",renderId);
									pageContext.setAttribute("formats",ArrayUtil.concat(source.getFdFormats(),';'));
								%>
								<script src="${ LUI_ContextPath }/sys/ui/js/var.js"></script> 
								<table class="tb_normal" width="100%">
									<tr>
										<td>数据</td>
										<td><div class="portlet_input_source_opt" jsname='_source_opt'></div></td>
									</tr>
									<tr>
										<td>呈现<br>
											<a href="javascript:selectRender()">更改呈现</a>
										</td>
										<td><div class="portlet_input_render_opt" jsname='_render_opt'></div></td>
									</tr>
								</table>
								<script>
								var lodingImg = "<img src='${LUI_ContextPath}/sys/ui/js/ajax.gif'/>";
								var dialogWin = window;
								function ondocready(cb){
									$(".portlet_input_source_opt").html(lodingImg).load("${LUI_ContextPath}/sys/ui/jsp/vars/source.jsp?x="+(new Date().getTime()),{"fdId":"${sourceId}","jsname":"_source_opt"},function(){
										$(".portlet_input_render_opt").attr("renderId","${renderId}");
										$(".portlet_input_render_opt").html(lodingImg).load("${LUI_ContextPath}/sys/ui/jsp/vars/render.jsp?x="+(new Date().getTime()),{"fdId":"${renderId}","jsname":"_render_opt"},function(){
											 if(cb)
												 cb();
										});
									});									
								}
								function selectRender(){
									seajs.use(['lui/dialog'],function(dialog){
										dialog.iframe("/sys/portal/designer/jsp/selectportletrender.jsp?format="+encodeURIComponent("${formats}")+"&scene=portal", "${ lfn:message('sys-portal:sysPortalPage.desgin.selectrender') }", function(val){
											if(!val){
												return;
											}
											$(".portlet_input_render_opt").attr("renderId",val.renderId);
											$(".portlet_input_render_opt").html(lodingImg).load("${LUI_ContextPath}/sys/ui/jsp/vars/render.jsp?x="+(new Date().getTime()),{"fdId":val.renderId,"jsname":"_render_opt"},function(){
												onRefresh();
											});
										}, {width:750,height:550}); 
									});
								}
								function getConfigValues(){
									var config = {};
									if(window['_source_opt']!=null){
										config.sourceOpt = window['_source_opt'].getValue();
									}else{
										config.sourceOpt = {};
									}
									if(window['_render_opt']!=null){
										config.renderOpt = window['_render_opt'].getValue();
									}else{
										config.renderOpt = {};
									}
									return config;
								}
								function generateURL(vars){
									var urlPrefix = "<%= ResourceUtil.getKmssConfigString("kmss.urlPrefix")%>";
									var base = "/resource/jsp/widget.jsp?portletId=${sysPortalPortletForm.fdId}"; 
									var url = base; 
									if($.trim(vars.renderId)!=""){
										url+="&renderId="+$.trim(vars.renderId);
									}
									url+="&sourceOpt="+encodeURIComponent(domain.stringify(vars.sourceOpt)); 
									url+="&renderOpt="+encodeURIComponent(domain.stringify(vars.renderOpt)); 
									LUI.$("#portlet_url").html(urlPrefix+url).attr("href",urlPrefix+url);
									
									LUI.$("#preview_portlet").attr("src","${LUI_ContextPath}"+url);
								} 
								function onRefresh(){ 
									var tempData = getConfigValues();
									for (var key in tempData.sourceOpt)   {
										if(typeof(tempData.sourceOpt[key]) == "object"){
											tempData.sourceOpt[key] = tempData.sourceOpt[key][key];
										}
									}
									for (var key in tempData.renderOpt)   {
										if(typeof(tempData.renderOpt[key]) == "object"){
											tempData.renderOpt[key] = tempData.renderOpt[key][key];
										}
									}
									if($.trim($(".portlet_input_render_opt").attr("renderId"))!=""){
										tempData.renderId = $.trim($(".portlet_input_render_opt").attr("renderId"));
									}
									generateURL(tempData);
								}
								LUI.ready(function(){
									window.$ = LUI.$;
									ondocready(onRefresh);
								});
								</script>
								<button type="button" onclick="onRefresh()">刷新</button>
							</td>
						</tr>						
					</table>
								
				</td> 
				
			</tr>
			<tr>
				<td class="td_normal_title" >
					外部访问URL
				</td>
				<td >
					<a id="portlet_url" href="" target="_blank">
					</a>
				</td>
			</tr>
		</table>
 	</template:replace>
</template:include>