<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit"   sidebar="auto">
<%@page import="com.landray.kmss.km.imissive.util.KmImissiveConfigUtil"%>
	<template:replace name="title">
		<c:choose>
			<c:when test="${ kmImissiveReceiveMainForm.method_GET == 'add' }">
				<c:out value="${lfn:message('km-imissive:kmImissiveReceiveMain.create.title') } - ${ lfn:message('km-imissive:module.km.imissive') }"></c:out>	
			</c:when>
			<c:otherwise>
				<c:out value="${kmImissiveReceiveMainForm.docSubject} - ${ lfn:message('km-imissive:module.km.imissive') }"></c:out>
			</c:otherwise>
		</c:choose>
	</template:replace>
	<template:replace name="toolbar">
	  <%@ include file="/km/imissive/script.jsp"%>
	  <%@ include file="/km/imissive/km_imissive_receive_main/script.jsp"%>
	  <ui:toolbar id="toolbar" layout="sys.ui.toolbar.float"> 
		<c:if test="${kmImissiveReceiveMainForm.method_GET=='add'}">
			<ui:button text="${lfn:message('button.savedraft') }" order="2" onclick="commitMethod('save','true');">
			</ui:button>
			<ui:button text="${lfn:message('button.submit') }" order="2" onclick="commitMethod('save','false');">
			</ui:button>
		</c:if>
		<c:if test="${kmImissiveReceiveMainForm.method_GET=='edit'}">
			<c:if test="${kmImissiveReceiveMainForm.docStatus=='10'}"> 
				<ui:button text="${lfn:message('button.savedraft') }" order="2" onclick="commitMethod('update','true');">
				</ui:button>
			</c:if> 
			<c:if test="${kmImissiveReceiveMainForm.docStatus<'20'}">
			    <ui:button text="${lfn:message('button.submit') }" order="2" onclick="commitMethod('update','false');">
				</ui:button>
			</c:if>
			<c:if test="${kmImissiveReceiveMainForm.docStatus=='20'}">
			    <ui:button text="${lfn:message('button.submit') }" order="2" onclick="Com_Submit(document.kmImissiveReceiveMainForm, 'update');">
				</ui:button>
			</c:if>
			<c:if test="${kmImissiveReceiveMainForm.docStatus>='30'}">
		     	<ui:button text="${lfn:message('button.submit') }" order="2" onclick="Com_Submit(document.kmImissiveReceiveMainForm, 'update');">
				</ui:button>
			</c:if>
		</c:if>
	     <ui:button text="${ lfn:message('button.close') }" order="5"  onclick="Com_CloseWindow()">
		 </ui:button>
		</ui:toolbar>
	</template:replace>
	<template:replace name="path">
	<ui:menu layout="sys.ui.menu.nav"  id="categoryId"> 
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home"></ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-imissive:module.km.imissive') }" ></ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-imissive:kmImissive.nav.ReceiveManagement') }"></ui:menu-item>
			<ui:menu-source autoFetch="false">
				<ui:source type="AjaxJson">
					{"url":"/sys/category/criteria/sysCategoryCriteria.do?method=path&modelName=com.landray.kmss.km.imissive.model.KmImissiveReceiveTemplate&categoryId=${kmImissiveReceiveMainForm.fdTemplateId}"} 
				</ui:source>
			</ui:menu-source>
		</ui:menu>
	</template:replace>
<template:replace name="content"> 
<c:if test="${kmImissiveReceiveMainForm.method_GET=='add'}">
	<script type="text/javascript">
		window.changeDocTemp = function(modelName,url,canClose){
			if(modelName==null || modelName=='' || url==null || url=='')
				return;
	 		seajs.use(['sys/ui/js/dialog'],function(dialog) {
			 	dialog.categoryForNewFile(modelName,url,false,null,function(rtn) {
					// 无分类状态下（一般于门户快捷操作）创建文档，取消操作同时关闭当前窗口
					if (!rtn)
						window.close();
				},'${param.categoryId}','_self',canClose);
		 	});
	 	};
	 	
		if('${param.fdTemplateId}'==''){
			window.changeDocTemp('com.landray.kmss.km.imissive.model.KmImissiveReceiveTemplate','/km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do?method=add&fdTemplateId=!{id}&fdTemplateName=!{name}&fdModelId=${param.fdModelId}&fdModelName=${param.fdModelName}',true);
		}
	</script>
