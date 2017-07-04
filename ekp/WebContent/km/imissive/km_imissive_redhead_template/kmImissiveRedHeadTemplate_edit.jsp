<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
Com_IncludeFile("doclist.js|dialog.js|calendar.js|optbar.js|jquery.js");
</script>
<script language="JavaScript">
window.onload = function(){
	checkEditType("${kmImissiveRedHeadTemplateForm.fdType}", null);
};
function Cate_CheckNotReaderFlag(el){
	document.getElementById("Cate_AllUserId").style.display=el.checked?"none":"";
	document.getElementById("Cate_AllUserNote").style.display=el.checked?"none":"";
	el.value=el.checked;
}
function checkEditType(value){
	var type=document.getElementsByName("fdType")[0];
	var _wordEdit = document.getElementById('wordEdit');
	var _templateDesc = document.getElementById('templateDesc');
	var _categoryDesc = document.getElementById('categoryDesc');
	var authNotReaderFlag=document.getElementsByName("authNotReaderFlag")[0];
	if(value==""){
		value = "0";
	}
	if("0" == value){
		_templateDesc.style.display = "block";
		_categoryDesc.style.display = "none";
		_wordEdit.style.display = "block";
		authNotReaderFlag.checked = "";
		authNotReaderFlag.onclick = function(){Cate_CheckNotReaderFlag(authNotReaderFlag);};
		Cate_CheckNotReaderFlag(authNotReaderFlag);
		jg_attachmentObject_editonline.load();
		jg_attachmentObject_editonline.show();
		jg_attachmentObject_editonline.ocxObj.Active(true);
	} else {
		_categoryDesc.style.display = "block";
		_templateDesc.style.display = "none";
		_wordEdit.style.display = "none";
		authNotReaderFlag.checked = "checked";
		authNotReaderFlag.onclick=function(){return false;};
		Cate_CheckNotReaderFlag(authNotReaderFlag);
	}
	type.value = value;
}

