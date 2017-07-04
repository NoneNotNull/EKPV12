<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.landray.kmss.km.smissive.util.KmSmissiveConfigUtil"%>
<template:include ref="default.edit" sidebar="auto">
	<template:replace name="title">
		<c:choose>
			<c:when test="${ kmSmissiveMainForm.method_GET == 'add' }">
				<c:out value="${lfn:message('km-smissive:kmSmissiveMain.create.title') } - ${ lfn:message('km-smissive:table.kmSmissiveMain') }"></c:out>	
			</c:when>
			<c:otherwise>
				<c:out value="${kmSmissiveMainForm.docSubject} - ${ lfn:message('km-missive:table.kmSmissiveMain') }"></c:out>
			</c:otherwise>
		</c:choose>
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar  id="toolbar" layout="sys.ui.toolbar.float"> 
		<%@ include file="/km/smissive/script.jsp"%>
			<%-- 暂存 --%> 
		<c:if test="${kmSmissiveMainForm.method_GET=='add'}">
		    <ui:button text="${lfn:message('km-smissive:smissive.button.store') }" order="2" onclick="if(addBookMarks())submitForm('save','10');">
			</ui:button>
			 <ui:button text="${lfn:message('button.submit') }" order="2" onclick="if(addBookMarks())submitForm('save','20');">
			</ui:button>
		</c:if>
		
		<c:if test="${kmSmissiveMainForm.method_GET=='edit' && (kmSmissiveMainForm.docStatus=='10' || kmSmissiveMainForm.docStatus=='11')}">
		 <%-- 编辑 --%>
		    <ui:button text="${lfn:message('km-smissive:smissive.button.store') }" order="2" onclick="if(addBookMarks())submitForm('update','10');">
			</ui:button>
			<ui:button text="${lfn:message('button.submit') }" order="2" onclick="if(addBookMarks())submitForm('update','20');">
			</ui:button>
		</c:if>
		<c:if test="${kmSmissiveMainForm.method_GET=='edit'&& kmSmissiveMainForm.docStatus!='10' && kmSmissiveMainForm.docStatus!='11'}">
		    <ui:button text="${lfn:message('button.submit') }" order="2" onclick="if(addBookMarks())submitForm('update');">
			</ui:button>
		</c:if>
		 <ui:button text="${ lfn:message('button.close') }" order="5"  onclick="Com_CloseWindow()">
		 </ui:button>
		</ui:toolbar>
	</template:replace>
	<template:replace name="path">
			<ui:combin ref="menu.path.simplecategory">
				<ui:varParams 
					moduleTitle="${ lfn:message('km-smissive:table.kmSmissiveMain') }" 
					modulePath="/km/smissive/" 
					modelName="com.landray.kmss.km.smissive.model.KmSmissiveTemplate" 
					autoFetch="false"
					href="/km/smissive/" 
					categoryId="${kmSmissiveMainForm.fdTemplateId}" />
			</ui:combin>
	</template:replace>	
