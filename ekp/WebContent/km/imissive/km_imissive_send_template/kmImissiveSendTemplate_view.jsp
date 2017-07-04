<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
window.onload = function(){
	setTimeout("Doc_SetCurrentLabel('Label_Tabel', 2, true);", 500);
	// 添加标签切换事件
	var table = document.getElementById("Label_Tabel");
	if(table != null && window.Doc_AddLabelSwitchEvent){
		Doc_AddLabelSwitchEvent(table, "aaa");
	}
};
function aaa(tableName, index){
	var trs = document.getElementById(tableName).rows;
	if(trs[index].id =="tr_content"){
		$("#missiveButtonDiv").show();
		$("#content").css({
			left:'34px',
			top:'135px',
			width:'95%',
			height:'550px'

		});
	}else{
		$("#missiveButtonDiv").hide();
		$("#content").css({
			left:'0px',
			top:'0px',
			width:'0px',
			height:'0px'

		});
	}
}
function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
<kmss:auth
	requestURL="/km/imissive/km_imissive_send_template/kmImissiveSendTemplate.do?method=edit&fdId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.edit"/>"
		onclick="Com_OpenWindow('kmImissiveSendTemplate.do?method=edit&fdId=${param.fdId}','_self');">
</kmss:auth> 
<kmss:auth
	requestURL="/km/imissive/km_imissive_send_template/kmImissiveSendTemplate.do?method=clone&cloneModelId=${param.fdId}"
	requestMethod="GET">
<input type="button" value="<kmss:message key="km-imissive:button.copy"/>"
		onclick="Com_OpenWindow('kmImissiveSendTemplate.do?method=clone&cloneModelId=${param.fdId}','_blank');">
</kmss:auth>

<kmss:auth
	requestURL="/km/imissive/km_imissive_send_template/kmImissiveSendTemplate.do?method=delete&fdId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.delete"/>"
		onclick="if(!confirmDelete())return;Com_OpenWindow('kmImissiveSendTemplate.do?method=delete&fdId=${param.fdId}','_self');">
</kmss:auth> <input type="button" value="<bean:message key="button.close"/>"
	onclick="Com_CloseWindow();"></div>
<p class="txttitle"><bean:message bundle="km-imissive"
	key="table.kmImissiveSendTemplate" /></p>
<center>
<div id="content" style="position:absolute;height: 0px;width: 0px">
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
			value="com.landray.kmss.km.imissive.model.KmImissiveSendTemplate" />
	</c:import>
</div>
<table id="Label_Tabel" width=95% LKS_LabelDefaultIndex="2">
	<tr
		LKS_LabelName="<bean:message bundle='km-imissive' key='kmImissiveSendTemplate.templateinfo'/>">
		<td><html:hidden name="kmImissiveSendTemplateForm" property="fdId" />
		<table class="tb_normal" width=100%>
			<!-- 模板名称 -->
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-imissive" key="kmImissiveSendTemplate.fdName" /></td>
				<td width=85% colspan="3"><bean:write name="kmImissiveSendTemplateForm"
					property="fdName" /></td>
			</tr>
			<!-- 适用类别 -->
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-imissive" key="kmImissiveSendTemplate.fdCatoryName" /></td>
				<td width=85% colspan="3"><bean:write name="kmImissiveSendTemplateForm"
					property="fdCategoryName" /></td>
			</tr>
			<tr>
				<!-- 排序号 -->
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-imissive" key="kmImissiveSendTemplate.fdOrder" /></td>
				<td width=35% colspan="3" >
				<bean:write name="kmImissiveSendTemplateForm" property="fdOrder" /></td>
			</tr>
			<%-- 所属场所 --%>
			<c:import url="/sys/authorization/sys_auth_area/sysAuthArea_field.jsp" charEncoding="UTF-8">
                <c:param name="id" value="${kmImissiveSendTemplateForm.authAreaId}"/>
            </c:import>	
            <!-- 审批记录可阅读者 -->
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-imissive" key="kmImissiveSendTemplate.authAppRecReaderIds" /></td>
				<td width=85% colspan="3"><bean:write name="kmImissiveSendTemplateForm"
					property="authTmpAppRecReaderNames" /></td>
			</tr>		
			<!-- 可使用者 -->
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-imissive" key="kmImissiveSendTemplate.authReaderIds" /></td>
				<td width=85% colspan="3"><bean:write name="kmImissiveSendTemplateForm"
					property="authReaderNames" /></td>
			</tr>
			<!-- 可维护者 -->
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-imissive" key="kmImissiveSendTemplate.authEditorIds" /></td>
				<td width=85% colspan="3"><bean:write name="kmImissiveSendTemplateForm"
					property="authEditorNames" /></td>
			</tr>
			<tr>
				<!-- 创建人 -->
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-imissive" key="kmImissiveSendTemplate.docCreatorId" /></td>
				<td width=35%><bean:write name="kmImissiveSendTemplateForm"
					property="docCreatorName" /></td>
			<!-- 创建时间 -->
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-imissive" key="kmImissiveSendTemplate.docCreateTime" /></td>
				<td width=35%><bean:write name="kmImissiveSendTemplateForm"
					property="docCreateTime" /></td>
			</tr>
			<c:if test="${not empty kmImissiveSendTemplateForm.docAlterorName}">
			<tr>
				<!-- 修改人 -->
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-imissive" key="kmImissiveSendTemplate.docAlterorId" /></td>
				<td width=35%><bean:write name="kmImissiveSendTemplateForm"
					property="docAlterorName" /></td>
				<!-- 修改时间 -->
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-imissive" key="kmImissiveSendTemplate.docAlterTime" /></td>
				<td width=35%><bean:write name="kmImissiveSendTemplateForm"
					property="docAlterTime" /></td>
			</tr>
			</c:if>
		</table>
		</td>
	</tr>
	<!-- 表单 -->
	<c:import url="/sys/xform/include/sysFormTemplate_view.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="kmImissiveSendTemplateForm" />
		<c:param name="fdKey" value="sendMainDoc" />
		<c:param name="fdMainModelName" value="com.landray.kmss.km.imissive.model.KmImissiveSendMain" />
		<c:param name="messageKey" value="km-imissive:kmImissiveSendTemplate.baseinfo" />
	</c:import>
	<tr id="tr_content" LKS_LabelName="<bean:message bundle="km-imissive" key="kmImissiveSendTemplate.docContent" />">
		<td id="td_content">
			<div id="missiveButtonDiv" style="text-align:right">
			</div>
		</td>
	</tr>
	<%----编号机制开始--%>
		<c:import url="/sys/number/include/sysNumberMappTemplate_view.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="kmImissiveSendTemplateForm" />
			<c:param name="modelName" value="com.landray.kmss.km.imissive.model.KmImissiveSendMain"/>
		</c:import>
	<%----编号机制结束--%>
	
	<!-- 流程 -->
	<c:import url="/sys/workflow/include/sysWfTemplate_view.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="kmImissiveSendTemplateForm" />
		<c:param name="fdKey" value="sendMainDoc" />
	</c:import>
	<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />">
		<td>
			<table class="tb_normal" width=100%>
				<c:import url="/sys/right/tmp_right_view.jsp" charEncoding="UTF-8">
					<c:param
						name="formName"
						value="kmImissiveSendTemplateForm" />
					<c:param
						name="moduleModelName"
						value="com.landray.kmss.km.imissive.model.KmImissiveSendTemplate" />
				</c:import>
			</table>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
