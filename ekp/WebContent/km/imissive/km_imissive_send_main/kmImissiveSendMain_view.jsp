<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.sys.attachment.util.JgWebOffice"%>
<%@page import="com.landray.kmss.km.imissive.util.KmImissiveConfigUtil"%>
<%@page import="com.landray.kmss.km.imissive.forms.KmImissiveSendMainForm"%>
<%@ page import="com.landray.kmss.util.IDGenerator"%>
<template:include ref="default.view"   sidebar="auto"> 
	<template:replace name="head">
		<link rel="Stylesheet" href="${LUI_ContextPath}/km/imissive/resource/css/att.css" />
	</template:replace>
	<template:replace name="title">
		<c:out value="${ kmImissiveSendMainForm.docSubject } - ${ lfn:message('km-imissive:module.km.imissive') }"></c:out> 
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
<script>
//解决非ie下控件高度问题
window.onload = function(){
	var obj = document.getElementById("JGWebOffice_editonline");
	if(obj){
		obj.setAttribute("height", 550);
	}
};
	seajs.use(['sys/ui/js/dialog'], function(dialog) {
		window.editDocNum = function(){
			var url = Com_GetCurDnsHost()+Com_Parameter.ContextPath+'km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=editDocNum&fdId=${param.fdId}';
		    dialog.iframe(url,"修改文号",function(rtn){
		    	 if(rtn!=null&&rtn!="cancel"){
		    	    location.reload();
		    	 }
			  },{width:500,height:300});
		},
		window.distribute = function(){
			var url = Com_GetCurDnsHost()+Com_Parameter.ContextPath+'km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=distribute&fdId=${param.fdId}';
		    dialog.iframe(url,"公文分发",function(rtn){
		    	 if(rtn!=null&&rtn!="cancel"){
		    	    location.reload();
		    	 }
			  },{width:700,height:450});
		},
		window.report = function(){
			var url = Com_GetCurDnsHost()+Com_Parameter.ContextPath+'km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=report&fdId=${param.fdId}';
		    dialog.iframe(url,"公文上报",function(rtn){
		    	 if(rtn!=null&&rtn!="cancel"){
		    	    location.reload();
		    	 }
			  },{width:700,height:450});
		},
		window.changeSign = function(){
			var url= Com_GetCurDnsHost()+Com_Parameter.ContextPath+"km/imissive/km_imissive_regdetail_list/kmImissiveRegDetailList.do?method=list&deliver=true&fdMainId=${kmImissiveSendMainForm.fdId}&type=3";
			var waitSign = document.getElementsByName("waitSignS")[0];
			var signed = document.getElementsByName("signedS")[0];
			if(waitSign.checked){
				url += "&waitSign=true";
			}
			if(signed.checked){
				url += "&signed=true ";
			}
			LUI('sign').source.setUrl(url);
			LUI('sign').source.get();
		},
		window.changeDistribute = function(){
			var url= Com_GetCurDnsHost()+Com_Parameter.ContextPath+"km/imissive/km_imissive_regdetail_list/kmImissiveRegDetailList.do?method=list&deliver=true&fdMainId=${kmImissiveSendMainForm.fdId}&type=1";
			var waitSign = document.getElementsByName("waitSignD")[0];
			var signed = document.getElementsByName("signedD")[0];
			if(waitSign.checked){
				url += "&waitSign=true";
			}
			if(signed.checked){
				url += "&signed=true ";
			}
			LUI('distribute').source.setUrl(url);
			LUI('distribute').source.get();
		},
		window.changeReport = function(){
			var url= Com_GetCurDnsHost()+Com_Parameter.ContextPath+"km/imissive/km_imissive_regdetail_list/kmImissiveRegDetailList.do?method=list&deliver=true&fdMainId=${kmImissiveSendMainForm.fdId}&type=2";
			var waitSign = document.getElementsByName("waitSignR")[0];
			var signed = document.getElementsByName("signedR")[0];
			if(waitSign.checked){
				url += "&waitSign=true";
			}
			if(signed.checked){
				url += "&signed=true ";
			}
			LUI('report').source.setUrl(url);
			LUI('report').source.get();
		},
		
		window.urgeSign = function(type){
		  var url="${KMSS_Parameter_ContextPath}km/imissive/km_imissive_regdetail_list/kmImissiveRegDetailList.do?method=urgeSign";
		  var values = [];
			$("input[name='"+type+"']:checked").each(function(){
					values.push($(this).val());
			});
			if(values.length==0){
				dialog.alert('<bean:message key="page.noSelect"/>');
				return;
			}
			$.post(url,$.param({"List_Selected":values},true),function(data){
				if(data.flag=="true"){
					dialog.alert('催办成功');
				}else{
					dialog.alert('催办失败');
				}
			},'json');
		},
		window.Delete =function(){
	    	dialog.confirm("${lfn:message('page.comfirmDelete')}",function(flag){
		    	if(flag==true){
		    		Com_OpenWindow('kmImissiveSendMain.do?method=delete&fdId=${param.fdId}','_self');
		    	}else{
		    		return false;
			    }
		    },"warn");
	   },
	   window.filingDoc= function() {
	    	dialog.confirm("${lfn:message('km-imissive:alert.filing.msg')}",function(flag){
		    	if(flag==true){
		    		Com_OpenWindow('kmImissiveSendMain.do?method=filing&fdId=${param.fdId}','_self');
		    	}else{
		    		return;
			    }
		  },"warn");  
		}
	});
