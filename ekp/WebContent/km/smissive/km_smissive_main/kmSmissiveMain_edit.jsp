<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ include file="/km/smissive/script.jsp"%>
<%@page import="com.landray.kmss.km.smissive.util.KmSmissiveConfigUtil"%>
<script>
	Com_IncludeFile("doclist.js|dialog.js|calendar.js|optbar.js|jquery.js|popwin.js");
</script>
<script language="JavaScript">
	Com_NewFileFromSimpleCateory('com.landray.kmss.km.smissive.model.KmSmissiveTemplate','<c:url value="/km/smissive/km_smissive_main/kmSmissiveMain.do" />?method=add&categoryId=!{id}&fdTemplateName=!{name}');
</script>
<script>
	function submitForm(method, status){
		//alert("submit form");
		submitTagApp();
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
	window.onload = function(){
		//returnContent();
		setTimeout("Doc_SetCurrentLabel('Label_Tabel', 1, true);", 500);	
		setTimeout("checkBookMarks();", 600);
		//checkBookMarks();
	}
</script>
<html:form action="/km/smissive/km_smissive_main/kmSmissiveMain.do" onsubmit="return validateKmSmissiveMainForm(this);">
<div id="optBarDiv">
	
	<%-- 暂存 --%> 
	<c:if test="${kmSmissiveMainForm.method_GET=='add'}">
		<input type=button
			value="<bean:message bundle="km-smissive" key="smissive.button.store"/>"
			onclick="if(addBookMarks())submitForm('save','10');">
		<input type=button value="<bean:message key="button.submit"/>"
			onclick="if(addBookMarks())submitForm('save','20');">
	</c:if>
	
	<c:if test="${kmSmissiveMainForm.method_GET=='edit' && (kmSmissiveMainForm.docStatus=='10' || kmSmissiveMainForm.docStatus=='11')}">
	 <%-- 编辑 --%>
		<input type=button
			value="<bean:message bundle="km-smissive" key="smissive.button.store"/>"
			onclick="if(addBookMarks())submitForm('update','10');">
		<input type=button value="<bean:message key="button.submit"/>"
			onclick="if(addBookMarks())submitForm('update','20');">
	</c:if>
	<c:if test="${kmSmissiveMainForm.method_GET=='edit'&& kmSmissiveMainForm.docStatus!='10' && kmSmissiveMainForm.docStatus!='11'}">
		<input type=button value="<bean:message key="button.submit"/>"
			onclick="if(addBookMarks())submitForm('update');">
	</c:if>
	
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle">
<font size="4">
<html:text property="fdTitle" style="width:200;font-size:12pt;color:blue;font-weight:bold;"/>
</font>
</p>

<center>
<html:hidden property="fdId"/>
<html:hidden property="fdTemplateId"/>
<html:hidden property="docStatus" />
<html:hidden property="docPublishTime" />
<html:hidden property="fdFileNo"/>
<html:hidden property="fdFlowFlag"/>

<table id="Label_Tabel" width="95%" LKS_LabelDefaultIndex="1" LKS_OnLabelSwitch="switchLabelEvent">

<tr	LKS_LabelName="<bean:message bundle="km-smissive" key="kmSmissiveMain.label.baseinfo" />"><td>
	<table class="tb_normal" width=100%>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docSubject"/>
			</td><td width=85% colspan="3">
				<html:text property="docSubject" style="width:90%" />
				<span class="txtstrong">*</span>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docAuthorId"/>
			</td><td width=35%>
				<html:hidden property="docAuthorId" />
				<html:text property="docAuthorName"	styleClass="inputsgl" readonly="true" />
				<a href="javascript:void(0)"
					onclick="Dialog_Address(false, 'docAuthorId','docAuthorName', ';', ORG_TYPE_PERSON);"><bean:message key="dialog.selectOrg" /></a>
				<span class="txtstrong">*</span>
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docCreateTime"/>
			</td><td width=35%>
				${kmSmissiveMainForm.docCreateTime }
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
				${kmSmissiveMainForm.fdTemplateName }
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdFileNo"/>
			</td><td width=35%>
				<c:choose>
					<c:when test="${kmSmissiveMainForm.docStatus == '30'}">
						${kmSmissiveMainForm.fdFileNo }
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
				<bean:message  bundle="km-smissive" key="kmSmissiveMainProperty.fdPropertyId"/>
			</td><td width=35% colspan="3">
				<html:hidden property="docPropertyIds"/>
				<html:text	property="docPropertyNames" readonly="true" styleClass="inputsgl" style="width:90%;"  />
				<a	href="javascript:void(0)"
				onclick="Dialog_property(true, 'docPropertyIds','docPropertyNames', ';', ORG_TYPE_PERSON);">
				<bean:message key="dialog.selectOrg" /> 
				</a>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdMainDeptId"/>
			</td><td width=35%>
				<html:hidden property="fdMainDeptId" />
				<html:text property="fdMainDeptName" styleClass="inputsgl" readonly="true" />
				<a href="javascript:void(0)"
				onclick="Dialog_Address(false, 'fdMainDeptId','fdMainDeptName', ';', ORG_TYPE_ORGORDEPT);"><bean:message key="dialog.selectOrg" /></a>
				<span class="txtstrong">*</span>
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docDeptId"/>
			</td><td width=35%>
				<html:hidden property="docDeptId"/>
				${kmSmissiveMainForm.docDeptName }
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdSendDeptId"/>
			</td><td colspan="3" width=35%>
				<html:hidden property="fdSendDeptIds" />
				<html:textarea property="fdSendDeptNames" readonly="true" style="width:90%;height:90px" styleClass="inputmul" />
				
				<a href="javascript:void(0)"
				onclick="Dialog_Address(true, 'fdSendDeptIds','fdSendDeptNames', ';', ORG_TYPE_ORGORDEPT);">
				<bean:message key="dialog.selectOrg" /></a>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdCopyDeptId"/>
			</td><td colspan="3" width=35%>
				<html:hidden property="fdCopyDeptIds" />
				<html:textarea property="fdCopyDeptNames" readonly="true" style="width:90%;height:90px" styleClass="inputmul" />				
				<a href="javascript:void(0)"
				onclick="Dialog_Address(true, 'fdCopyDeptIds','fdCopyDeptNames', ';', ORG_TYPE_ORGORDEPT);">
				<bean:message key="dialog.selectOrg" /></a>
			</td>
			
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdIssuerId"/>
			</td><td width=35%>
				<html:hidden property="fdIssuerId" />
				<html:text property="fdIssuerName"	styleClass="inputsgl" readonly="true" />
				<a href="javascript:void(0)"
					onclick="Dialog_Address(false, 'fdIssuerId','fdIssuerName', ';', ORG_TYPE_PERSON);">
				<bean:message key="dialog.selectOrg" />
				</a>
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docCreatorId"/>
			</td><td width=35%>
				${kmSmissiveMainForm.docCreatorName }
			</td>
		</tr>
		
		<!-- 标签机制 -->
		<c:import url="/sys/tag/include/sysTagMain_edit.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmSmissiveMainForm" />
			<c:param name="fdKey" value="smissiveDoc" /> 
			<c:param name="modelName" value="com.landray.kmss.km.smissive.model.KmSmissiveMain" />
			<c:param name="fdQueryCondition" value="fdTemplateId" /> 
		</c:import>
		<!-- 标签机制 -->	
		
		<c:if test="${kmSmissiveMainForm.method_GET=='add' }">
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
		</c:if>
		
	</table>
</td></tr>

	<!-- 其他机制 -->
	<%-- 以下代码为在线编辑的代码 --%>
	<tr	LKS_LabelName="<bean:message  bundle="km-smissive" key="kmSmissiveMain.label.content"/>">
	<td>
			<table class="tb_normal" width="100%">
				<tr>
					<td colspan="2">
					<div id="missiveButtonDiv" style="text-align:right">
							&nbsp;&nbsp;<input class="btnopt" type=button
								   value="<bean:message key="kmSmissiveMain.bookMarks.title" bundle="km-smissive"/>"
								   onclick="Com_OpenWindow(Com_Parameter.ContextPath+'km/smissive/bookMarks.jsp','_blank','height=550,width=450');"/>
							
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
							value="docSubject:${kmSmissiveMainForm.docSubject},docAuthorName:${kmSmissiveMainForm.docAuthorName},fdUrgency:${kmSmissiveMainForm.fdUrgency},fdTemplateName:${kmSmissiveMainForm.fdTemplateName},docCreateTime:${kmSmissiveMainForm.docCreateTime},fdSecret:${kmSmissiveMainForm.fdSecret},fdFileNo:${kmSmissiveMainForm.fdFileNo},fdMainDeptName:${kmSmissiveMainForm.fdMainDeptName},fdSendDeptNames:${kmSmissiveMainForm.fdSendDeptNames},fdCopyDeptNames:${kmSmissiveMainForm.fdCopyDeptNames},fdIssuerName:${kmSmissiveMainForm.fdIssuerName},docCreatorName:${kmSmissiveMainForm.docCreatorName}" />
				<c:param
								name="buttonDiv"
								value="missiveButtonDiv" />
				<c:param name="showDefault" value="true"/>
				<c:param name="isToImg" value="<%=KmSmissiveConfigUtil.isToImg()%>"/>
				</c:import>
			</td></tr>
			<tr>
			<td class="td_normal_title" width="15%">
			<bean:message  bundle="km-smissive" key="kmSmissiveMain.main.att"/>
			</td>
			<td width=85% colspan="3">
			<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp"
				charEncoding="UTF-8">
				<c:param name="fdKey" value="mainAtt" />
			</c:import>
			</td>
		</tr>
			</table>
			</td>
		</tr>
		<%-- <c:choose>
		<c:when test="${kmSmissiveMainForm.method_GET=='add' }">
			<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp"
					charEncoding="UTF-8">
					<c:param name="fdKey" value="mainOnline" />
					<c:param name="fdAttType" value="office" />
					<c:param name="fdModelId" value="${kmSmissiveMainForm.fdId}"/>
					<c:param name="fdModelName" value="com.landray.kmss.km.smissive.model.KmSmissiveMain"/>
					<c:param name="templateBeanName" value="kmSmissiveTemplateForm"/>
					<c:param name="fdTemplateKey" value="mainContent"/>
					
			</c:import>
		</c:when>
		<c:otherwise>
			<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp"
					charEncoding="UTF-8">
					<c:param name="fdKey" value="mainOnline" />
					<c:param name="fdAttType" value="office" />
			</c:import>
		</c:otherwise>
		</c:choose>--%>
	
	<%-- 以上代码为在线编辑的代码 --%>
	
	<%-- 以下代码为嵌入关联机制的代码 --%>
	<tr
		LKS_LabelName="<bean:message bundle="sys-relation" key="sysRelationMain.tab.label" />">
		<c:set var="mainModelForm" value="${kmSmissiveMainForm}"
			scope="request" />
		<c:set var="currModelName" value="com.landray.kmss.km.smissive.model.KmSmissiveMain" 
			scope="request"/>
		<td>
		<%@ include	file="/sys/relation/include/sysRelationMain_edit.jsp"%></td>
	</tr>
	<%-- 以上代码为嵌入关联机制的代码 --%>

	<%-- 以下代码为嵌入流程模板标签的代码 --%>
	<c:import url="/sys/workflow/include/sysWfProcess_edit.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="kmSmissiveMainForm" />
		<c:param name="fdKey" value="smissiveDoc" />
	</c:import>
	<%-- 以上代码为嵌入流程模板标签的代码 --%>
	
	<%---发布机制 开始---%>
	<c:import url="/sys/news/include/sysNewsPublishMain_edit.jsp" charEncoding="UTF-8">
		<c:param name="formName" value="kmSmissiveMainForm" />
		<c:param name="fdKey" value="smissiveDoc" />
		<c:param name="isShow" value="true" /><%--是否显示--%>
	</c:import>
	<%---发布机制 结束---%>

	<%-- 以下代码为嵌入权限的代码 --%>
	<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />"><td>
		<table class="tb_normal" width=100%>
			<c:import url="/sys/right/right_edit.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmSmissiveMainForm" />
				<c:param name="moduleModelName" value="com.landray.kmss.km.smissive.model.KmSmissiveMain" />
			</c:import>
		</table>
	</td></tr>
	<%-- 以上代码为嵌入权限的代码 --%>


</table>

</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="kmSmissiveMainForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>

<script language="javascript" for="window" event="onload">
	//var obj = document.getElementsByName("mainContent_bookmark");	//公司产品JS库有问题，其中生成的按钮没有ID属性，导致ie6不能够用该语句查找
	//obj[0].style.display = "none";
	var tt = document.getElementsByTagName("INPUT");
	
	for(var i=0;i<tt.length;i++){
		
		if(tt[i].name == "mainOnline_printPreview"){
			tt[i].style.display = "none";
		}
		
	}
	 
	// 将焦点移动到Label_Tabel上
	$(document).ready(function(){
		$('#Label_Tabel').focus();
		$(document).scrollTop(0);
	});
	 
	
</script>