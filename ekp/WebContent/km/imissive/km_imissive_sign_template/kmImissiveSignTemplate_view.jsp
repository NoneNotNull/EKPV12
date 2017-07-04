<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
//解决非ie下控件高度问题
window.onload = function(){
	var obj = document.getElementById("JGWebOffice_editonline");
	if(obj){
		obj.setAttribute("height", 550);
	}
};
</script>
<div id="optBarDiv">
<kmss:auth
	requestURL="/km/imissive/km_imissive_sign_template/kmImissiveSignTemplate.do?method=edit&fdId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.edit"/>"
		onclick="Com_OpenWindow('kmImissiveSignTemplate.do?method=edit&fdId=${param.fdId}','_self');">
</kmss:auth> 

<kmss:auth
	requestURL="/km/imissive/km_imissive_sign_template/kmImissiveSignTemplate.do?method=clone&cloneModelId=${param.fdId}"
	requestMethod="GET">
<input type="button" value="<kmss:message key="km-imissive:button.copy"/>"
		onclick="Com_OpenWindow('kmImissiveSignTemplate.do?method=clone&cloneModelId=${param.fdId}','_blank');">
</kmss:auth>

<kmss:auth
	requestURL="/km/imissive/km_imissive_sign_template/kmImissiveSignTemplate.do?method=delete&fdId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.delete"/>"
		onclick="if(!confirmDelete())return;Com_OpenWindow('kmImissiveSignTemplate.do?method=delete&fdId=${param.fdId}','_self');">
</kmss:auth> <input type="button" value="<bean:message key="button.close"/>"
	onclick="Com_CloseWindow();"></div>
<p class="txttitle"><bean:message bundle="km-imissive"
	key="table.kmImissiveSignTemplate" /></p>
