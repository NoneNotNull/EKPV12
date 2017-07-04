<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ page import="com.landray.kmss.tib.common.mapping.plugins.TibCommonMappingIntegrationPlugins"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.Map"%>

<%
// 组件解耦分离
List<Map<String, String>> listMap = TibCommonMappingIntegrationPlugins.getConfigs();
for (Map<String, String> map : listMap) {
	if (map.get("integrationKey").equals("SAP")) {
		request.setAttribute("sapFlag", "1");
	} else if (map.get("integrationKey").equals("SOAP")) {
		request.setAttribute("soapFlag", "1");
	} else if (map.get("integrationKey").equals("JDBC")) {
		request.setAttribute("jdbcFlag", "1");
	}
}
%>
<template:include ref="tib.list">
	<template:replace name="title">${ lfn:message('tib-common:module.tib.manage') }</template:replace>
	<template:replace name="nav">
		<ui:combin ref="menu.nav.create">
			<ui:varParam name="title" value="${ lfn:message('tib-common:module.tib.manage') }"></ui:varParam>
			<ui:varParam name="button">
				[
					{
						//"text": "${ lfn:message('tib-sys-core-provider:tibSysCoreIface.create') }",
						"text": "${ lfn:message('tib-common-mapping:tibCommonMappingModule.moduleRegister') }",
						//"href":"javascript:addDoc('${LUI_ContextPath}/tib/sys/core/provider/tib_sys_core_iface/tibSysCoreIface.do?method=add')",
						"href":"javascript:addDoc('${LUI_ContextPath}/tib/common/mapping/tib_common_mapping_module/tibCommonMappingModule.do?method=add')",
						"icon": "lui_icon_l_icon_1"
					}
				]
			</ui:varParam>
		</ui:combin>
		
		<div class="lui_list_nav_frame">
			<ui:accordionpanel>
				<%--TIB公共组件--%>
				<ui:content title="${ lfn:message('tib-common:module.tib.common') }" expand="true">
					 <%--数据初始化--%>
		             <ul class='lui_list_nav_list'>
					 	<li><a href="javascript:void(0)" onclick="tibLoadList('/tib/common/mapping/tib_common_mapping_module/tibCommonMappingModule_ui_include.jsp');" title="${ lfn:message('tib-common-mapping:table.tibCommonMappingModule') }">${ lfn:message('tib-common-mapping:table.tibCommonMappingModule') }</a></li>
		             	<li><ui:operation href="javascript:openPage('${LUI_ContextPath }/tib/common/init/tibCommonInit.do?method=showInit');" name="${ lfn:message('tib-common-init:module.init.data') }" target="_self"/></li>
					 </ul>	
					 <%--表单流程映射--%>
					 <dl class="lui_list_nav_dl">
		                 <dt><a href="javascript:void(0)" title="${ lfn:message('tib-common-mapping:tree.form.flow.mapping') }">${ lfn:message('tib-common-mapping:tree.form.flow.mapping') }</a></dt>
					     <ui:combin ref="menu.nav.tib.customcategory.default">
							 <ui:varParams 
								treeUrl="/tib/common/mapping/tib_common_mapping_module/tibCommonMappingModuleIndex.do?method=uiTreeView&currId=!{currId}&parentId=!{value}"/>
					     </ui:combin>
		             </dl>
					 <%--日志管理--%>
					 <dl class="lui_list_nav_dl">
		                 <dt><a href="javascript:void(0)" title="${ lfn:message('tib-common-log:tib.common.log.manager') }">${ lfn:message('tib-common-log:tib.common.log.manager') }</a></dt>
		                 <dd><a href="javascript:void(0)" onclick="openPage('${LUI_ContextPath }/tib/common/log/tib_common_log_manage/tibCommonLogManage.do?method=edit');" title="${ lfn:message('tib-common-log:table.tibCommonLogManage') }">${ lfn:message('tib-common-log:table.tibCommonLogManage') }</a></dd>
		                 <dd><a href="javascript:void(0)" onclick="tibLoadList('/tib/common/log/tib_common_log_opt/tibCommonLogOpt_ui_include.jsp');" title="${ lfn:message('tib-common-log:table.tibCommonLogOpt') }">${ lfn:message('tib-common-log:table.tibCommonLogOpt') }</a></dd>
		             </dl>
		             <dl class="lui_list_nav_dl">
		             	<dt><a href="javascript:void(0)" title="${ lfn:message('tib-common-log:tibCommonLogMain.fdType') }">${ lfn:message('tib-common-log:tibCommonLogMain.moduleLog') }</a></dt>
		                 <ui:combin ref="menu.nav.tib.customcategory.default">
							 <ui:varParams 
								treeUrl="/tib/common/log/tib_common_log_main/tibCommonLogMainIndex.do?method=uiTreeView&type=!{value}"/>
					     </ui:combin>
		             </dl>
		             <%--导入导出--%>
		             <dl class="lui_list_nav_dl">
		                 <dt><a href="javascript:void(0)" title="${ lfn:message('tib-common-inoutdata:module.tib.common.inoutdata') }">${ lfn:message('tib-common-inoutdata:module.tib.common.inoutdata') }</a></dt>
		                 <dd><a href="javascript:void(0)" onclick="openPage('${LUI_ContextPath }/tib/common/inoutdata/tibCommonInoutdata_export.jsp');" title="${ lfn:message('tib-common-inoutdata:imExport.dataExport') }">${ lfn:message('tib-common-inoutdata:imExport.dataExport') }</a></dd>
		                 <dd><a href="javascript:void(0)" onclick="openPage('${LUI_ContextPath }/tib/common/inoutdata/tibCommonInoutdata_upload.jsp');" title="${ lfn:message('tib-common-inoutdata:imExport.dataImport') }">${ lfn:message('tib-common-inoutdata:imExport.dataImport') }</a></dd>
		             </dl>
				</ui:content>
				<%--TIB服务--%>
				<ui:content title="${ lfn:message('tib-sys-core-provider:tib.sys.core.provider') }" expand="false">
					<ul class='lui_list_nav_list'>
						<li ><a href="javascript:void(0)" onclick="openPage('${LUI_ContextPath }/tib/sys/core/provider/tib_sys_core_iface/tibSysCoreIface.do?method=importInit')">${ lfn:message('tib-sys-core-provider:tibSysCoreIface.importInit') }</a></li>
						<li ><a href="javascript:void(0)" onclick="tibLoadList('/tib/sys/core/provider/tib_sys_core_iface_ui/tibSysCoreIface_include.jsp');">${ lfn:message('tib-sys-core-provider:table.tibSysCoreIface') }</a></li>
						<li ><a href="javascript:void(0)" onclick="tibLoadList('/tib/sys/core/provider/tib_sys_core_iface_impl_ui/tibSysCoreIfaceImpl_include.jsp');">
								${ lfn:message('tib-sys-core-provider:table.tibSysCoreIfaceImpl') }</a></li>
						<%--表单控件定义--%>
		                <li><a href="javascript:void(0)" onclick="tibLoadList('/tib/sys/core/control/tib_sys_core_control/tibSysCoreControl_ui_include.jsp');" title="${ lfn:message('tib-sys-core-control:module.tib.sys.core.control') }">${ lfn:message('tib-sys-core-control:module.tib.sys.core.control') }</a></li>
					</ul>
					<ui:operation href="javascript:openPage('${LUI_ContextPath}/tib/sys/core/provider/tib_sys_core_tag/tibSysCoreTag.do?method=list')" name="${ lfn:message('tib-sys-core-provider:tibSysCoreIface.tagMaintain') }" target="_self"/>
				</ui:content>
				
				<c:if test="${sapFlag == '1' }">
				<%--SAP中间件模块--%>		
				<ui:content title="${ lfn:message('tib-sys-sap-connector:module.tib.sys.sap.connector') }" expand="false">
					 <%--SAP连接配置--%>
					 <ul class='lui_list_nav_list'>
		                 <li><a href="javascript:void(0)" onclick="tibLoadList('/tib/sys/sap/connector/tib_sys_sap_server_setting/tibSysSapServerSetting_ui_include.jsp');" title="${ lfn:message('tib-sys-sap-connector:table.tibSysSapServerSetting') }">${ lfn:message('tib-sys-sap-connector:table.tibSysSapServerSetting') }</a></li>
		                 <li><a href="javascript:void(0)" onclick="tibLoadList('/tib/sys/sap/connector/tib_sys_sap_jco_setting/tibSysSapJcoSetting_ui_include.jsp');" title="${ lfn:message('tib-sys-sap-connector:table.tibSysSapJcoSetting') }">${ lfn:message('tib-sys-sap-connector:table.tibSysSapJcoSetting') }</a></li>
		                 <li><a href="javascript:void(0)" onclick="openPage('${LUI_ContextPath }/tib/sys/sap/connector/tib_sys_sap_jco_monitor.jsp');" title="${ lfn:message('tib-sys-sap-connector:tibSysSapJcoCheck') }">${ lfn:message('tib-sys-sap-connector:tibSysSapJcoCheck') }</a></li>
		             	 <li><a href="javascript:void(0)" onclick="tibLoadList('/tib/sys/sap/connector/tib_sys_sap_rfc_setting/tibSysSapRfcSetting_ui_include.jsp');" title="${ lfn:message('tib-sys-sap-connector:RfcSetting') }">${ lfn:message('tib-sys-sap-connector:RfcSetting') }</a></li>
		             	 <li><a href="javascript:void(0)" onclick="tibLoadList('/tib/sap/sync/tib_sap_sync_job/tibSapSyncJob_ui_include.jsp');" title="${ lfn:message('tib-sap-sync:tib.sap.sync') }">${ lfn:message('tib-sap-sync:tib.sap.sync') }</a></li>
		             </ul>
					 <%--函数管理所有分类
					 <dl class="lui_list_nav_dl">
		                 <dt><a href="javascript:void(0)" onclick="tibLoadList('/tib/sys/sap/connector/tib_sys_sap_rfc_setting/tibSysSapRfcSetting_ui_include.jsp');" 
		                 	title="${ lfn:message('tib-sys-sap-connector:RfcSetting') }">${ lfn:message('tib-sys-sap-connector:RfcSetting') }</a></dt>
		                 <ui:combin ref="menu.nav.tib.simplecategory.default">
							 <ui:varParams 
								modelName="com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcCategory" 
								href="javascript:tibLoadList('/tib/sys/sap/connector/tib_sys_sap_rfc_setting/tibSysSapRfcSetting_ui_include.jsp?categoryId=!{value}');"/>
					     </ui:combin>
		             </dl>
		             --%>
					 <%--SAP数据同步
					 <dl class="lui_list_nav_dl">
		                 <dt><a href="javascript:void(0)" title="${ lfn:message('tib-sap-sync:tib.sap.sync') }">${ lfn:message('tib-sap-sync:tib.sap.sync') }</a></dt>
		             	 <ui:combin ref="menu.nav.tib.simplecategory.default">
							 <ui:varParams 
								modelName="com.landray.kmss.tib.sap.sync.model.TibSapSyncCategory" 
								categoryId="${param.categoryId }"
								href="javascript:tibLoadList('/tib/sap/sync/tib_sap_sync_job/tibSapSyncJob_ui_include.jsp?categoryId=!{value}');"/>
					     </ui:combin>
		             </dl>
		             --%>
		             <ui:operation href="javascript:openPage('${LUI_ContextPath}/sys/simplecategory/sys_simple_category/sysCategoryMain_tree.jsp?modelName=com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcCategory&actionUrl=/tib/sys/sap/connector/tib_sys_sap_rfc_category/tibSysSapRfcCategory.do&formName=tibSysSapRfcCategoryForm&mainModelName=com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcSetting&docFkName=docCategory')" name="${ lfn:message('tib-sys-sap-connector:table.tibSysSapRfcCategory') }" target="_self" align="left"/>
		             <ui:operation href="javascript:openPage('${LUI_ContextPath}/tib/sap/sync/tib_sap_sync_category/tibSapSyncCategory_tree.jsp')" name="${ lfn:message('tib-sap-sync:table.tibSapSyncCategory') }" target="_self" align="left"/>
		             <ui:operation href="javascript:openPage('${LUI_ContextPath}/component/dbop/compDbcp.do?method=list')" name="${ lfn:message('tib-sys-sap-connector:RDBDatasource') }" target="_self"/>
				</ui:content>
				</c:if>
				<c:if test="${soapFlag == '1' }">
				<%--SOAP中间件模块--%>		
				<ui:content title="${ lfn:message('tib-sys-soap-connector:module.tib.sys.soap') }" expand="false">
		             <ul class='lui_list_nav_list'>
		             	<li><a href="javascript:void(0)" onclick="tibLoadList('/tib/sys/soap/connector/tib_sys_soap_setting/tibSysSoapSetting_ui_include.jsp');" title="${ lfn:message('tib-sys-soap-connector:tibSysSoapSettCategory.registerManager') }">${ lfn:message('tib-sys-soap-connector:tibSysSoapSettCategory.registerManager') }</a></li>
		             	<li><a href="javascript:void(0)" onclick="tibLoadList('/tib/sys/soap/connector/tib_sys_soap_main/tibSysSoapMain_ui_include.jsp');" title="${ lfn:message('tib-sys-soap-connector:tree.tibSysSoapMain.func.manager') }">${ lfn:message('tib-sys-soap-connector:tree.tibSysSoapMain.func.manager') }</a></li>
		             	<li><a href="javascript:void(0)" onclick="tibLoadList('/tib/soap/sync/tib_soap_sync_job/tibSoapSyncJob_ui_include.jsp');" title="${ lfn:message('tib-soap-sync:tib.soap.sync') }">${ lfn:message('tib-soap-sync:tib.soap.sync') }</a></li>
		             </ul>
		             <%--SOAP注册管理
					 <dl class="lui_list_nav_dl">
		                 <dt><a href="javascript:void(0)" title="${ lfn:message('tib-sys-soap-connector:tibSysSoapSettCategory.registerManager') }">${ lfn:message('tib-sys-soap-connector:tibSysSoapSettCategory.registerManager') }</a></dt>
		             	 <ui:combin ref="menu.nav.tib.simplecategory.default">
							 <ui:varParams 
								modelName="com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapSettCategory" 
								href="javascript:tibLoadList('/tib/sys/soap/connector/tib_sys_soap_setting/tibSysSoapSetting_ui_include.jsp?categoryId=!{value}');"
								treeUrl="/tib/sys/soap/connector/tib_sys_soap_sett_category/tibSysSoapSettCategory.do?method=uiCateTree&categoryId=!{value}"/>
					     </ui:combin>
		             </dl>
		             --%>
		             <%--SOAP函数管理
					 <dl class="lui_list_nav_dl">
		                 <dt><a href="javascript:void(0)" title="${ lfn:message('tib-sys-soap-connector:tree.tibSysSoapMain.func.manager') }">${ lfn:message('tib-sys-soap-connector:tree.tibSysSoapMain.func.manager') }</a></dt>
		             	 <ui:combin ref="menu.nav.tib.simplecategory.default">
							 <ui:varParams 
								modelName="com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapCategory" 
								href="javascript:tibLoadList('/tib/sys/soap/connector/tib_sys_soap_main/tibSysSoapMain_ui_include.jsp?categoryId=!{value}');"/>
					     </ui:combin>
		             </dl>
		             --%>
		             <%--SOAP数据同步
					 <dl class="lui_list_nav_dl">
		                 <dt><a href="javascript:void(0)" title="${ lfn:message('tib-soap-sync:tib.soap.sync') }">${ lfn:message('tib-soap-sync:tib.soap.sync') }</a></dt>
		             	 <ui:combin ref="menu.nav.tib.simplecategory.default">
							 <ui:varParams 
								modelName="com.landray.kmss.tib.soap.sync.model.TibSoapSyncCategory" 
								categoryId="${param.categoryId }"
								href="javascript:tibLoadList('/tib/soap/sync/tib_soap_sync_job/tibSoapSyncJob_ui_include.jsp?categoryId=!{value}');"/>
					     </ui:combin>
		             </dl>
		             --%>
		             <ui:operation href="javascript:openPage('${LUI_ContextPath}/tib/sys/soap/connector/tib_sys_soap_sett_category/tibSysSoapSettCategory_tree.jsp')" name="${ lfn:message('tib-sys-soap-connector:table.tibSysSoapSettCategory') }" target="_self" align="left"/>
		             <ui:operation href="javascript:openPage('${LUI_ContextPath}/tib/sys/soap/connector/tib_sys_soap_category/tibSysSoapCategory_tree.jsp')" name="${ lfn:message('tib-sys-soap-connector:table.tibSysSoapCategory') }" target="_self" align="right"/>
		             <ui:operation href="javascript:openPage('${LUI_ContextPath}/tib/soap/sync/tib_soap_sync_category/tibSoapSyncCategory_tree.jsp')" name="${ lfn:message('tib-soap-sync:table.tibSoapSyncCategory') }" target="_self" align="left"/>
				</ui:content>
				</c:if>
				<c:if test="${jdbcFlag == '1' }">
				<%--JDBC应用组件--%>		
				<ui:content title="${ lfn:message('tib-jdbc:module.tib.jdbc') }" expand="false">
					 <ul class='lui_list_nav_list'>
		             	<li><a href="javascript:void(0)" onclick="tibLoadList('/tib/jdbc/tib_jdbc_data_set/tibJdbcDataSet_ui_include.jsp');" title="${ lfn:message('tib-jdbc:table.tibJdbcDataSet') }">${ lfn:message('tib-jdbc:table.tibJdbcDataSet') }</a></li>
		             	<li><a href="javascript:void(0)" onclick="tibLoadList('/tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage_ui_include.jsp');" title="${ lfn:message('tib-jdbc:table.tibJdbcMappManage') }">${ lfn:message('tib-jdbc:table.tibJdbcMappManage') }</a></li>
		             	<li><a href="javascript:void(0)" onclick="tibLoadList('/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage_ui_include.jsp');" title="${ lfn:message('tib-jdbc:table.tibJdbcTaskManage') }">${ lfn:message('tib-jdbc:table.tibJdbcTaskManage') }</a></li>
		             </ul>
		             <%--JDBC数据集管理
					 <dl class="lui_list_nav_dl">
		                 <dt><a href="javascript:void(0)" title="${ lfn:message('tib-jdbc:table.tibJdbcDataSet') }">${ lfn:message('tib-jdbc:table.tibJdbcDataSet') }</a></dt>
		             	 <ui:combin ref="menu.nav.tib.simplecategory.default">
							 <ui:varParams 
								modelName="com.landray.kmss.tib.jdbc.model.TibJdbcDataSetCategory" 
								href="javascript:tibLoadList('/tib/jdbc/tib_jdbc_data_set/tibJdbcDataSet_ui_include.jsp?categoryId=!{value}');"/>
					     </ui:combin>
		             </dl>
		             --%>
		             <%--JDBC映射管理
					 <dl class="lui_list_nav_dl">
		                 <dt><a href="javascript:void(0)" title="${ lfn:message('tib-jdbc:table.tibJdbcMappManage') }">${ lfn:message('tib-jdbc:table.tibJdbcMappManage') }</a></dt>
		             	 <ui:combin ref="menu.nav.tib.simplecategory.default">
							 <ui:varParams 
								modelName="com.landray.kmss.tib.jdbc.model.TibJdbcMappCategory" 
								href="javascript:tibLoadList('/tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage_ui_include.jsp?categoryId=!{value}');"/>
					     </ui:combin>
		             </dl>
		             --%>
		             <%--JDBC任务管理
					 <dl class="lui_list_nav_dl">
		                 <dt><a href="javascript:void(0)" title="${ lfn:message('tib-jdbc:table.tibJdbcTaskManage') }">${ lfn:message('tib-jdbc:table.tibJdbcTaskManage') }</a></dt>
		             	 <ui:combin ref="menu.nav.tib.simplecategory.default">
							 <ui:varParams 
								modelName="com.landray.kmss.tib.jdbc.model.TibJdbcTaskCategory" 
								href="javascript:tibLoadList('/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage_ui_include.jsp?categoryId=!{value}');"/>
					     </ui:combin>
		             </dl>
		             --%>
		             <ui:operation href="javascript:openPage('${LUI_ContextPath}/tib/jdbc/tib_jdbc_data_set_category/tibJdbcDataSetCategory_tree.jsp')" name="${ lfn:message('tib-jdbc:table.tibJdbcDataSetCategory') }" target="_self" align="left"/>
		             <ui:operation href="javascript:openPage('${LUI_ContextPath}/tib/jdbc/tib_jdbc_mapp_category/tibJdbcMappCategory_tree.jsp')" name="${ lfn:message('tib-jdbc:table.tibJdbcMappCategory') }" target="_self" align="right"/>
		             <ui:operation href="javascript:openPage('${LUI_ContextPath}/tib/jdbc/tib_jdbc_task_category/tibJdbcTaskCategory_tree.jsp')" name="${ lfn:message('tib-jdbc:table.tibJdbcTaskCategory') }" target="_self" align="left"/>
				</ui:content>
				</c:if>
			</ui:accordionpanel>
		</div>
	</template:replace>