</c:if>
	<script>
	  Com_IncludeFile("dialog.js");
	</script>
	<script language="JavaScript">
	function commitMethod(commitType, saveDraft){
		var formObj = document.kmImissiveReceiveMainForm;
		var docStatus = document.getElementsByName("docStatus")[0];
		var fdSendtoUnitId=document.getElementsByName("fdSendtoUnitId")[0];
		var fdOutSendto=document.getElementsByName("fdOutSendto")[0];
		var fdReceiveStatus = document.getElementsByName("fdReceiveStatus")[0];
		var outerUnit=document.getElementById("outerUnit");
		if(saveDraft=="true"){
			docStatus.value="10";
		}else{
			docStatus.value="20";
			fdReceiveStatus.value="30";
		}
		//提交时判断是否需要正文，如果不需要则移除页面控件对象
		var type =  document.getElementsByName("fdNeedContent");
       	 if(type[0].value !="1"){
        	jg_attachmentObject_editonline.unLoad();
            $("#wordEdit").remove();
       	}else{
   			jg_attachmentObject_editonline.ocxObj.Active(true);
   			jg_attachmentObject_editonline.saveAsImage();
            jg_attachmentObject_editonline._submit();
         }
		Com_Submit(formObj, commitType);
	}
	
	//解决非ie下控件高度问题
	$(document).ready(function(){
		checkEditType("${kmImissiveReceiveMainForm.fdNeedContent}", null);
		var obj = document.getElementById("JGWebOffice_editonline");
		if(obj){
			obj.setAttribute("height", "550px");
		}
	});
	function checkEditType(value){
		var type=document.getElementsByName("fdNeedContent")[0];
		type.value = "0";
		var _wordEdit = document.getElementById('wordEdit');
		var _attEdit = document.getElementById('attEdit');
		if("1" == value){
			type.value = "1";
			_wordEdit.style.display = "block";
			_attEdit.style.display = "none";
			jg_attachmentObject_editonline.load();
			jg_attachmentObject_editonline.show();
			jg_attachmentObject_editonline.ocxObj.Active(true);
		} else {
			_attEdit.style.display = "block";
			_wordEdit.style.display = "none";
		}
	}
	</script>
