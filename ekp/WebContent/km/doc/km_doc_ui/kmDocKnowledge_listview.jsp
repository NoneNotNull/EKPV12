<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
		<div class="lui_list_operation">
			<div style='color: #979797;float: left;padding-top:1px;'>
				${ lfn:message('list.orderType') }：
			</div>
			<div style="float:left">
				<div style="display: inline-block;vertical-align: middle;">
					<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left">
						<list:sort property="docCreateTime" text="${lfn:message('sys-doc:sysDocBaseInfo.docCreateTime') }" group="sort.list" value="down"></list:sort>
						<list:sort property="docPublishTime" text="${lfn:message('km-doc:kmDoc.kmDocKnowledge.docPublishTime') }" group="sort.list"></list:sort>
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
							
							<ui:togglegroup order="0">
							    <ui:toggle icon="lui_icon_s_zaiyao" title="${ lfn:message('list.rowTable') }" 
									selected="true"group="tg_1" text="${ lfn:message('list.rowTable') }" value="rowtable"
									onclick="LUI('listview').switchType(this.value);">
								</ui:toggle>
								<ui:toggle icon="lui_icon_s_liebiao" title="${ lfn:message('list.columnTable') }" 
									value="columntable"  group="tg_1" text="${ lfn:message('list.columnTable') }" 
									onclick="LUI('listview').switchType(this.value);">
								</ui:toggle>
							</ui:togglegroup>
							<%-- 收藏 --%>
							<c:import url="/sys/bookmark/import/bookmark_bar_all.jsp" charEncoding="UTF-8">
								<c:param name="fdTitleProName" value="docSubject" />
								<c:param name="fdModelName"	value="com.landray.kmss.km.doc.model.KmDocKnowledge" />
							</c:import>
							
							<kmss:authShow roles="ROLE_KMDOC_CREATE">
								<ui:button text="${lfn:message('button.add')}" onclick="addDoc()" order="2"></ui:button>	
							</kmss:authShow>
							<kmss:auth
								requestURL="/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=deleteall&status=${param.status}&categoryId=${param.categoryId}&nodeType=${param.nodeType}"
								requestMethod="GET">								
								<ui:button text="${lfn:message('button.delete')}" onclick="delDoc()" order="4"></ui:button>
							</kmss:auth>
							
							<%-- 取消推荐 --%>
							<c:import url="/sys/introduce/import/sysIntroduceMain_cancelbtn.jsp" charEncoding="UTF-8">
								<c:param name="fdModelName" value="com.landray.kmss.km.doc.model.KmDocKnowledge" />
							</c:import>
							
							<%-- 修改权限 --%>
							<c:import url="/sys/right/import/doc_right_change_button.jsp" charEncoding="UTF-8">
								<c:param name="modelName" value="com.landray.kmss.km.doc.model.KmDocKnowledge" />
							</c:import>							
							<%-- 分类转移 --%>
							<c:import url="/sys/simplecategory/import/doc_cate_change_button.jsp" charEncoding="UTF-8">
								<c:param name="modelName" value="com.landray.kmss.km.doc.model.KmDocKnowledge" />
								<c:param name="docFkName" value="kmDocTemplate" />
								<c:param name="cateModelName" value="com.landray.kmss.km.doc.model.KmDocTemplate" />
							</c:import>
						</ui:toolbar>
				</div>
			</div>
		</div>
		
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		
		<%@ include file="/km/doc/km_doc_ui/kmDocKnowledge_listtable.jsp" %>
		
	 	<script type="text/javascript">

	 	var SYS_SEARCH_MODEL_NAME ="com.landray.kmss.km.doc.model.KmDocKnowledge";
	 	
			seajs.use(['lui/jquery','lui/dialog','lui/topic'], function($, dialog , topic) {

				// 监听新建更新等成功后刷新
				topic.subscribe('successReloadPage', function() {
					topic.publish('list.refresh');
				});
				
				//新建
				window.addDoc = function() {
						dialog.simpleCategoryForNewFile(
								'com.landray.kmss.km.doc.model.KmDocTemplate',
								'/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=add&fdTemplateId=!{id}',false,null,null,'${param.categoryId}');
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
							$.post('<c:url value="/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=deleteall"/>&categoryId=${param.categoryId}',
									$.param({"List_Selected":values},true),delCallback,'json');
						}
					});
				};
				window.delCallback = function(data){
					if(window.del_load!=null){
						window.del_load.hide();
						topic.publish("list.refresh");
					}
					dialog.result(data);
				};

					LUI.ready(function(){
						if(LUI('cancelIntroduce')){
						  LUI('cancelIntroduce').setVisible(false);
						}
					});
				
			      //控制取消推荐按钮的显示
				  topic.subscribe('criteria.changed',function(evt){
					  if(LUI('cancelIntroduce')){
					    LUI('cancelIntroduce').setVisible(false);
					  }
					  if(evt['criterions'].length>0){
							 for(var i=0;i<evt['criterions'].length;i++){
								//控制批量领取和批量归还按钮的显示
								if(evt['criterions'][i].key == "docIsIntroduced"){
									if(evt['criterions'][i].value.length==1){
										if(evt['criterions'][i].value[0]=="1"){
											LUI('cancelIntroduce').setVisible(true);
										}
									}
								}
								
							 }
						   }else{
							   document.getElementById("cancelIntroduce").style.display="none";
					     }
				});
			});
		</script>	 