<center>
<table id="Label_Tabel" width=95%>
	<tr
		LKS_LabelName="<bean:message bundle='km-imissive' key='kmImissiveSignTemplate.templateinfo'/>">
		<td><html:hidden name="kmImissiveSignTemplateForm" property="fdId" />
		<table class="tb_normal" width=100%>
			<!-- 模板名称 -->
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-imissive" key="kmImissiveSignTemplate.fdName" /></td>
				<td width=85% colspan="3"><bean:write name="kmImissiveSignTemplateForm"
					property="fdName" /></td>
			</tr>
			<!-- 适用类别 -->
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-imissive" key="kmImissiveSignTemplate.fdCatoryName" /></td>
				<td width=85% colspan="3"><bean:write name="kmImissiveSignTemplateForm"
					property="fdCategoryName" /></td>
			</tr>
			<tr>
				<!-- 排序号 -->
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-imissive" key="kmImissiveSignTemplate.fdOrder" /></td>
				<td width=35% colspan="3" >
				<bean:write name="kmImissiveSignTemplateForm" property="fdOrder" /></td>
			</tr>
			<%-- 所属场所 --%>
			<c:import url="/sys/authorization/sys_auth_area/sysAuthArea_field.jsp" charEncoding="UTF-8">
                <c:param name="id" value="${kmImissiveSignTemplateForm.authAreaId}"/>
            </c:import>	
            <!-- 审批记录可阅读者 -->
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-imissive" key="kmImissiveSignTemplate.authAppRecReaderIds" /></td>
				<td width=85% colspan="3"><bean:write name="kmImissiveSignTemplateForm"
					property="authTmpAppRecReaderNames" /></td>
			</tr>		
			<!-- 可使用者 -->
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-imissive" key="kmImissiveSignTemplate.authReaderIds" /></td>
				<td width=85% colspan="3"><bean:write name="kmImissiveSignTemplateForm"
					property="authReaderNames" /></td>
			</tr>
			<!-- 可维护者 -->
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-imissive" key="kmImissiveSignTemplate.authEditorIds" /></td>
				<td width=85% colspan="3"><bean:write name="kmImissiveSignTemplateForm"
					property="authEditorNames" /></td>
			</tr>
			<tr>
				<!-- 创建人 -->
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-imissive" key="kmImissiveSignTemplate.docCreatorId" /></td>
				<td width=35%><bean:write name="kmImissiveSignTemplateForm"
					property="docCreatorName" /></td>
			<!-- 创建时间 -->
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-imissive" key="kmImissiveSignTemplate.docCreateTime" /></td>
				<td width=35%><bean:write name="kmImissiveSignTemplateForm"
					property="docCreateTime" /></td>
			</tr>
			<c:if test="${not empty kmImissiveSignTemplateForm.docAlterorName}">
			<tr>
				<!-- 修改人 -->
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-imissive" key="kmImissiveSignTemplate.docAlterorId" /></td>
				<td width=35%><bean:write name="kmImissiveSignTemplateForm"
					property="docAlterorName" /></td>
				<!-- 修改时间 -->
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-imissive" key="kmImissiveSignTemplate.docAlterTime" /></td>
				<td width=35%><bean:write name="kmImissiveSignTemplateForm"
					property="docAlterTime" /></td>
			</tr>
			</c:if>
		</table>
		</td>
	</tr>
	<!-- 表单 -->
	<c:import url="/sys/xform/include/sysFormTemplate_view.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="kmImissiveSignTemplateForm" />
		<c:param name="fdKey" value="signMainDoc" />
		<c:param name="fdMainModelName" value="com.landray.kmss.km.imissive.model.KmImissiveSignMain" />
		<c:param name="messageKey" value="km-imissive:kmImissiveSignTemplate.baseinfo" />
	</c:import>
	<c:if test="${kmImissiveSignTemplateForm.fdNeedContent=='1'}">
		<tr LKS_LabelName="<bean:message bundle="km-imissive" key="kmImissiveSignTemplate.docContent"/>">
			<td>
				<table
					class="tb_normal"
					width="100%">
					<tr>
						<td>
						<div id="missiveButtonDiv" style="text-align:right">
							&nbsp;
						   <a href="javascript:void(0);" class="attbook" onclick="Com_OpenWindow(Com_Parameter.ContextPath+'km/imissive/km_imissive_sign_main/bookMarks.jsp','_blank');">
					       <bean:message key="kmImissive.bookMarks.title" bundle="km-imissive"/>
					       </a>
						</div>
						<c:import url="/sys/attachment/sys_att_main/jg/sysAttMain_view.jsp" charEncoding="UTF-8">
							<c:param
								name="fdKey"
								value="editonline" />
							<c:param
								name="fdAttType"
								value="office" />
							<c:param
								name="fdModelId"
								value="${param.fdId}" />
							<c:param
								name="buttonDiv"
								value="missiveButtonDiv" />
							<c:param 
								name="isTemplate"
								value="true"/>
							<c:param
								name="fdModelName"
								value="com.landray.kmss.km.imissive.model.KmImissiveSignTemplate" />
						</c:import>
						</td>
					</tr>
				</table>
			</td>
		</tr>
	</c:if>
	<%----编号机制开始--%>
		<c:import url="/sys/number/include/sysNumberMappTemplate_view.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="kmImissiveSignTemplateForm" />
			<c:param name="modelName" value="com.landray.kmss.km.imissive.model.KmImissiveSignMain"/>
		</c:import>
	<%----编号机制结束--%>
	
	<!-- 流程 -->
	<c:import url="/sys/workflow/include/sysWfTemplate_view.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="kmImissiveSignTemplateForm" />
		<c:param name="fdKey" value="signMainDoc" />
	</c:import>
	<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />">
		<td>
			<table class="tb_normal" width=100%>
				<c:import url="/sys/right/tmp_right_view.jsp" charEncoding="UTF-8">
					<c:param
						name="formName"
						value="kmImissiveSignTemplateForm" />
					<c:param
						name="moduleModelName"
						value="com.landray.kmss.km.imissive.model.KmImissiveSignTemplate" />
				</c:import>
			</table>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
