<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ page import="com.landray.kmss.util.UserUtil"%>
<script>
	if(typeof Com_Parameter.__sysAttMainlocale__ == "undefined")
		Com_Parameter.__sysAttMainlocale__= "<%= UserUtil.getKMSSUser(request).getLocale().toString().toLowerCase().replace('_', '-') %>";
</script>
<script>Com_IncludeFile("jg_attachment.js","${KMSS_Parameter_ContextPath}sys/attachment/js/","js",true);</script>
<script>Com_IncludeFile("data.js|json2.js");</script>
	<div id="optBarDiv">
		<table class="tb_noborder">
		<tr><td id="_button_${sysAttMainForm.fdKey}_JG_Attachment_TD"></td>
		</tr>
		</table>
		<input type=button value="<bean:message key="button.update"/>"
				onclick="return Attach_EditOnlineSubmit();"/>
		<script>
		function Attach_EditOnlineSubmit() {
			//提交表单校验
			for(var i=0; i<Com_Parameter.event["submit"].length; i++){
				if(!Com_Parameter.event["submit"][i]()){
					return false;
				}
			}
			//提交表单消息确认
			for(var i=0; i<Com_Parameter.event["confirm"].length; i++){
				if(!Com_Parameter.event["confirm"][i]()){
					return false;
				}
			}
			Com_Parameter.CloseInfo = null;
			Com_CloseWindow();
			return true;
		}
		</script>
		<input type="button" value="<bean:message key="button.close"/>"
			onclick="closeWin();">
	</div>
	<table class="tb_normal" width=100% height="100%" style="margin-top: -10px;">
		<tr>
		<td valign="top">
		<c:import url="/sys/attachment/sys_att_main/jg/sysAttMain_OCX.jsp" charEncoding="UTF-8">
			<c:param name="fdKey" value="${sysAttMainForm.fdKey}" />
			<c:param name="fdAttType" value="office" />
			<c:param name="fdModelId" value="${sysAttMainForm.fdModelId}" />
			<c:param name="fdModelName" value="${sysAttMainForm.fdModelName}" />
			<c:param name="editMode" value="2" />		
			<c:param name="attachmentId" value="${sysAttMainForm.fdId}" />
			<c:param name="fdFileName" value="${sysAttMainForm.fdFileName}" />
			<c:param name="canPrint" value="${canPrint}" />
			<c:param name="attHeight" value="100%" />
			<c:param name="trackRevisions" value="1" />			
		</c:import>			
		</td>		
		</tr>
	</table>
	<script type="text/javascript">
		Com_SetWindowTitle("${fdFileName}");
  		var url = window.location.href;
  		var fdId = Com_GetUrlParameter(url,"fdId");
  		var fdKey = '${sysAttMainForm.fdKey}';
  		var fdModelId = '${sysAttMainForm.fdModelId}';
  		var fdModelName = '${sysAttMainForm.fdModelName}';
  		if(fdModelId == null){
  			fdModelId = "";
  		}
  		if(fdModelName == null){
  			fdModelName = "";
  		}
  		var jg_attachmentObject_editonline = new JG_AttachmentObject(fdId,fdKey, fdModelName, fdModelId, "office", "edit");
  		jg_attachmentObject_editonline.userName = "<%=com.landray.kmss.util.UserUtil.getUser().getFdName()%>";
  		<c:if test="${canPrint=='1'}">
  			jg_attachmentObject_editonline.canPrint = true;
  		</c:if>
  		<c:if test="${canCopy=='1'}">
  			jg_attachmentObject_editonline.canCopy = true;	
  		</c:if>	
  	    //在线编辑打开，默认显示留痕
  		jg_attachmentObject_editonline.showRevisions = true;


  		function closeWin(){
  		   clearEdit(fdId,fdModelId,fdModelName,fdKey);
  		   if(jg_attachmentObject_editonline.ocxObj.WebClose()){
  			 Com_CloseWindow();
  			}
  		}
  	    
  	  /***********************************************
  	  功能  判断是否只有当前用户在线编辑
  	 ***********************************************/
  	 function isFirst(fdId,fdModelId,fdModelName,fdKey) {
  	  	 var flag;
  		 var url = Com_GetCurDnsHost() + Com_Parameter.ContextPath+"sys/attachment/sys_att_main/jg_service.jsp?method=isFirst&_addition=1";
  		 $.ajax({   
  		     type:"post",     
  		     url:url,     
  		     data:{fdId:fdId,fdModelId:fdModelId,fdModelName:fdModelName,fdKey:fdKey},    
  		     async:false,
  		     success:function(data){ 
  		    	 var xml = JSON.parse(data);
  				 	if(xml.isEdit == "0"){
  				 		alert("该附件正在被"+xml.editOrgName+"编辑"+",您只能查看");
  				 		//不是第一编辑人，控制为只读状态
  				 		 flag =  false;                 
  				 	}else if(xml.isEdit == "1"){
  				 		//是第一编辑人，控制可编辑状态
  				 		 flag = true;                        
  				 	}
  			   }     
  	      });
 	      return flag;
  	}
  	 
  	/***********************************************
  		 功能  清除当前在线编辑用户信息
  		 ***********************************************/
  	function clearEdit(fdId,fdModelId,fdModelName,fdKey,Obj) {
  			 var url = Com_GetCurDnsHost() + Com_Parameter.ContextPath+"sys/attachment/sys_att_main/jg_service.jsp?method=clearEdit&_addition=1";
  			 $.ajax({   
  			     type:"post", 
  			     url:url,     
  			     data:{fdId:fdId,fdModelId:fdModelId,fdModelName:fdModelName,fdKey:fdKey},    
  			     async:false,
  			     success:function(data){ 
  				  }  
  		      });
  	}
  		 
	/***
	 * 更新时间标识
	 */
	function updateTime(fdId,fdModelId,fdModelName,fdKey){
		 var url = Com_GetCurDnsHost() + Com_Parameter.ContextPath+"sys/attachment/sys_att_main/jg_service.jsp?method=updateTime&_addition=1";
		 $.ajax({   
		     type:"post",     
		     url:url,     
		     data:{fdId:fdId,fdModelId:fdModelId,fdModelName:fdModelName,fdKey:fdKey},    
		     async:false,
		     success:function(data){}     
	      });
	}

  		
  		Com_AddEventListener(window, "load", function() {
            jg_attachmentObject_editonline.load(encodeURIComponent("${sysAttMainForm.fdFileName}"));
  			if(isFirst(fdId,fdModelId,fdModelName,fdKey)){
  				jg_attachmentObject_editonline.ocxObj.EditType = "1";
  	  		}else{
  	  		    jg_attachmentObject_editonline.ocxObj.EditType = "0";
  	  	  	}	
  			jg_attachmentObject_editonline.show();
  		});
  		setInterval(function(){
  			     updateTime(fdId,fdModelId,fdModelName,fdKey);
  	  	   },3000);

  		Com_AddEventListener(window, "unload", function() {
  			clearEdit(fdId,fdModelId,fdModelName,fdKey,jg_attachmentObject_editonline);
  			jg_attachmentObject_editonline.unLoad();
  		});
  		//-->
  </script>
<%@ include file="/resource/jsp/edit_down.jsp"%>
