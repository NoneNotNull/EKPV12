<%@ page language="java" pageEncoding="UTF-8"
	import="com.landray.kmss.sys.notify.service.ISysNotifyCategoryService,com.landray.kmss.util.SpringBeanUtil" %>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<% 
	//提前获取业务聚合分类
	ISysNotifyCategoryService sysNotifyCategoryService = (ISysNotifyCategoryService) SpringBeanUtil
		.getBean("sysNotifyCategoryService");
	java.util.List cate = sysNotifyCategoryService.getCategorys();
	request.setAttribute("cateList",cate);

%>
<template:include ref="default.list">
	<template:replace name="title">
		<c:out value="${ lfn:message('sys-notify:table.sysNotifyTodo') }"></c:out>
	</template:replace>
	<template:replace name="path">
		<c:import url="/sys/notify/sys_notify_todo_ui/path_category.jsp"  charEncoding="UTF-8">
			<c:param name="href">/sys/notify/</c:param>
			<c:param name="fdCateId">${param.fdCateId }</c:param>
		</c:import>
	</template:replace>
	<template:replace name="nav">
		<ui:combin ref="menu.nav.create">
			<ui:varParam name="title" value="${ lfn:message('sys-notify:module.sys.notify') }" />
			<ui:varParam name="button">[{
						"text": "${ lfn:message('sys-notify:sysNotifyTodo.doing.item') }",
						"href": "javascript:window.location.href='${LUI_ContextPath}/sys/notify/'",
						"icon": "lui_icon_l_icon_22"
					}]
			</ui:varParam>				
		</ui:combin>
		<div class="lui_list_nav_frame">
			<ui:accordionpanel>
				<c:if test="${fn:length(cateList) > 0 }">
					<ui:content  title="${lfn:message('sys-notify:sysNotifyTodo.todo.category') }">
						<ul class='lui_list_nav_list'>
						  <c:forEach var="cate" items="${cateList}">
						  	<li><a href="${LUI_ContextPath }/sys/notify?fdCateId=${cate[0]}" >${cate[1]}</a></li>
						  </c:forEach>
						</ul>
					</ui:content>
				</c:if>
				
				<ui:content title="${ lfn:message('list.search') }">
					<ul class='lui_list_nav_list'>
						<li><a href="javascript:void(0)" onclick="switchNotifyTab(0);" >${ lfn:message('sys-notify:sysNotifyTodo.doing.item') }</a></li>
						<li><a href="javascript:void(0)" onclick="switchNotifyTab(1);" >${ lfn:message('sys-notify:sysNotifyTodo.done.item') }</a></li>
									
					</ul>
				</ui:content>
				
			</ui:accordionpanel>
		</div>
	</template:replace>
	
	<template:replace name="content">
	    <link type="text/css" rel="stylesheet" href="${LUI_ContextPath}/sys/notify/resource/css/notify.css"/>
		<div style="width:100%">
		  <ui:tabpanel layout="sys.ui.tabpanel.light" id="tabpanel">
			 <ui:content title="${ lfn:message('sys-notify:sysNotifyTodo.doing.item') }" >
			  <list:criteria id="doing" channel="status1">
			  		<list:cri-ref key="fdSubject" ref="criterion.sys.docSubject">
					</list:cri-ref>
					<list:cri-criterion title="${lfn:message('sys-notify:sysNotifyTodo.fdType.1') }" key="fdType" multi="false"> 
						<list:box-select>
							<list:item-select>
								<ui:source type="Static">
									[{text:'${ lfn:message('sys-notify:sysNotifyTodo.cate.audit') }', value:'13'}
									,{text:'${ lfn:message('sys-notify:sysNotifyTodo.cate.copyto') }',value:'2'}]
								</ui:source>
							</list:item-select>
						</list:box-select>
					</list:cri-criterion>
					
					<list:cri-criterion title="${lfn:message('sys-notify:sysNotifyTodo.moduleName') }" key="fdModelName" multi="false">
						<list:box-select>
							<list:item-select type="lui/criteria!CriterionSelectDatas"  id="moduleNames_doing">
								<ui:source type="AjaxJson" >
									{url: "/sys/notify/sys_notify_todo/sysNotifyTodo.do?method=getModules&oprType=doing&parentId=!{value}&fdCateId=${param.fdCateId}"}
								</ui:source>
							</list:item-select>
						</list:box-select>
					</list:cri-criterion>
					
					<list:cri-auto modelName="com.landray.kmss.sys.notify.model.SysNotifyTodo" 
					property="docCreator;fdCreateTime" />
				</list:criteria>
				<div class="lui_list_operation">
					<table width="100%">
						<tr>
							<td  class="lui_sort">
								${ lfn:message('list.orderType') }：
							</td>
							<td>
								<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" channel="status1">
									<list:sort property="fdCreateTime" text="${lfn:message('sys-notify:sysNotifyTodo.docCreateTime.1') }" group="sort.list" value="down"></list:sort>
									<list:sort property="fdLevel" text="${lfn:message('sys-notify:sysNotifyTodo.level') }" group="sort.list"></list:sort>
								</ui:toolbar>
							</td>
							<td align="right">
								<ui:toolbar count="3">
										<ui:togglegroup order="0">
										    <ui:toggle icon="lui_icon_s_zaiyao" title="${ lfn:message('list.rowTable') }" 
												selected="true" group="tg_1" text="${ lfn:message('list.rowTable') }" value="rowtable"
												onclick="LUI('listview').switchType(this.value);">
											</ui:toggle>
											<ui:toggle icon="lui_icon_s_liebiao" title="${ lfn:message('list.columnTable') }" 
												value="columntable"  group="tg_1" text="${ lfn:message('list.columnTable') }" 
												onclick="LUI('listview').switchType(this.value);">
											</ui:toggle>
										</ui:togglegroup>
										<ui:button text="${lfn:message('sys-notify:sysNotifyTodo.button.todo.finish')}" onclick="mngDelete()" order="2"></ui:button>	
								</ui:toolbar>
							</td>
						</tr>
					</table>
				</div>
				
				<list:listview id="listview" channel="status1">
					<ui:source type="AjaxJson">
							{url:'/sys/notify/sys_notify_todo/sysNotifyMainIndex.do?method=list&dataType=todo&fdCateId=${param.fdCateId}'}
					</ui:source>
					
					 <!-- 摘要视图 -->	
					<list:rowTable isDefault="false"
						rowHref="/sys/notify/sys_notify_todo/sysNotifyTodo.do?method=view&fdId=!{fdId}" name="rowtable" >
							<list:row-template>
						  {$
						  <div class="clearfloat lui_listview_rowtable_summary_content_box">
							<dl>
								<dt>
									<input type="checkbox" data-lui-mark="table.content.checkbox" value="{%row.fdId%}" name="List_Selected"/>
									<span class="lui_listview_rowtable_summary_content_serial">{%row.index%}</span>
								</dt>
							</dl>
					         <dl>		
					            <dt>
									<a href="${KMSS_Parameter_ContextPath}sys/notify/sys_notify_todo/sysNotifyTodo.do?method=view&fdId={%row.fdId%}" class="textEllipsis com_subject" target="_blank" data-lui-mark-id="{%row.rowId%}">{%row['todo.subject4View']%}</a>
								</dt>		
								
								<dd class="lui_listview_rowtable_summary_content_box_foot_info">
									$}
										if(row['docCreator.fdName']){
											{$
												<span>${lfn:message('sys-notify:sysNotifyTodo.docCreatorName')}：{%row['docCreator.fdName']%}</span>
											$}
										}
											{$
												<span>${lfn:message('sys-notify:sysNotifyTodo.docCreateTime.1')}：{%row['fdCreateTime']%}</span>
												<span>${lfn:message('sys-notify:sysNotifyTodo.moduleName')}：{%row['modelNameText']%}</span>
											$}
										if(row['lbpmCurrNode.key']){
											{$
												<span>{%row['lbpmCurrNode.key']%}：{%row['lbpmCurrNode.value']%}</span>
											$}
										}
										if(row['docFinishedTime.key']){
											{$
												<span>${lfn:message('sys-notify:sysNotifyTodo.kmPindagateMain.docEndTime')}：{%row['docFinishedTime.value']%}</span>
											$}
										}
										
									{$
									
								</dd>
							</dl>
						 </div>
						    $}		      
						</list:row-template>
					</list:rowTable>
					<list:colTable isDefault="false" layout="sys.ui.listview.columntable" 
						rowHref="/sys/notify/sys_notify_todo/sysNotifyTodo.do?method=view&fdId=!{fdId}"  name="columntable">
						<list:col-checkbox></list:col-checkbox>
						<list:col-serial></list:col-serial>
						<list:col-auto props="todo.subject4View;fdType;modelNameText;docCreator.fdName;fdCreateTime"></list:col-auto>
					</list:colTable>
				</list:listview> 
			 	<list:paging channel="status1"></list:paging>	
			 	<script type="text/javascript">
					seajs.use(['lui/jquery','lui/dialog','lui/topic'], function($, dialog , topic) {
						LUI.ready(function(){
							var dataType = "${param.dataType}";
							var done = dataType && dataType.indexOf('done')!=-1;
							if(done){;
								LUI('tabpanel').selectedIndex=1;
							}
						});
						
						//删除
						window.mngDelete = function(){
							var values = [];
							$("input[name='List_Selected']:checked").each(function(){
									values.push($(this).val());
								});
							if(values.length==0){
								dialog.alert('<bean:message key="page.noSelect"/>');
								return;
							}
							dialog.confirm('<bean:message bundle="sys-notify" key="sysNotifyTodo.confirm.finish"/>',function(value){
								if(value==true){
									window.del_load = dialog.loading();
									$.post('<c:url value="/sys/notify/sys_notify_todo/sysNotifyTodo.do?method=deleteall"/>',
											$.param({"List_Selected":values},true),SdelCallback,'json');
								}
							});
						};
						window.SdelCallback = function(data){
							if(window.del_load!=null)
								window.del_load.hide();
							if(data!=null && data.status==true){
								topic.channel('status1').publish("list.refresh");
								dialog.success('<bean:message key="return.optSuccess" />');
							}else{
								dialog.failure('<bean:message key="return.optFailure" />');
							}
						};
						//切换标签
						window.switchNotifyTab = function(index){
							LUI('tabpanel').setSelectedIndex(index);
						};
						//审批等操作完成后，自动刷新列表
						topic.subscribe('successReloadPage', function() {
							topic.channel('status1').publish('list.refresh');
						});
					});
				</script>	
			 	 
			  </ui:content>
			  <ui:content title="${ lfn:message('sys-notify:sysNotifyTodo.done.item') }" style="" >
				  <list:criteria id="done" channel="status2">
				  	   <list:cri-ref key="fdSubject" ref="criterion.sys.docSubject">
					   </list:cri-ref>
					   <list:cri-criterion title="${lfn:message('sys-notify:sysNotifyTodo.fdType.1') }" key="fdType" multi="false"> 
								<list:box-select>
									<list:item-select>
										<ui:source type="Static">
											[{text:'${ lfn:message('sys-notify:sysNotifyTodo.cate.audit') }', value:'13'}
											,{text:'${ lfn:message('sys-notify:sysNotifyTodo.cate.copyto') }',value:'2'}]
										</ui:source>
									</list:item-select>
								</list:box-select>
						</list:cri-criterion>
						
						<list:cri-criterion title="${lfn:message('sys-notify:sysNotifyTodo.moduleName') }" key="fdModelName" multi="false"> 
							<list:box-select>
								<list:item-select type="lui/criteria!CriterionSelectDatas" id="moduleNames_done">
									<ui:source type="AjaxJson">
										{url: "/sys/notify/sys_notify_todo/sysNotifyTodo.do?method=getModules&oprType=done&fdCateId=${param.fdCateId}"}
									</ui:source>
								</list:item-select>
							</list:box-select>
						</list:cri-criterion>
					
					<list:cri-auto modelName="com.landray.kmss.sys.notify.model.SysNotifyTodo" 
					property="docCreator;fdCreateTime" />
			  </list:criteria>
			  
			  <div class="lui_list_operation">
					<table width="100%">
						<tr>
							<td  class="lui_sort">
								${ lfn:message('list.orderType') }：
							</td>
							<td>
								<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" channel="status2">
									<list:sort property="fdCreateTime" text="${lfn:message('sys-notify:sysNotifyTodo.finishDate') }" group="sort.list" value="down"></list:sort>
									<list:sort property="fdLevel" text="${lfn:message('sys-notify:sysNotifyTodo.level') }" group="sort.list"></list:sort>
								</ui:toolbar>
							</td>
							<td align="right">
								<ui:toolbar count="3">
										<ui:togglegroup order="0">
										    <ui:toggle icon="lui_icon_s_zaiyao" title="${ lfn:message('list.rowTable') }" 
												selected="true" group="tg_1" text="${ lfn:message('list.rowTable') }" value="rowtable"
												onclick="LUI('listview2').switchType(this.value);">
											</ui:toggle>
											<ui:toggle icon="lui_icon_s_liebiao" title="${ lfn:message('list.columnTable') }" 
												value="columntable"  group="tg_1" text="${ lfn:message('list.columnTable') }" 
												onclick="LUI('listview2').switchType(this.value);">
											</ui:toggle>
										</ui:togglegroup>
										
								</ui:toolbar>
							</td>
						</tr>
					</table>
				</div>
			  	
				<list:listview id="listview2" channel="status2">
					<ui:source type="AjaxJson">
							{url:'/sys/notify/sys_notify_todo/sysNotifyMainIndex.do?method=list&dataType=done&fdCateId=${param.fdCateId}'}
					</ui:source>
					
					
					<!-- 摘要视图 -->	
					<list:rowTable isDefault="false"
						rowHref="!{tr_href}" name="rowtable" >
							<list:row-template>
						  {$
						  <div class="clearfloat lui_listview_rowtable_summary_content_box">
							<dl>
								<dt>
									<input type="checkbox" data-lui-mark="table.content.checkbox" value="{%row.fdId%}" name="List_Selected"/>
									<span class="lui_listview_rowtable_summary_content_serial">{%row.index%}</span>
								</dt>
							</dl>
					         <dl>		
					            <dt>
									<a href="{%row.tr_href%}" class="textEllipsis com_subject" target="_blank" data-lui-mark-id="{%row.rowId%}">{%row['todo.subject4View']%}</a>
								</dt>		
								
								<dd class="lui_listview_rowtable_summary_content_box_foot_info">
							$}
								if(row['docCreator.fdName']){
									{$
										<span>${lfn:message('sys-notify:sysNotifyTodo.docCreatorName')}：{%row['docCreator.fdName']%}</span>
									$}
								}
								{$
									<span>${lfn:message('sys-notify:sysNotifyTodo.docCreateTime.1')}：{%row['fdCreateTime']%}</span>
									<span>${ lfn:message('sys-notify:sysNotifyTodo.moduleName') }：{%row['modelNameText']%}</span>
								$}
								if(row['lbpmCurrNode.key']){
									{$
										<span>{%row['lbpmCurrNode.key']%}：{%row['lbpmCurrNode.value']%}</span>
									$}
								}
								if(row['docFinishedTime.key']){
									{$
										<span>${lfn:message('sys-notify:sysNotifyTodo.kmPindagateMain.docEndTime')}：{%row['docFinishedTime.value']%}</span>
									$}
								}
								
								
							{$
								</dd>
							</dl>
						 </div>
						    $}		      
						</list:row-template>
					</list:rowTable>
					<list:colTable isDefault="false" layout="sys.ui.listview.columntable" 
						rowHref="!{tr_href}"  name="columntable">
						<list:col-checkbox></list:col-checkbox>
						<list:col-serial></list:col-serial>
						<list:col-auto props="todo.subject4View;fdType;modelNameText;fdCreateTime"></list:col-auto>
					</list:colTable>
				</list:listview> 
			 	<list:paging channel="status2"></list:paging>	
			  </ui:content>
		</ui:tabpanel>
	  </div> 
	</template:replace>
</template:include>
