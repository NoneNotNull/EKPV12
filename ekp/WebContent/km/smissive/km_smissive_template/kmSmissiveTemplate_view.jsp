<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
	function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<div id="optBarDiv">
		<kmss:auth requestURL="/km/smissive/km_smissive_template/kmSmissiveTemplate.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('kmSmissiveTemplate.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
		<kmss:auth requestURL="/km/smissive/km_smissive_template/kmSmissiveTemplate.do?method=delete&fdId=${param.fdId}" requestMethod="GET">
			<input type="button"
				value="<bean:message key="button.delete"/>"
				onclick="if(!confirmDelete())return;Com_OpenWindow('kmSmissiveTemplate.do?method=delete&fdId=${param.fdId}','_self');">
		</kmss:auth>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="km-smissive" key="table.kmSmissiveTemplate"/></p>
<center>

<table id="Label_Tabel" width="95%">
	<%-- 类别 --%>
	<c:import url="/sys/simplecategory/include/sysCategoryMain_view.jsp" charEncoding="UTF-8">
		<c:param name="formName" value="kmSmissiveTemplateForm" />
		<c:param name="fdModelName" value="com.landray.kmss.km.smissive.model.KmSmissiveTemplate" />
	</c:import>
	
	<tr LKS_LabelName="<bean:message bundle="km-smissive" key="kmSmissiveTemplate.label.baseinfo" />"><td>
	
		<table class="tb_normal" width=95%>
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdCodePre"/>
				</td><td width=85% colspan="3">
					${kmSmissiveTemplateForm.fdCodePre}
				</td>
			</tr>
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdYear"/>
				</td><td width=35%>
					${kmSmissiveTemplateForm.fdYear}
				</td>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdCurNo"/>
				</td><td width=35%>
					${kmSmissiveTemplateForm.fdCurNo}
				</td>
			</tr>
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdTmpTitle"/>
				</td><td width=85% colspan="3">
					${kmSmissiveTemplateForm.fdTmpTitle}
				</td>
			</tr>
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdTmpUrgency"/>
				</td><td width=35%>
					<sunbor:enumsShow value="${kmSmissiveTemplateForm.fdTmpUrgency}" 
					enumsType="km_smissive_urgency" bundle="km-smissive" />
				</td>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdTmpSecret"/>
				</td><td width=35%>
					<html:text property="fdTmpSecret"/>
					<sunbor:enumsShow value="${kmSmissiveTemplateForm.fdTmpSecret}" 
					enumsType="km_smissive_secret" bundle="km-smissive" />
				</td>
			</tr>
			
			
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdTmpMainDept"/>
				</td><td width=35%>
					${kmSmissiveTemplateForm.fdTmpMainDeptName}
				</td>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdTmpSendDept"/>
				</td><td width=35%>
					${kmSmissiveTemplateForm.fdTmpSendDeptNames}
				</td>
			</tr>
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdTmpCopyDept"/>
				</td><td width=35%>
					${kmSmissiveTemplateForm.fdTmpCopyDeptNames}
				</td>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdTmpIssuer"/>
				</td><td width=35%>
					${kmSmissiveTemplateForm.fdTmpIssuerName}
				</td>
			</tr>
			
			
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.fdTmpFlowFlag"/>
				</td><td width=85% colspan="3">
					${kmSmissiveTemplateForm.fdTmpFlowFlag}
				</td>
			</tr>
			
			<!-- 标签机制 -->
			<c:import url="/sys/tag/include/sysTagTemplate_view.jsp"
				charEncoding="UTF-8">
				<c:param name="formName" value="kmSmissiveTemplateForm" />
				<c:param name="fdKey" value="smissiveDoc" /> 
			</c:import>
			<!-- 标签机制 -->

			<tr>
				<td class="td_normal_title" width="15%">
				<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.main.att"/>
				</td>
				<td width=85% colspan="3">
				<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
					charEncoding="UTF-8">
					<c:param name="fdKey" value="rattachment" />
					<c:param name="formBeanName" value="kmSmissiveTemplateForm" />
				</c:import>
				</td>
			</tr>
			
		</table>
	
	</td></tr>
	
	<!-- 加入机制 -->
	<%-- 以下代码为在线编辑的代码 --%>
	<tr	LKS_LabelName="<bean:message  bundle="km-smissive" key="kmSmissiveTemplate.label.content"/>">
		<td>
			<table
				class="tb_normal"
				width="100%">
				<tr>
					<td>
						<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
							<c:param
								name="fdKey"
								value="mainContent" />
							<c:param
								name="fdAttType"
								value="office" />
							<c:param
								name="fdModelId"
								value="${kmSmissiveTemplateForm.fdId}" />
							<c:param 
								name="isTemplate"
								value="true"/>
							<c:param
								name="formBeanName"
								value="kmSmissiveTemplateForm" />
						</c:import>
					</td>
				</tr>
			</table>
		<%-- <c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
				charEncoding="UTF-8">
				<c:param name="fdKey" value="mainContent" />
				<c:param name="fdAttType" value="office" />
				<c:param name="formBeanName" value="kmSmissiveTemplateForm" />
		</c:import>--%>
	</td></tr>
	<%-- 以上代码为在线编辑的代码 --%>
		
	<%-- 以下代码为嵌入流程模板标签的代码 --%>
	<c:import url="/sys/workflow/include/sysWfTemplate_view.jsp"
			charEncoding="UTF-8">
		<c:param name="formName" value="kmSmissiveTemplateForm" />
		<c:param name="fdKey" value="smissiveDoc" />
		<c:param name="fdModelName" value="com.landray.kmss.km.smissive.model.KmSmissiveTemplate" />
		<c:param name="messageKey" value="km-smissive:kmSmissive.label.flow" />
	</c:import>
	<%-- 以上代码为嵌入流程模板标签的代码 --%>
	
	<%-- 以下代码为嵌入默认权限模板标签的代码 --%>
	<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />"><td>
		<table class="tb_normal" width=100%>
			<c:import url="/sys/right/tmp_right_view.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmSmissiveTemplateForm" />
				<c:param name="moduleModelName" value="com.landray.kmss.km.smissive.model.KmSmissiveTemplate" />
			</c:import>
		</table>
	</td></tr>
	<%-- 以上代码为嵌入默认权限模板标签的代码 --%>
	
	<%----发布机制开始--%>
	<c:import url="/sys/news/include/sysNewsPublishCategory_view.jsp" charEncoding="UTF-8">
		<c:param name="formName" value="kmSmissiveTemplateForm" />
		<c:param name="fdKey" value="smissiveDoc" /> 
		<c:param name="messageKey" value="km-smissive:kmSmissiveTemplate.label.publish" />
	</c:import>
	<%----发布机制结束--%>
	
</table>

</center>
<%@ include file="/resource/jsp/view_down.jsp"%>