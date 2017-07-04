<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.landray.kmss.web.taglib.editor.CKEditorConfig"%>
<%@page import="com.landray.kmss.km.collaborate.model.KmCollaborateConfig"%>
<template:include ref="default.dialog">
	<template:replace name="content">	
	    <link href="${LUI_ContextPath}/km/collaborate/resource/css/reply_edit.css" rel="stylesheet" type="text/css" />
	    <script>
		   seajs.use(['lui/jquery','lui/dialog'], function(_$, _dialog) {
	            $=_$;
	            dialog=_dialog;
	            //获取富文本狂内容
                window.RTF_GetContent = function(prop){
           		   var instance=CKEDITOR.instances[prop];
        		   if(instance){
        		        return instance.getData();
        		   }
        		        return "";
        		   };
	            //提交表单
                window.formSubmit = function(method){
                	var v=RTF_GetContent("fdContent");
                	if(v==null ||v=="") {
        				dialog.alert("${lfn:message('km-collaborate:kmCollaborateMainReply.contentValidate') }");
        				return;
        			}
                	if($("input[name='fdNotifyType']").val()=="" || $("input[name='fdNotifyType']").val()==null)
        			{
        				dialog.alert("${lfn:message('km-collaborate:kmCollaborateMainReply.fdNotifyTypeValidate') }");
        				return;
        			}
                	document.getElementsByName("fdContent")[0].value=v;
                	for(var i=0; i<Com_Parameter.event["confirm"].length; i++){
            			if(!Com_Parameter.event["confirm"][i]()){
            				return false;
            			}
            		}
		       			LUI.$.ajax({
		       				url: '${LUI_ContextPath}/km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do?method='+method,
		       				type: 'POST',
		       				dataType: 'json',
		       				async: false,
		       				data: $("#kmCollaborateMainReply").serialize(),
		       				success: function(data, textStatus, xhr) {
		       					if(data==true){
		       						dialog.success('<bean:message key="return.optSuccess" />');
		       						setTimeout(function(){$dialog.hide("success");}, 1500);
		       					}else{
		       						dialog.faiture('<bean:message key="return.optFailure" />');
		       						$dialog.hide("faiture");
		       					}
		       				}
		       			});
		       			return true;
                    
                   };
	      });
</script>
<center>
<html:form action="/km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do" styleId="kmCollaborateMainReply">
   <div id="Edit_div" class="collaborate_quickPost_read">
		<input type="hidden" name="fdCommunicationMainId" value="${param.mainId }"/>
		<input type="hidden" id="fdParentId"  name="fdParentId" value="${param.fdParentId!=null ? param.fdParentId :kmCollaborateMainReplyForm.fdParentId}" />
		<input type="hidden" id="fdId"  name="fdId"  value="${kmCollaborateMainReplyForm.fdId }" />
		<table  id="table_reply" class="tb_simple " width="100%">
			<tr>
			    <td class="td_user_img">
                        <%String fdId = UserUtil.getUser().getFdId();
                             request.setAttribute("imageUserId",fdId);%>
                        <img src="${ LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId=${imageUserId}" style="width: 60px;height: 60px" alt=""/>
                </td>
				<td>
					    <%
						  CKEditorConfig __config = new CKEditorConfig();
								__config.addConfigValue("smiley_height","325");
						%>  
						<kmss:editor property="fdContent"  width="100%" height="200px"  config="<%=__config %>"/>
						<input type="hidden" id="fdContent___Config" value="ToolbarStartExpanded=false">
				</td>
			</tr>
			<tr>
				<td></td>
			    <td style="text-align: left">  
				     <c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
						<c:param name="fdKey" value="replyAttachment" />
						<c:param name="fdModelId" value="${kmCollaborateMainReplyForm.fdId }" />
						<c:param name="fdModelName" value="com.landray.kmss.km.collaborate.model.KmCollaborateMainReply" />
					 </c:import>
					 <p class="p_upload"> </p>
			   </td>
			</tr>
			<tr>
			    <td></td>
				<td style="text-align: left">  
				    <c:if test="${param.method eq 'add'}">
					     <ui:button styleClass="com_bgcolor_n com_fontcolor_n com_bordercolor_n post_button" text="${lfn:message('button.submit')}" onclick="formSubmit('saveReplyOfReply');"/>
				    </c:if>
				    <c:if test="${param.method eq 'edit'}">
					     <ui:button styleClass="com_bgcolor_n com_fontcolor_n com_bordercolor_n post_button" text="${lfn:message('button.submit')}" onclick="formSubmit('updateReply');"/>
				    </c:if>
					
					<%request.setAttribute("replyNotifyType", new KmCollaborateConfig().getDefaultNotifyType());%>
					<span class="notify_div"><bean:message key="kmCollaborateMainReply.fdNotifyType" bundle="km-collaborate" />：</span>
					    <span style="padding-left: 7x">
					       	<c:if test="${param.method eq 'add'}">
					        	<kmss:editNotifyType property="fdNotifyType"  value="${replyNotifyType}"/>
					        </c:if>
					        <c:if test="${param.method eq 'edit'}">
					            <html:hidden property="fdNotifyType" value="${replyNotifyType}"/>
					        	<kmss:showNotifyType value="${replyNotifyType}"/>
					        </c:if>
					    </span>
				</td>
			</tr>
		</table>
	</div>
<html:hidden property="method_GET" />
</html:form>
</center>
	</template:replace>
</template:include>