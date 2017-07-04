<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="TA" value="${param.zone_TA}"/>
<template:include ref="zone.navlink">
	<template:replace name="title">${lfn:message('km-collaborate:table.kmCollaborateMainTitle')}</template:replace>
	<template:replace name="content">
		<list:criteria id="criteria1" expand="true">
		    <list:cri-criterion title="${lfn:message(lfn:concat('km-collaborate:kmCollaborateMain.Collaborate.', TA))}" key="taCollaborate" multi="false">
				<list:box-select>
					<list:item-select cfg-defaultValue="create" cfg-required="true">
						<ui:source type="Static">
						    [{text:'${lfn:message(lfn:concat('km-collaborate:kmCollaborateMain.Launch.', TA))}', value:'create'},
							 {text:'${lfn:message(lfn:concat('km-collaborate:kmCollaborateMain.Participate.', TA))}', value:'participate'},
							 {text:'${lfn:message(lfn:concat('km-collaborate:kmCollaborateMain.Attention.', TA))}', value:'attention'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			  <!-- 文档状态，默认查询进行中 -->
			<list:cri-criterion title="${lfn:message('km-collaborate:kmCollaborateMain.docStatus')}" key="docStatus" expand="false" multi="false">
					<list:box-select>
					<list:item-select id="docStatus1" cfg-enable="true">
						<ui:source type="Static">
							[{text:'${ lfn:message('km-collaborate:kmCollaborateMain.draft') }', value:'10'},
							{text:'${ lfn:message('km-collaborate:status.going') }',value:'30'},
							{text:'${ lfn:message('km-collaborate:status.over') }',value:'40'}]
						</ui:source>
					</list:item-select>
				</list:box-select>
			</list:cri-criterion>
			
			  <!-- 文档状态，默认查询进行中 -->
			<list:cri-criterion title="${lfn:message('km-collaborate:kmCollaborateMain.docStatus')}" key="docStatus" expand="false" multi="false">
					<list:box-select>
					<list:item-select id="docStatus2" cfg-enable="false">
						<ui:source type="Static">
							[{text:'${ lfn:message('km-collaborate:status.going') }',value:'30'},
							{text:'${ lfn:message('km-collaborate:status.over') }',value:'40'}]
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
						<ui:toolbar layout="sys.ui.toolbar.sort" style="float:left" count="6">
							<list:sort property="kmCollaborateMain.docCreateTime" text="${lfn:message('km-collaborate:kmCollaborateLogs.docCreateTime')}" group="sort.list" value="down"></list:sort>
							<list:sort property="kmCollaborateMain.docReadCount" text="${lfn:message('km-collaborate:kmCollaborateMain.docReadCount')}" group="sort.list"></list:sort>
							<list:sort property="kmCollaborateMain.docReplyCount" text="${lfn:message('km-collaborate:kmCollaborateMain.docReplyCount')}" group="sort.list"></list:sort>
						</ui:toolbar>
					</td>
					<td align="right">
						<ui:toolbar count="3" id="Btntoolbar">
							<%-- 收藏 --%>
							<c:import url="/sys/bookmark/import/bookmark_bar_all.jsp" charEncoding="UTF-8">
								<c:param name="fdTitleProName" value="docSubject" />
								<c:param name="fdModelName"	value="com.landray.kmss.km.collaborate.model.KmCollaborateMain" />
							</c:import>
						</ui:toolbar> 						
					</td>
				</tr>
			</table>
		</div>
			
	    <ui:fixed elem=".lui_list_operation"></ui:fixed>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
					{url:'/km/collaborate/km_collaborate_main/kmCollaborateMainIndex.do?method=list&type=zone&userId=${zone_user.fdId}'}
			</ui:source>
			<list:colTable isDefault="true" layout="sys.ui.listview.columntable" 
				rowHref="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=!{method}&fdId=!{fdId}" name="columntable">
				<list:col-checkbox name="List_Selected" headerStyle="width:5%"></list:col-checkbox>
				<list:col-serial title="${ lfn:message('page.serial')}" headerStyle="width:5%"></list:col-serial>
				<list:col-auto props="fdIsLook;fdIsPriority;fdHasAttachment"></list:col-auto>
				<list:col-auto props="docSubject;fdCategory.fdName;docCreator.fdName;docReadCount;docReplyCount;docCreateTime;attend"></list:col-auto>
			</list:colTable>
		</list:listview>
	 	<list:paging></list:paging>
	 	 	<script type="text/javascript">
	 	seajs.use(['lui/jquery', 'lui/util/str', 'lui/dialog','lui/topic','lui/toolbar'], function($, strutil, dialog , topic ,toolbar) {
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

			 topic.subscribe('criteria.changed',function(evt){
				 if(LUI('cancelIntroduce')){
					LUI('cancelIntroduce').setVisible(false);
			   	 }
					if(evt['criterions'].length>0){
                      for(var i=0;i<evt['criterions'].length;i++){
                          //状态栏显示
                    	  if(evt['criterions'][i].key=="taCollaborate"){
  							if(evt['criterions'][i].value.length==1){
  								if(evt['criterions'][i].value[0]=="create"){
  									LUI('docStatus1').setEnable(true);
  									LUI('docStatus2').setEnable(false);
  								}
  								else{
  									LUI('docStatus1').setEnable(false);
  									LUI('docStatus2').setEnable(true);
  								}
  							}
  					       }	       
    						
                      }					
				  }
				});			
			 
			window.ajaxAtten=function(event,fdId){
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