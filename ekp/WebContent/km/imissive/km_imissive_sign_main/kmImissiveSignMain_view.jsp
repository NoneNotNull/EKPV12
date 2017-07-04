<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.sys.attachment.util.JgWebOffice"%>
<%@page import="com.landray.kmss.km.imissive.util.KmImissiveConfigUtil"%>
<%@page import="com.landray.kmss.km.imissive.forms.KmImissiveSignMainForm"%>
<template:include ref="default.view"   sidebar="auto"> 
     <template:replace name="head">
		<link rel="Stylesheet" href="${LUI_ContextPath}/km/imissive/resource/css/att.css" />
	</template:replace>
	<template:replace name="title">
		<c:out value="${ kmImissiveSignMainForm.docSubject } - ${ lfn:message('km-imissive:module.km.imissive') }"></c:out> 
	</template:replace>
	<template:replace name="toolbar">
<%
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
			var url = Com_GetCurDnsHost()+Com_Parameter.ContextPath+'km/imissive/km_imissive_sign_main/kmImissiveSignMain.do?method=editDocNum&fdId=${param.fdId}';
		    dialog.iframe(url,"修改文号",function(rtn){
		    	 if(rtn!=null&&rtn!="cancel"){
		    	    location.reload();
		    	 }
			  },{width:500,height:300});
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
				if(data!=null && data.status==true){
					dialog.alert('归档成功');
				}else{
					dialog.alert('归档失败');
				}
			},'json');
		},
		window.Delete =function(){
	    	dialog.confirm("${lfn:message('page.comfirmDelete')}",function(flag){
		    	if(flag==true){
		    		Com_OpenWindow('kmImissiveSignMain.do?method=delete&fdId=${param.fdId}','_self');
		    	}else{
		    		return false;
			    }
		    },"warn");
	   },
	   window.filingDoc= function() {
	    	dialog.confirm("${lfn:message('km-imissive:alert.filing.msg')}",function(flag){
		    	if(flag==true){
		    		Com_OpenWindow('kmImissiveSignMain.do?method=filing&fdId=${param.fdId}','_self');
		    	}else{
		    		return;
			    }
		  },"warn");  
		}
	});