</script>

	<ui:toolbar  id="toolbar" layout="sys.ui.toolbar.float" count="5">
		<c:if test="${kmImissiveSendMainForm.fdIsFiling != true}">
			<kmss:auth requestURL="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
				<c:if test="${(kmImissiveSendMainForm.docStatus!='00' && kmImissiveSendMainForm.docStatus!='30') || (kmImissiveSendMainForm.docStatus == '30' && kmImissiveSendMainForm.fdReportStatus == '20') }">
					<ui:button text="${lfn:message('button.edit') }" order="4" 
					onclick="Com_OpenWindow('kmImissiveSendMain.do?method=edit&fdId=${param.fdId}&fdTemplateId=${kmImissiveSendMainForm.fdTemplateId}','_self');">
				    </ui:button>
				</c:if>
			</kmss:auth>
			<c:if test="${kmImissiveSendMainForm.docStatus=='30' and kmImissiveSendMainForm.fdIsFiling!= true}">
			<kmss:auth requestURL="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=editDocNum&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${lfn:message('km-imissive:kmImissiveSendMain.editdocnum') }" order="4" 
				onclick="editDocNum();">
			    </ui:button>
			</kmss:auth>
			<c:if test="${kmImissiveSendMainForm.fdMissiveType !=  '2'}">
			<kmss:auth requestURL="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=distribute&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${lfn:message('km-imissive:kmImissiveSendMain.distribute') }" order="4" 
				 onclick="distribute();">
			    </ui:button>
			</kmss:auth>
			</c:if>
			<c:if test="${kmImissiveSendMainForm.fdMissiveType != '1'}">
			<kmss:auth requestURL="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=report&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${lfn:message('km-imissive:kmImissiveSendMain.report') }" order="4" 
				 onclick="report();">
			    </ui:button>
			</kmss:auth>
			</c:if>
			</c:if>
			<c:if test="${kmImissiveSendMainForm.docStatus =='20'}">
			<%-- 文件编号附加选项 --%>
			<c:if  test="${kmImissiveSendMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.modifyDocNum =='true'}">
			    <ui:button text="${lfn:message('km-imissive:kmImissive.modifyDocNum') }" order="3"
					 onclick="generateFileNum();">
				</ui:button>
			</c:if>
			<%-- 清稿附加选项 --%>
			<c:if  test="${kmImissiveSendMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.cleardraft =='true'}">
			    <ui:button text="${lfn:message('km-imissive:kmImissiveSendMain.cleardraft') }" order="3" 
					 onclick="cleardraft();">
				</ui:button>
			</c:if>
			<%-- 套红附加选项 --%>
			<c:if  test="${kmImissiveSendMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.redhead =='true'}">
			   <ui:button text="${lfn:message('km-imissive:kmImissive.redhead') }" order="2"
			     onclick="LoadHeadWordList('com.landray.kmss.km.imissive.model.KmImissiveSendMain');">
			   </ui:button>
			</c:if>
			<!-- 签章附加选项 -->
			<kmss:ifModuleExist path="/km/signature/">
			<c:if test="${kmImissiveSendMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.sigzq =='true'}">
				<ui:button text="${lfn:message('km-imissive:kmImissive.sigzq') }" order="2" onclick="WebOpenSignature();">
				</ui:button>
			</c:if>
			</kmss:ifModuleExist>
			</c:if>
			<%-- 归档 --%>
			<c:if test="${kmImissiveSendMainForm.docStatus == '30' || kmImissiveSendMainForm.docStatus == '00'}">
			<kmss:auth
				requestURL="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=filing&fdId=${param.fdId}"
				requestMethod="GET">
				<ui:button text="${lfn:message('km-imissive:button.filing') }" order="4" onclick="filingDoc();">
			    </ui:button>
			</kmss:auth>
			</c:if>
		</c:if>
		<c:if test="${kmImissiveSendMainForm.docStatus!='10'}">
				<kmss:auth
					requestURL="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=print&fdId=${param.fdId}"
					requestMethod="GET">
					<ui:button text="${lfn:message('button.print') }" order="4" 
					 onclick="Com_OpenWindow('kmImissiveSendMain.do?method=print&fdId=${param.fdId}','_blank');">
				    </ui:button>
				</kmss:auth>
		</c:if>
		<c:if test="${kmImissiveSendMainForm.fdDistributeTime == null and kmImissiveSendMainForm.fdReportTime == null}">
			<kmss:auth requestURL="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			   <ui:button text="${lfn:message('button.delete') }" order="4"
			     onclick="Delete();">
			   </ui:button>
			</kmss:auth>
		</c:if>
		<ui:button text="${lfn:message('button.close')}" order="5" onclick="Com_CloseWindow();">
		</ui:button>
		</ui:toolbar>
	</template:replace>
	<template:replace name="path">
	   <ui:menu layout="sys.ui.menu.nav"  id="categoryId"> 
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home"></ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-imissive:module.km.imissive') }" href="/km/imissive/" target="_self"></ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-imissive:kmImissive.nav.SendManagement') }" href="/km/imissive/" target="_self"></ui:menu-item>
			<ui:menu-source autoFetch="false"
			            target="_self" 
						href="/km/imissive/index.jsp#cri.q=fdTemplate:${kmImissiveSendMainForm.fdTemplateId}">
				<ui:source type="AjaxJson">
					{"url":"/sys/category/criteria/sysCategoryCriteria.do?method=path&modelName=com.landray.kmss.km.imissive.model.KmImissiveSendTemplate&categoryId=${kmImissiveSendMainForm.fdTemplateId}"} 
				</ui:source>
			</ui:menu-source>
		</ui:menu>
	</template:replace>	
	<template:replace name="content">
	   <c:if test="${kmImissiveSendMainForm.docStatus == '20'}">
			<kmss:auth requestURL="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">							
				<c:set var="editStatus" value="true"/>						
			</kmss:auth>
			<%--编辑正文 --%>
			<c:if  test="${kmImissiveSendMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.editDocContent =='true'}">
				<c:set var="editStatus" value="true"/>
			</c:if>
			<%--签章 --%>
			<c:if  test="${kmImissiveSendMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.sigzq =='true'}">
				<c:set var="editStatus" value="true"/>
			</c:if>
			<%--套红 --%>
			<c:if  test="${kmImissiveSendMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.redhead =='true'}">
				<c:set var="editStatus" value="true"/>
			</c:if>
			<%--清稿 --%>
			<c:if  test="${kmImissiveSendMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.cleardraft =='true'}">
			   <c:set var="editStatus" value="true"/>
			</c:if>
			<%--不强制留痕--%>
			<c:if  test="${kmImissiveSendMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.forceRevisions =='true' and editStatus == true}">
			   <c:set var="forceRevisions" value="false"/>
			</c:if>
		</c:if>
		<c:if test="${editStatus == true or !isShowImg}">
		    <c:set var="expandContent" value="true"/>
		</c:if>
	    <html:form action="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do"> 
	    <div class="lui_form_content_frame" style="padding-top:10px">
	       <kmss:showWfPropertyValues  var="nodevalue" idValue="${kmImissiveSendMainForm.fdId}" propertyName="nodeName" />
		   <c:import url="/sys/xform/include/sysForm_view.jsp"	charEncoding="UTF-8">
				<c:param name="formName" value="kmImissiveSendMainForm" />
				<c:param name="fdKey" value="sendMainDoc" />
				<c:param name="messageKey" value="km-imissive:kmImissiveSendMain.baseinfo"/>
				<c:param name="useTab" value="false"/>
			</c:import>
		</div>
		<div class="lui_form_content_frame" style="padding-top:10px">
			<c:if test="${not empty kmImissiveSendMainForm.attachmentForms['attachment'].attachments}">
				<div class="lui_form_spacing"></div> 
				<div>
					<div class="lui_form_subhead"><img src="${KMSS_Parameter_ContextPath}sys/attachment/view/img/attachment.png"> ${ lfn:message('sys-doc:sysDocBaseInfo.docAttachments') }(${fn:length(kmImissiveSendMainForm.attachmentForms['attachment'].attachments)})</div>
					<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
								charEncoding="UTF-8">
						<c:param name="formBeanName" value="kmImissiveSendMainForm" />
						<c:param name="fdKey" value="attachment" />
					</c:import>
				</div> 	
			</c:if>
		</div>
		<ui:tabpage expand="false">
		 <!-- 页签打开时再加载金格控件 -->
		<ui:content title="正文" expand="${expandContent}">
			<%-- --套红头 -- --%>
			<%@ include file="/km/imissive/kmImissiveRedhead_script.jsp"%>
			<%@ include file="/km/imissive/km_imissive_send_main/kmImissiveSendRedhead_script.jsp"%>
			<table class="tb_normal" width="100%">
				<!-- 提示信息 -->
			<%if(com.landray.kmss.sys.attachment.util.JgWebOffice.isJGEnabled()){%>
			   <c:if test="${isShowImg&&kmImissiveSendMainForm.docStatus!='20'}">
				   <tr>
				        <td class="td_normal_title" width=15%>
							<bean:message  bundle="km-imissive" key="kmMissiveMain.prompt.title"/>
						</td>
				     	<td colspan="3">
				     	  <font style="text-align:center"><bean:message  bundle="km-imissive" key="kmMissiveMain.prompt"/></font>
				        </td>
				   </tr>
			  </c:if>
			<%}%>
				<tr>
					<td colspan="4">
					    <div id="missiveButtonDiv" style="text-align:right;padding-bottom:5px">&nbsp;
					    <c:if test="${editStatus != true}">
						     <%if(JgWebOffice.isJGEnabled()&&Boolean.parseBoolean(KmImissiveConfigUtil.isShowImg())){ %>
								<c:choose>
								  <c:when test="${isIE}">
								     <a href="javascript:void(0);" class="attswich com_btn_link"
										onclick="Com_OpenWindow('kmImissiveSendMain.do?method=view&fdId=${param.fdId}&isShowImg=${isShowImg}','_self');">
									   ${lfn:message('km-imissive:missive.button.change.view') }
									 </a>
								 </c:when>
								 <c:otherwise>
								  <%if(JgWebOffice.isJGMULEnabled()){%>
									   <a href="javascript:void(0);" class="attswich com_btn_link"
										onclick="Com_OpenWindow('kmImissiveSendMain.do?method=view&fdId=${param.fdId}&isShowImg=${isShowImg}','_self');">
									   ${lfn:message('km-imissive:missive.button.change.view') }
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
									name="fdModelId"
									value="${kmImissiveSendMainForm.fdId}" />
								<c:param
									name="fdModelName"
									value="com.landray.kmss.km.imissive.model.KmImissiveSendMain" />
								<c:param
									name="formBeanName"
									value="kmImissiveSendMainForm" />
								<c:param 
									name="bookMarks" 
									value="docsubject:${kmImissiveSendMainForm.docSubject},doctype:${kmImissiveSendMainForm.fdDocTypeName},sendunit:${kmImissiveSendMainForm.fdSendtoUnitName},docnum:${kmImissiveSendMainForm.fdDocNum},secretgrade:${kmImissiveSendMainForm.fdSecretGradeName},checker:${kmImissiveSendMainForm.fdCheckerName},emergency:${kmImissiveSendMainForm.fdEmergencyGradeName},signature:${kmImissiveSendMainForm.fdSignatureName},draftunit:${kmImissiveSendMainForm.fdDraftUnitName},drafter:${kmImissiveSendMainForm.fdDrafterName},drafttime:${kmImissiveSendMainForm.fdDraftTime},content:${kmImissiveSendMainForm.fdContent},signdatecn:${kmImissiveSendMainForm.docPublishTimeUpper},signdate:${kmImissiveSendMainForm.docPublishTimeNum},printnum:${kmImissiveSendMainForm.fdPrintNum},printpagenum:${kmImissiveSendMainForm.fdPrintPageNum},copytounit:${kmImissiveSendMainForm.fdCopytoNames},maintounit:${kmImissiveSendMainForm.fdMaintoNames},reporttounit:${kmImissiveSendMainForm.fdReporttoNames}" />
								<c:param name="isToImg" value="false"/>
								<c:param name="buttonDiv" value="missiveButtonDiv" />
								<c:param name="forceRevisions" value="${forceRevisions}"/>
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
									name="fdModelId"
									value="${kmImissiveSendMainForm.fdId}" />
								<c:param
									name="fdModelName"
									value="com.landray.kmss.km.imissive.model.KmImissiveSendMain" />
								<c:param
									name="formBeanName"
									value="kmImissiveSendMainForm" />
								<c:param 
									name="bookMarks" 
									value="docsubject:${kmImissiveSendMainForm.docSubject},doctype:${kmImissiveSendMainForm.fdDocTypeName},sendunit:${kmImissiveSendMainForm.fdSendtoUnitName},docnum:${kmImissiveSendMainForm.fdDocNum},secretgrade:${kmImissiveSendMainForm.fdSecretGradeName},checker:${kmImissiveSendMainForm.fdCheckerName},emergency:${kmImissiveSendMainForm.fdEmergencyGradeName},signature:${kmImissiveSendMainForm.fdSignatureName},draftunit:${kmImissiveSendMainForm.fdDraftUnitName},drafter:${kmImissiveSendMainForm.fdDrafterName},drafttime:${kmImissiveSendMainForm.fdDraftTime},content:${kmImissiveSendMainForm.fdContent},signdatecn:${kmImissiveSendMainForm.docPublishTimeUpper},signdate:${kmImissiveSendMainForm.docPublishTimeNum},printnum:${kmImissiveSendMainForm.fdPrintNum},printpagenum:${kmImissiveSendMainForm.fdPrintPageNum},copytounit:${kmImissiveSendMainForm.fdCopytoNames},maintounit:${kmImissiveSendMainForm.fdMaintoNames},reporttounit:${kmImissiveSendMainForm.fdReporttoNames}" />
							  <c:param name="isShowImg" value="${isShowImg}"/>
							  <c:param name="buttonDiv" value="missiveButtonDiv" />
							</c:import>
						</c:if>
					</td>
				</tr>
			  </table>
		</ui:content>
	<!-- 以下代码为嵌入流程模板标签的代码 -->
	<kmss:auth requestURL="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=readViewLog&fdId=${param.fdId}" requestMethod="GET">
		<c:import url="/sys/workflow/import/sysWfProcess_view.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmImissiveSendMainForm" />
			<c:param name="fdKey" value="sendMainDoc" />
			<c:param name="showHistoryOpers" value="true" />
			<c:param name="isSimpleWorkflow" value="false" />
			<c:param name="onClickSubmitButton" value="Com_Submit(document.kmImissiveSendMainForm, 'approveSend');" />
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
			value="kmImissiveSendMainForm" />
	</c:import>
	<!-- 阅读机制 -->
	<ui:content title="发文跟踪">
<link type="text/css" rel="stylesheet" href="${LUI_ContextPath}/km/imissive/resource/css/jquery.qtip.css" />
<script type="text/javascript" src="${LUI_ContextPath}/km/imissive/resource/js/jquery.qtip.js" charset="UTF-8"></script>
<script type="text/javascript" src="${LUI_ContextPath}/km/imissive/resource/js/hogan.js" charset="UTF-8"></script>
<!-- 模板 -->
<script id="equipInfo-Template" type="text/template">
<div style="overflow:hidden;width:200px;">
<ul>
 <li style="font-size:12px;margin-bottom:5px">退回意见:{{fdContent}}</li>
 <li style="font-size:12px;margin-bottom:5px">退回人:{{docCreator}}</li>
 <li style="font-size:12px;margin-bottom:5px">退回单位:{{fdUnitName}}</li>
 <li style="font-size:12px;margin-bottom:5px">退回时间:{{docCreateTime}}</li>
</ul>
</div>
</script>
<script>
seajs.use(['lui/jquery','lui/topic'], function($,  topic) {
window.ccc = function(){
	var source = $("#equipInfo-Template").html();  
	var template = Hogan.compile(source);
	$(".aaa").each(function(){
		$(this).qtip({
			content: {
				text: 'Loading...',
				ajax: {
					url: "${KMSS_Parameter_ContextPath}km/imissive/km_imissive_return_opinion/kmImissiveReturnOpinion.do?method=loadOpinionById&fdDetailId="+this.id,
					type: 'GET', // POST or GET
					dataType:"json",
					success: function(data, status) {
						this.set('content.text', template.render(data));
					}
				}
			},
		    position: {
				my: 'right top',
				at: 'right bottom',
			    effect: false,
			    target: 'mouse'
			}
		})
	});
 },
 topic.channel("report").subscribe("list.loaded",ccc);
});
</script>
		<table width=100%>
		    <tr>	  
			   <td>
			   <div style="margin-top: 15px;">
			     <div style="float:left">
					 <b>会签记录
					 </b>
				 </div>
				 <div style="margin-right:10px;text-align:right">
					  <kmss:auth requestURL="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=sign&fdId=${param.fdId}" requestMethod="GET">
					     <a href="javascript:;" onclick="urgeSign('sign')" class="com_btn_link">催办签收</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  </kmss:auth>
					  <input type="checkbox" name="waitSignS"  onclick="changeSign()">待签收
					  <input type="checkbox" name="signedS"  onclick="changeSign()">已签收
			     </div>
			   </div>
			 	<div style="height: 15px;"></div>
				   <list:listview id="sign" channel="sign">
						<ui:source type="AjaxJson">
							{"url":"/km/imissive/km_imissive_regdetail_list/kmImissiveRegDetailList.do?method=list&deliver=true&fdMainId=${kmImissiveSendMainForm.fdId}&type=3"}
						</ui:source>
						<list:colTable  isDefault="true" layout="sys.ui.listview.listtable" cfg-norecodeLayout="simple">
						    <list:col-checkbox name="sign"></list:col-checkbox>
							<list:col-auto props=""></list:col-auto>
						</list:colTable>						
					</list:listview>
					<div style="height: 15px;"></div>
					<list:paging layout="sys.ui.paging.simple" channel="sign"></list:paging>
			   </td>
			  </tr>	
			  <c:if test="${kmImissiveSendMainForm.docStatus =='30' && kmImissiveSendMainForm.fdMissiveType != '2'}">
			  <tr>	  
			   <td>
			   <div style="margin-top: 15px;">
			     <div style="float:left">
					 <b>分发记录
					 </b>
				 </div>
				 <div style="margin-right:10px;text-align:right">
				  <kmss:auth requestURL="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=distribute&fdId=${param.fdId}" requestMethod="GET">
				    <a href="javascript:;" onclick="urgeSign('distribute')" class="com_btn_link">催办签收</a>&nbsp;
			        <a href="javascript:;" onclick="distribute();" class="com_btn_link">补发</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				  </kmss:auth>
					 <input type="checkbox" name="waitSignD"  onclick="changeDistribute()">待签收
					 <input type="checkbox" name="signedD"  onclick="changeDistribute()">已签收
			    </div>
			   </div>
			 	<div style="height: 15px;"></div>
				   <list:listview id="distribute" channel="distribute">
						<ui:source type="AjaxJson">
							{"url":"/km/imissive/km_imissive_regdetail_list/kmImissiveRegDetailList.do?method=list&deliver=true&fdMainId=${kmImissiveSendMainForm.fdId}&type=1"}
						</ui:source>
						<list:colTable  isDefault="true" layout="sys.ui.listview.listtable" cfg-norecodeLayout="simple">
						    <list:col-checkbox name="distribute"></list:col-checkbox>
							<list:col-auto props=""></list:col-auto>
						</list:colTable>						
					</list:listview>
					<div style="height: 15px;"></div>
					<list:paging layout="sys.ui.paging.simple" channel="distribute"></list:paging>
			   </td>
			  </tr>	
			  </c:if>
			  <c:if test="${kmImissiveSendMainForm.docStatus =='30' && kmImissiveSendMainForm.fdMissiveType != '1'}">
			  <tr>	  
			   <td>
			    <div style="margin-top: 15px;">
				     <div style="float:left">
						 <b>上报记录
						 </b>
					 </div>
					 <div style="margin-right:10px;text-align:right">
					 <kmss:auth requestURL="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=report&fdId=${param.fdId}" requestMethod="GET">
					    <a href="javascript:;" onclick="urgeSign('report')" class="com_btn_link">催办签收</a>&nbsp;
				        <a href="javascript:;" onclick="report();" class="com_btn_link">补报</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					 </kmss:auth>
						<input type="checkbox" name="waitSignR"  onclick="changeReport()">待签收
					    <input type="checkbox" name="signedR"  onclick="changeReport()">已签收
				    </div>
			    </div>
			 	<div style="height: 15px;"></div>
				   <list:listview id="report" channel="report">
						<ui:source type="AjaxJson">
							{"url":"/km/imissive/km_imissive_regdetail_list/kmImissiveRegDetailList.do?method=list&deliver=true&fdMainId=${kmImissiveSendMainForm.fdId}&type=2"}
						</ui:source>
						<list:colTable isDefault="true" layout="sys.ui.listview.listtable" cfg-norecodeLayout="simple">
						    <list:col-checkbox name="report"></list:col-checkbox>
							<list:col-auto props=""></list:col-auto>
						</list:colTable>	
					</list:listview>
					<div style="height: 15px;"></div>
					<list:paging layout="sys.ui.paging.simple"  channel="report"></list:paging>
			   </td>
			  </tr>
			  </c:if>
			 <kmss:auth requestURL="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=readViewLog&fdId=${param.fdId}" requestMethod="GET">
			  <tr>	  
			   <td>
			    <div style="margin-top: 15px;">
				    <div style="float:left">
						 <b>附件跟踪记录
						 </b>
					 </div>
			    </div>
			 	<div style="height: 15px;"></div>
			 	<script type="text/javascript">
			 	  function openfile(fdId){
			 		 var url="${KMSS_Parameter_ContextPath}sys/attachment/sys_att_main/sysAttMain.do?method=view&fdModelName=com.landray.kmss.km.imissive.model.KmImissiveAttTrack&fdSendId=${kmImissiveSendMainForm.fdId}&fdId="+fdId;
			 		 Com_OpenWindow(url,"_blank");
				  }
			 	</script>
				   <list:listview id="att" channel="att">
						<ui:source type="AjaxJson">
							{"url":"/km/imissive/km_imissive_att_track/kmImissiveAttTrack.do?method=list&fdMainId=${kmImissiveSendMainForm.fdId}"}
						</ui:source>
						<list:colTable isDefault="true" layout="sys.ui.listview.listtable" cfg-norecodeLayout="simple">
							<list:col-auto props=""></list:col-auto>
						</list:colTable>	
					</list:listview>
					<div style="height: 15px;"></div>
					<list:paging layout="sys.ui.paging.simple"  channel="att"></list:paging>
			   </td>
			  </tr>
			  </kmss:auth>
			  <tr>	  
			   <td>
			    <div style="margin-top: 15px;">
				    <div style="float:left">
						 <b>传阅记录
						 </b>
					 </div>
					 <div style="margin-right:10px;text-align:right">&nbsp;&nbsp;&nbsp;
				     </div>
			    </div>
			 	<div style="height: 15px;"></div>
			    <c:import
					url="/sys/circulation/import/sysCirculationMain_view.jsp"
					charEncoding="UTF-8">
					<c:param
						name="formName"
						value="kmImissiveSendMainForm" />
					<c:param
						name="isShowUiContent"
						value="false" />
				</c:import>
				 </td>
			  </tr>
			  <c:if test="${kmImissiveSendMainForm.docStatus =='30'}">
			   <tr>	  
			   <td>
			    <div style="margin-top: 15px;">
				    <div style="float:left">
						 <b>发布记录
						 </b>
					 </div>
					 <div style="margin-right:10px;text-align:right">&nbsp;&nbsp;&nbsp;
				     </div>
			    </div>
			 	<div style="height: 15px;"></div>
				<c:import url="/sys/news/import/sysNewsPublishMain_view.jsp"
				charEncoding="UTF-8">
					<c:param name="formName" value="kmImissiveSendMainForm" />
					<c:param name="fdKey" value="sendMainDoc" />
					<c:param name="isShowUiContent" value="false" />
			    </c:import>
			   </td>
			  </tr>
			  </c:if>
		</table> 
	  </ui:content>
	<!-- 权限机制-->
	<ui:content title="${ lfn:message('sys-right:right.moduleName') }">
		<table class="tb_normal" width=100%>
			<tr>
				<td class="td_normal_title" width="15%">审批意见可阅读者</td>
				<td width="85%" colspan='3'>
				    <c:if test="${empty kmImissiveSendMainForm.authAppRecReaderNames}">
						<bean:message bundle="sys-right" key="right.other.person" />
					</c:if>
					<c:if test="${not empty kmImissiveSendMainForm.authAppRecReaderNames}">
						<c:out value="${kmImissiveSendMainForm.authAppRecReaderNames}"></c:out>
					</c:if>
				</td>
			</tr>
			<c:import url="/sys/right/right_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmImissiveSendMainForm" />
				<c:param name="moduleModelName" value="com.landray.kmss.km.imissive.model.KmImissiveSendMain" />
			</c:import>
		</table>
	</ui:content>
	<c:import url="/sys/bookmark/import/bookmark_bar.jsp"
			charEncoding="UTF-8">
			<c:param name="fdSubject" value="${kmImissiveSendMainForm.docSubject}" />
			<c:param name="fdModelId" value="${kmImissiveSendMainForm.fdId}" />
			<c:param name="fdModelName"
				value="com.landray.kmss.km.imissive.model.KmImissiveSendMain" />
	</c:import>		
</ui:tabpage>
</html:form>
<%@ include file="/km/imissive/cookieUtil_script.jsp"%>
<script>
	Com_IncludeFile("att_dynamic.js","${KMSS_Parameter_ContextPath}km/imissive/","js",true);
</script>
<script>
$(document).ready(function(){
	<c:if  test="${kmImissiveSendMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.modifyDocNum =='true' and kmImissiveSendMainForm.docStatus=='20'}">
	 generateAutoNum();
	</c:if>
});

seajs.use(['sys/ui/js/dialog'], function(dialog) {
	window.dialog = dialog;
});
var tempDocNum = "";
//文档加载时自动获取文号
function generateAutoNum(){
	 var docNum = document.getElementsByName("fdDocNum")[0];
	if("${fdNoId}" != ""){
	if(getValueFromCookie("${fdNoId}${kmImissiveSendMainForm.fdId}")){
		docNum.value = getValueFromCookie("${fdNoId}${kmImissiveSendMainForm.fdId}");
	    tempDocNum=getValueFromCookie("${fdNoId}${kmImissiveSendMainForm.fdId}");
	    document.getElementById("docnum").innerHTML = getValueFromCookie("${fdNoId}${kmImissiveSendMainForm.fdId}");
	  //填充控件中的文号书签 
	    if(Attachment_ObjectInfo['editonline']){
	           Attachment_ObjectInfo['editonline'].setBookmark('docnum',getValueFromCookie("${fdNoId}${kmImissiveSendMainForm.fdId}"));
	    }
	}else{
	    var url="${KMSS_Parameter_ContextPath}km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=generateNum"; 
		 $.ajax({     
    	     type:"post",   
    	     url:url,     
    	     data:{fdDocNum:docNum.value,fdId:"${kmImissiveSendMainForm.fdId}"},    
    	     async:false,    //用同步方式 
    	     success:function(data){
    	 	    var results =  eval("("+data+")");
    		    if(results['docNum']!=null){
    		   	   docNum.value = results['docNum'];
    		       tempDocNum=results['docNum'];
    		       document.getElementById("docnum").innerHTML = results['docNum'];
    		       //填充控件中的文号书签 
    		        if(Attachment_ObjectInfo['editonline']){
    		           Attachment_ObjectInfo['editonline'].setBookmark('docnum',document.getElementsByName("fdDocNum")[0].value);
    		        }
    			}
    		    document.cookie=("${fdNoId}${kmImissiveSendMainForm.fdId}="+results['docNum']);
    		}    
        });
	 }
   }
}

//文件编号
   function generateFileNum(){
	        var docNum = document.getElementsByName("fdDocNum")[0];
		    path=Com_GetCurDnsHost()+Com_Parameter.ContextPath+'km/imissive/km_imissive_send_main/kmImissiveNum.jsp?fdId=${kmImissiveSendMainForm.fdId}&fdNoId=${fdNoId}&tempDocNum='+encodeURI(tempDocNum);
		    dialog.iframe(path,"文件编号",function(rtn){
			  if(rtn!="undefined"&&rtn!=null){
	    		  docNum.value = rtn;
	   		      tempDocNum=rtn;
	   		      document.getElementById("docnum").innerHTML = rtn;
	   		      //填充控件中的文号书签
	   		      if(Attachment_ObjectInfo['editonline']){
	   		         Attachment_ObjectInfo['editonline'].setBookmark('docnum',document.getElementsByName("fdDocNum")[0].value);
	   		      }
			  }
		   },{width:400,height:200});
	}
	//异步保存附件跟踪信息
   function saveAttTrack(fdFileId,fdFileName,type,fdNodeName){
	   var flag = false;
	   var url="${KMSS_Parameter_ContextPath}km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=addAttTrack"; 
	   $.ajax({     
  	     type:"post",     
  	     url:url,     
  	     data:{fdMainId:"${kmImissiveSendMainForm.fdId}",type:type,fdFileId:fdFileId,fdFileName:fdFileName,fdNodeName:fdNodeName},    
  	     async:false,    //用同步方式 
  	     success:function(){
  	    	flag = true;
  		 }    
      });
	   return flag;
   }
   <%
	 //生成一个附件id,供痕迹稿上传用
	  request.setAttribute("revisionAttId",IDGenerator.generateID());
	 //生成一个附件id,供清稿上传用
	  request.setAttribute("clearAttId",IDGenerator.generateID());
	%>
	
//清稿
   function doCleardraft(){
		var obj_ = document.getElementById("JGWebOffice_editonline");
		var rFlag = false;
		var cFlag = false;
		try {
			if(obj_){
				obj_.WebSetMsgByName("COMMAND","REVISIONDRAFT");
				obj_.WebSetMsgByName("_modelName", "com.landray.kmss.km.imissive.model.KmImissiveAttTrack");
				obj_.WebSetMsgByName("_key", "revisionAtt");
				obj_.WebSetMsgByName("_fdId","${revisionAttId}" );
				//保存痕迹稿
				rFlag=obj_.WebSave(true);
				if(rFlag){
					if(saveAttTrack(obj_.WebGetMsgByName("fd_fileId"),obj_.WebGetMsgByName("fd_fileName"),"1","${nodevalue}")){
					obj_.WebSetMsgByName("COMMAND","CLEARDRAFT");
					obj_.WebSetMsgByName("_modelName", "com.landray.kmss.km.imissive.model.KmImissiveAttTrack");
					obj_.WebSetMsgByName("_key", "clearAtt");
					obj_.WebSetMsgByName("_fdId","${clearAttId}" );
					//删除正文痕迹
					obj_.ClearRevisions();
					////保存清稿
					cFlag=obj_.WebSave(true);
					if(cFlag){
						if(saveAttTrack(obj_.WebGetMsgByName("fd_fileId"),obj_.WebGetMsgByName("fd_fileName"),"2","${nodevalue}")){
						obj_.WebSetMsgByName("COMMAND","NODRAFT");
						//清稿成功后需要保存正文
						var saveA = document.getElementsByName("editonline_saveDraft")[0];
						if(saveA != null && saveA != undefined){
							saveA.click();
							dialog.alert("清稿成功，请到发文跟踪页签查看清稿痕迹！",function(){
								location.reload();
							});
						}
					  }
					}else{
						dialog.alert("清稿失败！");
					}
				  }
				}
			}else{
				dialog.alert("请先切换阅读模式！");
			}
		} catch (e) {
			dialog.alert("清稿失败，抛异常！");
		}
   }
	 function cleardraft(){
			dialog.confirm("清稿后，所有的留痕将被强制接受，是否继续？",function(flag){
			if(flag==true){
				doCleardraft();
			}},"warn");
		}	
	
<c:if  test="${kmImissiveSendMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.modifyDocNum =='true'}">
Com_Parameter.event["submit"].push(function(){
		//操作类型为通过类型 ，才写回编号 
		if(lbpm.globals.getCurrentOperation().operation['isPassType'] == true){
		    var docNum = document.getElementsByName("fdDocNum")[0];
		    var isRepeat=true;
		    var results;
		    if(""==docNum.value){
		        alert('<bean:message bundle="km-imissive" key="kmImissiveSendMain.message.error.fdDocNum"/>');
		        return false;
		     }else{
		    	 var url="${KMSS_Parameter_ContextPath}km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=saveDocNum"; 
		    	 $.ajax({     
		    	     type:"post",     
		    	     url:url,     
		    	     data:{fdDocNum:docNum.value,fdId:"${kmImissiveSendMainForm.fdId}"},    
		    	     async:false,    //用同步方式 
		    	     success:function(data){
				    	    results =  eval("("+data+")");
				    	    if(results['isRepeat']=="true"){
				    		    alert('<bean:message bundle="km-imissive" key="kmImissiveSendMain.message.error.fdDocNum.repeat"/>');
				    		    isRepeat = false;
				    	}
				    }     
		          });
		        if(results['flag']=="false"&&results['isRepeat']!="true"){
			        alert("更新文档编号不成功");
			        return false
			    }else{
		    	    return isRepeat;
			    }
		     }
		}else{
			return true;
		}
});
</c:if>

var redheadFlag = "";  //是否进行套红标示
<c:if  test="${kmImissiveSendMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.redhead =='true'}">
Com_Parameter.event["submit"].push(function(){
	   var flag = true;
	   if(""==redheadFlag){
		   flag =  confirm("当前节点有套红附加选项,还未套红,是否继续提交？");
	   }
	   return flag;
});
</c:if>

 //如果流程附加节点中有签发操作，则将签发日期和签发人写回
 <c:if  test="${kmImissiveSendMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.signature =='true'}">
 Com_Parameter.event["submit"].push(function(){
		//操作类型为通过类型，才写回
		if(lbpm.globals.getCurrentOperation().operation['isPassType'] == true){
			   var flag=true;
			    var url="${KMSS_Parameter_ContextPath}km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=saveSignatureAndTime"; 
			   	 $.ajax({     
		    	     type:"post",     
		    	     url:url,     
		    	     data:{fdId:"${kmImissiveSendMainForm.fdId}"},    
		    	     async:false,     //用同步方式 
		    	     success:function(data){
				    	    results =  eval("("+data+")");
				    	    if(results['flag']=="false"){
				    		    alert('生成签发日期失败');
				    		    flag = false;
				    	}
				    } 
		          });
		 	return flag;      
		}
		return true;
 });
  </c:if>
</script>
</template:replace>
<template:replace name="nav">
    <%--关联机制 --%>
		<c:import url="/sys/relation/import/sysRelationMain_view.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="kmImissiveSendMainForm" />
		</c:import>
	<!-- 关联机制 -->
</template:replace>
</template:include>
