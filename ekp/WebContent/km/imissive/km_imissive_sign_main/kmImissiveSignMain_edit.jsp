<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit"  sidebar="auto">
<%@page import="com.landray.kmss.km.imissive.util.KmImissiveConfigUtil"%>
		<template:replace name="toolbar">
		<%@ include file="/km/imissive/script.jsp"%>
		<%@ include file="/km/imissive/km_imissive_sign_main/script.jsp"%>
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float"> 
			<c:if test="${kmImissiveSignMainForm.method_GET=='add'}">
			    <ui:button text="${lfn:message('button.savedraft') }" order="2" onclick=" commitMethod('save','true');">
				</ui:button>
				<ui:button text="${lfn:message('button.submit') }" order="2" onclick=" commitMethod('save','false');">
				</ui:button>
			</c:if>
			<%-- 套红附加选项 --%>
			<c:if  test="${kmImissiveSignMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.redhead =='true'}">
			   <ui:button text="${lfn:message('km-imissive:kmImissive.redhead') }" order="2"
			     onclick="LoadHeadWordList('com.landray.kmss.km.imissive.model.KmImissiveSignMain');">
			   </ui:button>
			</c:if>
			<%-- 文件编号附加选项 --%>
			<c:if  test="${kmImissiveSignMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.modifyDocNum =='true'}">
			    <ui:button text="${lfn:message('km-imissive:kmImissive.modifyDocNum') }" order="3"
					 onclick="generateFileNum();">
				</ui:button>
			</c:if>
			<c:if test="${kmImissiveSignMainForm.method_GET=='edit'}">
				<c:if test="${kmImissiveSignMainForm.docStatus=='10'}">
					<ui:button text="${lfn:message('button.savedraft') }" order="2" onclick=" commitMethod('update','true');">
					</ui:button>
				</c:if>
				<c:if test="${kmImissiveSignMainForm.docStatus<'20'}">
				    <ui:button text="${lfn:message('button.submit') }" order="2" onclick=" commitMethod('update','false');">
					</ui:button>
				</c:if>
				<c:if test="${kmImissiveSignMainForm.docStatus=='20'}">
				    <ui:button text="${lfn:message('button.submit') }" order="2" onclick=" Com_Submit(document.kmImissiveSignMainForm, 'update');">
					</ui:button>
				</c:if>
				<c:if test="${kmImissiveSignMainForm.docStatus>='30'}">
				    <ui:button text="${lfn:message('button.submit') }" order="2" onclick=" Com_Submit(document.kmImissiveSignMainForm, 'update');">
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
			<ui:menu-item text="${ lfn:message('km-imissive:kmImissive.meun.sign') }"></ui:menu-item>
			<ui:menu-source autoFetch="false">
				<ui:source type="AjaxJson">
					{"url":"/sys/category/criteria/sysCategoryCriteria.do?method=path&modelName=com.landray.kmss.km.imissive.model.KmImissiveSignTemplate&categoryId=${kmImissiveSignMainForm.fdTemplateId}"} 
				</ui:source>
			</ui:menu-source>
		</ui:menu>
		</template:replace>
	<template:replace name="content"> 
	<script>
	    Com_IncludeFile("doclist.js|dialog.js|calendar.js|optbar.js|jquery.js");
	</script>
	<c:if test="${kmImissiveSignMainForm.method_GET=='add'}">
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
				window.changeDocTemp('com.landray.kmss.km.imissive.model.KmImissiveSignTemplate','/km/imissive/km_imissive_sign_main/kmImissiveSignMain.do?method=add&fdTemplateId=!{id}&fdTemplateName=!{name}&fdModelId=${param.fdModelId}&fdModelName=${param.fdModelName}',true);
			}
		</script>
	</c:if>
	<script language="JavaScript">
	function commitMethod(commitType, saveDraft){
		var formObj = document.kmImissiveSignMainForm;
		var docStatus = document.getElementsByName("docStatus")[0];
		if(saveDraft=="true"){
			docStatus.value="10";
		}else{
			docStatus.value="20";
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
		 //删除cookie,避免新建每次取到同一编号
		 if("${fdNoId}"!=""){
		  delCookieByName("${fdNoId}");
		 }
	}
	//解决非ie下控件高度问题
	$(document).ready(function(){
		checkEditType("${kmImissiveSignMainForm.fdNeedContent}", null);
		var obj = document.getElementById("JGWebOffice_editonline");
		if(obj){
			obj.setAttribute("height", "550px");
		}
	});
	function checkEditType(value){
		var type=document.getElementsByName("fdNeedContent")[0];
		type.value = "0";
		var _wordEdit = document.getElementById('wordEdit');
		if("1" == value){
			type.value = "1";
			_wordEdit.style.display = "block";
			jg_attachmentObject_editonline.load();
			jg_attachmentObject_editonline.show();
			jg_attachmentObject_editonline.ocxObj.Active(true);
		} else {
			_wordEdit.style.display = "none";
		}
	}
	</script>
		<html:form action="/km/imissive/km_imissive_sign_main/kmImissiveSignMain.do">
			<div class="lui_form_content_frame" style="padding-top: 5px">
				<c:import url="/sys/xform/include/sysForm_edit.jsp"
					charEncoding="UTF-8">
					<c:param name="formName" value="kmImissiveSignMainForm" />
					<c:param name="fdKey" value="signMainDoc"/>
					<c:param name="messageKey" value="km-imissive:kmImissiveSignMain.baseinfo"/>
					<c:param name="useTab" value="false" />
				</c:import>
			</div>
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
							value="com.landray.kmss.km.imissive.model.KmImissiveSignMain" />
					</c:import>
				</div> 	
		   </div>
			<table class="tb_normal" width="98%">
					<html:hidden property="docStatus" />
					<html:hidden property="fdId"/>
					<html:hidden property="fdModelId" />
					<html:hidden property="fdModelName"/>
					<html:hidden property="fdNeedContent" />
				  <tr>
					<td class="td_normal_title" width=15%>
						<bean:message key="kmImissiveSignTemplate.fdNeedContent" bundle="km-imissive" />
					</td>
					<td width="85%">
						<xform:radio property="fdEditType" showStatus="edit" value="${kmImissiveSignMainForm.fdNeedContent}" onValueChange="checkEditType">
							<xform:enumsDataSource enumsType="kmImissiveSignTemplate_fdNeedContent" />
						</xform:radio>
					</td>
				  </tr>
				  <tr>
					<td colspan="4">
					<div id="wordEdit" style="height:600px;"
									<c:if test="${kmImissiveSignMainForm.fdNeedContent!='word'}">style="display:none"</c:if>>
						<%-- --套红头 -- --%>
				        <%@ include file="/km/imissive/kmImissiveSignRedhead_script.jsp"%>
						<div id="child">			
						  <div id="missiveButtonDiv" style="text-align: right; padding-bottom: 5px">&nbsp; 
						    <a
								href="javascript:void(0);" class="attbook"
								onclick="Com_OpenWindow(Com_Parameter.ContextPath+'km/imissive/km_imissive_sign_main/bookMarks.jsp','_blank');">
							<bean:message key="kmImissive.bookMarks.title" bundle="km-imissive" />
							</a>
						   </div>
						   <c:import url="/sys/attachment/sys_att_main/jg/sysAttMain_edit.jsp" charEncoding="UTF-8">
								<c:param name="fdModelId" value="${kmImissiveSignMainForm.fdId}" />
								<c:param name="fdModelName" value="com.landray.kmss.km.imissive.model.KmImissiveSignMain" />
								<c:param name="fdKey" value="editonline" />
								<c:param name="formBeanName" value="kmImissiveSignMainForm" />
								<c:param name="fdAttType" value="word"/>
								<c:param name="bindSubmit" value="false"/>
								<c:param name="fdTemplateModelId" value="${kmImissiveSignMainForm.fdTemplateId}" />
								<c:param name="fdTemplateModelName" value="com.landray.kmss.km.imissive.model.KmImissiveSignTemplate" />
								<c:param name="fdTemplateKey" value="editonline" />
								<c:param name="bookMarks"
									value="docsubject:${kmImissiveSignMainForm.docSubject},doctype:${kmImissiveSignMainForm.fdDocTypeName},docnum:${kmImissiveSignMainForm.fdDocNum},secretgrade:${kmImissiveSignMainForm.fdSecretGradeName},checker:${kmImissiveSignMainForm.fdCheckerName},emergency:${kmImissiveSignMainForm.fdEmergencyGradeName},draftdept:${kmImissiveSignMainForm.fdDraftDeptName},drafter:${kmImissiveSignMainForm.fdDrafterName},drafttime:${kmImissiveSignMainForm.fdDraftTime},content:${kmImissiveSignMainForm.fdContent},signdatecn:${kmImissiveSignMainForm.docPublishTimeUpper},signdate:${kmImissiveSignMainForm.docPublishTimeNum},printnum:${kmImissiveSignMainForm.fdPrintNum},printpagenum:${kmImissiveSignMainForm.fdPrintPageNum}" />
								<c:param name="buttonDiv" value="missiveButtonDiv"/>
								<c:param name="isToImg" value="false"/>
							</c:import>
						</div>
					</div>
					</td>
				</tr>
			</table>
			<ui:tabpage expand="false">
				<!-- 以下代码为嵌入流程模板标签的代码 -->
				<c:import url="/sys/workflow/import/sysWfProcess_edit.jsp"
					charEncoding="UTF-8">
					<c:param name="formName" value="kmImissiveSignMainForm" />
					<c:param name="fdKey" value="signMainDoc" />
					<c:param name="showHistoryOpers" value="true" />
				</c:import>
				<!-- 以上代码为嵌入流程模板标签的代码 -->
				<!--发布机制开始-->
				<c:import url="/sys/news/import/sysNewsPublishMain_edit.jsp"
					charEncoding="UTF-8">
					<c:param name="formName" value="kmImissiveSignMainForm" />
					<c:param name="fdKey" value="signMainDoc" />
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
							<c:param name="formName" value="kmImissiveSignMainForm" />
							<c:param name="moduleModelName" value="com.landray.kmss.km.imissive.model.KmImissiveSignMain" />
						</c:import>
					</table>
				</ui:content>
				<!-- 权限机制 -->
			</ui:tabpage>
		</html:form>
<script language="JavaScript">
	$KMSSValidation(document.forms['kmImissiveSignMainForm']);
</script>
<%@ include file="/km/imissive/cookieUtil_script.jsp"%>
<script language="JavaScript">
$(document).ready(function(){
	<c:if  test="${kmImissiveSignMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.modifyDocNum =='true' and kmImissiveSignMainForm.method_GET=='add'}">
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
		 if(getValueFromCookie("${fdNoId}")){
				docNum.value = getValueFromCookie("${fdNoId}");
			    tempDocNum=getValueFromCookie("${fdNoId}");
			    document.getElementById("docnum").innerHTML = getValueFromCookie("${fdNoId}");
			    if(Attachment_ObjectInfo['editonline']){
			           Attachment_ObjectInfo['editonline'].setBookmark('docnum',getValueFromCookie("${fdNoId}"));
			    }
			}else{
			    var url="${KMSS_Parameter_ContextPath}km/imissive/km_imissive_sign_main/kmImissiveSignMain.do?method=generateNumByNumberId"; 
				 $.ajax({     
		  	     type:"post",     
		  	     url:url,     
		  	     data:{fdNumberId:"${fdNoId}",fdId:"${kmImissiveSignMainForm.fdId}"},   
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
		  		  document.cookie=("${fdNoId}="+results['docNum']);
		  		}    
		      });
		}
   }
}
//文件编号
function generateFileNum(){
	        var docNum = document.getElementsByName("fdDocNum")[0];
		    path=Com_GetCurDnsHost()+Com_Parameter.ContextPath+'km/imissive/km_imissive_sign_main/kmImissiveNum.jsp?fdId=${kmImissiveSignMainForm.fdId}&fdNumberId=${fdNoId}&tempDocNum='+encodeURI(tempDocNum);
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
</script>
</template:replace>
<template:replace name="nav">
	<!-- 关联机制 -->
		<c:import url="/sys/relation/import/sysRelationMain_edit.jsp" charEncoding="UTF-8">
		   <c:param name="formName" value="kmImissiveSignMainForm" />
	    </c:import>
	<!-- 关联机制 -->
</template:replace>
</template:include>