</script>

		<ui:toolbar  id="toolbar" layout="sys.ui.toolbar.float" count="5">
		<c:if test="${kmImissiveSignMainForm.fdIsFiling != true}">
			<kmss:auth requestURL="/km/imissive/km_imissive_sign_main/kmImissiveSignMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
				<c:if test="${(kmImissiveSignMainForm.docStatus!='00' && kmImissiveSignMainForm.docStatus!='30') || (kmImissiveSignMainForm.docStatus == '30') }">
					<ui:button text="${lfn:message('button.edit') }" order="4" 
					onclick="Com_OpenWindow('kmImissiveSignMain.do?method=edit&fdId=${param.fdId}&fdTemplateId=${kmImissiveSignMainForm.fdTemplateId}','_self');">
				    </ui:button>
				</c:if>
			</kmss:auth>
			<c:if test="${kmImissiveSignMainForm.docStatus=='30' and kmImissiveSignMainForm.fdIsFiling!= true}">
			<kmss:auth requestURL="/km/imissive/km_imissive_sign_main/kmImissiveSignMain.do?method=editDocNum&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${lfn:message('km-imissive:kmImissiveSignMain.editdocnum') }" order="4" 
				onclick="editDocNum();">
			    </ui:button>
			</kmss:auth>
			</c:if>
			<%-- 归档 --%>
			<c:if test="${kmImissiveSignMainForm.docStatus == '30' || kmImissiveSignMainForm.docStatus == '00'}">
			<kmss:auth
				requestURL="/km/imissive/km_imissive_sign_main/kmImissiveSignMain.do?method=filing&fdId=${param.fdId}"
				requestMethod="GET">
				<ui:button text="${lfn:message('km-imissive:button.filing') }" order="4" onclick="filingDoc();">
			    </ui:button>
			</kmss:auth>
			</c:if>
			<c:if test="${kmImissiveSignMainForm.docStatus =='20'}">
				<c:if  test="${kmImissiveSignMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.modifyDocNum =='true'}">
				    <ui:button text="${lfn:message('km-imissive:kmImissive.modifyDocNum') }" order="3"
						 onclick="generateFileNum();">
					</ui:button>
				</c:if>
			  <c:if test="${kmImissiveSignMainForm.fdNeedContent=='1' and kmImissiveSignMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.redhead =='true'}">
				<%-- 套红附加选项 --%>
				   <ui:button text="${lfn:message('km-imissive:kmImissive.redhead') }" order="2"
				     onclick="LoadHeadWordList('com.landray.kmss.km.imissive.model.KmImissiveSignMain');">
				   </ui:button>
			  </c:if>
			</c:if>
		</c:if>
		<c:if test="${kmImissiveSignMainForm.docStatus!='10'}">
				<kmss:auth
					requestURL="/km/imissive/km_imissive_sign_main/kmImissiveSignMain.do?method=print&fdId=${param.fdId}"
					requestMethod="GET">
					<ui:button text="${lfn:message('button.print') }" order="4" 
					 onclick="Com_OpenWindow('kmImissiveSignMain.do?method=print&fdId=${param.fdId}','_blank');">
				    </ui:button>
				</kmss:auth>
		</c:if>
		<kmss:auth requestURL="/km/imissive/km_imissive_sign_main/kmImissiveSignMain.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
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
			<ui:menu-item text="${ lfn:message('km-imissive:kmImissive.nav.SignManagement') }" href="/km/imissive/km_imissive_sign_main/index.jsp" target="_self"></ui:menu-item>
			<ui:menu-source autoFetch="false"
			            target="_self" 
						href="/km/imissive/km_imissive_sign_main/index.jsp#cri.q=fdTemplate:${kmImissiveSignMainForm.fdTemplateId}">
				<ui:source type="AjaxJson">
					{"url":"/sys/category/criteria/sysCategoryCriteria.do?method=path&modelName=com.landray.kmss.km.imissive.model.KmImissiveSignTemplate&categoryId=${kmImissiveSignMainForm.fdTemplateId}"} 
				</ui:source>
			</ui:menu-source>
		</ui:menu>
	</template:replace>	
	<template:replace name="content">
	<c:if test="${kmImissiveSignMainForm.docStatus =='20' and kmImissiveSignMainForm.fdNeedContent=='1'}">
		<kmss:auth requestURL="/km/imissive/km_imissive_sign_main/kmImissiveSignMain.do?method=edit&fdId=${param.fdId}" requestMethod="GET">							
			<c:set var="editStatus" value="true"/>						
		</kmss:auth>
		<c:if  test="${kmImissiveSignMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.editDocContent =='true'}">
			<c:set var="editStatus" value="true"/>
		</c:if>
		<c:if  test="${kmImissiveSignMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.redhead =='true'}">
			<c:set var="editStatus" value="true"/>
		</c:if>
		<%-- 是否展开正文 --%>
		<c:if test="${editStatus == true or !isShowImg}">
		    <c:set var="expandContent" value="true"/>
		</c:if>
	</c:if>
	<html:form action="/km/imissive/km_imissive_sign_main/kmImissiveSignMain.do">
	    <div class="lui_form_content_frame" style="padding-top:10px">
		   <c:import url="/sys/xform/include/sysForm_view.jsp"	charEncoding="UTF-8">
				<c:param name="formName" value="kmImissiveSignMainForm" />
				<c:param name="fdKey" value="signMainDoc" />
				<c:param name="messageKey" value="km-imissive:kmImissiveSignMain.baseinfo"/>
				<c:param name="useTab" value="false"/>
			</c:import>
		</div>
		<div class="lui_form_content_frame" style="padding-top:10px">
			<c:if test="${not empty kmImissiveSignMainForm.attachmentForms['attachment'].attachments}">
				<div class="lui_form_spacing"></div> 
				<div>
					<div class="lui_form_subhead"><img src="${KMSS_Parameter_ContextPath}sys/attachment/view/img/attachment.png"> ${ lfn:message('sys-doc:sysDocBaseInfo.docAttachments') }(${fn:length(kmImissiveSignMainForm.attachmentForms['attachment'].attachments)})</div>
					<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
								charEncoding="UTF-8">
						<c:param name="formBeanName" value="kmImissiveSignMainForm" />
						<c:param name="fdKey" value="attachment" />
					</c:import>
				</div> 
			</c:if>
		</div>
		<ui:tabpage expand="false">
		 <!-- 页签打开时再加载金格控件 -->
		<c:if test="${kmImissiveSignMainForm.fdNeedContent=='1'}">
		<ui:content title="正文" expand="${expandContent}">
			<%@ include file="/km/imissive/kmImissiveSignRedhead_script.jsp"%>
			<%@ include file="/km/imissive/km_imissive_sign_main/kmImissiveSignRedhead_script.jsp"%>
			<table class="tb_normal" width="100%">
				<!-- 提示信息 -->
			<%if(com.landray.kmss.sys.attachment.util.JgWebOffice.isJGEnabled()){%>
			   <c:if test="${isShowImg&&kmImissiveSignMainForm.docStatus!='20'}">
				   <tr>
				        <td class="td_normal_title" width=15%>
							<bean:message  bundle="km-imissive" key="kmMissiveMain.prompt.title"/>
						</td>
				     	<td colspan="3">
				     	  <font style="text-align:center"><bean:message  bundle="km-imissive" key="kmMissiveMain.prompt"/></font>
				        </td>
				   </tr>
			  </c:if>
			<%} %>
				<tr>
					<td colspan="4">
					    <div id="missiveButtonDiv" style="text-align:right;padding-bottom:5px">&nbsp;
					    <c:if test="${editStatus != true}">
						     <%if(JgWebOffice.isJGEnabled()&&Boolean.parseBoolean(KmImissiveConfigUtil.isShowImg())){ %>
								<c:choose>
								  <c:when test="${isIE}">
								     <a href="javascript:void(0);" class="attswich com_btn_link"
										onclick="Com_OpenWindow('kmImissiveSignMain.do?method=view&fdId=${param.fdId}&isShowImg=${isShowImg}','_self');">
									   ${lfn:message('km-imissive:missive.button.change.view') }
									 </a>
								 </c:when>
								 <c:otherwise>
								  <%if(JgWebOffice.isJGMULEnabled()){%>
									   <a href="javascript:void(0);" class="attswich com_btn_link"
										onclick="Com_OpenWindow('kmImissiveSignMain.do?method=view&fdId=${param.fdId}&isShowImg=${isShowImg}','_self');">
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
									value="${kmImissiveSignMainForm.fdId}" />
								<c:param
									name="fdModelName"
									value="com.landray.kmss.km.imissive.model.KmImissiveSignMain" />
								<c:param
									name="formBeanName"
									value="kmImissiveSignMainForm" />
								<c:param 
									name="bookMarks" 
									value="docsubject:${kmImissiveSignMainForm.docSubject},doctype:${kmImissiveSignMainForm.fdDocTypeName},docnum:${kmImissiveSignMainForm.fdDocNum},secretgrade:${kmImissiveSignMainForm.fdSecretGradeName},checker:${kmImissiveSignMainForm.fdCheckerName},emergency:${kmImissiveSignMainForm.fdEmergencyGradeName},draftdept:${kmImissiveSignMainForm.fdDraftDeptName},drafter:${kmImissiveSignMainForm.fdDrafterName},drafttime:${kmImissiveSignMainForm.fdDraftTime},content:${kmImissiveSignMainForm.fdContent},signdatecn:${kmImissiveSignMainForm.docPublishTimeUpper},signdate:${kmImissiveSignMainForm.docPublishTimeNum},printnum:${kmImissiveSignMainForm.fdPrintNum},printpagenum:${kmImissiveSignMainForm.fdPrintPageNum}" />
								<c:param name="buttonDiv" value="missiveButtonDiv" />
								<c:param name="isToImg" value="false"/>
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
									name="isLoadJG"
									value="false" />
								<c:param
									name="fdModelId"
									value="${kmImissiveSignMainForm.fdId}" />
								<c:param
									name="fdModelName"
									value="com.landray.kmss.km.imissive.model.KmImissiveSignMain" />
								<c:param
									name="formBeanName"
									value="kmImissiveSignMainForm" />
								<c:param 
									name="bookMarks"
									value="docsubject:${kmImissiveSignMainForm.docSubject},doctype:${kmImissiveSignMainForm.fdDocTypeName},docnum:${kmImissiveSignMainForm.fdDocNum},secretgrade:${kmImissiveSignMainForm.fdSecretGradeName},checker:${kmImissiveSignMainForm.fdCheckerName},emergency:${kmImissiveSignMainForm.fdEmergencyGradeName},draftdept:${kmImissiveSignMainForm.fdDraftDeptName},drafter:${kmImissiveSignMainForm.fdDrafterName},drafttime:${kmImissiveSignMainForm.fdDraftTime},content:${kmImissiveSignMainForm.fdContent},signdatecn:${kmImissiveSignMainForm.docPublishTimeUpper},signdate:${kmImissiveSignMainForm.docPublishTimeNum},printnum:${kmImissiveSignMainForm.fdPrintNum},printpagenum:${kmImissiveSignMainForm.fdPrintPageNum}" />
							  <c:param name="buttonDiv" value="missiveButtonDiv" />
							  <c:param name="isShowImg" value="${isShowImg}"/>
							</c:import>
						</c:if>
					</td>
				</tr>
			  </table>
		</ui:content>
		</c:if>
	<!-- 以下代码为嵌入流程模板标签的代码 -->
	<kmss:auth requestURL="/km/imissive/km_imissive_sign_main/kmImissiveSignMain.do?method=readViewLog&fdId=${param.fdId}" requestMethod="GET">
		<c:import url="/sys/workflow/import/sysWfProcess_view.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmImissiveSignMainForm" />
			<c:param name="fdKey" value="signMainDoc" />
			<c:param name="showHistoryOpers" value="true" />
			<c:param name="isSimpleWorkflow" value="false" />
			<c:param name="onClickSubmitButton" value="Com_Submit(document.kmImissiveSignMainForm, 'approveSign');" />
			<c:param name="isExpand" value="false" />
		</c:import>
	</kmss:auth>
	<c:import
			url="/sys/circulation/import/sysCirculationMain_view.jsp"
			charEncoding="UTF-8">
			<c:param
				name="formName"
				value="kmImissiveSignMainForm" />
		</c:import>
		<!-- -----------------------------------------传阅完------------------------------------------------------------ -->
		<!-- 发布机制开始 -->
		<c:import url="/sys/news/import/sysNewsPublishMain_view.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmImissiveSignMainForm" />
			<c:param name="fdKey" value="signMainDoc" />
		</c:import>
	<!-- 以上代码为嵌入流程模板标签的代码 -->
	<!-- 阅读机制 -->
	<c:import
		url="/sys/readlog/import/sysReadLog_view.jsp"
		charEncoding="UTF-8">
		<c:param
			name="formName"
			value="kmImissiveSignMainForm" />
	</c:import>
	<!-- 阅读机制 -->
	<!-- 权限机制-->
	<ui:content title="${ lfn:message('sys-right:right.moduleName') }">
		<table class="tb_normal" width=100%>
			<tr>
				<td class="td_normal_title" width="15%">审批意见可阅读者</td>
				<td width="85%" colspan='3'>
					<c:if test="${empty kmImissiveSignMainForm.authAppRecReaderNames}">
						<bean:message bundle="sys-right" key="right.other.person" />
					</c:if>
					<c:if test="${not empty kmImissiveSignMainForm.authAppRecReaderNames}">
						<c:out value="${kmImissiveSignMainForm.authAppRecReaderNames}"></c:out>
					</c:if>
				</td>
			</tr>
			<c:import url="/sys/right/right_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmImissiveSignMainForm" />
				<c:param name="moduleModelName" value="com.landray.kmss.km.imissive.model.KmImissiveSignMain" />
			</c:import>
		</table>
	</ui:content>
	<c:import url="/sys/bookmark/import/bookmark_bar.jsp"
			charEncoding="UTF-8">
			<c:param name="fdSubject" value="${kmImissiveSignMainForm.docSubject}" />
			<c:param name="fdModelId" value="${kmImissiveSignMainForm.fdId}" />
			<c:param name="fdModelName"
				value="com.landray.kmss.km.imissive.model.KmImissiveSignMain" />
	</c:import>
</ui:tabpage>
</html:form>
<%@ include file="/km/imissive/cookieUtil_script.jsp"%>
<script>
	Com_IncludeFile("att_dynamic.js","${KMSS_Parameter_ContextPath}km/imissive/","js",true);
</script>
<script>
$(document).ready(function(){
	<c:if  test="${kmImissiveSignMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.modifyDocNum =='true' and kmImissiveSignMainForm.docStatus=='20'}">
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
	     var url="${KMSS_Parameter_ContextPath}km/imissive/km_imissive_sign_main/kmImissiveSignMain.do?method=generateNum"; 
		 $.ajax({     
    	     type:"post",     
    	     url:url,     
    	     data:{fdDocNum:docNum.value,fdId:"${kmImissiveSignMainForm.fdId}"},    
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
//清稿
   function cleardraft(){
		var obj_ = document.getElementById("JGWebOffice_editonline");
		var rFlag = false;
		var cFlag = false;
		try {
			if(obj_){
				//标识A，表示保存底稿，否则为保存正文
				obj_.WebSetMsgByName("COMMAND","REVISIONDRAFT");
				obj_.WebSetMsgByName("_fdModelName", "com.landray.kmss.km.imissive.model.KmImissiveSignMain");
				obj_.WebSetMsgByName("_fdKey", "revisionAtt");
				obj_.WebSetMsgByName("_fdModelId","${kmImissiveSignMainForm.fdId}" );
				rFlag=obj_.WebSave(true);
				if(rFlag){
					obj_.WebSetMsgByName("COMMAND","CLEARDRAFT");
					obj_.WebSetMsgByName("_fdKey", "clearAtt");
					//删除正文痕迹
					obj_.ClearRevisions();
					cFlag=obj_.WebSave(true);
					if(rFlag){
						obj_.WebSetMsgByName("COMMAND","NODRAFT");
					//清稿成功后需要保存正文
					var saveA = document.getElementsByName("editonline_saveDraft")[0];
					if(saveA != null && saveA != undefined){
						saveA.click();
					}
					dialog.alert("清稿成功！");
					//location.reload();
					}else{
						dialog.alert("清稿失败！");
					}
				}
			}else{
				dialog.alert("请先切换阅读模式！");
			}
		} catch (e) {
			dialog.alert("清稿失败，抛异常！");
		}
   }
	
<c:if  test="${kmImissiveSignMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.modifyDocNum =='true'}">
Com_Parameter.event["submit"].push(function(){
		//操作类型为通过类型 ，才写回编号 
		if(lbpm.globals.getCurrentOperation().operation['isPassType'] == true){
		    var docNum = document.getElementsByName("fdDocNum")[0];
		    var isRepeat=true;
		    var results;
		    if(""==docNum.value){
		        alert('<bean:message bundle="km-imissive" key="kmImissiveSignMain.message.error.fdDocNum"/>');
		        return false;
		     }else{
		    	 var url="${KMSS_Parameter_ContextPath}km/imissive/km_imissive_sign_main/kmImissiveSignMain.do?method=saveDocNum"; 
		    	 $.ajax({     
		    	     type:"post",     
		    	     url:url,     
		    	     data:{fdDocNum:docNum.value,fdId:"${kmImissiveSignMainForm.fdId}"},    
		    	     async:false,    //用同步方式 
		    	     success:function(data){
				    	    results =  eval("("+data+")");
				    	    if(results['isRepeat']=="true"){
				    		    alert('<bean:message bundle="km-imissive" key="kmImissiveSignMain.message.error.fdDocNum.repeat"/>');
				    		    isRepeat = false;
				    	}
				    	  //删除cookie,避免新建每次取到同一编号
				   		 if("${fdNoId}"!=""){
				   		  delCookieByName("${fdNoId}");
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
<c:if test="${kmImissiveSignMainForm.fdNeedContent=='1' and kmImissiveSignMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.redhead =='true'}">
Com_Parameter.event["submit"].push(function(){
	   var flag = true;
	   if(""==redheadFlag){
		   flag =  confirm("当前节点有套红附加选项,还未套红,是否继续提交？");
	   }
	   return flag;
});
</c:if>

 //如果流程附加节点中有签发操作，则将签发日期和签发人写回
 <c:if  test="${kmImissiveSignMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.signature =='true'}">
 Com_Parameter.event["submit"].push(function(){
		//操作类型为通过类型，才写回
		if(lbpm.globals.getCurrentOperation().operation['isPassType'] == true){
			   var flag=true;
			    var url="${KMSS_Parameter_ContextPath}km/imissive/km_imissive_sign_main/kmImissiveSignMain.do?method=saveSignatureAndTime"; 
			   	 $.ajax({     
		    	     type:"post",     
		    	     url:url,     
		    	     data:{fdId:"${kmImissiveSignMainForm.fdId}"},    
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
			<c:param name="formName" value="kmImissiveSignMainForm" />
		</c:import>
	<!-- 关联机制 -->
</template:replace>
</template:include>