<html:form action="/km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do">
			<div class="lui_form_content_frame" style="padding-top: 5px">
				<c:import url="/sys/xform/include/sysForm_edit.jsp"
					charEncoding="UTF-8">
					<c:param name="formName" value="kmImissiveReceiveMainForm" />
					<c:param name="fdKey" value="receiveMainDoc"/>
					<c:param name="messageKey" value="km-imissive:kmImissiveReceiveMain.baseinfo"/>
					<c:param name="useTab" value="false" />
				</c:import>
			</div>
		     <table class="tb_normal" width="100%">
					<html:hidden property="fdId"/>
					<html:hidden property="docStatus" />
					<html:hidden property="fdReceiveStatus" />
					<html:hidden property="fdModelId" />
					<html:hidden property="fdModelName"/>
					<html:hidden property="fdMainId"/>
					<html:hidden property="fdNeedContent" />
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message key="kmImissiveReceiveTemplate.fdNeedContent" bundle="km-imissive" />
					</td>
					<td width="85%">
						<xform:radio property="fdEditType" showStatus="edit" value="${kmImissiveReceiveMainForm.fdNeedContent}" onValueChange="checkEditType">
							<xform:enumsDataSource enumsType="kmImissiveReceiveTemplate_fdNeedContent" />
						</xform:radio>
					</td>
				</tr>
				<tr>
					<td colspan="4">
					<div id="wordEdit" style="height:600px;"
									<c:if test="${kmImissiveReceiveMainForm.fdNeedContent!='1'}">style="display:none"</c:if>>
						<div id="missiveButtonDiv" style="text-align: right; padding-bottom: 5px">&nbsp;
						<a href="javascript:void(0);" class="attbook"
							   onclick="Com_OpenWindow(Com_Parameter.ContextPath+'km/imissive/km_imissive_receive_main/bookMarks.jsp','_blank');">
						     <bean:message key="kmImissive.bookMarks.title" bundle="km-imissive" />
						     </a>
						</div>
						 <c:import url="/sys/attachment/sys_att_main/jg/sysAttMain_edit.jsp" charEncoding="UTF-8">
						   <c:param name="fdKey" value="editonline" />
							<c:param name="fdAttType" value="word" />
							<c:param name="bindSubmit" value="false"/>
							<c:param name="fdModelId" value="${kmImissiveReceiveMainForm.fdId}" />
							<c:param name="fdModelName" value="com.landray.kmss.km.imissive.model.KmImissiveReceiveMain" />
							<c:param name="formBeanName" value="kmImissiveReceiveMainForm" />
							<c:param name="fdTemplateModelId" value="${kmImissiveReceiveMainForm.fdTemplateId}" />
							<c:param name="fdTemplateModelName" value="com.landray.kmss.km.imissive.model.KmImissiveReceiveTemplate" />
							<c:param name="fdTemplateKey" value="editonline"/>
							<c:param name="templateBeanName" value="kmImissiveReceiveTemplateForm" />
							<c:param name="isToImg" value="false"/>
							<c:param name="buttonDiv" value="missiveButtonDiv" />
							<c:param  name="bookMarks"  value="docsubject:${kmImissiveReceiveMainForm.docSubject},doctype:${kmImissiveReceiveMainForm.fdDocTypeName},sendunit:${kmImissiveReceiveMainForm.fdSendtoUnitName},docnum:${kmImissiveReceiveMainForm.fdDocNum},receivenum:${kmImissiveReceiveMainForm.fdReceiveDocNum},secretgrade:${kmImissiveReceiveMainForm.fdSecretGradeName},emergency:${kmImissiveReceiveMainForm.fdEmergencyGradeName},signer:${kmImissiveReceiveMainForm.fdSignerName},signtime:${kmImissiveReceiveMainForm.fdSignTime},recorder:${kmImissiveReceiveMainForm.fdRecorderName},recordtime:${kmImissiveReceiveMainForm.fdRecordTime},receivetime:${kmImissiveReceiveMainForm.fdReceiveTime},receiveunit:${kmImissiveReceiveMainForm.fdReceiveUnitName}${kmImissiveReceiveMainForm.fdOutSendto},content:${kmImissiveReceiveMainForm.fdContent}"/>
						</c:import>
					</div>
					  <div id="attEdit" <c:if test="${kmImissiveReceiveMainForm.fdNeedContent!='0'}">style="display:none"</c:if>>
					      <div class="lui_form_spacing"></div> 
				            <div>
							   <div class="lui_form_subhead"><img src="${KMSS_Parameter_ContextPath}sys/attachment/view/img/attachment.png">正文附件</div>
								<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
									<c:param name="fdKey" value="mainonline"/>
									<c:param  name="fdMulti" value="false" />
									<c:param name="fdModelId" value="${kmImissiveReceiveMainForm.fdId }" />
									<c:param name="fdModelName" value="com.landray.kmss.km.imissive.model.KmImissiveReceiveMain" />
								</c:import>
							</div>
						</div>
					</td>
				</tr>
			</table>
			<div class="lui_form_content_frame" style="padding-top:10px">
				<div class="lui_form_spacing"></div> 
				<div>
					<div class="lui_form_subhead"><img src="${KMSS_Parameter_ContextPath}sys/attachment/view/img/attachment.png"> ${ lfn:message('sys-doc:sysDocBaseInfo.docAttachments') }</div>
				    <c:import
						url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp"
						charEncoding="UTF-8">
						<c:param name="fdKey" value="attachment" />
						<c:param name="fdModelId" value="${param.fdId }" />
						<c:param name="fdModelName"
							value="com.landray.kmss.km.imissive.model.KmImissiveReceiveMain" />
					</c:import>
				</div> 	
		   </div>
		<ui:tabpage expand="false">
		<!-- 以下代码为嵌入流程模板标签的代码 -->
		<c:import url="/sys/workflow/import/sysWfProcess_edit.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmImissiveReceiveMainForm" />
			<c:param name="fdKey" value="receiveMainDoc" />
			<c:param name="showHistoryOpers" value="true" />
		</c:import>
		<!-- 以上代码为嵌入流程模板标签的代码 -->
		<!--发布机制开始-->
		<c:import url="/sys/news/import/sysNewsPublishMain_edit.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmImissiveReceiveMainForm" />
			<c:param name="fdKey" value="receiveMainDoc" />
			<c:param name="isShow" value="true" />
		</c:import>
		<!--发布机制结束-->
	     <!-- 权限机制  -->
		<ui:content title="${ lfn:message('sys-right:right.moduleName') }">
			<table class="tb_normal" width=100%>
				<tr>
					<td class="td_normal_title" width="15%">审批意见可阅读者</td>
					<td width="85%" colspan='3'>
						<xform:address textarea="true" mulSelect="true" propertyId="authAppRecReaderIds" propertyName="authAppRecReaderNames" style="width:97%;height:90px;" ></xform:address>
					    <br><span class="com_help"><bean:message bundle="sys-right" key="right.read.authReaders.note1" /></span>
					</td>
				</tr>
				<c:import url="/sys/right/right_edit.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmImissiveReceiveMainForm" />
					<c:param name="moduleModelName" value="com.landray.kmss.km.imissive.model.KmImissiveReceiveMain" />
				</c:import>
			</table>
		</ui:content>
		<!-- 权限机制 -->
	</ui:tabpage>
<html:hidden property="method_GET"/>
</html:form>
<script language="JavaScript">
			$KMSSValidation(document.forms['kmImissiveReceiveMainForm']);
		</script>
</template:replace>
<template:replace name="nav">
       <!-- 关联机制 -->
	    <c:import url="/sys/relation/import/sysRelationMain_edit.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="kmImissiveReceiveMainForm" />
		</c:import>
		<!-- 关联机制 -->
</template:replace>
</template:include>