Com_Parameter.event["submit"].push(function(){
		//提交时判断是模板还是分类，如果是分类则移除页面控件对象
		var type =  document.getElementsByName("fdType");
		var flag = false;
		if(type[0].value !="0"){
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
<html:form action="/km/imissive/km_imissive_redhead_template/kmImissiveRedHeadTemplate.do">
	<c:import url="/sys/simplecategory/sys_simple_category/sysCategoryMain_edit_button.jsp"
				charEncoding="UTF-8">
		<c:param name="formName" value="kmImissiveRedHeadTemplateForm" />
	</c:import>
<p class="txttitle"><bean:message  bundle="km-imissive" key="table.kmImissiveRedHeadTemplate"/></p>
<center>
<table id="Label_Tabel" width="95%">
	<tr LKS_LabelName="<bean:message bundle="km-imissive" key="kmImissiveRedHeadTemplate.template.fdName" />">
		<td>
			<table class="tb_normal" width=100%>
				<c:set var="selectEmpty" value="true" />
				<kmss:auth
					requestURL="/km/imissive/km_imissive_redhead_template/kmImissiveRedHeadTemplate.do?method=add"
					requestMethod="Get">
					<c:set var="selectEmpty" value="false" />
				</kmss:auth>
				 <%-- 编辑方式 --%>
				<html:hidden property="fdType" />
				<tr>
					<td class="td_normal_title" width=15%>
						类型
					</td>
					<td width="85%" colspan="3">
						<xform:radio property="fdEditType" showStatus="edit" value="${kmImissiveRedHeadTemplateForm.fdType}" onValueChange="checkEditType">
							<xform:enumsDataSource enumsType="kmImissiveRedHeadTemplate_fdType" />
						</xform:radio>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-imissive" key="kmImissiveRedHeadTemplate.fdName" /></td>
					<td colspan="3"><xform:text property="fdName" style="width:90%"  required="true"/></td>
					<html:hidden property="fdId" />
				</tr>
               <tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="km-imissive" key="kmImissiveRedHeadTemplate.fdParentName" /></td>
					<td colspan="3"><html:hidden property="fdParentId" /> <html:text
						property="fdParentName" readonly="true" styleClass="inputsgl"
						style="width:90%" /> <a href="#"
						onclick="Dialog_SimpleCategory('com.landray.kmss.km.imissive.model.KmImissiveRedHeadTemplate','fdParentId','fdParentName',false,null,'01',null,${selectEmpty},'${param.fdId}');null">
					<bean:message key="dialog.selectOther" /> </a></td>
				</tr> 
				<tr>
					<td class="td_normal_title" width=15%><bean:message bundle="km-imissive"
						key="kmImissiveRedHeadTemplate.parentMaintainer" /></td>
						<td colspan="3" id="parentMaintainerId">${parentMaintainer}</td>					 
							</tr>
							<%---更改父类时同时修改继承上级分类维护者---%>
							<script>
					function checkParentId(){
						var formObj = document.forms['kmImissiveRedHeadTemplateForm'];
						if(formObj.fdParentId.value!="" && formObj.fdParentId.value==formObj.fdId.value){
							alert('<bean:message bundle="sys-simplecategory" key="error.illegalSelected" />');
							return false;
						}else
							return true;	
					}
					Com_Parameter.event["submit"][Com_Parameter.event["submit"].length] = checkParentId;
			
					function Cate_getParentMaintainer(){				
						var parameters ="parentId="+document.getElementsByName("fdParentId")[0].value;
						var s_url = Com_Parameter.ContextPath+"km/imissive/km_imissive_send_template/kmImissiveRedHeadTemplate.do?method=getParentMaintainer";
						$.ajax({
							url: s_url,
							type: "GET",
							data: parameters,
							dataType:"text",
							async: false,
							success: function(text){
								Com_SetInnerText(document.getElementById("parentMaintainerId"),text);
							}});
					}
				</script>
				<%-- 所属场所 --%>
                <c:import url="/sys/authorization/sys_auth_area/sysAuthArea_field.jsp" charEncoding="UTF-8">
                    <c:param name="id" value="${kmImissiveRedHeadTemplate.authAreaId}"/>
                </c:import> 
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						key="model.fdOrder" /></td>
					<td colspan="3"><html:text property="fdOrder" /></td>			
				</tr>	
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						key="model.tempEditorName" /></td>
					<td colspan="3"><html:hidden  property="authEditorIds"/><html:textarea property="authEditorNames" style="width:90%" rows="4" readonly="true" styleClass="inputmul"/>
					<a href="#" onclick="Dialog_Address(true, 'authEditorIds', 'authEditorNames', ';', null);">
						<bean:message key="dialog.selectOrg"/>
					</a>
					<div class="description_txt">
					<bean:message bundle="sys-simplecategory" key="description.main.tempEditor" />
					</div>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						key="model.tempReaderName" /></td>
					<td colspan="3">
					<input type="checkbox"  name="authNotReaderFlag" value="${sysSimpleCategoryMain.authNotReaderFlag}" onclick="Cate_CheckNotReaderFlag(this);" 
					<c:if test="${sysSimpleCategoryMain.authNotReaderFlag eq 'true'}">checked</c:if>>
					<bean:message bundle="sys-simplecategory" key="description.main.tempReader.notUse" />
					<div id="Cate_AllUserId">
					<html:hidden  property="authReaderIds"/><html:textarea property="authReaderNames" style="width:90%" rows="4" readonly="true" styleClass="inputmul"/>
					<a href="#" onclick="Dialog_Address(true, 'authReaderIds', 'authReaderNames', ';', null);">
						<bean:message key="dialog.selectOrg"/>
					</a>
					</div>
					<div id="Cate_AllUserNote">
					<bean:message bundle="sys-simplecategory" key="description.main.tempReader.allUse" />
					</div>
					</td>
				</tr>
				<tr>
	              <td  width="15%" class="td_normal_title" valign="top">
	                      <bean:message  bundle="km-imissive" key="kmImissiveRedHeadTemplate.fdDesc"/> 
	              </td>
	              <td width="85%" colspan="3">
	                <html:textarea property="fdDesc" style="width:90%;height:90px" 	styleClass="inputmul" />
	              </td>
                </tr>
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						key="model.fdCreator" /></td>
					<td width=35%><bean:write name="kmImissiveRedHeadTemplateForm" property="docCreatorName"/></td>
					<td class="td_normal_title" width=15%><bean:message
						key="model.fdCreateTime" /></td>
					<td width=35%><bean:write name="kmImissiveRedHeadTemplateForm" property="docCreateTime"/></td>			
				</tr>
				<c:if test="${kmImissiveRedHeadTemplateForm.docAlterorName!=''}">
					<tr>
						<td class="td_normal_title" width=15%><bean:message
							key="model.docAlteror" /></td>
						<td width=35%><bean:write name="kmImissiveRedHeadTemplateForm" property="docAlterorName"/></td>
						<td class="td_normal_title" width=15%><bean:message
							key="model.fdAlterTime" /></td>
						<td width=35%><bean:write name="kmImissiveRedHeadTemplateForm" property="docAlterTime"/></td>
					</tr>
				</c:if>
			</table>
		</td>
	</tr>													
	<tr id="tr_content" LKS_LabelName="<bean:message bundle="km-imissive" key="kmImissiveRedHeadTemplate.docContent" />">
		<td>
			<table class="tb_normal" width="100%" id="TB_MAIN_EDITOR">
				 <tr>
				    <td class="td_normal_title" width=10%> 
				        <bean:message key="kmImissiveRedHeadTemplate.hint" bundle="km-imissive"/>
				    </td>
				    <td>
				       <div id="templateDesc" style="display:none">
				        <bean:message key="kmImissiveRedHeadTemplate.hint.content1" bundle="km-imissive"/><br>
				         <bean:message key="kmImissiveRedHeadTemplate.hint.content2" bundle="km-imissive"/><br>
				          <bean:message key="kmImissiveRedHeadTemplate.hint.content3" bundle="km-imissive"/><br>
				       </div>
				       <div id="categoryDesc" style="display:none">
				                     模板类型为分类，不需要设置套红正文
				       </div>
				    </td>
				  </tr>
				  <tr>
					 <td  colspan="2">
				     <div id="wordEdit" style="height:600px;">
						<div id="missiveButtonDiv" style="text-align:right">
						   &nbsp;
						   <a href="javascript:void(0);" class="attbook" onclick="Com_OpenWindow(Com_Parameter.ContextPath+'km/imissive/km_imissive_send_main/bookMarks.jsp','_blank');">
					       <bean:message key="kmImissive.bookMarks.title" bundle="km-imissive"/>
					       </a>
						</div>
						<div>
						<c:import url="/sys/attachment/sys_att_main/jg/sysAttMain_edit.jsp" charEncoding="UTF-8">
							<c:param name="fdKey" value="editonline" />
							<c:param name="fdAttType" value="${kmImissiveRedHeadTemplateForm.fdType}" />
							<c:param name="fdModelId" value="${kmImissiveRedHeadTemplateForm.fdId}" />
							<c:param name="fdModelName" value="com.landray.kmss.km.imissive.model.KmImissiveRedHeadTemplate" />
							<c:param name="buttonDiv" value="missiveButtonDiv" />
							<c:param name="bindSubmit" value="false"/>
							<c:param  name="isTemplate" value="true"/>
						</c:import>
					   </div>
					</div>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</center>
<script language="JavaScript">
			$KMSSValidation(document.forms['kmImissiveRedHeadTemplateForm']);
</script>
<html:hidden property="method_GET"/>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>