<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view" sidebar="no" width="980px">
	<template:replace name="title">
		<c:out value="${ lfn:message('sys-handover:module.sys.handover') }"></c:out>
	</template:replace>
	<%-- 按钮栏 --%>
	<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float">
		    <kmss:authShow roles="ROLE_SYSHANDOVER_MAINTAIN">
				<ui:button text="${lfn:message('button.delete') }" order="1" onclick="deleteDoc('sysHandoverConfigMain.do?method=delete&fdId=${param.fdId}');">
				</ui:button>
			</kmss:authShow>
				<ui:button text="${lfn:message('button.close') }" order="2" onclick="closeDoc();">
				</ui:button>
		</ui:toolbar>
	</template:replace>
	<template:replace name="path">
			<ui:menu layout="sys.ui.menu.nav">
				<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_self">
				</ui:menu-item>
				<ui:menu-item text="${lfn:message('sys-handover:module.sys.handover')}" href="/sys/handover/" target="_self">
			   </ui:menu-item> 
		</ui:menu>
	</template:replace>	
	<template:replace name="content"> 
		   <script>
				seajs.use("${LUI_ContextPath}/sys/handover/resource/css/handover.css");
				seajs.use(['${LUI_ContextPath}/sys/handover/sys_handover_config/js/hand.js','lui/dialog'], function(hand,dialog) {
					_hand = hand;
					LUI.ready( function() {
						  var logData = '${logData}';
						  var logDataJson = JSON.parse(logData);
						 // for(var i=0;i<dataArr.length;i++){
							// hand.showData(dataArr[i],false);
						  //}
						  //debugger;
						  for (var key in logDataJson){
							 hand.showData(logDataJson[key],"resultContent",false);
						  }
					});
					window.openUrl = function(url){
						if(url==''){
							return;
					    }
			 		    window.open("${LUI_ContextPath}"+url,"_blank");
			 		};
			 		window.deleteDoc = function(delUrl){
						dialog.confirm('<bean:message key="page.comfirmDelete"/>',function(isOk){
							if(isOk){
								Com_OpenWindow(delUrl,'_self');
							}	
						});
						return;
					};
					window.closeDoc = function(){
				 		window.close();
			 		};
			 		 //一键展开折叠
					window.oneKeyShow = function(isShow){
						if(isShow == true){
							 $("#a_spead_onekeyButton").hide();
							 $("#a_retract_onekeyButton").show();
						}else{
							 $("#a_retract_onekeyButton").hide();
							 $("#a_spead_onekeyButton").show();
					    }
						hand.oneKeySpead(isShow);
						
					};
				});
		  </script>
	      <div name="searchContent" class="searchContent" style="padding: 10px">		
	       	  <div class="lui_handover_header">
                <span>${ lfn:message('sys-handover:sysHandoverConfigLog.fdMain.executeLog') }</span>
                <%-- 一键展开/折叠--%> 
                <ui:button styleClass="a_spead_onekeyButton" text="${ lfn:message('sys-handover:sysHandoverConfigMain.onekeySpred') }" id="a_spead_onekeyButton" onclick="oneKeyShow(true);"/>
                <ui:button styleClass="a_retract_onekeyButton" style="display:none" text="${ lfn:message('sys-handover:sysHandoverConfigMain.onekeyRetract') }" id="a_retract_onekeyButton" onclick="oneKeyShow(false);"/>
              </div>   
		     <table class="tb_normal lui_handover_headTb lui_sheet_c_table" >  
			      <tr>
					  <td width="15%" class="td_normal_title" valign="top">${ lfn:message('sys-handover:sysHandoverConfigMain.fdFromName') }</td>
					  <td width="35%"><c:out value="${configMain.fdFromName}" /></td>
				      <td width="15%" class="td_normal_title" valign="top">${ lfn:message('sys-handover:sysHandoverConfigMain.fdToName') }</td>
					  <td width="35%"><c:out value="${configMain.fdToName}" /></td>
				  </tr><!--	
				  <tr>
				      <td width="20%" class="td_normal_title" valign="top">${ lfn:message('sys-handover:sysHandoverConfigLog.fdMain.executeWay') }</td>
					  <td><c:out value="${ lfn:message('sys-handover:sysHandover.executeWay.replace') }" /></td>
				  </tr>	
			      -->
			      <tr>
			 	      <td width="15%" class="td_normal_title" valign="top">${ lfn:message('sys-handover:sysHandoverConfigLog.fdMain.executeList') }</td>
			 	      <%-- 交接记录 --%>
					   <td width="85%" colspan="3">
					       <div name="resultContent" class="resultContent" id="resultContent"></div>
					  </td>
				  </tr>		
				  <tr>
				      <td width="15%" class="td_normal_title" valign="top">${ lfn:message('sys-handover:sysHandoverConfigLog.fdMain.executer') }</td>
				      <td width="35%"><c:out value="${configMain.docCreator.fdName}"/> </td>
					  <td width="15%" class="td_normal_title">${ lfn:message('sys-handover:sysHandoverConfigLog.fdMain.executerTime') }  </td>
					  <td width="35%"><kmss:showDate type="datetime" value="${configMain.docCreateTime}" /></td>
				  </tr>	  
		  	</table>
		 </div>	 
	</template:replace>
</template:include>
