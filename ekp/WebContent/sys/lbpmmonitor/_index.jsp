<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.config.design.SysConfigs,com.landray.kmss.sys.simplecategory.model.ISysSimpleCategoryModel" %>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.list">
	<template:replace name="title">
		<c:out value="${ lfn:message('sys-lbpmmonitor:module.sys.lbpmmonitor') }"></c:out>
	</template:replace>
	<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav" id="simplecategoryId">
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_self">
			</ui:menu-item>
			<ui:menu-item text="${ lfn:message('sys-lbpmmonitor:module.sys.lbpmmonitor') }" href="/sys/lbpmmonitor/index.jsp" target="_self">
			</ui:menu-item>
		</ui:menu>
	</template:replace>
	<template:replace name="nav">
		
		<ui:combin ref="menu.nav.create">
			<ui:varParam name="title" value="${ lfn:message('sys-lbpmmonitor:module.sys.lbpmmonitor') }" />
			<ui:varParam name="button">
				[
						{
							"text": "${ lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.moniter') }",
							"href":"/sys/lbpmmonitor/index.jsp",
							"icon": "lui_icon_l_icon_1"
						}
				]
			</ui:varParam>
		</ui:combin>
		
		<div class="lui_list_nav_frame">
			<ui:accordionpanel>
				
				<c:set var="_href" scope="page" value="/sys/lbpmmonitor/index.jsp" />
				<ui:content style="padding:0px;" title="${lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.module') }">
					<c:if test="${empty param.modelName}">	
						<ui:dataview>
							<ui:source type="AjaxJson">
								{"url":"/sys/lbpmmonitor/sys_lbpmmonitor_criteria/SysLbpmMonitorCriteria.do?method=criteria"}
							</ui:source>
							<ui:render ref="sys.ui.cate.default" var-href="${_href}?modelName=!{value}" var-target="_self">
							</ui:render>
						</ui:dataview>
					</c:if>
					<c:if test="${not empty param.modelName}">
						<ui:menu layout="sys.ui.menu.ver.cate.slide">
							<ui:menu-source href="${_href}?modelName=!{value}"
								target="_self" >
								<ui:source type="AjaxJson">
									{"url":"/sys/lbpmmonitor/sys_lbpmmonitor_criteria/SysLbpmMonitorCriteria.do?method=criteria&current=${param.modelName}"} 
								</ui:source>
							</ui:menu-source>
						</ui:menu>
					</c:if>
					<c:if test="${not empty param.modelName}">
						<ui:operation href="${_href}" target="_self" name="${lfn:message('list.lever.up') }" align="left"/>
					</c:if>	
				</ui:content>
				
				<ui:content title="${ lfn:message('list.otherOpt') }">
					<ul class='lui_list_nav_list'>
						<%-- 
							<li><a href="" target="_blank">${ lfn:message('list.manager') }</a></li>
						--%>
						<li><a href="${LUI_ContextPath }/sys/lbpmmonitor/sys_lbpm_monitor_flowVersion/index.jsp" target="_self">${ lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.versionMng') }</a></li>
					</ul>
				</ui:content>
			</ui:accordionpanel>
		</div>
	</template:replace>
	<template:replace name="content">
		<list:criteria id="criteria1" expand="true">
			
		    <%--流程状态--%>  
			<list:cri-criterion title="${lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.status')}" key="fdStatus" multi="false"> 
				<list:box-select>
					<list:item-select id="fdStatus">
						<ui:source type="Static">
							   [{text:'${ lfn:message('sys-lbpmmonitor:status.append') }',value:'20'},
							   {text:'${ lfn:message('sys-lbpmmonitor:status.error') }',value:'21'},
							   {text:'${ lfn:message('sys-lbpmmonitor:status.publish') }',value:'30'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>

			<c:if test="${not empty param.modelName }">
				<%	
					String modelName=request.getParameter("modelName");
					String templateModelName = SysConfigs.getInstance().getFlowDefByMain(modelName).getTemplateModelName();
					Class clazz = Class.forName(templateModelName);
					boolean isSimpleCategory=ISysSimpleCategoryModel.class.isAssignableFrom(clazz);
					pageContext.setAttribute("templateModelName", templateModelName);
					pageContext.setAttribute("isSimpleCategory", isSimpleCategory);
				%>
				<c:if test="${isSimpleCategory}">
					<%-- 
					<list:cri-criterion title="${lfn:message('sys-ui:ui.criteria.simplecategory') }" expand="false" key="simpleCategory">
						<list:box-select>
						<list:item-select type="lui/criteria/select_panel!CriterionHierarchyDatas">
							<ui:source type="AjaxJson">
								{url: "/sys/simplecategory/criteria/sysSimpleCategoryCriteria.do?method=criteria&modelName=${templateModelName}&parentId=!{value}"}
							</ui:source>
						</list:item-select>
						</list:box-select>
					</list:cri-criterion>--%>
					<list:cri-ref ref="criterion.sys.simpleCategory" key="simpleCategory" multi="false" title="${lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.categoryNav') }" expand="true">
					  <list:varParams modelName="${templateModelName}"/>
					</list:cri-ref>
				</c:if>
				<c:if test="${!isSimpleCategory}">
					<list:cri-ref ref="criterion.sys.category" key="docCategory" multi="false" title="${lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.categoryNav') }" expand="true">
					  <list:varParams modelName="${templateModelName}"/>
					</list:cri-ref>
				</c:if>
				
			</c:if>
			
			<list:cri-auto modelName="com.landray.kmss.sys.lbpm.engine.persistence.model.LbpmProcess" 
				property="fdCreator;fdCreateTime;" />
					
			<list:cri-ref key="fdId" ref="criterion.sys.string" title="${lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.fdId')}">
			</list:cri-ref>
			
			<list:cri-criterion title="${ lfn:message('sys-lbpmmonitor:sysLbpmMonitor.flow.otherSearch')}" key="other"> 
				<list:box-select>
					<list:item-select>
						<ui:source type="Static">
						    [{text:'${ lfn:message('sys-lbpmmonitor:sysLbpmMonitor.list.recentHandle') }', value:'recentHandle'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			
		</list:criteria>
		
		<!-- 排序 -->
		<div class="lui_list_operation">
			<table width="100%">
				<tr>
					<td  class="lui_sort">
						${ lfn:message('list.orderType') }：
					</td>
					<td>
						<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" count="6" >
							<list:sort property="fdCreateTime" text="${lfn:message('sys-lbpmmonitor:sysLbpmMonitor.order.creatorTime')}" group="sort.list" value="down"></list:sort>
							<list:sort property="fdStatus" text="${lfn:message('sys-lbpmmonitor:sysLbpmMonitor.order.status')}" group="sort.list"></list:sort>
						</ui:toolbar>
					</td>
					<td align="right">
						<ui:toolbar id="Btntoolbar">
							 <ui:button text="${lfn:message('sys-lbpmmonitor:button.batchPrivi')}" onclick="batchPrivil()" order="1" ></ui:button>
						</ui:toolbar>						
					</td>
				</tr>
			</table>
		</div>
		
	    <ui:fixed elem=".lui_list_operation"></ui:fixed>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
					{url:'/sys/lbpmmonitor/sys_lbpmmonitor_flow/SysLbpmMonitorFlow.do?method=listChildren&modelName=${param.modelName }'}
			</ui:source>
			<list:colTable isDefault="false" layout="sys.ui.listview.columntable" 
				rowHref="/sys/lbpmmonitor/sys_lbpmmonitor_flow/SysLbpmMonitorFlow.do?method=view&fdId=!{fdId}&fdModelName=!{fdModelName}"  name="columntable">
				<list:col-checkbox></list:col-checkbox>
				<list:col-serial></list:col-serial>
				<list:col-auto props=""></list:col-auto>
			</list:colTable>
		</list:listview> 
	 	<list:paging></list:paging>	 
	 	
	 	<script type="text/javascript">
	 		function batchPrivil(){
	 			var values = "";
	 			var selected;
	 			var select = document.getElementsByName("List_Selected");
	 			for ( var i = 0; i < select.length; i++) {
	 				if (select[i].checked) {
	 					selected = true;
	 					break;
	 				}
	 			}
	 			if (selected) {
	 				var url = '/sys/lbpmmonitor/sys_lbpm_monitor_flow/batchPirvil_flow.jsp';
	 				seajs.use( [ 'lui/dialog','lui/topic' ], function(dialog,topic) {
	 					dialog.iframe(url,"${lfn:message('sys-lbpmmonitor:button.batchPrivi')}", function(value) {
	 					}, {
	 						"width" : 800,
	 						"height" : 500
	 					});
	 				});
	 				return;
	 			} else {
	 				seajs.use( [ 'lui/dialog' ],function(dialog){
	 					dialog.alert("${lfn:message('page.noSelect')}");
	 				});
	 			}
	 		}
	 	</script>
	</template:replace>
</template:include>
