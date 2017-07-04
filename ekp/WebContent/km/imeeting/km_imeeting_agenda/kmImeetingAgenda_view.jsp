<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<script>Com_IncludeFile("doclist.js");</script>
<table class="tb_normal" width=100% id="TABLE_DocList" align="center">
	<tr align="center">
		<%--序号--%> 
		<td class="td_normal_title" style="width: 5%">
			<bean:message key="page.serial"/>
		</td>
		<%--会议议题--%> 
		<td class="td_normal_title" style="width: 12%">
			<bean:message bundle="km-imeeting" key="kmImeetingAgenda.docSubject"/>
		</td>
		<%--汇报人--%> 
		<td class="td_normal_title" style="width: 8%">
			<bean:message bundle="km-imeeting" key="kmImeetingAgenda.docReporter"/>
		</td>
		<%--汇报时间--%> 
		<td class="td_normal_title" style="width: 8%">
			<bean:message bundle="km-imeeting" key="kmImeetingAgenda.docReporterTime"/>
		</td>
		<%--发布状态下，不显示所需上会、材料负责人、提交时间列--%> 
		<c:if test="${ kmImeetingMainForm.docStatusFirstDigit != '3'}">
			<style>
				#TABLE_DocList .upload_list_filename_view{
					min-width: 100px!important;
					max-width: 120px!important;
				}
			</style>
			<%--上会所需材料--%> 
			<td class="td_normal_title" style="width: 12%">
				<bean:message bundle="km-imeeting" key="kmImeetingAgenda.attachmentName"/>
			</td>
			<%--材料负责人--%> 
			<td class="td_normal_title" style="width: 8%">
				<bean:message bundle="km-imeeting" key="kmImeetingAgenda.docRespons"/>
			</td>
			<%--提交时间--%> 
			<td class="td_normal_title" style="width: 8%">
				<bean:message bundle="km-imeeting" key="kmImeetingAgenda.attachmentSubmitTime"/>
			</td>
		</c:if>
		<c:if test="${ kmImeetingMainForm.docStatusFirstDigit == '3'}">
		<%--提交的材料--%> 
		<td class="td_normal_title" style="width: 38%">
			<bean:message bundle="km-imeeting" key="kmImeetingAgenda.attachment.submit"/>
			<%--材料负责人显示上会按钮--%> 
			<c:if test="${canUpload==true }">
				<a style="margin-top: -6px;" class="lui_icon_s lui_icon_s_arrow_up"  title="上传材料" target="_blank"
					href="${LUI_ContextPath}/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=editUpdateAtt&fdId=${kmImeetingMainForm.fdId }"></a>
			</c:if>
		</td>
		</c:if>
	</tr>
	
	<%--基准行--%>
	<tr KMSS_IsReferRow="1" style="display: none">
		<td KMSS_IsRowIndex="1" width="5%" align="center"></td>
		<td style="width: 12%">
			<xform:text property="kmImeetingAgendaForms[!{index}].docSubject" style="width:95%;" required="true" subject="${lfn:message('km-imeeting:kmImeetingAgenda.docSubject') }"/>
		</td>
		<td style="width: 8%">
			<xform:address propertyName="kmImeetingAgendaForms[!{index}].docReporterName" propertyId="kmImeetingAgendaForms[!{index}].docReporterId" orgType="ORG_TYPE_PERSON"></xform:address>
		</td>
		<td style="width: 6%">
			<xform:text property="kmImeetingAgendaForms[!{index}].docReporterTime" style="width:98%;" />
		</td>
		<c:if test="${ kmImeetingMainForm.docStatusFirstDigit != '3'}">
			<td style="width: 12%">
				<xform:text property="kmImeetingAgendaForms[!{index}].attachmentName" style="width:98%;" />
			</td>
			<td style="width: 8%">
				<xform:address propertyName="kmImeetingAgendaForms[!{index}].docResponsName" propertyId="kmImeetingAgendaForms[!{index}].docResponsId" orgType="ORG_TYPE_PERSON"></xform:address>
			</td>
			<td style="width: 10%">
				<xform:text property="kmImeetingAgendaForms[!{index}].attachmentSubmitTime" style="width:98%;" />
			</td>
		</c:if>
		<td style="width: 38%">
		</td>
	</tr>
	
	<%--内容行--%>
	<c:forEach items="${kmImeetingMainForm.kmImeetingAgendaForms}"  var="kmImeetingAgendaitem" varStatus="vstatus">
		<tr KMSS_IsContentRow="1">
			<td width="5%" align="center">
				<input type="hidden" name="kmImeetingAgendaForms[${vstatus.index}].fdId" value="${kmImeetingAgendaitem.fdId}" /> 
				${vstatus.index+1}
			</td>
			<td width=12% align="center">
				<c:out value="${kmImeetingAgendaitem.docSubject}"></c:out>
			</td>
			<td style="width: 8%" align="center">
				<c:out value="${kmImeetingAgendaitem.docReporterName}"></c:out>
			</td>
			<td style="width: 6%" align="center">
				<c:if test="${not empty  kmImeetingAgendaitem.docReporterTime}">
					<c:out value="${kmImeetingAgendaitem.docReporterTime}"></c:out>
					<bean:message key="date.interval.minute"/>
				</c:if>
			</td>
			<c:if test="${ kmImeetingMainForm.docStatusFirstDigit != '3'}">
				<td style="width: 12%" align="center">
					<c:out value="${kmImeetingAgendaitem.attachmentName}"></c:out>
				</td>
				<td style="width: 8%" align="center">
					<c:out value="${kmImeetingAgendaitem.docResponsName}"></c:out>
				</td>
				<td style="width: 10%" align="center">
					<c:if test="${not empty  kmImeetingAgendaitem.attachmentSubmitTime}">
						<bean:message bundle="km-imeeting" key="kmImeetingAgenda.attachmentSubmitTime.tip1"/>
						<c:out value="${kmImeetingAgendaitem.attachmentSubmitTime}"></c:out>
						<bean:message bundle="km-imeeting" key="kmImeetingAgenda.attachmentSubmitTime.tip2"/>
					</c:if>
				</td>
			</c:if>
			<c:if test="${ kmImeetingMainForm.docStatusFirstDigit == '3'}">
			<td style="width: 38%">
				<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
					<c:param name="fdKey" value="ImeetingUploadAtt_${kmImeetingAgendaitem.fdId }" />
					<c:param name="fdModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingMain" />
					<c:param name="fdModelId" value="${kmImeetingMainForm.fdId }" />
				</c:import>
			</td>
			</c:if>
		</tr>
	</c:forEach>
</table>