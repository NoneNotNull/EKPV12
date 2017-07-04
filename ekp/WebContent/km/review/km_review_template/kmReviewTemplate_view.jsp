<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
function confirmDelete(msg){
	var del = confirm("<bean:message key="page.comfirmDelete"/>");
	return del;
}
</script>
<kmss:windowTitle 
	moduleKey="km-review:table.kmReviewMain" 
	subjectKey="km-review:table.kmReviewTemplate" 
	subject="${kmReviewTemplateForm.fdName}" />
<div id="optBarDiv">

<kmss:auth
	requestURL="/km/review/km_review_template/kmReviewTemplate.do?method=edit&fdId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.edit"/>"
		onclick="Com_OpenWindow('kmReviewTemplate.do?method=edit&fdId=${param.fdId}','_self');">
</kmss:auth> 
<!-- 非外部流程 -->
<c:if test="${kmReviewTemplateForm.fdIsExternal != 'true'}">			
	<kmss:auth
		requestURL="/km/review/km_review_template/kmReviewTemplate.do?method=clone&cloneModelId=${param.fdId}"
		requestMethod="GET">
	<input type="button" value="<kmss:message key="km-review:button.copy"/>"
			onclick="Com_OpenWindow('kmReviewTemplate.do?method=clone&cloneModelId=${param.fdId}','_blank');">
	</kmss:auth>
</c:if>

<kmss:auth
	requestURL="/km/review/km_review_template/kmReviewTemplate.do?method=delete&fdId=${param.fdId}"
	requestMethod="GET">
	<input type="button" value="<bean:message key="button.delete"/>"
		onclick="if(!confirmDelete())return;Com_OpenWindow('kmReviewTemplate.do?method=delete&fdId=${param.fdId}','_self');">
</kmss:auth> <input type="button" value="<bean:message key="button.close"/>"
	onclick="Com_CloseWindow();"></div>
<p class="txttitle"><bean:message bundle="km-review"
	key="table.kmReviewTemplate" /></p>
