<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.list">
	<template:replace name="title">
		<c:out value="${ lfn:message('km-smissive:table.kmSmissiveMain') }"></c:out>
	</template:replace>
	<template:replace name="path">
		<ui:combin ref="menu.path.simplecategory">
			<ui:varParams 
			    id="simplecategoryId"
				moduleTitle="${ lfn:message('km-smissive:table.kmSmissiveMain') }" 
				href="/km/smissive/" 
				modelName="com.landray.kmss.km.smissive.model.KmSmissiveTemplate" 
				categoryId="${param.categoryId }" />
		</ui:combin>
	</template:replace>
	<template:replace name="nav">
		<!-- 所有分类 -->
		<ui:combin ref="menu.nav.simplecategory.all"> 
			<ui:varParams
				modelName="com.landray.kmss.km.smissive.model.KmSmissiveTemplate" 
				href="/km/smissive/" />
		</ui:combin>
		<ui:combin ref="menu.nav.create">
			<ui:varParam name="title" value="${ lfn:message('km-smissive:table.kmSmissiveMain') }" />
			<ui:varParam name="button">
				[
					<kmss:authShow roles="ROLE_KMSMISSIVE_CREATE">
					{
						"text": "${ lfn:message('km-smissive:kmSmissiveMain.create.title') }",
						"href": "javascript:addDoc();",
						"icon": "lui_icon_l_icon_12"
					}
					</kmss:authShow>
				]
			</ui:varParam>				
		</ui:combin>
		
		<div class="lui_list_nav_frame">
			<ui:accordionpanel>
			    <ui:combin ref="menu.nav.favorite.category">
					<ui:varParams 
					    href="/km/smissive/?categoryId=!{value}"
						modelName="com.landray.kmss.km.smissive.model.KmSmissiveTemplate"/>
				</ui:combin>
				<ui:content style="padding:0px;" title="${lfn:message('sys-category:menu.sysCategory.index') }">
					<ui:combin ref="menu.nav.simplecategory.flat">
						<ui:varParams 
							modelName="com.landray.kmss.km.smissive.model.KmSmissiveTemplate" 
							href="/km/smissive/" 
							categoryId="${param.categoryId }" />
					</ui:combin>
					<c:if test="${not empty param.simplecategoryId}">
						<ui:operation href="javascript:LUI('simplecategoryId').gotoNav(-1)" target="_self" name="${lfn:message('list.lever.up') }" align ="left"/>
					</c:if>	
				</ui:content>
				<ui:content title="${ lfn:message('list.search') }">
				<ul class='lui_list_nav_list'>
				    <li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').clearValue();">${ lfn:message('km-smissive:smissive.tree.myJob.alldoc') }</a></li>
					<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('mydoc', 'create');">${ lfn:message('km-smissive:smissive.create.my') }</a></li>
					<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('mydoc', 'approval');">${ lfn:message('km-smissive:smissive.approval.my') }</a></li>
					<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('mydoc', 'approved');">${ lfn:message('km-smissive:smissive.approved.my') }</a></li>
				</ul>
				</ui:content>
				<ui:content title="${ lfn:message('list.otherOpt') }"> 
					<ul class='lui_list_nav_list'>
						<li><a href="${LUI_ContextPath }/sys/?module=km/smissive" target="_blank">${ lfn:message('list.manager') }</a></li>
					</ul>
				</ui:content>
			</ui:accordionpanel>
		</div>
	</template:replace>
	<template:replace name="content">  
		<list:criteria id="criteria1">
	     	<list:cri-ref key="docSubject" ref="criterion.sys.docSubject"> 
			</list:cri-ref>
			<list:cri-criterion title="${ lfn:message('km-smissive:smissive.myDoc') }" key="mydoc" multi="false">
				<list:box-select>
					<list:item-select>
						<ui:source type="Static">
							[{text:'${ lfn:message('km-smissive:smissive.create.my') }', value:'create'}
							,{text:'${ lfn:message('km-smissive:smissive.approval.my') }',value:'approval'}
							, {text:'${ lfn:message('km-smissive:smissive.approved.my') }', value: 'approved'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<list:cri-criterion title="${ lfn:message('km-smissive:kmSmissiveMain.docStatus')}" key="docStatus"> 
				<list:box-select>
					<list:item-select>
						<ui:source type="Static">
							[{text:'${ lfn:message('status.draft')}', value:'10'},{text:'${ lfn:message('status.examine')}',value:'20'},{text:'${ lfn:message('status.refuse')}',value:'11'},{text:'${ lfn:message('status.discard')}',value:'00'},{text:'${ lfn:message('status.publish')}',value:'30'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<list:cri-auto modelName="com.landray.kmss.km.smissive.model.KmSmissiveMain" property="docAuthor;fdMainDept;docCreateTime;fdFileNo;docProperties" />
		</list:criteria>
		<div class="lui_list_operation">
			<div style='color: #979797;float: left;padding-top:1px;'>
				${ lfn:message('list.orderType') }：
			</div>
			<div style="float:left">
				<div style="display: inline-block;vertical-align: middle;">
					<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" >
						<list:sort property="docCreateTime" text="${lfn:message('km-smissive:kmSmissiveMain.docCreateTime') }" group="sort.list" value="down"></list:sort>
						<list:sort property="docPublishTime" text="${lfn:message('km-smissive:kmSmissiveMain.docPublishTime') }" group="sort.list"></list:sort>
					</ui:toolbar>
				</div>
			</div>
			<div style="float:left;">	
				<list:paging layout="sys.ui.paging.top" > 		
				</list:paging>
			</div>
			<div style="float:right">
				<div style="display: inline-block;vertical-align: middle;">
					<ui:toolbar count="3">
						<%-- 收藏 --%>
						<c:import url="/sys/bookmark/import/bookmark_bar_all.jsp"
							charEncoding="UTF-8">
							<c:param name="fdTitleProName" value="docSubject" />
							<c:param name="fdModelName" value="com.landray.kmss.km.smissive.model.KmSmissiveMain" />
						</c:import>
						<kmss:authShow roles="ROLE_KMSMISSIVE_CREATE">
						<kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=add" requestMethod="GET">
						<ui:button text="${lfn:message('button.add')}" onclick="addDoc()" order="2"></ui:button>
						</kmss:auth>
						<kmss:auth requestURL="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=deleteall&status=${param.status}&categoryId=${param.categoryId}&nodeType=${param.nodeType}" requestMethod="GET">
							<ui:button text="${lfn:message('button.delete')}" onclick="delDoc()" order="3"></ui:button>
						</kmss:auth>
						</kmss:authShow>
						<%-- 修改权限 --%>
						<c:import url="/sys/right/import/doc_right_change_button.jsp" charEncoding="UTF-8">
							<c:param name="modelName" value="com.landray.kmss.km.smissive.model.KmSmissiveMain" />
							<c:param name="authReaderNoteFlag" value="2" />
						</c:import>							
						<%-- 分类转移 --%>
						<c:import url="/sys/simplecategory/import/doc_cate_change_button.jsp" charEncoding="UTF-8">
							<c:param name="modelName" value="com.landray.kmss.km.smissive.model.KmSmissiveMain" />
							<c:param name="docFkName" value="fdTemplate" />
							<c:param name="cateModelName" value="com.landray.kmss.km.smissive.model.KmSmissiveTemplate" />
						</c:import>
					</ui:toolbar>
				</div>
			</div>
		</div>
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
					{url:'/km/smissive/km_smissive_main/kmSmissiveMainIndex.do?method=listChildren&categoryId=${param.categoryId}'}
			</ui:source>
			<list:colTable isDefault="false" layout="sys.ui.listview.columntable" 
				rowHref="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=view&fdId=!{fdId}"  name="columntable">
				<list:col-checkbox></list:col-checkbox>
				<list:col-serial></list:col-serial>
				<list:col-auto props=""></list:col-auto>
			</list:colTable>
			<list:rowTable isDefault="false"
				rowHref="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=view&fdId=!{fdId}" name="rowtable" >
				<list:row-template ref="sys.ui.listview.rowtable">
				</list:row-template>
			</list:rowTable>
		</list:listview>
	 	<list:paging></list:paging>	 
	 	<script type="text/javascript">

	 	var SYS_SEARCH_MODEL_NAME ="com.landray.kmss.km.smissive.model.KmSmissiveMain";
	 	
			seajs.use(['lui/jquery','lui/dialog','lui/topic'], function($, dialog , topic) {

				// 监听新建更新等成功后刷新
				topic.subscribe('successReloadPage', function() {
					topic.publish('list.refresh');
				});
				
				//新建
				window.addDoc = function() {
						dialog.simpleCategoryForNewFile(
								'com.landray.kmss.km.smissive.model.KmSmissiveTemplate',
								'/km/smissive/km_smissive_main/kmSmissiveMain.do?method=add&categoryId=!{id}',false,null,null,'${param.categoryId}');
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
							$.post('<c:url value="/km/smissive/km_smissive_main/kmSmissiveMain.do?method=deleteall"/>',
									$.param({"List_Selected":values},true),delCallback,'json');
						}
					});
				};
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
	</template:replace>
</template:include>
