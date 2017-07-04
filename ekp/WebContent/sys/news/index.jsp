<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.list">
	<template:replace name="title">
		<c:out value="${lfn:message('sys-news:news.moduleName')}"></c:out>
	</template:replace>
	<template:replace name="path">
		<ui:combin ref="menu.path.simplecategory">
			<ui:varParams 
				id="simplecategoryId"
				moduleTitle="${ lfn:message('sys-news:news.moduleName') }" 
				href="/sys/news/" 
				modelName="com.landray.kmss.sys.news.model.SysNewsTemplate" 
				categoryId="${param.categoryId}" />
		</ui:combin>
	</template:replace>
	<template:replace name="nav">
	<!-- 所有分类 -->
		<ui:combin ref="menu.nav.simplecategory.all"> 
			<ui:varParams 
				modelName="com.landray.kmss.sys.news.model.SysNewsTemplate" 
				href="/sys/news/" />
		</ui:combin>
	<!-- 新建 -->		
		<ui:combin ref="menu.nav.create">
			<ui:varParam name="title" value="${ lfn:message('sys-news:news.moduleName') }" />
			<ui:varParam name="button">
				[
					<kmss:authShow roles="ROLE_SYSNEWS_CREATE">
					{
						"text": "${ lfn:message('sys-news:sysNews.create.title') }",
						"href": "javascript:addDoc();",
						"icon": "lui_icon_l_icon_24"
					}
					</kmss:authShow>
				]
			</ui:varParam>				
		</ui:combin>
		<div class="lui_list_nav_frame">
			<ui:accordionpanel>
				 <!--常用分类 -->
			 	<ui:combin ref="menu.nav.favorite.category">
					<ui:varParams 
						href="/sys/news/?categoryId=!{value}"
						modelName="com.landray.kmss.sys.news.model.SysNewsTemplate" />
				</ui:combin>
			    <!-- 分类索引 -->
				<ui:content style="padding:0px;" title="${lfn:message('sys-category:menu.sysCategory.index') }">
					<ui:combin ref="menu.nav.simplecategory.flat">
						<ui:varParams 
							modelName="com.landray.kmss.sys.news.model.SysNewsTemplate" 
							href="/sys/news/" 
							categoryId="${param.categoryId}" />
					</ui:combin>
					<c:if test="${not empty param.categoryId}">
						<ui:operation href="javascript:LUI('simplecategoryId').gotoNav(-1)" target="_self" name="${lfn:message('list.lever.up') }" align="left"/>
					</c:if>	
				</ui:content>
			  <!-- 查询栏 -->
				<ui:content title="${ lfn:message('list.search') }">
				<ul class='lui_list_nav_list'>
					<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').clearValue();LUI('criteria1').setValue('docStatus', '30');">${ lfn:message('sys-news:sysNewsMain.allNews') }</a></li>
					<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('mydoc', 'create');">${ lfn:message('sys-news:sysNewsMain.myNews') }</a></li>
					<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('mydoc', 'approval');">${ lfn:message('list.approval') }</a></li>
					<li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('mydoc', 'approved');">${ lfn:message('list.approved') }</a></li>
				    <li><a href="javascript:void(0)" onclick="openQuery();LUI('criteria1').setValue('fdIsTop', '1');">${ lfn:message('sys-news:sysNewsMain.fdIsTopNews') }</a></li>
				</ul>
				</ui:content>
				<!-- 其他操作 -->	
				<ui:content title="${ lfn:message('list.otherOpt') }" toggle="true">
					<ul class='lui_list_nav_list'>
						<li><a href="${LUI_ContextPath }/sys/?module=sys/news" target="_blank">${ lfn:message('list.manager') }</a></li>
					</ul>
				</ui:content>
			</ui:accordionpanel>
		</div>
	</template:replace>
	<template:replace name="content">  
	   <%-- 筛选器 --%>	
	    <list:criteria id="criteria1">
	         <list:cri-ref key="docSubject" ref="criterion.sys.docSubject">
			</list:cri-ref>
		   	<!--重要度、发布时间 -->
			<list:cri-auto modelName="com.landray.kmss.sys.news.model.SysNewsMain" property="fdImportance;docPublishTime" expand="false"/>
			<!--文档状态 -->
			<list:cri-criterion title="${lfn:message('sys-news:sysNewsMain.docStatus')}" key="docStatus" expand="false">
				<list:box-select>
					<list:item-select  cfg-defaultValue="30">
						<ui:source type="Static">
							[{text:'${ lfn:message('sys-news:status.draft') }', value:'10'},
							{text:'${ lfn:message('sys-news:status.examine') }',value:'20'},
							{text:'${ lfn:message('sys-news:status.refuse') }', value: '11'},
							{text:'${ lfn:message('sys-news:status.discard') }',value:'00'},
							{text:'${ lfn:message('sys-news:status.publish') }',value:'30'},
							{text:'${ lfn:message('sys-news:status.cancle') }',value:'40'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
		    <!--作者、部门 -->
			<list:cri-auto modelName="com.landray.kmss.sys.news.model.SysNewsMain" property="fdAuthor;fdDepartment" />
			<!-- 我上传的查询器 -->
			<list:cri-criterion title="${lfn:message('sys-news:sysNews.sysNewsMain.my')}" key="mydoc" expand="false" multi="false">
				<list:box-select>
					<list:item-select>
						<ui:source type="Static">
							[{text:'${ lfn:message('sys-news:sysNewsMain.myNews') }', value:'create'},{text:'${ lfn:message('list.approval') }',value:'approval'}, {text:'${ lfn:message('list.approved') }', value: 'approved'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			<!-- 其他查询 -->
			<list:cri-criterion title="${lfn:message('sys-news:sysNewsMain.otherSearch') }" key="fdIsTop" expand="false"  >
				<list:box-select>
					<list:item-select>
						<ui:source type="Static">
							[{text:'${ lfn:message('sys-news:sysNewsMain.fdIsTopNews') }',value:'1'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>	
		</list:criteria>
		<!-- 排序 -->
		<div class="lui_list_operation">
			<div style='color: #979797;float: left;padding-top:1px;'>
				${ lfn:message('list.orderType') }：
			</div>
			<div style="float:left">
				<div style="display: inline-block;vertical-align: middle;">
					<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" count="6" >
						<list:sort property="fdIsTop;fdTopTime;docAlterTime" text="${lfn:message('sys-news:sysNewsMain.new') }" group="sort.list" value="down"></list:sort>
						<list:sort property="docPublishTime" text="${lfn:message('sys-news:sysNewsMain.docPublishTime') }" group="sort.list" ></list:sort>
						<list:sort property="docReadCount" text="${lfn:message('sys-news:sysNewsMain.docHits') }" group="sort.list"></list:sort>
					</ui:toolbar>
				</div>
			</div>
			<div style="float:left;">	
				<list:paging layout="sys.ui.paging.top" > 		
				</list:paging>
			</div>
			<div style="float:right">
				<div style="display: inline-block;vertical-align: middle;">
					<ui:toolbar count="3" id="btnToolBar">
							<%-- 视图切换 --%>
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
						
							<%-- 收藏 --%>
							<c:import url="/sys/bookmark/import/bookmark_bar_all.jsp" charEncoding="UTF-8">
								<c:param name="fdTitleProName" value="docSubject" />
								<c:param name="fdModelName"	value="com.landray.kmss.sys.news.model.SysNewsMain" />
							</c:import>
							
							<kmss:authShow roles="ROLE_SYSNEWS_CREATE">
								<ui:button text="${lfn:message('button.add')}" onclick="addDoc()" order="2"></ui:button>	
							</kmss:authShow>
															
							<%-- ------删除----- --%>
							<kmss:auth requestURL="/sys/news/sys_news_main/sysNewsMain.do?method=deleteall&status=${param.status}&categoryId=${param.categoryId}&nodeType=${param.nodeType}" requestMethod="GET">						
							    <ui:button text="${lfn:message('button.delete')}" onclick="delDoc()" order="3"></ui:button>
							</kmss:auth>
							
							<%-- 修改权限 --%>
							<c:import url="/sys/right/import/doc_right_change_button.jsp" charEncoding="UTF-8">
								<c:param name="modelName" value="com.landray.kmss.sys.news.model.SysNewsMain" />
							</c:import>							
							<%-- 分类转移 --%>
							<c:import url="/sys/simplecategory/import/doc_cate_change_button.jsp" charEncoding="UTF-8">
								<c:param name="modelName" value="com.landray.kmss.sys.news.model.SysNewsMain" />
								<c:param name="docFkName" value="fdTemplate" />
								<c:param name="cateModelName" value="com.landray.kmss.sys.news.model.SysNewsTemplate" />
							</c:import>
							
							
							<!-- 在“发布文档”和“文档维护”目录树下需要显示以下按钮 -->
		
								<%-- ------置顶-----  --%>
								<kmss:auth requestURL="/sys/news/sys_news_main/sysNewsMain.do?method=setTop&categoryId=${param.categoryId}&nodeType=${param.nodeType}" requestMethod="GET">
									<ui:button id="setTop"  text="${lfn:message('sys-news:news.button.setTop')}" onclick="setTop(true)" ></ui:button>	
									<ui:button id="unSetTop" text="${lfn:message('sys-news:news.button.unSetTop')}" onclick="setTop(false)"></ui:button>	
								</kmss:auth>
								
					
								<%-- ------取消发布		 --%>			
				    			<kmss:auth requestURL="/sys/news/sys_news_main/sysNewsMain.do?method=setPublish&categoryId=${param.categoryId}&nodeType=${param.nodeType}" requestMethod="GET">
									<ui:button id="unPublish" text="${lfn:message('sys-news:news.button.unPublish')}" onclick="op(false)"></ui:button>
								</kmss:auth>
												
							<%-- ------重新发布----- --%>
								<kmss:auth requestURL="/sys/news/sys_news_main/sysNewsMain.do?method=setPublish&categoryId=${param.categoryId}&nodeType=${param.nodeType}" requestMethod="GET">
									<ui:button id="publish" text="${lfn:message('sys-news:news.button.publish')}" onclick="op(true)" ></ui:button>
								</kmss:auth>
						
								
						</ui:toolbar>
				</div>
			</div>
		</div>
		
	    <ui:fixed elem=".lui_list_operation"></ui:fixed>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
					{url:'/sys/news/sys_news_main/sysNewsMainIndex.do?method=listChildren&categoryId=${param.categoryId}'}
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
			});
     </script>	 
	</template:replace>
</template:include>