<template:replace name="content"> 
	<script>
	Com_IncludeFile("doclist.js|dialog.js|calendar.js|optbar.js|jquery.js|popwin.js");
    </script>
    <c:if test="${kmSmissiveMainForm.method_GET=='add'}">
			<script language="JavaScript">
				function changeDocCate(modeName,url,canClose) {
					if(modeName==null || modeName=='' || url==null || url=='')
						return;
					seajs.use(['sys/ui/js/dialog'],	function(dialog) {
						dialog.simpleCategoryForNewFile(modeName,url,false,
						function(rtn) {
							// 无分类状态下（一般于门户快捷操作）创建文档，取消操作同时关闭当前窗口
							if (!rtn)
								window.close();
						},null,null,"_self",canClose);
					});
				};
			
			    var _doc_create_url='/km/smissive/km_smissive_main/kmSmissiveMain.do?method=add&categoryId=!{id}';
			    if('${param.categoryId}'==''){
			   		changeDocCate('com.landray.kmss.km.smissive.model.KmSmissiveTemplate',_doc_create_url,true);
			    }
			</script>
		</c:if>
    <script>
	function submitForm(method, status){
		//alert("submit form");
		//submitTagApp();
		//00废弃 10草稿 11被驳回 20审批中 30已发布 40已过期
		if(status!=null){
			document.getElementsByName("docStatus")[0].value = status;
		}
		Com_Submit(document.kmSmissiveMainForm, method);
	}
	//解决当在新窗口打开主文档时控件显示不全问题，这里打开时即为最大化修改by张文添
	function max_window(){
		window.moveTo(0, 0);
		window.resizeTo(window.screen.availWidth, window.screen.availHeight);
	}
	max_window();
	$(document).ready(function(){
		setTimeout("checkBookMarks();", 600);
		//解决非ie下控件高度问题
		var obj = document.getElementById("JGWebOffice_mainOnline");
		if(obj){
			obj.setAttribute("height", "550px");
		}
	});
