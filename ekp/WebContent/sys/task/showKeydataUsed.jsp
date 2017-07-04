<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
		<script>
			var SYS_SEARCH_MODEL_NAME ="com.landray.kmss.sys.task.model.SysTaskMain";
		   seajs.use(['lui/jquery','lui/dialog','lui/topic'], function($, dialog , topic) {

				// 监听新建更新等成功后刷新
				topic.subscribe('successReloadPage', function() {
					topic.publish('list.refresh');
				});
				
		 		//新建
				window.addDoc = function() {
					window.open('${LUI_ContextPath}/sys/task/sys_task_main/sysTaskMain.do?method=add');
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
							$.post('<c:url value="/sys/task/sys_task_main/sysTaskMain.do?method=deleteall"/>',
									$.param({"List_Selected":values},true),delCallback,'json');
						}
					});
				};
				//删除回调函数
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

				topic.subscribe('list.loaded',function(evt){
					if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
						window.frameElement.style.height =  ($(document.body).height()+30) + "px";
					}
					
				});
		   });
	   </script>
	
		
		
		<%--操作栏--%>
		<div class="lui_list_operation">
			<table width="100%">
				<tr>
					
					<td align="right">
						<ui:toolbar count="3">
							<%--新建--%>
							<kmss:authShow roles="ROLE_SYSTASK_CREATE">
								<ui:button text="${lfn:message('button.add')}" onclick="addDoc()" order="2"></ui:button>	
							</kmss:authShow>
							
						</ui:toolbar>
					</td>
				</tr>
			</table>
		</div>	
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		<%--list视图--%>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
				{url:'/sys/task/sys_task_main/sysTaskIndex.do?method=showKeydataUsed&keydataId=${param.keydataId }'}
			</ui:source>
			<%--列表形式--%>
			<list:colTable isDefault="false" layout="sys.ui.listview.columntable" 
				rowHref="/sys/task/sys_task_main/sysTaskMain.do?method=view&fdId=!{fdId}"  name="columntable">
				<list:col-checkbox></list:col-checkbox>
				<list:col-serial></list:col-serial>
				<list:col-auto props=""></list:col-auto>
			</list:colTable>   
		</list:listview> 
	 	<list:paging></list:paging>	 
	   
