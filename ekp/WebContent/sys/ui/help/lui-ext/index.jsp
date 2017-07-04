<%@ page import="com.landray.kmss.sys.config.xml.DesignConfigLoader"%>
<%@ page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
	if(request.getParameter("reLoad")!=null&&request.getParameter("reLoad").equals("yes")){
		DesignConfigLoader.getXmlReaderContext().refresh("http://www.landray.com.cn/schema/lui");
	}
	request.setAttribute("datas",SysUiPluginUtil.getExtends().values());

request.setAttribute("sys.ui.theme", "default");
%>
<ui:json var="columns">
	[
		{id:"fdId", name:"ID"},
		{id:"fdName", name:"名称"},
		{id:"fdName", name:"操作",type:"__custom__",text:"删除","onclick":"deleteTheme"}
	]
</ui:json>
<ui:json var="paths">
	[
		{name:"扩展资源"}
	]
</ui:json>
<template:include file="/sys/ui/help/common/list.jsp">
	<template:replace name="beforeList">
		<script type="text/javascript"> 
		  	function stopBubble(e) {
		        //如果提供了事件对象，则这是一个非IE浏览器
		        if ( e && e.stopPropagation )
		            //因此它支持W3C的stopPropagation()方法
		            e.stopPropagation();
		        else
		            //否则，我们需要使用IE的方式来取消事件冒泡
		            window.event.cancelBubble = true;
		    }
			function deleteTheme(rid,evt) {
				stopBubble(evt);
				seajs.use(['lui/jquery','lui/dialog'],function($,dialog){
					dialog.confirm("你确定要删除这个资源包吗?",function(val){
						if(val){
							$.get("${LUI_ContextPath}/sys/ui/sys_ui_extend/sysUiExtend.do?method=deleteExtend&id="+rid,function(txt){
								if($.trim(txt)=="操作成功"){
									dialog.success(txt);
									location.href = Com_SetUrlParameter(location.href, "reLoad", "yes");
								}
							});
						}
					});
				});				
			}
			function uploadTheme(){
				seajs.use(['lui/dialog'],function(dialog){
					dialog.iframe("/sys/ui/help/lui-ext/upload.jsp","上传",function(){
						location.href = Com_SetUrlParameter(location.href, "reLoad", "yes");
					},{"width":500,"height":300});
				});
			}
			function mergeTheme(){
				seajs.use(['lui/jquery','lui/dialog'],function($,dialog){
					$.get("${LUI_ContextPath}/sys/ui/sys_ui_extend/sysUiExtend.do?method=merge",function(txt){
						dialog.success(txt);
					});
				});
			}
			</script>
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" var-navwidth="95%">
			<ui:button text="合并" onclick="mergeTheme()" />
		</ui:toolbar>
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" var-navwidth="95%">
			<ui:button text="上传" onclick="uploadTheme()" />
		</ui:toolbar>
	</template:replace>
</template:include>
