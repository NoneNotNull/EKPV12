<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="person.home">
	<template:replace name="title">${ lfn:message('km-review:table.kmReviewMain') }</template:replace>
	<template:replace name="content">
		<list:criteria id="criteria1" expand="true">
		    <list:cri-criterion title="${ lfn:message('km-review:kmReviewMain.my')}" key="selfdoc" multi="false">
				<list:box-select>
					<list:item-select cfg-defaultValue="create" cfg-required="true">
						<ui:source type="Static">
						    [{text:'${ lfn:message('km-review:kmReviewMain.create.my') }', value:'create'},
						    {text:'${ lfn:message('km-review:kmReviewMain.approval.my') }', value:'approval'},
						    {text:'${ lfn:message('km-review:kmReviewMain.approved.my') }', value:'approved'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<list:cri-criterion title="${ lfn:message('km-review:kmReviewMain.docStatus') }" key="docStatus" > 
				<list:box-select>
					<list:item-select id="mydoc1" cfg-enable="true">
						<ui:source type="Static">
							[{text:'${ lfn:message('km-review:status.draft')}', value:'10'},
							{text:'${ lfn:message('km-review:status.append')}',value:'20'},
							{text:'${ lfn:message('km-review:status.refuse')}',value:'11'},
							{text:'${ lfn:message('km-review:status.discard')}',value:'00'},
							{text:'${ lfn:message('km-review:status.publish')}',value:'30'},
							{text:'${ lfn:message('km-review:status.feedback')}',value:'31'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<list:cri-criterion title="${ lfn:message('km-review:kmReviewMain.docStatus') }" key="docStatus" > 
				<list:box-select>
					<list:item-select id="mydoc2" cfg-enable="false">
						<ui:source type="Static">
							[{text:'${ lfn:message('km-review:status.append')}',value:'20'},
							{text:'${ lfn:message('km-review:status.refuse')}',value:'11'},
							{text:'${ lfn:message('km-review:status.discard')}',value:'00'},
							{text:'${ lfn:message('km-review:status.publish')}',value:'30'},
							{text:'${ lfn:message('km-review:status.feedback')}',value:'31'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
		</list:criteria>
		<div class="lui_list_operation">
				<table width="100%">
					<tr>
						<td  class="lui_sort">
							${ lfn:message('list.orderType') }：
						</td>
						<td>
							<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" >
								<list:sort property="docCreateTime" text="${lfn:message('km-review:kmReviewMain.docCreateTime') }" group="sort.list" value="down"></list:sort>
								<list:sort property="docPublishTime" text="${lfn:message('km-review:kmReviewMain.docPublishTime') }" group="sort.list"></list:sort>
							</ui:toolbar>
						</td>
						<td align="right">
							<ui:toolbar>
							 <kmss:authShow roles="ROLE_KMREVIEW_CREATE">
							  <ui:button text="${lfn:message('button.add')}" onclick="addDoc()" order="2" ></ui:button>
							 </kmss:authShow>
							<kmss:auth
								requestURL="/km/review/km_review_main/kmReviewMain.do?method=deleteall&categoryId=${param.categoryId}&nodeType=${param.nodeType}"
								requestMethod="GET">
							<ui:button text="${lfn:message('button.delete')}" order="4" onclick="delDoc()"></ui:button>
							</kmss:auth>
							<%-- 收藏 --%>
							<c:import url="/sys/bookmark/import/bookmark_bar_all.jsp" charEncoding="UTF-8">
								<c:param name="fdTitleProName" value="docSubject" />
								<c:param name="fdModelName"	value="com.landray.kmss.km.review.model.KmReviewMain" />
							</c:import>
							<%-- 修改权限 --%>
							<c:import url="/sys/right/import/doc_right_change_button.jsp" charEncoding="UTF-8">
								<c:param name="modelName" value="com.landray.kmss.km.review.model.KmReviewMain" />
								<c:param name="authReaderNoteFlag" value="2" />
							</c:import>							
							<%-- 分类转移 --%>
							<kmss:auth
									requestURL="/km/review/km_review_main/kmReviewMain.do?method=changeTemplate&categoryId=${param.categoryId}&nodeType=${param.nodeType}"
									requestMethod="GET">
								<ui:button text="${lfn:message('km-review:button.translate')}" order="4" onclick="chgSelect();"></ui:button>
							</kmss:auth>	
						</ui:toolbar>						
						</td>
					</tr>
				</table>
			</div>
			<list:listview id="listview">
						<ui:source type="AjaxJson">
								{url:'/km/review/km_review_index/kmReviewIndex.do?method=list'}
						</ui:source>
						<list:colTable isDefault="true" layout="sys.ui.listview.columntable" 
							rowHref="/km/review/km_review_main/kmReviewMain.do?method=view&fdId=!{fdId}">
							<list:col-checkbox name="List_Selected" headerStyle="width:20px"></list:col-checkbox>
							<list:col-serial title="${ lfn:message('page.serial')}" headerStyle="width:20px"></list:col-serial>
							 <list:col-html title="${ lfn:message('km-review:kmReviewMain.docSubject') }" style="text-align:left;min-width:150px">
							  {$ <span class="com_subject">{%row['docSubject']%}</span> $}
							 </list:col-html>
							<list:col-auto props="fdNumber;docCreator.fdName;docCreateTime;docStatus;nodeName;handlerName"></list:col-auto> 
						</list:colTable>
			</list:listview>
			<list:paging></list:paging>
		</div> 
	<script>	
	seajs.use(['lui/jquery','lui/dialog','lui/topic'], function($,dialog,topic) {

			// 监听新建更新等成功后刷新
			topic.subscribe('successReloadPage', function() {
				topic.publish('list.refresh');
			});
		
			//新建
	 		window.addDoc = function() {
					dialog.categoryForNewFile(
							'com.landray.kmss.km.review.model.KmReviewTemplate',
							'/km/review/km_review_main/kmReviewMain.do?method=add&fdTemplateId=!{id}',false,null,null,'${param.categoryId}',null,null,true);
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
						$.post('<c:url value="/km/review/km_review_main/kmReviewMain.do?method=deleteall"/>',
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
			//分类转移
			window.chgSelect = function() {
				var values = "";
				$("input[name='List_Selected']:checked").each(function(){
					 values += "," + $(this).val();
					});
				if(values==''){
					dialog.alert('<bean:message bundle="km-review" key="message.trans_doc_select" />');
					return;
				}
				values = values.substring(1);
				Com_OpenWindow('<c:url value="/km/review/km_review_main/kmReviewChangeTemplate.jsp" />?values='+values+'&categoryId=${param.categoryId}');
				return ;
			};

		
		  topic.subscribe('criteria.changed',function(evt){
			  if(evt['criterions'].length>0){
					 for(var i=0;i<evt['criterions'].length;i++){
						if(evt['criterions'][i].key == "selfdoc"){
							if(evt['criterions'][i].value.length==1){
								if(evt['criterions'][i].value[0]=="create"){
									LUI('mydoc1').setEnable(true);
								}else{
									LUI('mydoc1').setEnable(false);
								}
								if(evt['criterions'][i].value[0]=="approved"){
									LUI('mydoc2').setEnable(true);
								}else{
									LUI('mydoc2').setEnable(false);
								}
							}
						}
						
					 }
			  }
		});
	});
	</script>
	</template:replace>
</template:include>
