<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
Com_IncludeFile("dialog.js|calendar.js|optbar.js|jquery.js");
</script>
<script>
window.onload = function(){
	//默认选中表单模式
	var method = "${kmImissiveReceiveTemplateForm.method_GET}";
	if(method == "add"){
		$('input:radio[name="sysFormTemplateForms.receiveMainDoc.fdMode"][value="1"]').parent().hide();
		$('input:radio[name="sysFormTemplateForms.receiveMainDoc.fdMode"][value="3"]').prop('checked', true);
	}
	if(method == "edit"){
		$('input:radio[name="sysFormTemplateForms.receiveMainDoc.fdMode"][value="1"]').parent().hide();
	}
	
	checkEditType("${kmImissiveReceiveTemplateForm.fdNeedContent}", null);
};
function checkEditType(value){
	var type=document.getElementsByName("fdNeedContent")[0];
	var _wordEdit = document.getElementById('wordEdit');
	if(value==""){
		value = "0";
	}
	if("1" == value){
		_wordEdit.style.display = "block";
		jg_attachmentObject_editonline.load();
		jg_attachmentObject_editonline.show();
		jg_attachmentObject_editonline.ocxObj.Active(true);
	} else {
		_wordEdit.style.display = "none";
	}
	type.value = value;
}

Com_Parameter.event["submit"].push(function(){
	//提交时判断是模板还是分类，如果是分类则移除页面控件对象
	var type =  document.getElementsByName("fdNeedContent");
	var flag = false;
		  if(type[0].value !="1"){
			 jg_attachmentObject_editonline.unLoad();
		     $("#wordEdit").remove();
		     flag = true;
	      }else{
			jg_attachmentObject_editonline.ocxObj.Active(true);
	        jg_attachmentObject_editonline._submit();
	        flag = true;
	     }
	     return flag;
	});
</script>
<html:form action="/km/imissive/km_imissive_receive_template/kmImissiveReceiveTemplate.do" onsubmit="return validateKmImissiveReceiveTemplateForm(this);">
	<div id="optBarDiv">
		<c:if test="${kmImissiveReceiveTemplateForm.method_GET=='edit'}">
			<%--更新--%>
			<input type=button value="<bean:message key="button.update"/>"
				onclick="Com_Submit(document.kmImissiveReceiveTemplateForm, 'update');">
		</c:if>
		 <c:if test="${kmImissiveReceiveTemplateForm.method_GET=='add' || kmImissiveReceiveTemplateForm.method_GET=='clone'}">
		 	<%--新增--%>
			<input type=button value="<bean:message key="button.save"/>"
				onclick="Com_Submit(document.kmImissiveReceiveTemplateForm, 'save');">
			<input type=button value="<bean:message key="button.saveadd"/>"
				onclick="Com_Submit(document.kmImissiveReceiveTemplateForm, 'saveadd');">
		</c:if> 
			<%--关闭--%>
			<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
	</div>