</template:include>
<script type="text/javascript">
 	seajs.use(['lui/jquery', 'lui/util/str', 'lui/dialog','lui/topic'], function($, strutil, dialog , topic) {
 		//根据筛选器分类异步校验权限
		window.getCateId = function(evt, cateId) {
			//每次都重置分类id的值,因为可能存在直接点叉清除分类筛选项
			for ( var i = 0; i < evt['criterions'].length; i++) {
				if (evt['criterions'][i].key == "docCategory") {
					if (evt['criterions'][i].value[0] != cateId) {
						return evt['criterions'][i].value[0];
					}
				}
			}
		};
	 	//新建
 		window.addDoc = function(url) {
 			window.open(url);
	 	};
	 	window.addSimpleCategoryDoc = function(modelName, url, categoryId) {
	 		dialog.simpleCategoryForNewFile(modelName, url, false,null,null,categoryId);
		};
	 	//删除
 		window.delDoc = function(url){
 			var values = [];
			$(window.frames["tibMainIframe"].document).find("input[name='List_Selected']:checked").each(function(){
					values.push($(this).val());
				});
			if(values.length==0){
				dialog.alert('<bean:message key="page.noSelect"/>');
				return;
			}
			dialog.confirm('<bean:message key="page.comfirmDelete"/>',function(value){
				if(value==true){
					window.del_load = dialog.loading();
					$.post('<c:url value="'+ url +'"/>',
							$.param({"List_Selected":values},true),delCallback,'json');
				}
			});
		};
		window.delCallback = function(data){
			if(window.del_load!=null) {
				window.del_load.hide();
			}
			if(data!=null && data.status==true){
				topic.publish("list.refresh");
				dialog.success('<bean:message key="return.optSuccess" />');
			}else{
				dialog.failure('<bean:message key="return.optFailure" />');
			}
		};
		// 加载右边窗口
		window.tibLoadList = function(inUrl){
			openQuery();
			$("#tibMainIframe").attr("src", "${LUI_ContextPath}"+ inUrl).load(function(){
				tibOpenPageResize();
			});
		};
		$(function(){
			//tibLoadList("/tib/sys/core/provider/tib_sys_core_iface_ui/tibSysCoreIface_include.jsp");
			tibLoadList("/tib/common/mapping/tib_common_mapping_module/tibCommonMappingModule_ui_include.jsp");
		});
 	});
</script>