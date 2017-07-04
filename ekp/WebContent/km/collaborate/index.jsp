<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.list">
    <!-- 标题 -->
	<template:replace name="title">${ lfn:message('km-collaborate:table.kmCollaborateMainTitle') }</template:replace>
	<!-- 路径 -->
	<template:replace name="path">
			<ui:menu layout="sys.ui.menu.nav">
				<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_self">
				</ui:menu-item>
				<ui:menu-item text="${ lfn:message('km-collaborate:table.kmCollaborateMainTitle') }" href="/km/collaborate/" target="_self">
				</ui:menu-item>
			</ui:menu>
	</template:replace>
	<!-- 导航区域 -->
	<template:replace name="nav">
				<!-- 新建 -->
			<ui:combin ref="menu.nav.create">
					<ui:varParam name="title" value="${ lfn:message('km-collaborate:table.kmCollaborateMainTitle')}"></ui:varParam>
					<ui:varParam name="button">
						[
						  	<kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=add">
							{
								"text": "${ lfn:message('km-collaborate:kmcollaborateMain.createCollaborate')}",
								"href":"javascript:addDoc()",
								"icon": "lui_icon_l_icon_36"
							}
							</kmss:auth>
						]
					</ui:varParam>
				</ui:combin>
			<!-- 左侧导航链接 -->
			<div class="lui_list_nav_frame">
				<ui:accordionpanel>
					<ui:content title="${lfn:message('list.search') }" expand="true" >
					<ul class='lui_list_nav_list'>
					    <li><a href="javascript:void(0)" onclick="openQuery();LUI('collaborateMainCriteria').clearValue();">${ lfn:message('km-collaborate:table.kmCollaborateMain.all')}</a></li>
					    <li><a href="javascript:void(0)" onclick="openQuery();LUI('collaborateMainCriteria').setValue('pageType','myDoc');">${ lfn:message('km-collaborate:kmCollaborateMain.myLaunch')}</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('collaborateMainCriteria').setValue('pageType','myJoin');">${ lfn:message('km-collaborate:kmCollaborateMain.myParticipate')}</a></li>
						<li><a href="javascript:void(0)" onclick="openQuery();LUI('collaborateMainCriteria').setValue('pageType','myFollow');">${ lfn:message('km-collaborate:kmCollaborateMain.myAttention')}</a></li>
					</ul>
					</ui:content>
					<ui:content title="${ lfn:message('list.otherOpt') }" toggle="true">
						<ul class='lui_list_nav_list'>
							<li><a href="${LUI_ContextPath }/sys/?module=km/collaborate" target="_blank">${ lfn:message('list.manager') }</a></li>
						</ul>
					</ui:content>
				</ui:accordionpanel>
				</div>
	</template:replace>
	<template:replace name="content">   
	 <!-- 筛选器 -->
		<list:criteria id="collaborateMainCriteria">
		     <!-- 主题 -->
		    <list:cri-ref key="docSubject" ref="criterion.sys.docSubject">
			</list:cri-ref>
			<!-- 我的沟通 -->
		    <list:cri-criterion title="${ lfn:message('km-collaborate:kmCollaborateMain.Collaborate.my') }" key="pageType" expand="false" multi="false">
							<list:box-select>
								<list:item-select>
							    	 <ui:source type="Static">
									    [{text:'${ lfn:message('km-collaborate:kmCollaborateMain.myLaunch') }',value:'myDoc'},
									    {text:'${ lfn:message('km-collaborate:kmCollaborateMain.myParticipate') }',value:'myJoin'},
									    {text:'${ lfn:message('km-collaborate:kmCollaborateMain.myAttention') }',value:'myFollow'}
									    ]
								     </ui:source>
								     <ui:event event="selectedChanged" args="evt">
											var vals = evt.values;
											if (vals.length > 0 && vals[0] != null) {
												var val = vals[0].value;
												if (val != 'myDoc') {
													LUI('mark').setEnable(true);
												} else{
													LUI('mark').setEnable(false);
												}
											}else{
											        LUI('mark').setEnable(false);
											}
						 			</ui:event>
					  </list:item-select>
				  </list:box-select>
			</list:cri-criterion>	
			<!-- 标记 -->
		    <list:cri-criterion title="${ lfn:message('km-collaborate:kmCollaborateMain.mark') }" key="mark" expand="false" multi="false">
							<list:box-select>
								<list:item-select id="mark" cfg-enable="false">
							    	 <ui:source type="Static">
									    [{text:'${ lfn:message('km-collaborate:kmCollaborateMain.mark.unRead') }',value:'unRead'},
									    {text:'${ lfn:message('km-collaborate:kmCollaborateMain.mark.readed') }',value:'readed'},
									    {text:'${ lfn:message('km-collaborate:kmCollaborateMain.mark.overdue') }',value:'overdue'}
									    ]
								     </ui:source>
					  </list:item-select>
				  </list:box-select>
			 </list:cri-criterion>	
			 <!-- 类型 -->
			 <list:cri-criterion title="${ lfn:message('km-collaborate:table.kmCollaborateCategory.tilteKind') }" key="fdCategory" expand="false">
				<list:box-select>
					<list:item-select>
						<ui:source type="AjaxJson">
							{url:'/km/collaborate/km_collaborate_category/kmCollaborateCategory.do?method=getCollaborateCategory'}
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>	
		   
			 <!-- 创建者、创建时间 -->
		    <list:cri-auto modelName="com.landray.kmss.km.collaborate.model.KmCollaborateMain" property="docStatus;docCreator;docCreateTime" expand="false"/>
		</list:criteria>
		<div class="lui_list_operation">
			<div style='color: #979797;float: left;padding-top:1px;'>
				${ lfn:message('list.orderType') }：
			</div>
			<div style="float:left">
				<div style="display: inline-block;vertical-align: middle;">
					<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" count="6" >
						<list:sort property="kmCollaborateMain.docCreateTime" text="${lfn:message('km-collaborate:kmCollaborateLogs.docCreateTime')}" group="sort.list" value="down"></list:sort>
							<list:sort property="kmCollaborateMain.docReadCount" text="${lfn:message('km-collaborate:kmCollaborateMain.docReadCount')}" group="sort.list"></list:sort>
							<list:sort property="kmCollaborateMain.docReplyCount" text="${lfn:message('km-collaborate:kmCollaborateMain.docReplyCount')}" group="sort.list"></list:sort>
					</ui:toolbar>
				</div>
			</div>
			<div style="float:left;">	
				<list:paging layout="sys.ui.paging.top" > 		
				</list:paging>
			</div>
			<div style="float:right">
				<div style="display: inline-block;vertical-align: middle;">
					<ui:toolbar count="3" >
						<%-- 新建 --%>
						<kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=add">
							<ui:button text="${lfn:message('button.add')}" onclick="addDoc()" order="2" ></ui:button>
						</kmss:auth>
						<%-- 删除1、如果是草稿状态,(默认为创建者的文档，可以删除2、若不是草稿需要删除权限)--%>	
						<c:if test="${param.status eq 10 }">		
							<ui:button text="${lfn:message('button.delete')}" order="4" onclick="delDoc()"></ui:button>
						</c:if>
						<c:if test="${! (param.status eq 10) }">
							 <kmss:authShow roles="ROLE_KMCOLLABORATEMAIN_DELETE">
							    	<ui:button text="${lfn:message('button.delete')}" order="4" onclick="delDoc()"></ui:button>
							</kmss:authShow>
						</c:if>	
					</ui:toolbar>
				</div>
			</div>
		</div>
			
	    <ui:fixed elem=".lui_list_operation"></ui:fixed>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
					{url:'/km/collaborate/km_collaborate_main/kmCollaborateMainIndex.do?method=list'}
			</ui:source>
			<list:colTable isDefault="true" layout="sys.ui.listview.columntable" 
				rowHref="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=!{method}&fdId=!{fdId}" name="columntable">
				<list:col-checkbox name="List_Selected" headerStyle="width:5%"></list:col-checkbox>
				<list:col-serial title="${ lfn:message('page.serial')}" headerStyle="width:5%"></list:col-serial>
				<list:col-auto props="fdIsLook;fdIsPriority;fdHasAttachment"></list:col-auto>
				<list:col-auto props="docSubject;fdCategory.fdName;docCreator.fdName;docReadCount;docReplyCount;docCreateTime;docStatus;attend"></list:col-auto>
			</list:colTable>
		</list:listview>
	 	<list:paging></list:paging>
	 	<script type="text/javascript">
	    var SYS_SEARCH_MODEL_NAME ="com.landray.kmss.km.collaborate.model.KmCollaborateMain";
	    
	 	seajs.use(['lui/jquery', 'lui/util/str', 'lui/dialog','lui/topic','lui/toolbar'], function($, strutil, dialog , topic ,toolbar) {

	 		// 监听新建更新等成功后刷新
			topic.subscribe('successReloadPage', function() {
				topic.publish('list.refresh');
			});

		 	//新建
	 		window.addDoc = function() {
	 			Com_OpenWindow('<c:url value="/km/collaborate/km_collaborate_main/kmCollaborateMain.do" />?method=add');
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
						$.post('<c:url value="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=deleteall"/>',
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
			
			//关注和取消关注事件
		    function getEvent(event){
			 	return event || window.event;
			 }
			 function getTarget(event){
			     event=getEvent(event);
			 	var source=event.target|| event.srcElement;
			 	return source;
			 }
			 function stopPropagation(event){
			 	event=event ||getEvent(event);
			 	if(event.stopPropagation)
			 		 event.stopPropagation();
			 	else 
			 		event.cancelBubble=true;
			 }

			 
			window.ajaxAtten=function(event,fdId){
				     //debugger;
			 	     var attenSrc="gz_y.png";
			 	     var disAttenSrc="gz_n.png";
			    	     event = event|| window.event;
			    	     var target= getTarget(event);
			    	     var src=target.src;
			    	     var flag="";
			    	     if(src.indexOf(attenSrc)!=-1) {
			    	    	flag="cancleAttention";
			    	    	
			    	     }
			    	     else if(src.indexOf(disAttenSrc)!=-1) {
			    	    	flag="attention";
			    	    	
			    	     }
			    	     var url="${LUI_ContextPath}/km/collaborate/km_collaborate_partner_info/kmCollaboratePartnerInfo.do?method=isRead&flag="+flag+"&docid="+fdId;
			    	      $.get(url,function(data){
			    	    	   if(data.indexOf("true")){
			    	    		if(src.indexOf(attenSrc)!=-1) {
			    	    	    	target.src=src.replace(attenSrc,disAttenSrc) ;
			    	    	    	target.alt="<bean:message key='kmCollaborate.jsp.signToAtt' bundle='km-collaborate' />";
			    	    	    	dialog.success("<bean:message key='kmCollaborate.jsp.calcelAtt.success' bundle='km-collaborate' />");
			    	    	     }
			    	    	     else if(src.indexOf(disAttenSrc)!=-1) {
			    	    	    	target.src=src.replace(disAttenSrc,attenSrc) ;
			    	    	    	target.alt="<bean:message key='kmCollaborate.jsp.calcelAtt' bundle='km-collaborate' />";
			    	    	    	dialog.success('<bean:message key="kmCollaborate.jsp.attention.success" bundle="km-collaborate" />');
			    	    	     }
			    	    	   }
			    	    	   else{
			    	    	    dialog.failure('<bean:message key="kmCollaborate.jsp.modify.failure" bundle="km-collaborate"/>');
			    	    	   }
			    	     }); 
			    	   stopPropagation(event);
			    }
	 	});
	 	</script>
	</template:replace>
</template:include>