</script>
<html:form action="/km/smissive/km_smissive_main/kmSmissiveMain.do">
<p class="txttitle"><c:out value="${kmSmissiveMainForm.fdTitle}"></c:out></p>
<html:hidden property="fdId"/>
<html:hidden property="fdTitle"/>
<html:hidden property="fdTemplateId"/>
<html:hidden property="docStatus" />
<html:hidden property="docPublishTime" />
<html:hidden property="fdFileNo"/>
<html:hidden property="fdFlowFlag"/>
	<div class="lui_form_content_frame" style="padding-top:10px">
		<table class="tb_normal" width="100%">
				<tr>
					<td colspan="2">
					<div id="missiveButtonDiv" style="text-align:right;padding-bottom:5px">&nbsp;
					 <a href="javascript:void(0);" class="attbook" onclick="Com_OpenWindow(Com_Parameter.ContextPath+'km/smissive/bookMarks.jsp','_blank');">
					    <bean:message key="kmSmissiveMain.bookMarks.title" bundle="km-smissive"/>
					 </a>
					</div>
			 <%
			// 金格启用模式
				if (com.landray.kmss.sys.attachment.util.JgWebOffice.isJGEnabled()) {
					pageContext.setAttribute("sysAttMainUrl","/sys/attachment/sys_att_main/jg/sysAttMain_edit.jsp");
				} else {
					pageContext.setAttribute("sysAttMainUrl","/sys/attachment/sys_att_main/sysAttMain_edit.jsp");
				}%> 
				    <c:import url="${sysAttMainUrl}" charEncoding="UTF-8">
					<c:param name="fdKey" value="mainOnline" />
					<c:param name="fdAttType" value="office" />
					<c:param name="fdModelId" value="${kmSmissiveMainForm.fdId}" />
					<c:param name="fdModelName"
						value="com.landray.kmss.km.smissive.model.KmSmissiveMain" />
					<c:param name="fdTemplateModelId" value="${kmSmissiveMainForm.fdTemplateId}" />
					<c:param name="fdTemplateModelName"
						value="com.landray.kmss.km.smissive.model.KmSmissiveTemplate" />
					<c:param name="fdTemplateKey" value="mainContent" />
					<c:param name="templateBeanName" value="kmSmissiveTemplateForm" />
					<c:param 
								name="bookMarks" 
								value="docSubject:${kmSmissiveMainForm.docSubject},docAuthorName:${kmSmissiveMainForm.docAuthorName},fdUrgency:${kmSmissiveMainForm.fdUrgencyName},fdTemplateName:${kmSmissiveMainForm.fdTemplateName},docCreateTime:${kmSmissiveMainForm.docCreateTime},fdSecret:${kmSmissiveMainForm.fdSecretName},fdFileNo:${kmSmissiveMainForm.fdFileNo},fdMainDeptName:${kmSmissiveMainForm.fdMainDeptName},fdSendDeptNames:${kmSmissiveMainForm.fdSendDeptNames},fdCopyDeptNames:${kmSmissiveMainForm.fdCopyDeptNames},fdIssuerName:${kmSmissiveMainForm.fdIssuerName},docCreatorName:${kmSmissiveMainForm.docCreatorName}" />
					<c:param
									name="buttonDiv"
									value="missiveButtonDiv" />
					<c:param name="showDefault" value="true"/>
					<c:param name="isToImg" value="fasle"/>
					</c:import>
				</td>
				</tr>
				<tr>
				<td class="td_normal_title" width="15%">
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.main.att"/>
				</td>
				<td width=85%>
				<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp"
					charEncoding="UTF-8">
					<c:param name="fdKey" value="mainAtt" />
				</c:import>
				</td>
			 </tr>
			</table>
	</div>
	<ui:tabpage expand="false" >
		<ui:content title="${lfn:message('km-smissive:kmSmissiveMain.label.baseinfo')}" expand="true">
		<table class="tb_normal" width=100% id="Table_Main">
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docSubject"/>
			</td><td width=85% colspan="3">
				<xform:text property="docSubject" style="width:97%" />
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docAuthorId"/>
			</td><td width=35%>
			    <xform:address propertyId="docAuthorId" propertyName="docAuthorName" orgType="ORG_TYPE_PERSON"  className="inputsgl" style="width:95%" required="true" subject="${ lfn:message('km-smissive:kmSmissiveMain.docAuthorId') }"></xform:address>
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docCreateTime"/>
			</td><td width=35%>
			   <xform:datetime property="docCreateTime" dateTimeType="date" style="width:95%" showStatus="readOnly" className="inputsgl"></xform:datetime>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdUrgency"/>
			</td><td width=35%>
				<sunbor:enums property="fdUrgency"
							enumsType="km_smissive_urgency" elementType="select"
							bundle="km-smissive" />
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdSecret"/>
			</td><td width=35%>
				<sunbor:enums property="fdSecret"
							enumsType="km_smissive_secret" elementType="select"
							bundle="km-smissive" />
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdTemplateId"/>
			</td><td width=35%>
			    <c:out value="${kmSmissiveMainForm.fdTemplateName }"></c:out>
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdFileNo"/>
			</td><td width=35%>
				<c:choose>
					<c:when test="${kmSmissiveMainForm.docStatus == '30'}">
					    <c:out value="${kmSmissiveMainForm.fdFileNo }"></c:out>
					</c:when>
					<c:otherwise>
						<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdFileNo.describe"/>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<%-- 所属场所 --%>
		<c:import url="/sys/authorization/sys_auth_area/sysAuthArea_field.jsp" charEncoding="UTF-8">
             <c:param name="id" value="${kmSmissiveMainForm.authAreaId}"/>
        </c:import>	        
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdMainDeptId"/>
			</td><td width=35%>
			    <xform:address propertyId="fdMainDeptId" propertyName="fdMainDeptName"  orgType="ORG_TYPE_ORGORDEPT"  className="inputsgl" style="width:95%" required="true" subject="${ lfn:message('km-smissive:kmSmissiveMain.fdMainDeptId') }"></xform:address>
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docDeptId"/>
			</td><td width=35%>
				<html:hidden property="docDeptId"/>
				<c:out value="${kmSmissiveMainForm.docDeptName }"></c:out>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdSendDeptId"/>
			</td><td  width=35%>
			    <xform:address propertyId="fdSendDeptIds" propertyName="fdSendDeptNames" textarea="true" orgType="ORG_TYPE_ORGORDEPT" mulSelect="true" style="width:95%;height:90px"  className="inputmul"></xform:address>
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdCopyDeptId"/> 
			</td><td width=35%>
			    <xform:address propertyId="fdCopyDeptIds" propertyName="fdCopyDeptNames" textarea="true" orgType="ORG_TYPE_ORGORDEPT" mulSelect="true" style="width:95%;height:90px"  className="inputmul"></xform:address>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdIssuerId"/>
			</td><td width=35%>
			    <xform:address propertyId="fdIssuerId" propertyName="fdIssuerName" orgType="ORG_TYPE_PERSON" className="inputsgl" style="width:95%"></xform:address>
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docCreatorId"/>
			</td><td width=35%>
			   <c:out value="${kmSmissiveMainForm.docCreatorName }"></c:out>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMainProperty.fdPropertyId"/>
			</td><td width=85% colspan="3">
				<xform:dialog style="width:97%;" propertyId="docPropertyIds" propertyName="docPropertyNames">
					Dialog_property(true, 'docPropertyIds','docPropertyNames', ';', ORG_TYPE_PERSON);
				</xform:dialog>
			</td>
		</tr>
		<!-- 标签机制 -->
		<c:import url="/sys/tag/import/sysTagMain_edit.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="kmSmissiveMainForm" />
			<c:param name="fdKey" value="smissiveDoc" /> 
			<c:param name="modelName" value="com.landray.kmss.km.smissive.model.KmSmissiveMain" />
			<c:param name="fdQueryCondition" value="fdTemplateId" /> 
		</c:import>
		<!-- 标签机制 -->	
		<c:if test="${kmSmissiveMainForm.method_GET=='add' }">
		<!-- 
			<tr>
				<td	class="td_normal_title"	width="15%">
				<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.main.att"/>
				</td>
				<td width="85%" colspan="3">
				<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
					charEncoding="UTF-8">
					<c:param name="fdKey" value="rattachment" />
					<c:param name="formBeanName" value="kmSmissiveTemplateForm" />
				</c:import>
				</td>
			</tr>
			-->
		</c:if>
		</table>
		</ui:content>
	<%-- 以下代码为嵌入流程模板标签的代码 --%>
	  <c:import url="/sys/workflow/import/sysWfProcess_edit.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmSmissiveMainForm" />
			<c:param name="fdKey" value="smissiveDoc" />
	   </c:import>
	<%-- 以上代码为嵌入流程模板标签的代码 --%>
	<%---发布机制 开始---%>
	<c:import url="/sys/news/import/sysNewsPublishMain_edit.jsp" charEncoding="UTF-8">
		<c:param name="formName" value="kmSmissiveMainForm" />
		<c:param name="fdKey" value="smissiveDoc" />
		<c:param name="isShow" value="true" /><%--是否显示--%>
	</c:import>
	<%---发布机制 结束---%>
	<c:import url="/sys/right/import/right_edit.jsp" charEncoding="UTF-8">
		<c:param name="formName" value="kmSmissiveMainForm" />
		<c:param name="moduleModelName" value="com.landray.kmss.km.smissive.model.KmSmissiveMain" />
	</c:import>
	</ui:tabpage>
	<html:hidden property="method_GET"/>
</html:form>
<script language="JavaScript">
			$KMSSValidation(document.forms['kmSmissiveMainForm']);
</script>
<script language="javascript" for="window" event="onload">
	//var obj = document.getElementsByName("mainContent_bookmark");	//公司产品JS库有问题，其中生成的按钮没有ID属性，导致ie6不能够用该语句查找
	//obj[0].style.display = "none";
	var tt = document.getElementsByTagName("INPUT");
	
	for(var i=0;i<tt.length;i++){
		
		if(tt[i].name == "mainOnline_printPreview"){
			tt[i].style.display = "none";
		}
		
	}
</script>
</template:replace>
<template:replace name="nav">
		<!-- 关联机制 -->
		<c:import url="/sys/relation/import/sysRelationMain_edit.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="kmSmissiveMainForm" />
	    </c:import>
		<!-- 关联机制 -->
</template:replace> 
</template:include>
