<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="body">  
	 <script type="text/javascript">
			seajs.use(['theme!list', 'theme!portal']);	
	 </script>
	 <div style="padding: 10px">
	  <%-- 筛选器 --%>	
	  <list:criteria id="criteria1" multi="true">
		    <!--交接人,接收人 -->
			<list:cri-auto modelName="com.landray.kmss.sys.handover.model.SysHandoverConfigMain" property="fdFromName;fdToName;docCreator"/>
	  </list:criteria>
	  <div class="lui_list_operation">
			<table width="100%">
				<tr>
					<td align="right">
					   <ui:toolbar count="3" >
					   <kmss:authShow roles="ROLE_SYSHANDOVER_CREATE">
						   <ui:button id="add" text="${lfn:message('sys-handover:sysHandoverConfigMain.create')}" onclick="addDoc()" order="1"></ui:button>	
					   </kmss:authShow>
					   <kmss:authShow roles="ROLE_SYSHANDOVER_MAINTAIN">
						   <ui:button id="delete" text="${lfn:message('sys-handover:sysHandoverConfigMain.delete')}" onclick="delDoc()" order="2"></ui:button>	
					   </kmss:authShow>
					   </ui:toolbar>
					</td>
				</tr>
			</table>
		</div>
	    <ui:fixed elem=".lui_list_operation"></ui:fixed>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
				{url:'/sys/handover/sys_handover_config_main/sysHandoverConfigMain.do?method=list'}
			</ui:source>
			<list:colTable isDefault="true" layout="sys.ui.listview.columntable" 
				rowHref="/sys/handover/sys_handover_config_main/sysHandoverConfigMain.do?method=view&fdId=!{fdId}"  name="columntable">
				<list:col-checkbox></list:col-checkbox>
				<list:col-serial></list:col-serial>
				<list:col-auto props=""></list:col-auto>
			</list:colTable>
		</list:listview> 
	 	<list:paging></list:paging>	 
	 	<script type="text/javascript">
			seajs.use(['lui/jquery','lui/dialog','lui/topic','lui/toolbar'], function($, dialog , topic,toolbar) {
				// 监听新建更新等成功后刷新
				topic.subscribe('successReloadPage', function() {
					topic.publish('list.refresh');
				});
				//新建
				window.addDoc = function() {
				   window.open("${LUI_ContextPath }/sys/handover/sys_handover_config_main/sysHandoverConfigMain.do?method=add","_blank");
				};
				//删除
				window.delDoc = function(){
					var values = [];
					$("input[name='List_Selected']:checked").each(function(){
							values.push($(this).val());
						});
					if(values.length==0){
						dialog.alert('<bean:message key="page.noSelect"/>');
						return;
					}
					dialog.confirm('<bean:message key="page.comfirmDelete"/>',function(value){
						if(value==true){
							window.del_load = dialog.loading();
							$.post('<c:url value="/sys/handover/sys_handover_config_main/sysHandoverConfigMain.do?method=deleteall"/>',
									$.param({"List_Selected":values},true),delCallback,'json');
						}
					});
				};
				//删除回调	
				window.delCallback = function(data){
					if(window.del_load!=null)
						window.del_load.hide();
					if(data!=null && data.status==true){
						topic.publish("list.refresh");
						dialog.success('<bean:message key="return.optSuccess" />');
					}else{
						dialog.failure('<bean:message key="return.optFailure" />');
					}
				};
				
			});
     	</script>	 
     </div>
	</template:replace>
</template:include>
