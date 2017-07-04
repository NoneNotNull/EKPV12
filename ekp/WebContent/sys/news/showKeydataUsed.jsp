<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
	
	   
		<!-- 排序 -->
		<div class="lui_list_operation">
			<table width="100%">
				<tr>
					
					<td align="right">
						<ui:toolbar count="3" id="btnToolBar">
							<%-- 视图切换 
							<ui:togglegroup order="0">
									 <ui:toggle icon="lui_icon_s_zaiyao" title="${ lfn:message('list.rowTable') }" 
										selected="true"  group="tg_1" text="${ lfn:message('list.rowTable') }" value="rowtable"
										onclick="LUI('listview').switchType(this.value);">
									</ui:toggle>
									<ui:toggle icon="lui_icon_s_liebiao" title="${ lfn:message('list.columnTable') }" 
										value="columntable"	group="tg_1" text="${ lfn:message('list.columnTable') }" 
										onclick="LUI('listview').switchType(this.value);">
									</ui:toggle>
							 </ui:togglegroup>
						
							--%>
							
							<kmss:authShow roles="ROLE_SYSNEWS_CREATE">
								<ui:button text="${lfn:message('button.add')}" onclick="addDoc()" order="2"></ui:button>	
							</kmss:authShow>
															
							
						</ui:toolbar>
					</td>
				</tr>
			</table>
		</div>
		
	    <ui:fixed elem=".lui_list_operation"></ui:fixed>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
					{url:'/sys/news/sys_news_main/sysNewsMainIndex.do?method=showKeydataUsed&keydataId=${param.keydataId }'}
			</ui:source>
			
			<list:rowTable
				rowHref="/sys/news/sys_news_main/sysNewsMain.do?method=view&fdId=!{fdId}" name="rowtable" >
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
			                	<a href="${KMSS_Parameter_ContextPath}sys/news/sys_news_main/sysNewsMain.do?method=view&fdId={%row.fdId%}" target="_blank" data-lui-mark-id="{%row.rowId%}">{%row.docSubject_row%}</a>
			                </dt>	
							<dd>
							    <span>{%str.textEllipsis(row['fdDescription_row'],150)%}</span>
							</dd>
							<dd class="lui_listview_rowtable_summary_content_box_foot_info">
					         	${lfn:message('sys-news:sysNewsMain.fdAuthorId') }：<em style="font-style: normal" class="com_author">{%row['fdWriterName_row']%}</em>
								<span>${lfn:message('sys-news:sysNewsMain.fdDepartmentIdBy') }：{%row['fdDepartment.fdName']%}</span>
								<span>{%row['docPublishTime_row']%}</span>
								<span>${lfn:message('sys-news:sysNewsPublishMain.fdImportance') }：{%row['fdImportance']%}</span>
								<span>{%row['docHits_row']%}</span>
								<span>{%row['sysTagMain_row']%}</span>
							</dd>
						</dl>
					</div>	
				    $}		      
				</list:row-template>
			</list:rowTable>
			
			<list:colTable isDefault="false" layout="sys.ui.listview.columntable" 
				rowHref="/sys/news/sys_news_main/sysNewsMain.do?method=view&fdId=!{fdId}"  name="columntable">
				<list:col-checkbox></list:col-checkbox>
				<list:col-serial></list:col-serial>
				<list:col-auto props="docSubject;fdImportance;docCreator.fdName;docPublishTime;docAlterTime;docHits;fdTopDays"></list:col-auto>
			</list:colTable>
			
		</list:listview> 
	 	<list:paging></list:paging>	 
	 	<script type="text/javascript">
		    var SYS_SEARCH_MODEL_NAME ="com.landray.kmss.sys.news.model.SysNewsMain";
    	    Com_IncludeFile("dialog.js");
			seajs.use(['lui/jquery','lui/dialog','lui/topic','lui/toolbar'], function($, dialog , topic,toolbar) {

				// 监听新建更新等成功后刷新
				topic.subscribe('successReloadPage', function() {
					topic.publish('list.refresh');
				});
				
				//新建
				window.addDoc = function() {
						dialog.simpleCategoryForNewFile(
								'com.landray.kmss.sys.news.model.SysNewsTemplate',
								'/sys/news/sys_news_main/sysNewsMain.do?method=add&fdTemplateId=!{id}&fdTemplateName=!{name}&fdModelId=${param.fdModelId}&fdModelName=${param.fdModelName}',false,null,null,'${param.categoryId}');
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
							$.post('<c:url value="/sys/news/sys_news_main/sysNewsMain.do?method=deleteall"/>&categoryId=${param.categoryId}',
									$.param({"List_Selected":values},true),delCallback,'json');
						}
					});
				};
			
					LUI.ready(function(){
						if(LUI('setTop')){LUI('setTop').setVisible(false);	}
						if(LUI('unSetTop')){LUI('unSetTop').setVisible(false);}
						if(LUI('publish')){	LUI('publish').setVisible(false);	}
						if(LUI('unPublish')){LUI('unPublish').setVisible(false);}
					//	openQuery();LUI('criteria1').setValue('docStatus', '30');
					});
				
				 topic.subscribe('criteria.changed',function(evt){
						if(LUI('setTop')){LUI('setTop').setVisible(false);}
						if(LUI('unSetTop')){LUI('unSetTop').setVisible(false);}
						if(LUI('publish')){LUI('publish').setVisible(false);}
						if(LUI('unPublish')){LUI('unPublish').setVisible(false);}
						if(evt['criterions'].length>0){
                          for(var i=0;i<evt['criterions'].length;i++){
                              //发布状态显示【置顶】、【取消发布】按钮
                        	  if(evt['criterions'][i].key=="docStatus"){
      							if(evt['criterions'][i].value.length==1){
      								if(evt['criterions'][i].value[0]=="30"){
      									if(LUI('setTop')){LUI('setTop').setVisible(true);}
      									if(LUI('unSetTop')){LUI('unSetTop').setVisible(true);}
      									if(LUI('unPublish')){LUI('unPublish').setVisible(true);}
      								}
      								if(evt['criterions'][i].value[0]=="40"){
      									if(LUI('publish')){LUI('publish').setVisible(true);}
      								}							
      							}
      					       }
                              //置顶查询显示【取消置顶】按钮
                              if(evt['criterions'][i].key=="fdIsTop"){
        							if(evt['criterions'][i].value.length==1){
        								if(evt['criterions'][i].value[0]=="1"){
        									if(LUI('setTop')){LUI('setTop').setVisible(true);}
        									if(LUI('unSetTop')){LUI('unSetTop').setVisible(true);}
        								}
        							}
        					   }
        						
        						
                          }					
					  }
					});

				 window.setTop=function(isTop){
						var values = [];
						$("input[name='List_Selected']:checked").each(function(){
							values.push($(this).val());
						});
					    if(values.length==0){
						dialog.alert('<bean:message key="page.noSelect"/>');
						return;
					   }
					  var days=null;
						if(isTop){
						dialog.iframe("./sys_news_main/sysNewsMain_topday.jsp","${lfn:message('sys-news:sysNewsMain.fdTopTime')}",function (value){
                                 days=value;
                             	if(days==null){
    								return;
    							}else{
    											window.del_load = dialog.loading();
    											$.post('<c:url value="/sys/news/sys_news_main/sysNewsMain.do?method=setTop"/>',
    													$.param({"List_Selected":values,"fdIsTop":isTop,"fdDays":days},true),topCallback,'json');									
    							}
								},{width:400,height : 200});
						}else{		
							    days=0;		
							    dialog.confirm('<bean:message bundle="sys-news" key="news.setTop.confirmCancel"/>',function(value){
								if(value==true){
									window.del_load = dialog.loading();
									$.post('<c:url value="/sys/news/sys_news_main/sysNewsMain.do?method=setTop"/>',
											$.param({"List_Selected":values,"fdIsTop":isTop,"fdDays":days},true),topCallback,'json');
								}
							});					
						}
					};
					
				 window.op=function(optype) {
						var values = [];
						$("input[name='List_Selected']:checked").each(function(){
							values.push($(this).val());
						});
					    if(values.length==0){
						   dialog.alert('<bean:message key="page.noSelect"/>');
						   return;
					    }
                        //取消发布确认框
						if(optype==false){
							dialog.confirm('<bean:message bundle="sys-news" key="news.publish.confirmCancel"/>',function(value){
								if(value==true){
									window.del_load = dialog.loading();
									$.post('<c:url value="/sys/news/sys_news_main/sysNewsMain.do?method=setPublish"/>',
											$.param({"List_Selected":values,"op":optype},true),publishCallback,'json');		
								}
							});
					    }else{
							window.del_load = dialog.loading();
							$.post('<c:url value="/sys/news/sys_news_main/sysNewsMain.do?method=setPublish"/>',
									$.param({"List_Selected":values,"op":optype},true),publishCallback,'json');		
					    }	  
					};


                   //置顶、取消置顶回调
					window.topCallback = function(data){
						if(window.del_load!=null)
							window.del_load.hide();
						if(data!=null && data.status==true){
							topic.publish("list.refresh");
							dialog.success('<bean:message key="return.optSuccess" />');
						}else{
							dialog.failure('<bean:message key="return.optFailure" />');
						}
					};

                  //发布、取消发布回调
					window.publishCallback = function(data){
						if(window.del_load!=null)
							window.del_load.hide();
						if(data!=null && data.status==true){
							topic.publish("list.refresh");
							dialog.success('<bean:message key="return.optSuccess" />');
						}else{
							dialog.failure('<bean:message key="return.optFailure" />');
						}
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

				topic.subscribe('list.loaded',function(evt){
					if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
						window.frameElement.style.height =  ($(document.body).height()+30) + "px";
					}
					
				});
			});
     </script>	 
