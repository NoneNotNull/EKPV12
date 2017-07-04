<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.framework.plugin.core.config.IExtension"%>
<%@page import="com.landray.kmss.km.imeeting.util.StatExecutorPlugin"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
	String fdType=(String)request.getAttribute("fdType");
	IExtension ext=StatExecutorPlugin.getExtensionForStat(fdType);
	if(ext!=null){
		if(StringUtil.isNotNull(StatExecutorPlugin.getConditionJsp(ext))){
			request.setAttribute("conditionUrl", StatExecutorPlugin.getConditionJsp(ext));
		}
		if(StringUtil.isNotNull(StatExecutorPlugin.getExtJs(ext))){
			request.setAttribute("extJs", StatExecutorPlugin.getExtJs(ext));
		}
	}
%>
<template:include ref="default.view" sidebar="no">
	
	<%-- 标签页标题 --%>
	<template:replace name="title">
		<bean:message bundle="km-imeeting"  key="kmImeetingStat.${fdType}" />
	</template:replace>

	<template:replace name="head">
		<script language="JavaScript">
			Com_IncludeFile("echarts-plain.js",
				"${LUI_ContextPath}/sys/ui/js/chart/echarts/","js",true);
			Com_IncludeFile("validator.jsp|validation.js|plugin.js|validation.jsp|xform.js|jquery.js|dialog.js|calendar.js", null, "js");
			seajs.use("${LUI_ContextPath}/km/imeeting/resource/css/stat.css");
			seajs.use(["${LUI_ContextPath}/km/imeeting/resource/js/stat.js"],function(stat){
				window.stat = stat;
			});
			LUI.ready(function(){
				$("#div_condtionSection").attr("isShow","1");
				window.stat.expandDiv($("#div_condtionArea .div_titleArea"),'div_condtionSection');
				//禁用
				var queryAreaEles = $("#div_condtionSection *");
				queryAreaEles.prop("disabled",true);
				queryAreaEles.removeAttr("onclick");
				//执行查询
				if("${param.listDetail}"=="true"){
					window.stat.listDetail();
				}else{
					var type=Com_GetUrlParameter(location.href, "type");
					window.stat.statExecutor(type);
				}
			});
		</script>
	</template:replace>
	
	
	<%-- 顶部操作栏 --%>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
			<kmss:authShow roles="ROLE_KMIMEETING_STAT_MAINTAINER">
				<%--编辑 --%>
				<ui:button text="${lfn:message('button.edit') }" order="1" onclick="Com_OpenWindow('kmImeetingStat.do?method=edit&fdId=${param.fdId}','_self');">
				</ui:button>
				<%--删除 --%>
				<ui:button text="${lfn:message('button.delete') }" order="1" onclick="Delete();">
				</ui:button>
			</kmss:authShow>
			<%--关闭 --%>
			<ui:button text="${lfn:message('button.close') }" order="5" onclick="Com_CloseWindow();">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	
	<%-- 路径导航栏 --%>
	<template:replace name="path">
		<ui:combin ref="kmImeeting.stat.path">
			<ui:varParam name="id" value="pathMenu"></ui:varParam>
			<ui:varParam name="items">
				[{
						text:'<bean:message key="km-imeeting:kmImeetingStat.${fdType}"/>',
						href:"#"
				}]
			</ui:varParam>
		</ui:combin>
	</template:replace>	
	
	<%--主内容区--%>
	<template:replace name="content"> 
		<html:form action="/km/imeeting/km_imeeting_stat/kmImeetingStat.do">
			<html:hidden property="method_GET"/>
			<html:hidden property="fdId"/>
			<p class="lui_form_subject">
				<bean:message key="km-imeeting:kmImeetingStat.${kmImeetingStatForm.fdType}"/>
			</p>
			<div class="lui_form_content_frame" style="padding-top:20px">
				<html:hidden property="fdType"/>
				<%--条件筛选--%>	
				<div id="div_condtionArea">
					<div class="div_section">
						<div class="div_line"></div>
						<div class="div_titleArea"  onclick="window.stat.expandDiv(this,'div_condtionSection');">
							${lfn:message('km-imeeting:kmImeetingStat.title.condition') }
							<span class="div_icon_coll"></span>
						</div>
					</div>	
					<c:import url="${conditionUrl}" charEncoding="UTF-8">
						<c:param name="fdType" value="${kmImeetingStatForm.fdType}"/>
						<c:param name="formName" value="kmImeetingStatForm"/>
						<c:param name="mode" value="edit"></c:param>
					</c:import>
				</div>
				<div id="div_chartArea">
					<div class="div_section">
						<div class="div_line"></div>
						<div class="div_titleArea" onclick="window.stat.expandDiv(this,'div_reportSection');">
							${lfn:message('km-imeeting:kmImeetingStat.stat.section.result')}
							<span class="div_icon_exp"></span>
						</div>
					</div>
					<c:if test="${empty param.listDetail or param.listDetail=='' }">
						<div id="div_reportSection">
							<div id="div_chartSection">
								<%--echart图表--%>
								<ui:chart height="350px" width="800px;" id="kmImeetingStatChart">
				  					<ui:source type="AjaxJson">
										{"url":""}
				  					</ui:source>
								</ui:chart>
							</div>
							<div id="div_listSection">
								<div id="div_list" class="div_list"></div>
							</div>
						</div>
					</c:if>
					<c:if test="${not empty param.listDetail and param.listDetail==true }">
						<div id="div_reportSection">
							<div id="div_list" class="div_list"></div>
							<br/>
							<list:paging></list:paging>
							<script type="text/javascript">
								seajs.use( [ 'lui/topic' ], function(topic) {
									topic.subscribe("paging.changed", function(evt) {
										var pages = evt['page'];
										for ( var i = 0; i < pages.length; i++) {
											var pageInfo = pages[i];
											$("input[name='" + pageInfo['key'] + "']").val(
													pageInfo['value'][0]);
										}
										window.stat.listDetail();
									}, null);
								});
							</script>
						</div>
					</c:if>
				</div>
			</div>
		</html:form>
	</template:replace>
</template:include>
<script type="text/javascript">
	seajs.use(['sys/ui/js/dialog'], function(dialog) {
		window.Delete=function(){
	    	dialog.confirm("${lfn:message('page.comfirmDelete')}",function(flag){
		    	if(flag==true){
		    		Com_OpenWindow('kmImeetingStat.do?method=delete&fdId=${param.fdId}','_self');
		    	}else{
		    		return false;
			    }
		    },"warn");
	    };
	});
</script>
<c:if test="${not empty extJs }">
	<script language="JavaScript" src="${LUI_ContextPath}${extJs}"></script>
</c:if>