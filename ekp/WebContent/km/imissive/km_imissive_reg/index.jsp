<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.list">
	<template:replace name="title">
		<c:out value="${ lfn:message('km-imissive:kmImissive.tree.title') }"></c:out>
	</template:replace>
   <template:replace name="path"> 
		<ui:menu layout="sys.ui.menu.nav"  id="categoryId"> 
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_self"></ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-imissive:module.km.imissive') }" href="/km/imissive/" target="_self"></ui:menu-item>
			<ui:menu-item text="公文交换" href="/km/imissive/km_imissive_reg/index.jsp" target="_self">
				<ui:menu-item text="发文管理" href="/km/imissive/index.jsp" target="_self"></ui:menu-item>
				<ui:menu-item text="收文管理" href="/km/imissive/km_imissive_receive_main/index.jsp" target="_self"></ui:menu-item>
			   	<ui:menu-item text="签报" href="/km/imissive/km_imissive_sign_main/index.jsp" target="_self"></ui:menu-item>
			</ui:menu-item>
		</ui:menu>
	</template:replace>
	<template:replace name="nav">
		<div class="lui_list_nav_frame">
	      <ui:accordionpanel>
				<c:import url="/km/imissive/import/nav.jsp" charEncoding="UTF-8">
				   <c:param name="key" value="reg"></c:param>
				    <c:param name="criteria" value="regCriteria"></c:param>
				</c:import>
		  </ui:accordionpanel>
		</div>
	</template:replace>
	<template:replace name="content">  
	  <list:criteria id="regCriteria">
	      <list:cri-ref key="docSubject" ref="criterion.sys.docSubject"> 
		  </list:cri-ref>
	      <list:cri-criterion title="我的登记单" key="fdDeliverType" multi="false" channel="true" expand="true">
				<list:box-select>
					<list:item-select>
						<ui:source type="Static">
							[{text:'${ lfn:message('km-imissive:kmImissive.tree.mydistribute') }', value:'1'},{text:'${ lfn:message('km-imissive:kmImissive.tree.myreport') }',value:'2'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
		</list:criteria>
		  <div class="lui_list_operation">
			<div style='color: #979797;float: left;padding-top:1px;'> 
						${ lfn:message('list.orderType') }：
					</div>
					<div style="float:left">
						<div style="display: inline-block;vertical-align: middle;">
						<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" >
							<list:sort property="docCreateTime" text="创建时间" group="sort.list" value="down"></list:sort>
						</ui:toolbar>
					</div>
					</div>
					<div style="float:left;">	
						<list:paging layout="sys.ui.paging.top" > 		
						</list:paging>
					</div>	
					<div style="float:right">
						<div style="display: inline-block;vertical-align: middle;">
						<ui:toolbar count="3" id="Btntoolbar">
							<ui:button text="${lfn:message('button.delete')}" onclick="delDoc()" order="1"></ui:button> 
						</ui:toolbar>
					   </div>
				  </div>
		   </div>
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
					{url:'/km/imissive/km_imissive_reg/kmImissiveReg.do?method=list'}
			</ui:source>
			<list:colTable isDefault="false" layout="sys.ui.listview.columntable" 
				rowHref="/km/imissive/km_imissive_reg/kmImissiveReg.do?method=view&fdId=!{fdId}"  name="columntable">
				<list:col-checkbox></list:col-checkbox>
				<list:col-serial></list:col-serial>
				<list:col-auto props=""></list:col-auto>
			</list:colTable>
		</list:listview> 
	 	<list:paging></list:paging>
	 	<script type="text/javascript">
	 	var SYS_SEARCH_MODEL_NAME ="com.landray.kmss.km.imissive.model.KmImissiveReg";
	 	seajs.use(['lui/jquery','lui/dialog','lui/topic'], function($, dialog , topic) {
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
							$.post('<c:url value="/km/imissive/km_imissive_reg/kmImissiveReg.do?method=deleteall"/>',
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