<p class="txttitle"><bean:message  bundle="km-imissive" key="table.kmImissiveReceiveTemplate"/></p>
<center>
<table id="Label_Tabel" width="95%" LKS_LabelDefaultIndex="2">
		<tr LKS_LabelName="<bean:message bundle='km-imissive' key='kmImissiveReceiveTemplate.templateinfo'/>">
			<td>
				<table class="tb_normal" width=100%>
					<html:hidden property="fdId" />
					<%--模板名称--%>
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imissive" key="kmImissiveReceiveTemplate.fdName" />
						</td>
						<td width=85% colspan="3">
							<html:text property="fdName" style="width:80%;" /><span class="txtstrong">*</span>
						</td>
					</tr>
					<%--适用类别--%>
					<tr>
						<td class="td_normal_title" width=15%>
							<bean:message bundle="km-imissive" key="kmImissiveReceiveTemplate.fdCatoryName" />
						</td>
						<td width=85% colspan="3">
							<html:hidden property="fdCategoryId" /> 
							<html:text property="fdCategoryName" readonly="true" styleClass="inputsgl" style="width:80%;" /> <span class="txtstrong">*</span>
							&nbsp;&nbsp;&nbsp;
							<a href="#" onclick="Dialog_Category('com.landray.kmss.km.imissive.model.KmImissiveReceiveTemplate','fdCategoryId','fdCategoryName');">
								<bean:message key="dialog.selectOther" />
							</a>
							<c:if test="${not empty noAccessCategory}">
								<script language="JavaScript">
									function closeWindows(rtnVal){
										if(rtnVal==null){
											window.close();
										}
									}
									if(!confirm("<bean:message arg0="${noAccessCategory}" key="error.noAccessCreateTemplate.alert" />")){
										window.close();
									}else{
										Dialog_Category('com.landray.kmss.km.imissive.model.KmImissiveReceiveTemplate','fdCategoryId','fdCategoryName',null,null,null,null,closeWindows, true);
									}
								</script>
							</c:if>						
						</td>
					</tr>
					<tr>
					<!-- 排序号 -->
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-imissive" key="kmImissiveReceiveTemplate.fdOrder" /></td>

					<td width=35% colspan="3" >
					   <html:text property="fdOrder" style="width:80%;" />
					</td>
				</tr>
				<%-- 所属场所 --%>
				<c:import url="/sys/authorization/sys_auth_area/sysAuthArea_field.jsp" charEncoding="UTF-8">
                     <c:param name="id" value="${kmImissiveReceiveTemplateForm.authAreaId}"/>
                </c:import>
				<!-- 可使用者 -->
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-imissive" key="kmImissiveReceiveTemplate.authReaderIds" /></td>
					<td  width=85% colspan="3"><html:hidden property="authReaderIds" /> <html:textarea
						property="authReaderNames" style="width:80%" readonly="true" /> <a
						href="#"
						onclick="Dialog_Address(true, 'authReaderIds','authReaderNames', ';',null);"><bean:message
						key="dialog.selectOther" /></a><br>
						<bean:message key="kmImissiveReceiveTemplate.tepmlateUser" bundle="km-imissive"/>
				   </td>
				</tr>
				<!-- 可维护者 -->
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-imissive" key="kmImissiveReceiveTemplate.authEditorIds" /></td>
					<td width=85% colspan="3"><html:hidden property="authEditorIds" /> <html:textarea
						property="authEditorNames" style="width:80%" readonly="true" /> <a
						href="#"
						onclick="Dialog_Address(true, 'authEditorIds','authEditorNames', ';',null);"><bean:message
						key="dialog.selectOther" /></a><br>
						<bean:message key="kmImissiveReceiveTemplate.tepmlateManager" bundle="km-imissive"/>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-imissive" key="kmImissiveReceiveTemplate.authAppRecReaderIds" /></td>
					<td width=85% colspan="3">
					<html:hidden property="authTmpAppRecReaderIds" /> 
					<html:textarea
						property="authTmpAppRecReaderNames" style="width:80%" readonly="true" /> <a
						href="#"
						onclick="Dialog_Address(true, 'authTmpAppRecReaderIds','authTmpAppRecReaderNames', ';',null);"><bean:message
						key="dialog.selectOther" /></a><br>
						<bean:message key="kmImissiveReceiveTemplate.appRecReader" bundle="km-imissive"/>
					</td>
				</tr>
				<%---新建时，不显示 创建人，创建时间 modify by zhouchao---%>
               <c:if
		         test="${kmImissiveReceiveTemplateForm.method_GET=='edit'}">
				<tr>
					<!-- 创建人员 -->
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-imissive" key="kmImissiveReceiveTemplate.docCreatorId" /></td>
					
					<td width=35%><html:text property="docCreatorName"
						readonly="true" style="width:50%;" /></td>
					<!-- 创建时间 -->
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-imissive" key="kmImissiveReceiveTemplate.docCreateTime" /></td>
					<td width=35%><html:text property="docCreateTime"
						readonly="true" style="width:50%;" /></td>
				</tr>
				<c:if test="${not empty kmImissiveReceiveTemplateForm.docAlterorName}">
				<tr>
					<!-- 修改人 -->
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-imissive" key="kmImissiveReceiveTemplate.docAlterorId" /></td>
					<td width=35%><bean:write name="kmImissiveReceiveTemplateForm"
						property="docAlterorName" /></td>
					<!-- 修改时间 -->
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-imissive" key="kmImissiveReceiveTemplate.docAlterTime" /></td>
					<td width=35%><bean:write name="kmImissiveReceiveTemplateForm"
						property="docAlterTime" /></td>
				</tr>
				</c:if>
				</c:if>
			</table>
			</td>
		</tr>
	<tr LKS_LabelName="<bean:message bundle="km-imissive" key="kmImissiveReceiveTemplate.baseinfo" />">
		<td>
			<c:import url="/sys/xform/include/sysFormTemplate_edit.jsp"
				charEncoding="UTF-8">
				<c:param name="formName" value="kmImissiveReceiveTemplateForm" />
				<c:param name="fdKey" value="receiveMainDoc" />
				<c:param name="fdMainModelName" value="com.landray.kmss.km.imissive.model.KmImissiveReceiveMain" />
				<c:param name="messageKey" value="km-imissive:kmImissiveReceiveTemplate.baseinfo" />
				<c:param name="useLabel" value="false" />
			</c:import>
		</td>
	</tr>
	<tr id="tr_content" LKS_LabelName="<bean:message bundle="km-imissive" key="kmImissiveReceiveTemplate.docContent" />">
		<td id="td_content">
		<table id="base_info" class="tb_normal" width=100%>
			<%-- 编辑方式 --%>
			<html:hidden property="fdNeedContent" />
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message key="kmImissiveReceiveTemplate.fdNeedContent" bundle="km-imissive" />
				</td>
				<td width="85%">
					<xform:radio property="fdEditType" showStatus="edit" value="${kmImissiveReceiveTemplateForm.fdNeedContent}" onValueChange="checkEditType">
						<xform:enumsDataSource enumsType="kmImissiveReceiveTemplate_fdNeedContent" />
					</xform:radio>
				</td>
			</tr>
			<tr>
				 <td  colspan="2">
			     <div id="wordEdit" style="height:600px;">
					<div id="missiveButtonDiv" style="text-align:right">
					   &nbsp;
					   <a href="javascript:void(0);" class="attbook" onclick="Com_OpenWindow(Com_Parameter.ContextPath+'km/imissive/km_imissive_receive_main/bookMarks.jsp','_blank');">
				       <bean:message key="kmImissive.bookMarks.title" bundle="km-imissive"/>
				       </a>
					</div>
					<div>
					<c:import url="/sys/attachment/sys_att_main/jg/sysAttMain_edit.jsp" charEncoding="UTF-8">
						<c:param name="fdKey" value="editonline" />
						<c:param name="fdAttType" value="${kmImissiveReceiveTemplateForm.fdNeedContent}" />
						<c:param name="fdModelId" value="${kmImissiveReceiveTemplateForm.fdId}" />
						<c:param name="fdModelName" value="com.landray.kmss.km.imissive.model.KmImissiveReceiveTemplate" />
						<c:param name="bindSubmit" value="false"/>
						<c:param name="buttonDiv" value="missiveButtonDiv" />
						<c:param  name="isTemplate" value="true"/>
					</c:import>
				  </div>
				</div>
				</td>
			</tr>
			</table>
		</td>
	</tr>
	<!-- 以下代码为嵌入流程模板标签的代码 -->
	<c:import url="/sys/workflow/include/sysWfTemplate_edit.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmImissiveReceiveTemplateForm" />
			<c:param name="fdKey" value="receiveMainDoc" />
	</c:import>
	<!-- 以上代码为嵌入流程模板标签的代码 -->
	<c:import url="/sys/number/include/sysNumberMappTemplate_edit.jsp" charEncoding="UTF-8">
		<c:param name="formName" value="kmImissiveReceiveTemplateForm" />
		<c:param name="modelName" value="com.landray.kmss.km.imissive.model.KmImissiveReceiveMain"/>
	</c:import>
	<tr LKS_LabelName="<bean:message bundle="sys-relation" key="sysRelationMain.tab.label" />">
		<c:set
			var="mainModelForm"
			value="${kmImissiveReceiveTemplateForm}"
			scope="request" />
		<c:set
			var="currModelName"
			value="com.landray.kmss.km.imissive.model.KmImissiveReceiveMain"
			scope="request" />
		<td><%@ include file="/sys/relation/include/sysRelationMain_edit.jsp"%></td>
	</tr>
	<!--发布机制开始 -->
	<c:import url="/sys/news/include/sysNewsPublishCategory_edit.jsp" 
		charEncoding="UTF-8">
		<c:param name="formName" value="kmImissiveReceiveTemplateForm" />
		<c:param name="fdKey" value="receiveMainDoc" />
	</c:import>
	<!--发布机制结束-->
	<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />">
		<td>
			<table class="tb_normal" width=100%>
				<c:import url="/sys/right/tmp_right_edit.jsp" charEncoding="UTF-8">
					<c:param
						name="formName"
						value="kmImissiveReceiveTemplateForm" />
					<c:param
						name="moduleModelName"
						value="com.landray.kmss.km.imissive.model.KmImissiveReceiveTemplate" />
				</c:import>
			</table>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="kmImissiveReceiveTemplateForm" cdata="false"
	dynamicJavascript="true" staticJavascript="false" />
<%@ include file="/resource/jsp/edit_down.jsp"%>