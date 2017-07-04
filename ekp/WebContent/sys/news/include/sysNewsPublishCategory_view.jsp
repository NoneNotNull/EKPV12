<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysNPCategory_Key" value="${param.fdKey}" />
<c:set var="sysNPCategoryFormPrefix" value="sysNewsPublishCategoryForms.${param.fdKey}." />
<c:set var="sysNPCategoryForm" value="${requestScope[param.formName].sysNewsPublishCategoryForms[param.fdKey]}" />
<tr 
	<c:if test="${empty param.messageKey}">
		LKS_LabelName='<kmss:message key="sys-news:sysNewsPublishMain.tab.publish.label"/>'
	</c:if>
	<c:if test="${not empty param.messageKey}">
		LKS_LabelName='<kmss:message key="${param.messageKey}"/>'
	</c:if>
>
<td>
<table class="tb_normal" width=100%>	 
	<c:if test="${sysNPCategoryForm.fdIsAutoPublish}">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-news" key="sysNewsPublishCategory.fdIsAutoPublish"/>
		</td>
		<td width=35% colspan=3> 
		<sunbor:enumsShow value="${sysNPCategoryForm.fdIsAutoPublish}" enumsType="common_yesno" />	 
		</td>
	</tr> 
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-news" key="sysNewsPublishCategory.fdIsFlow"/>
		</td>
		<td width=35% colspan=3>
		<sunbor:enumsShow value="${sysNPCategoryForm.fdIsFlow}" enumsType="common_yesno" />	 	 
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-news" key="sysNewsPublishCategory.fdCategoryId"/>
		</td>
		<td width=35%>
		 ${sysNPCategoryForm.fdCategoryName}
		 <c:if test="${empty sysNPCategoryForm.fdCategoryName}">
		 <bean:message  bundle="sys-news" key="sysNewsPublishCategory.fdCategoryNameIsEmpty"/>
		 </c:if>  
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-news" key="sysNewsPublishCategory.fdIsModify"/>
		</td>
		<td width=35%>
			<sunbor:enumsShow value="${sysNPCategoryForm.fdIsModifyCate}" enumsType="common_yesno" />	 	 
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-news" key="sysNewsPublishCategory.fdImportance"/>
		</td>
		<td width=35%>
		<sunbor:enumsShow value="${sysNPCategoryForm.fdImportance}" enumsType="sysNewsMain_fdImportance" bundle="sys-news" />	 	 	 
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-news" key="sysNewsPublishCategory.fdIsModify"/>
		</td>
		<td width=35%>
			<sunbor:enumsShow value="${sysNPCategoryForm.fdIsModifyImpor}" enumsType="common_yesno" />	 	 
		</td>
	</tr> 
	</c:if>
	<!-- 如果自动发布为否则不显示发布的设置 -->
   <c:if test="${!sysNPCategoryForm.fdIsAutoPublish}">
		<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-news" key="sysNewsPublishCategory.fdIsAutoPublish"/>
		</td>
		<td width=85%> 
		<sunbor:enumsShow value="false" enumsType="common_yesno" />	 
		</td>
	</tr>
	</c:if>
</table>
</td>
</tr>
	 
