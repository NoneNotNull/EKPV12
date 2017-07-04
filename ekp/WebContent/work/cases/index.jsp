<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.list">
	<template:replace name="title">
		<c:out value="${ lfn:message('work-cases:module.work.cases') }"></c:out>
	</template:replace>
	<!--路径导航栏  -->
	<template:replace name="path">			
		<ui:menu layout="sys.ui.menu.nav"> 
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home">
			</ui:menu-item>	
			<ui:menu-item text="${ lfn:message('work-cases:module.work.cases') }">
			</ui:menu-item>
		</ui:menu>
	</template:replace>
	<template:replace name="nav">
		<script>
			function addDoc(){
				
				/* Com_OpenWindow("${LUI_ContextPath}/work/cases/work_cases_main/workCasesMain.do?method=add"); */
				seajs.use(['lui/jquery','lui/dialog','lui/topic'],function($,dialog,topic){
					window.addDoc = function(){
						dialog.simpleCategoryForNewFile("com.landray.kmss.work.cases.model.WorkCasesCategory", "/work/cases/work_cases_main/workCasesMain.do?method=add&docCategoryId=!{id}",false,null,null,"${param.categoryId}");
					}
				})
			}
			function delDoc(){
				var values = [];
				$("input[name='List_Selected']:checked").each(function(){
						values.push($(this).val());
					});
				if(values.length==0){
					dialog.alert('<bean:message key="page.noSelect"/>');
					return;
				}
				seajs.use(['lui/jquery','lui/dialog','lui/topic'], function($, dialog , topic){
					dialog.confirm('<bean:message key="page.comfirmDelete"/>',function(value){
						if(value==true){
							var del_load = dialog.loading();
							$.post('${LUI_ContextPath}/work/cases/work_cases_main/workCasesMain.do?method=deleteall&categoryId=${param.categoryId}',$.param({"List_Selected":values},true),function(data){
								if(del_load!=null){
									del_load.hide();
									topic.publish("list.refresh");
								}
								dialog.result(data);
							},'json');
						}
					});
				});
			}
		</script>
		<!--新建按钮  -->
		<ui:combin ref="menu.nav.create">
			<ui:varParam name="title" value="${ lfn:message('work-cases:module.work.cases') }" />
			<ui:varParam name="button">
				[
					<kmss:authShow roles="ROLE_WORKCASES_ADD">
					{
						"text": "${ lfn:message('work-cases:module.work.cases') }",
						"href": "javascript:addDoc();",
						"icon": "lui_icon_l_icon_1"
					}
					</kmss:authShow>
				]
			</ui:varParam>				
		</ui:combin>
		<div class="lui_list_nav_frame">
			 <ui:accordionpanel>				 
				<!-- 常用查询 -->
				<ui:content title="${ lfn:message('list.search') }">
				<ul class='lui_list_nav_list'>
					<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('mydoc', 'create');">${ lfn:message('list.create') }</a></li>
					<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('mydoc', 'approval');">${ lfn:message('list.approval') }</a></li>
					<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('mydoc', 'approved');">${ lfn:message('list.approved') }</a></li>
					<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').clearValue();LUI('criteria1').setValue('docStatus', '30');">${ lfn:message('list.alldoc') }</a></li>
				</ul>
				</ui:content>
				<!-- 其他操作 -->
				<ui:content title="${ lfn:message('list.otherOpt') }">
					<ul class='lui_list_nav_list'>
						<li><a href="${LUI_ContextPath }/sys/?module=work/cases" target="_blank">${ lfn:message('list.manager') }</a></li>
					</ul>
				</ui:content>
			</ui:accordionpanel>
		</div>
	</template:replace>
	<template:replace name="content">
		<!-- 查询条件  -->
		<list:criteria id="criteria1">
			<!--  -->
			<list:cri-ref key="docSubject" ref="criterion.sys.docSubject"/>
			<!--list:cri-criterion表示一个筛选项目  title表示筛选器左边的文字,key对应后台model的字段名-->
			<list:cri-criterion title="${ lfn:message('list.kmDoc.my') }" key="mydoc" multi="false">
				<!--list:box-select表示右边的筛选项区域   -->
				<list:box-select>
					<!--list:item-select表示筛选项目的内容  -->
					<list:item-select>
						<ui:source type="Static">
							[{text:'${ lfn:message('list.create') }', value:'create'},{text:'${ lfn:message('list.approval') }',value:'approval'}, {text:'${ lfn:message('list.approved') }', value: 'approved'}]
						</ui:source>
					</list:item-select>
				</list:box-select> 
			</list:cri-criterion>
			<list:cri-criterion title="${ lfn:message('work-cases:workCasesMain.docStatus')}" key="docStatus"> 
				<list:box-select>
				<!--cfg-defaultValue定义了筛选项 的默认值  -->
					<list:item-select cfg-defaultValue="30">
						<ui:source type="Static">
							[{text:'${ lfn:message('work-cases:enumeration_work_cases_main_docstatus_abandon')}',value:'00'},
							{text:'${ lfn:message('work-cases:enumeration_work_cases_main_docstatus_draft')}', value:'10'},
							{text:'${ lfn:message('work-cases:enumeration_work_cases_main_docstatus_refuse')}',value:'11'},
							{text:'${ lfn:message('work-cases:enumeration_work_cases_main_docstatus_review')}',value:'20'},
							{text:'${ lfn:message('work-cases:enumeration_work_cases_main_docstatus_pass')}',value:'30'},
							{text:'${ lfn:message('work-cases:enumeration_work_cases_main_docstatus_invalid')}',value:'32'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<!--根据后台定义的数据字典自动生成某些字段的筛选项，根据modelName加载数据字典,然后生成property指定的筛选项  -->
			<list:cri-auto modelName="com.landray.kmss.work.cases.model.WorkCasesMain" 
				property="docCreateTime;docPublishTime;fdWorkType;docCategory" />
		</list:criteria>
		 
		<!-- 列表工具栏 -->
		<div class="lui_list_operation">
			<table width="100%">
				<tr>
					<td style='width: 39px;'>
						${ lfn:message('list.orderType') }：
					</td>
					<td>
						<!--列表排序  -->
						<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" >
							<list:sort property="fdId" text="${lfn:message('list.sort.fdId') }" group="sort.list" value="down"></list:sort>
						</ui:toolbar>
					</td>
					<td align="right">
						<ui:toolbar count="3">
							<!--视图切换  -->
							<ui:togglegroup order="0">
							    <ui:toggle icon="lui_icon_s_zaiyao" title="${ lfn:message('list.rowTable') }" 
									selected="true"group="tg_1" text="${ lfn:message('list.rowTable') }" value="rowtable" onclick="LUI('listview').switchType(this.value);">
								</ui:toggle>
								<ui:toggle icon="lui_icon_s_liebiao" title="${ lfn:message('list.columnTable') }" 
									value="columntable"  group="tg_1" text="${ lfn:message('list.columnTable') }" onclick="LUI('listview').switchType(this.value);">
								</ui:toggle>
							</ui:togglegroup>
							<!-- 新建按钮 -->
							<kmss:authShow roles="ROLE_WORKCASES_ADD">
								<ui:button text="${lfn:message('button.add')}" onclick="addDoc()" order="2"></ui:button>
							</kmss:authShow>
							<kmss:auth requestURL="/work/cases/work_cases_main/workCasesMain.do?method=deleteall">					 								
								<ui:button text="${lfn:message('button.delete')}" onclick="delDoc()" order="4"></ui:button>
							</kmss:auth>
							
							<%-- 取消推荐 
							<c:import url="/sys/introduce/import/sysIntroduceMain_cancelbtn.jsp" charEncoding="UTF-8">
								<c:param name="fdModelName" value="com.landray.kmss.work.cases.model.WorkCasesMain" />
							</c:import>
							--%>
							<%-- 修改权限 
							<c:import url="/sys/right/import/doc_right_change_button.jsp" charEncoding="UTF-8">
								<c:param name="modelName" value="com.landray.kmss.work.cases.model.WorkCasesMain" />
							</c:import>
							--%>				 
						</ui:toolbar>
					</td>
				</tr>
			</table>
		</div>
		
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		 
		 <!--数据展示标签  -->
	 	<list:listview id="listview">
			<ui:source type="AjaxJson">
					{url:'/work/cases/work_cases_main/workCasesMain.do?method=data&categoryId=${param.categoryId}'}
			</ui:source>
			<!-- 列表视图 -->	
			<list:colTable isDefault="false"
				rowHref="/work/cases/work_cases_main/workCasesMain.do?method=view&fdId=!{fdId}"  name="columntable">
				<!--复选框  -->
				<list:col-checkbox></list:col-checkbox>
				<!--序号  -->
				<list:col-serial></list:col-serial>
				 <!--列顺序  -->
				<list:col-auto props="docSubject;docCategory.fdName;fdWorkType;docStatus;docCreator.fdName;docCreateTime;docPublishTime"></list:col-auto>
			</list:colTable>
			<!-- 摘要视图 -->	
			<list:rowTable isDefault="false"
				rowHref="/work/cases/work_cases_main/workCasesMain.do?method=view&fdId=!{fdId}" name="rowtable" >
				<list:row-template ref="sys.ui.listview.rowtable">
				<%--
				docSubject;icon;fdDescription;docCategory.fdName;docAuthor.fdName;docDept.fdName;docPublishTime;tag
				 --%>
			   	{"showOtherProps":"docCreateTime;fdWorkType;docStatus;docCreator.fdName"}
				</list:row-template>
			</list:rowTable>
		</list:listview> 
		 <!--分页控件  -->
	 	<list:paging></list:paging>	 
	</template:replace>
</template:include>