<center>
<table id="Label_Tabel" width=95%>
	<tr
		LKS_LabelName="<bean:message bundle='km-review' key='kmReviewTemplateLableName.templateInfo'/>">
		<td><html:hidden name="kmReviewTemplateForm" property="fdId" />
		<table class="tb_normal" width=100%>
			<!-- 模板名称 -->
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-review" key="kmReviewTemplate.fdName" /></td>
				<td width=85% colspan="3"><bean:write name="kmReviewTemplateForm"
					property="fdName" /> 
					<c:if test="${kmReviewTemplateForm.fdIsExternal == 'true'}">	
					     <span style="padding-left: 20px">
					         <xform:checkbox property="fdIsExternal" htmlElementProperties="id=fdIsExternal">
								   	<xform:simpleDataSource value="true"><bean:message bundle="km-review" key="kmReviewMain.fdIsExternal"/></xform:simpleDataSource>
							 </xform:checkbox>
						 </span>
				    </c:if>
				</td>
			</tr>
  <!-- 外部流程 -->
     <c:if test="${kmReviewTemplateForm.fdIsExternal == 'true'}">	
            <%--外部URL--%>
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message bundle="km-review" key="kmReviewMain.fdExternalUrl" />
				</td>
				<td width=85% colspan="3">
					<bean:write name="kmReviewTemplateForm"
						property="fdExternalUrl" />
				</td>
			</tr>
	 </c:if>		
			<!-- 适用类别 -->
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-review" key="kmReviewMain.fdCatoryName" /></td>
				<td width=85% colspan="3"><bean:write name="kmReviewTemplateForm"
					property="fdCategoryName" /></td>
			</tr>
			<%---辅助类 modify by zhouchao ---%>
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-review" key="table.sysCategoryProperty" /></td>
				<td width=85% colspan="3"><bean:write name="kmReviewTemplateForm"
					property="docPropertyNames" /></td>
			</tr>
			<tr>
				<!-- 前缀 -->
				<% if(!com.landray.kmss.sys.number.util.NumberResourceUtil.isModuleNumberEnable("com.landray.kmss.km.review.model.KmReviewMain")){ %>
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-review" key="kmReviewTemplate.fdNumberPrefix" /></td>
				<td width=35%><bean:write name="kmReviewTemplateForm"
					property="fdNumberPrefix" /></td>
				<%} %>
				<!-- 排序号 -->
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-review" key="kmReviewMain.fdOrder" /></td>
				<td width=35%
					<% if(com.landray.kmss.sys.number.util.NumberResourceUtil.isModuleNumberEnable("com.landray.kmss.km.review.model.KmReviewMain")){ %>
						colspan="3"
						<%} %>
					><bean:write name="kmReviewTemplateForm"
					property="fdOrder" /></td>
			</tr>
     <!-- 非外部流程 -->	
     <c:if test="${kmReviewTemplateForm.fdIsExternal != 'true'}">			
			<!-- 实施反馈人 -->
			<tr>
				<td class="td_normal_title" width=12%><bean:message
					bundle="km-review" key="table.kmReviewFeedback" /></td>
				<td width="33%"><bean:write name="kmReviewTemplateForm"
					property="fdFeedbackNames" /></td>
				<td class="td_normal_title" width=12%><bean:message
					bundle="km-review" key="kmReviewTemplate.fdFeedbackModify" /></td>
				<td width="33%"><c:if
					test="${kmReviewTemplateForm.fdFeedbackModify=='true'}">
					<bean:message key="message.yes" />
				</c:if> <c:if test="${kmReviewTemplateForm.fdFeedbackModify=='false'}">
					<bean:message key="message.no" />
				</c:if></td>

			</tr>
			<!-- 标题规则 -->
			<tr>
				<td class="td_normal_title" width=12%><bean:message
					bundle="km-review" key="kmReviewTemplate.titleRegulation" /></td>
				<td colspan=3><bean:write name="kmReviewTemplateForm"
					property="titleRegulationName" /></td>
			</tr>
			<!-- 关键字 -->
			<tr>
				<td class="td_normal_title" width=12%><bean:message
					bundle="km-review" key="kmReviewKeyword.fdKeyword" /></td>
				<td colspan=3><bean:write name="kmReviewTemplateForm"
					property="fdKeywordNames" /></td>
			</tr>
	</c:if>		
			<%-- 所属场所 --%>
			<c:import url="/sys/authorization/sys_auth_area/sysAuthArea_field.jsp" charEncoding="UTF-8">
                <c:param name="id" value="${kmReviewTemplateForm.authAreaId}"/>
            </c:import>			
			<!-- 可使用者 -->
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-review" key="table.kmReviewTemplateUser" /></td>
				<td width=85% colspan="3"><bean:write name="kmReviewTemplateForm"
					property="authReaderNames" /></td>
			</tr>
			<!-- 可维护者 -->
			<tr>
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-review" key="table.kmReviewTemplateEditor" /></td>
				<td width=85% colspan="3"><bean:write name="kmReviewTemplateForm"
					property="authEditorNames" /></td>
			</tr>
			<tr>
				<!-- 创建人 -->
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-review" key="kmReviewTemplate.docCreatorId" /></td>
				<td width=35%><bean:write name="kmReviewTemplateForm"
					property="docCreatorName" /></td>
			<!-- 创建时间 -->
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-review" key="kmReviewTemplate.docCreateTime" /></td>
				<td width=35%><bean:write name="kmReviewTemplateForm"
					property="docCreateTime" /></td>
			</tr>
			<c:if test="${not empty kmReviewTemplateForm.docAlterorName}">
			<tr>
				<!-- 修改人 -->
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-review" key="kmReviewTemplate.docAlteror" /></td>
				<td width=35%><bean:write name="kmReviewTemplateForm"
					property="docAlterorName" /></td>
				<!-- 修改时间 -->
				<td class="td_normal_title" width=15%><bean:message
					bundle="km-review" key="kmReviewTemplate.docAlterTime" /></td>
				<td width=35%><bean:write name="kmReviewTemplateForm"
					property="docAlterTime" /></td>
			</tr>
			</c:if>
		</table>
		</td>
	</tr>
