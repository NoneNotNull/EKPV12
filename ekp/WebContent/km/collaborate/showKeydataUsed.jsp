<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
	
		
	<div style="float:right">	
		<div class="lui_list_operation">
			<div style="display: inline-block;vertical-align: middle;">
					<ui:toolbar count="3" >
						<%-- 新建 --%>
						<kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=add">
							<ui:button text="${lfn:message('button.add')}" onclick="addDoc()" order="2" ></ui:button>
						</kmss:auth>
					</ui:toolbar>
				</div>
		</div>
		</div>
		 <ui:fixed elem=".lui_list_operation"></ui:fixed>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
					{url:'/km/collaborate/km_collaborate_main/kmCollaborateMainIndex.do?method=showKeydataUsed&keydataId=${param.keydataId}'}
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
			    };

			topic.subscribe('list.loaded',function(evt){
				if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
					window.frameElement.style.height =  ($(document.body).height()+30) + "px";
				}
				
			});
	 	});
	 	</script>
