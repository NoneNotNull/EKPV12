<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.landray.kmss.sys.attachment.util.JgWebOffice"%>
<%@page import="com.landray.kmss.km.imissive.util.KmImissiveConfigUtil"%>
<template:include ref="default.view"   sidebar="auto">
    <template:replace name="head">
		<link rel="Stylesheet" href="${LUI_ContextPath}/km/imissive/resource/css/att.css" />
	</template:replace>
	<template:replace name="title">
		<c:out value="${ kmImissiveReceiveMainForm.docSubject } - ${ lfn:message('km-imissive:module.km.imissive') }"></c:out>
	</template:replace>
	<template:replace name="toolbar">
<%
	//out.print(request.getHeader("User-Agent"));
	if(request.getHeader("User-Agent").toUpperCase().indexOf("MSIE")>-1){
		request.setAttribute("isIE",true);
	}else if(request.getHeader("User-Agent").toUpperCase().indexOf("TRIDENT")>-1){
		request.setAttribute("isIE",true);
	}else{
		request.setAttribute("isIE",false);
	}
%>
		<ui:toolbar  id="toolbar" layout="sys.ui.toolbar.float" count="5">
		<c:if test="${kmImissiveReceiveMainForm.docStatus!='10'}">
			<kmss:auth
				requestURL="/km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do?method=print&fdId=${param.fdId}"
				requestMethod="GET">
				<ui:button text="${lfn:message('button.print') }" order="4"
				     onclick="Com_OpenWindow('kmImissiveReceiveMain.do?method=print&fdId=${param.fdId}','_blank');">
			    </ui:button>
			</kmss:auth>
		</c:if>
		<c:if test="${kmImissiveReceiveMainForm.fdIsFiling != true}"> 
			<kmss:auth requestURL="/km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
				<c:if test="${kmImissiveReceiveMainForm.docStatus!='00' && kmImissiveReceiveMainForm.docStatus!='30'}">
				   <ui:button text="${lfn:message('button.edit') }" order="3"
				     onclick="Com_OpenWindow('kmImissiveReceiveMain.do?method=edit&fdId=${param.fdId}','_self');">
				   </ui:button>
				</c:if>
			</kmss:auth>
		<%-- 归档 --%>
		<c:if test="${kmImissiveReceiveMainForm.docStatus == '30' || kmImissiveReceiveMainForm.docStatus == '00'}">
		    <kmss:auth requestURL="/km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do?method=filing&fdId=${param.fdId}" requestMethod="GET">
		        <ui:button text="${lfn:message('km-imissive:button.filing') }" order="4"
				     onclick="filingDoc();">
				</ui:button>
			</kmss:auth>
		</c:if>
		<c:if test="${kmImissiveReceiveMainForm.docStatus == '30'}">
		  <kmss:auth requestURL="/km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do?method=changeReceive&fdId=${param.fdId}" requestMethod="GET">
			 <ui:button text="转发文" order="4"
					     onclick="changeToSend();">
			</ui:button>
			<ui:button text="转收文" order="4"
					     onclick="changeToReceive();">
			</ui:button>
		  </kmss:auth>
	    </c:if>
	  </c:if>
		<kmss:auth requestURL="/km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
		    <ui:button text="${lfn:message('button.delete') }" order="4"
			     onclick="Delete();">
		    </ui:button>
		</kmss:auth>
		<ui:button text="${lfn:message('button.close')}" order="5" onclick="Com_CloseWindow();">
		</ui:button>
		</ui:toolbar>
	</template:replace>
	<template:replace name="path">
	  <ui:menu layout="sys.ui.menu.nav"  id="categoryId"> 
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home"></ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-imissive:module.km.imissive') }" href="/km/imissive/" target="_self"></ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-imissive:kmImissive.nav.ReceiveManagement') }" href="/km/imissive/km_imissive_receive_main/index.jsp" target="_self"></ui:menu-item>
			<ui:menu-source autoFetch="false"
			               target="_self" 
						   href="/km/imissive/km_imissive_receive_main/index.jsp#cri.q=fdTemplate:${kmImissiveReceiveMainForm.fdTemplateId}">
				<ui:source type="AjaxJson">
					{"url":"/sys/category/criteria/sysCategoryCriteria.do?method=path&modelName=com.landray.kmss.km.imissive.model.KmImissiveReceiveTemplate&categoryId=${kmImissiveReceiveMainForm.fdTemplateId}"} 
				</ui:source>
			</ui:menu-source>
		</ui:menu>
	</template:replace>	
    <template:replace name="content"> 
   <c:if test="${kmImissiveReceiveMainForm.fdReceiveStatus != '10' && kmImissiveReceiveMainForm.fdReceiveStatus != '00'}">									
		<c:if test="${kmImissiveReceiveMainForm.docStatus=='20'}">
			<kmss:auth requestURL="/km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
				<c:set var="editStatus" value="true"/>
			</kmss:auth>
			<c:if  test="${kmImissiveReceiveMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.editDocContent =='true'}">
			<c:set var="editStatus" value="true"/>
		</c:if>
		</c:if>					
	</c:if>
	<script>
	seajs.use(['sys/ui/js/dialog'], function(dialog) {
		window.dialog=dialog;
	});
	window.changeToSend = function(){
		 Dialog_Tree(false, 'fdSendtempId', 'fdSendtempName', ',', 
	             'kmImissiveCfgTreeService&type=RS&fdReceiveId=${kmImissiveReceiveMainForm.fdId}','发文模板',null, function(){
	            	 var idString = document.getElementsByName("fdSendtempId")[0].value;
		             if(idString!=""){
		            	 var idArray = idString.split(";");
			             var fdTemplateId = idArray[0];
			             var fdCfgId =idArray[1];
			             var url = "${LUI_ContextPath}/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=addSend&fdTemplateId="+fdTemplateId+"&fdCfgId="+fdCfgId+"&fdReceiveId=${kmImissiveReceiveMainForm.fdId}";
			             Com_OpenWindow(url, "_self");
		             }
			       }, '', false, true);
   };
	window.changeToReceive = function(){
		 Dialog_Tree(false, 'fdReceivetempId', 'fdReceivetempName', ',', 
	             'kmImissiveCfgTreeService&type=RR&fdReceiveId=${kmImissiveReceiveMainForm.fdId}','收文模板',null, function(){
	            	 var idString = document.getElementsByName("fdReceivetempId")[0].value;
		             if(idString!=""){
		            	 var idArray = idString.split(";");
			             var fdTemplateId = idArray[0];
			             var fdCfgId =idArray[1];
			             var url = "${LUI_ContextPath}/km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do?method=addReceive&fdTemplateId="+fdTemplateId+"&fdCfgId="+fdCfgId+"&fdReceiveId=${kmImissiveReceiveMainForm.fdId}";
			             Com_OpenWindow(url, "_self");
		             }
			       }, '', false, true);
   };
	function Delete(){
    	dialog.confirm("${lfn:message('page.comfirmDelete')}",function(flag){
	    	if(flag==true){
	    		Com_OpenWindow('kmImissiveReceiveMain.do?method=delete&fdId=${param.fdId}','_self');
	    	}else{
	    		return false;
		    }
	    },"warn");
    }

	window.updateSign = function(){
		dialog.confirm("确定签收？",function(flag){
			//异步保存签收
			if(flag==true){
				var url="${KMSS_Parameter_ContextPath}km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do?method=updateSign"; 
				 $.ajax({     
		    	     type:"post",     
		    	     url:url,     
		    	     data:{fdId:"${kmImissiveReceiveMainForm.fdId}"},    
		    	     async:false,    //用同步方式 
		    	     success:function(data){
		    	    	 dialog.categoryForNewFile(
									'com.landray.kmss.km.imissive.model.KmImissiveReceiveTemplate',
									'/km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do?method=reload&fdTemplateId=!{id}&fdId=${kmImissiveReceiveMainForm.fdId}',false,null,null,null,"_self",true,true);
		    		}    
		        });
			}else{
				return;
			}
			
		},"warn");
	};
    
		function filingDoc() {
			seajs.use(['sys/ui/js/dialog'],
					function(dialog) {
			    	dialog.confirm("${lfn:message('km-imissive:alert.filing.msg')}",function(flag){
				    	if(flag==true){
				    		Com_OpenWindow('kmImissiveReceiveMain.do?method=filing&fdId=${param.fdId}','_self');
				    	}else{
				    		return;
					    }
				  },"warn");
			});
		}
		//解决非ie下控件高度问题
		window.onload = function(){
			var obj = document.getElementById("JGWebOffice_editonline");
			if(obj){
				obj.setAttribute("height", 550);
			}
		};
	</script>
	 <html:form action="/km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do"> 
		<div class="lui_form_content_frame" style="padding-top:10px">
		   <!-- 发文转过来的收文没有表单模板，用默认的查看页面查看 -->
		   <c:import url="/sys/xform/include/sysForm_view.jsp"	charEncoding="UTF-8">
				<c:param name="formName" value="kmImissiveReceiveMainForm" />
				<c:param name="fdKey" value="receiveMainDoc" />
				<c:param name="messageKey" value="km-imissive:kmImissiveSendMain.baseinfo"/>
				<c:param name="useTab" value="false"/>
			</c:import>
		</div>
		<c:if test="${kmImissiveReceiveMainForm.fdNeedContent=='0'}">
		<div class="lui_form_content_frame" style="padding-top:10px">
			<c:if test="${not empty kmImissiveReceiveMainForm.attachmentForms['mainonline'].attachments}">
				<div class="lui_form_spacing"></div>
				<div>
					<div class="lui_form_subhead"><img src="${KMSS_Parameter_ContextPath}sys/attachment/view/img/attachment.png">正文附件</div>
					<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
						<c:param name="formBeanName" value="kmImissiveReceiveMainForm" />
						<c:param name="fdKey" value="mainonline" />
						<c:param name="fdModelId" value="${param.fdId}" />
						<c:param name="fdModelName" value="com.landray.kmss.km.imissive.model.KmImissiveReceiveMain" />
					</c:import>
				</div> 
			</c:if>
		</div>
		</c:if>
		<div class="lui_form_content_frame" style="padding-top:10px">
			<c:if test="${not empty kmImissiveReceiveMainForm.attachmentForms['attachment'].attachments}">
				<div class="lui_form_spacing"></div> 
				<div>
					<div class="lui_form_subhead"><img src="${KMSS_Parameter_ContextPath}sys/attachment/view/img/attachment.png"> ${ lfn:message('sys-doc:sysDocBaseInfo.docAttachments') }(${fn:length(kmImissiveReceiveMainForm.attachmentForms['attachment'].attachments)})</div>
					<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
								charEncoding="UTF-8">
						<c:param name="formBeanName" value="kmImissiveReceiveMainForm" />
						<c:param name="fdKey" value="attachment" />
					</c:import>
				</div> 
			</c:if>
		</div>
		<ui:tabpage expand="false"> 
		<input type="hidden" name="fdSendtempId"/>
		<input type="hidden" name="fdSendtempName"/>
		<input type="hidden" name="fdReceivetempId"/>
		<input type="hidden" name="fdReceivetempName"/>
		<c:if test="${kmImissiveReceiveMainForm.fdNeedContent=='1'}">
		<ui:content title="正文" expand="false">
		<table class="tb_normal" width="100%">
		   <tr>
				<td colspan="4">
				 <div id="missiveButtonDiv" style="text-align:right;padding-bottom:5px">&nbsp;
				 <c:if test="${editStatus != true}">
				     <%if(JgWebOffice.isJGEnabled()&&Boolean.parseBoolean(KmImissiveConfigUtil.isShowImg())){ %>
						<c:choose>
						  <c:when test="${isIE}">
						     <a href="javascript:void(0);" class="attswich com_btn_link"
								onclick="Com_OpenWindow('kmImissiveReceiveMain.do?method=view&fdId=${param.fdId}&isShowImg=${isShowImg}','_self');">
							   ${lfn:message('km-imissive:missive.button.change.view')}
							 </a>
						 </c:when>
						 <c:otherwise>
						  <%if(JgWebOffice.isJGMULEnabled()){%>
							   <a href="javascript:void(0);" class="attswich com_btn_link"
								onclick="Com_OpenWindow('kmImissiveReceiveMain.do?method=view&fdId=${param.fdId}&isShowImg=${isShowImg}','_self');">
							   ${lfn:message('km-imissive:missive.button.change.view')}
							   </a>
						    <%} %>
						 </c:otherwise>
						</c:choose>
					<%} %>
				</c:if>
		         </div>
					 <c:if test="${editStatus == true}">
						<%
							// 金格启用模式
							if(com.landray.kmss.sys.attachment.util.JgWebOffice.isJGEnabled()) {
								pageContext.setAttribute("sysAttMainUrl", "/sys/attachment/sys_att_main/jg/sysAttMain_edit.jsp");
							}
						%>
						<c:import url="${sysAttMainUrl}" charEncoding="UTF-8">
							<c:param
								name="fdKey"
								value="editonline" />
							<c:param
								name="fdAttType"
								value="office" />
							<c:param 
								name="fdMulti" 
								value="false" />
							<c:param
								name="fdModelId"
								value="${param.fdId}" />
							<c:param
								name="fdModelName"
								value="com.landray.kmss.km.imissive.model.KmImissiveReceiveMain" />
							<c:param
								name="formBeanName"
								value="kmImissiveReceiveMainForm" />
							<c:param name="buttonDiv" value="missiveButtonDiv" />
							<c:param name="isToImg" value="<%=KmImissiveConfigUtil.isShowImg()%>"/>
							<c:param  name="bookMarks" 
								value="docsubject:${kmImissiveReceiveMainForm.docSubject},doctype:${kmImissiveReceiveMainForm.fdDocTypeName},sendunit:${kmImissiveReceiveMainForm.fdSendtoUnitName},docnum:${kmImissiveReceiveMainForm.fdDocNum},receivenum:${kmImissiveReceiveMainForm.fdReceiveDocNum},secretgrade:${kmImissiveReceiveMainForm.fdSecretGradeName},emergency:${kmImissiveReceiveMainForm.fdEmergencyGradeName},signer:${kmImissiveReceiveMainForm.fdSignerName},signtime:${kmImissiveReceiveMainForm.fdSignTime},recorder:${kmImissiveReceiveMainForm.fdRecorderName},recordtime:${kmImissiveReceiveMainForm.fdRecordTime},receivetime:${kmImissiveReceiveMainForm.fdReceiveTime},receivetunit:${kmImissiveReceiveMainForm.fdReceiveUnitName}${kmImissiveReceiveMainForm.fdOutSendto},shareNum:${kmImissiveReceiveMainForm.fdShareNum},content:${kmImissiveReceiveMainForm.fdContent}"/>
							</c:import>
					 </c:if>
					   <c:if test="${editStatus != true}">
						<%
							// 金格启用模式
							if(com.landray.kmss.sys.attachment.util.JgWebOffice.isJGEnabled()) {
								pageContext.setAttribute("sysAttMainUrl", "/sys/attachment/sys_att_main/jg/sysAttMain_include_viewHtml.jsp");
							}
						%>
						<c:import url="${sysAttMainUrl}" charEncoding="UTF-8">
							<c:param
								name="fdKey"
								value="editonline" />
							<c:param
								name="fdAttType"
								value="office" />
							<c:param 
								name="fdMulti" 
								value="false" />
							<c:param
								name="fdModelId"
								value="${param.fdId}" />
							<c:param
								name="fdModelName"
								value="com.landray.kmss.km.imissive.model.KmImissiveReceiveMain" />
							<c:param
								name="formBeanName"
								value="kmImissiveReceiveMainForm" />
							<c:param name="isShowImg" value="${isShowImg}"/>
							<c:param name="buttonDiv" value="missiveButtonDiv" />
							<c:param
								name="bookMarks"
								value="docsubject:${kmImissiveReceiveMainForm.docSubject},doctype:${kmImissiveReceiveMainForm.fdDocTypeName},sendunit:${kmImissiveReceiveMainForm.fdSendtoUnitName},docnum:${kmImissiveReceiveMainForm.fdDocNum},receivenum:${kmImissiveReceiveMainForm.fdReceiveDocNum},secretgrade:${kmImissiveReceiveMainForm.fdSecretGradeName},emergency:${kmImissiveReceiveMainForm.fdEmergencyGradeName},signer:${kmImissiveReceiveMainForm.fdSignerName},signtime:${kmImissiveReceiveMainForm.fdSignTime},recorder:${kmImissiveReceiveMainForm.fdRecorderName},recordtime:${kmImissiveReceiveMainForm.fdRecordTime},receivetime:${kmImissiveReceiveMainForm.fdReceiveTime},receivetunit:${kmImissiveReceiveMainForm.fdReceiveUnitName}${kmImissiveReceiveMainForm.fdOutSendto},shareNum:${kmImissiveReceiveMainForm.fdShareNum},content:${kmImissiveReceiveMainForm.fdContent}" />
						</c:import>		
						</c:if>					
				</td>
			</tr>
		</table>
		</ui:content>
		</c:if>
		<c:import url="/sys/bookmark/import/bookmark_bar.jsp"
			charEncoding="UTF-8">
			<c:param name="fdSubject" value="${kmImissiveReceiveMainForm.docSubject}" />
			<c:param name="fdModelId" value="${kmImissiveReceiveMainForm.fdId}" />
			<c:param name="fdModelName"
				value="com.landray.kmss.km.imissive.model.KmImissiveReceiveMain" />
		</c:import>
		<!-- 以下代码为嵌入流程模板标签的代码 -->
		<kmss:auth requestURL="/km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do?method=readViewLog&fdId=${param.fdId}" requestMethod="GET">
		<c:import url="/sys/workflow/import/sysWfProcess_view.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmImissiveReceiveMainForm" />
			<c:param name="fdKey" value="receiveMainDoc" />
			<c:param name="showHistoryOpers" value="true" />
			<c:param name="isSimpleWorkflow" value="false" />
			<c:param name="onClickSubmitButton" value="Com_Submit(document.kmImissiveReceiveMainForm, 'approveReceive');" />
			<c:param name="isExpand" value="false" />
		</c:import>
		</kmss:auth>
		<!-- 以上代码为嵌入流程模板标签的代码 -->
		<!-- 阅读机制 -->
		<c:import
			url="/sys/readlog/import/sysReadLog_view.jsp"
			charEncoding="UTF-8">
			<c:param
				name="formName"
				value="kmImissiveReceiveMainForm" />
		</c:import>
		<!-- 阅读机制 -->
		<!-- -----------------------------------------传阅------------------------------------------------------------ -->
		<c:import
			url="/sys/circulation/import/sysCirculationMain_view.jsp"
			charEncoding="UTF-8">
			<c:param
				name="formName"
				value="kmImissiveReceiveMainForm" />
		</c:import>
		<!-- -----------------------------------------传阅完------------------------------------------------------------ -->
		<!-- 发布机制开始 -->
		<c:import url="/sys/news/import/sysNewsPublishMain_view.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmImissiveReceiveMainForm" />
			<c:param name="fdKey" value="receiveMainDoc" />
		</c:import>
		<!-- 发布机制结束 -->
		<!-- 权限机制-->
		<ui:content title="${ lfn:message('sys-right:right.moduleName') }">
			<table class="tb_normal" width=100%>
				<tr>
					<td class="td_normal_title" width="15%">审批意见可阅读者</td>
					<td width="85%" colspan='3'>
						<c:if test="${empty kmImissiveReceiveMainForm.authAppRecReaderNames}">
							<bean:message bundle="sys-right" key="right.other.person" />
						</c:if>
						<c:if test="${not empty kmImissiveReceiveMainForm.authAppRecReaderNames}">
							<c:out value="${kmImissiveReceiveMainForm.authAppRecReaderNames}"></c:out>
						</c:if>
					</td>
				</tr>
				<c:import url="/sys/right/right_view.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmImissiveReceiveMainForm" />
					<c:param name="moduleModelName" value="com.landray.kmss.km.imissive.model.KmImissiveReceiveMain" />
				</c:import>
			</table>
		</ui:content>
	    <!-- 权限机制 -->
	</ui:tabpage>
	</html:form>
    </template:replace>
 <template:replace name="nav">
		<%--关联机制 --%>
		<c:import url="/sys/relation/import/sysRelationMain_view.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="kmImissiveReceiveMainForm" />
		</c:import>
	    <!-- 关联机制 -->
</template:replace>
</template:include>