<!-- 非外部流程 -->	
<c:if test="${kmReviewTemplateForm.fdIsExternal != 'true'}">	
	<c:if test="${kmReviewTemplateForm.fdUseForm == 'false'}">	
	<tr LKS_LabelName="<kmss:message key='km-review:kmReviewDocumentLableName.reviewContent'/>">
		<td>
		<table class="tb_normal" width=100%>
		<tr>
			<td colspan="4">
				${kmReviewTemplateForm.docContent}
			</td>
		</tr>
		</table>
		</td>
	</tr>
	</c:if>
	<c:if test="${kmReviewTemplateForm.fdUseForm == 'true' || empty kmReviewTemplateForm.fdUseForm}">
	<!-- 表单 -->
	<c:import url="/sys/xform/include/sysFormTemplate_view.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="kmReviewTemplateForm" />
		<c:param name="fdKey" value="reviewMainDoc" />
		<c:param name="fdMainModelName" value="com.landray.kmss.km.review.model.KmReviewMain" />
		<c:param name="messageKey" value="km-review:kmReviewDocumentLableName.reviewContent" />
	</c:import>
	</c:if>
	
	<%----编号机制开始--%>
	<% if(com.landray.kmss.sys.number.util.NumberResourceUtil.isModuleNumberEnable("com.landray.kmss.km.review.model.KmReviewMain")){ %>
		<c:import url="/sys/number/include/sysNumberMappTemplate_view.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="kmReviewTemplateForm" />
			<c:param name="modelName" value="com.landray.kmss.km.review.model.KmReviewMain"/>
		</c:import>
	<%} %>
	<%----编号机制结束--%>
	
	<!-- 流程 -->
	<c:import url="/sys/workflow/include/sysWfTemplate_view.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="kmReviewTemplateForm" />
		<c:param name="fdKey" value="reviewMainDoc" />
	</c:import>
	<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />">
		<td>
			<table class="tb_normal" width=100%>
				<c:import url="/sys/right/tmp_right_view.jsp" charEncoding="UTF-8">
					<c:param
						name="formName"
						value="kmReviewTemplateForm" />
					<c:param
						name="moduleModelName"
						value="com.landray.kmss.km.review.model.KmReviewTemplate" />
				</c:import>
			</table>
		</td>
	</tr>
	
	<%--
	<!--提醒机制(分类) 开始-->
	<tr LKS_LabelName="<bean:message bundle="sys-notify" key="sysNotify.remind.calendar" />">
	  <td>
		  <table class="tb_normal" width=100%>
			 <c:import url="/sys/notify/include/sysNotifyRemindCategory_view.jsp"	charEncoding="UTF-8">
				<c:param name="formName" value="kmReviewTemplateForm" />
				<c:param name="fdKey" value="reviewMainDoc" />
				<c:param name="fdPrefix" value="sysNotifyRemindCategory_view" />
			</c:import>
		  </table>
	  </td>
	</tr>
	<!--提醒机制(分类) 结束-->
	--%>
	
	<%--
	<!--日程机制(普通模块) 开始-->
	<tr LKS_LabelName="<bean:message bundle="sys-agenda" key="module.sys.agenda" />">
	  <td>
		  <table class="tb_normal" width=100%>
			 <c:import url="/sys/agenda/include/sysAgendaCategory_general_view.jsp"	charEncoding="UTF-8">
				<c:param name="formName" value="kmReviewTemplateForm" />
				<c:param name="fdKey" value="reviewMainDoc" />
				<c:param name="fdPrefix" value="sysAgendaCategory_general_view" />
			</c:import>
		  </table>
	  </td>
	</tr>
	<!--日程机制(普通模块) 结束-->
	--%>
	
	<!--日程机制(表单模块) 开始-->
	<tr LKS_LabelName="<bean:message bundle="sys-agenda" key="module.sys.agenda.syn" />">
	  <td>
		  <table class="tb_normal" width=100%>
		  	<tr>
				<td class="td_normal_title" width=15%>
			       <bean:message bundle="sys-agenda" key="module.sys.agenda.syn.time" />
				</td>
			    <td>
			    	<xform:radio property="syncDataToCalendarTime" >
						<xform:enumsDataSource enumsType="kmReviewMain_syncDataToCalendarTime" />
					</xform:radio>
			    </td>
			</tr>
			<tr>
				<td colspan="4" style="padding: 0px;">
					 <c:import url="/sys/agenda/include/sysAgendaCategory_formula_view.jsp"	charEncoding="UTF-8">
						<c:param name="formName" value="kmReviewTemplateForm" />
						<c:param name="fdKey" value="reviewMainDoc" />
						<c:param name="fdPrefix" value="sysAgendaCategory_formula_view" />
						<%--可选字段 1.syncTimeProperty:同步时机字段； 2.noSyncTimeValues:当syncTimeProperty为此值时，隐藏同步机制 --%>
						<c:param name="syncTimeProperty" value="syncDataToCalendarTime" />
						<c:param name="noSyncTimeValues" value="noSync" />
					</c:import>
				</td>
			</tr>
		  </table>
	  </td>
	</tr>
	<!--日程机制(表单模块) 结束-->
</c:if>	
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
