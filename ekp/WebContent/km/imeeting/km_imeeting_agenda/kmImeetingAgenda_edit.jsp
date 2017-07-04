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
		<td class="td_normal_title" style="width: 18%">
			<bean:message bundle="km-imeeting" key="kmImeetingAgenda.docSubject"/>
		</td>
		<%--汇报人--%> 
		<td class="td_normal_title" style="width: 12%">
			<bean:message bundle="km-imeeting" key="kmImeetingAgenda.docReporter"/>
		</td>
		<%--汇报时间--%> 
		<td class="td_normal_title" style="width: 10%">
			<bean:message bundle="km-imeeting" key="kmImeetingAgenda.docReporterTime"/>
		</td>
		<%--上会所需材料--%> 
		<td class="td_normal_title" style="width: 16%">
			<bean:message bundle="km-imeeting" key="kmImeetingAgenda.attachmentName"/>
		</td>
		<%--材料负责人--%> 
		<td class="td_normal_title" style="width: 12%">
			<bean:message bundle="km-imeeting" key="kmImeetingAgenda.docRespons"/>
		</td>
		<%--提交时间--%> 
		<td class="td_normal_title" style="width: 10%">
			<bean:message bundle="km-imeeting" key="kmImeetingAgenda.attachmentSubmitTime"/>
		</td>
		<%--添加按钮--%>
		<td class="td_normal_title" style="width: 7%;" align="center">
			<a id="add"  href="javascript:void(0);" onclick="DocList_AddRow();">
				<img src="${KMSS_Parameter_StylePath}/icons/add.gif" border="0" />
			</a>
		</td>
	</tr>
	
	<%--基准行--%>
	<tr KMSS_IsReferRow="1" style="display: none">
		<td KMSS_IsRowIndex="1" width="5%" align="center"></td>
		<td style="width: 18%" align="center">
			<xform:text property="kmImeetingAgendaForms[!{index}].docSubject" showStatus="edit" style="width:95%;" required="true" subject="${lfn:message('km-imeeting:kmImeetingAgenda.docSubject') }"/>
		</td>
		<td style="width: 12%" align="center">
			<xform:address propertyName="kmImeetingAgendaForms[!{index}].docReporterName" propertyId="kmImeetingAgendaForms[!{index}].docReporterId" orgType="ORG_TYPE_PERSON" showStatus="edit"></xform:address>
		</td>
		<td style="width: 10%" align="center">
			<xform:text property="kmImeetingAgendaForms[!{index}].docReporterTime" style="width:65%;" showStatus="edit"/>
			<bean:message key="date.interval.minute"/>
		</td>
		<td style="width: 16%" align="center">
			<xform:text property="kmImeetingAgendaForms[!{index}].attachmentName" subject="${lfn:message('km-imeeting:kmImeetingAgenda.attachmentName') }" style="width:98%;" showStatus="edit"/>
		</td>
		<td style="width: 12%" align="center">
			<xform:address propertyName="kmImeetingAgendaForms[!{index}].docResponsName" propertyId="kmImeetingAgendaForms[!{index}].docResponsId" orgType="ORG_TYPE_PERSON" showStatus="edit"></xform:address>
		</td>
		<td style="width: 10%" align="center">
			<bean:message bundle="km-imeeting" key="kmImeetingAgenda.attachmentSubmitTime.tip1"/>
			<xform:text property="kmImeetingAgendaForms[!{index}].attachmentSubmitTime" style="width:20%;" showStatus="edit"/>
			<bean:message bundle="km-imeeting" key="kmImeetingAgenda.attachmentSubmitTime.tip2"/>
		</td>
		<!-- 删除 -->
		<td width="7%" align="center">
			<a href="javascript:void(0);" onclick="DocList_MoveRow(-1);">
				<img src="${KMSS_Parameter_StylePath}/icons/up.gif" border="0" />
			</a>
			<a href="javascript:void(0);" onclick="DocList_MoveRow(1);">
				<img src="${KMSS_Parameter_StylePath}/icons/down.gif" border="0" />
			</a>
			<a href="javascript:void(0);" onclick="DocList_DeleteRow();">
				<img src="${KMSS_Parameter_StylePath}/icons/delete.gif" border="0" />
			</a>
		</td>
	</tr>
	
	<%--内容行--%>
	<c:forEach items="${kmImeetingMainForm.kmImeetingAgendaForms}"  var="kmImeetingAgendaitem" varStatus="vstatus">
		<tr KMSS_IsContentRow="1">
			<td width="5%" align="center">
				${vstatus.index+1}
				<input type="hidden" name="kmImeetingAgendaForms[${vstatus.index}].fdId" value="${kmImeetingAgendaitem.fdId}" /> 
				<input type="hidden" name="kmImeetingAgendaForms[${vstatus.index}].fdMainId" value="${kmImeetingMainForm.fdId}" />
			</td>
			<td width=18% align="center">
				<xform:text property="kmImeetingAgendaForms[${vstatus.index}].docSubject" value="${kmImeetingAgendaitem.docSubject}"
					subject="${lfn:message('km-imeeting:kmImeetingAgenda.docSubject') }"
					style="width:95%"  required="true" showStatus="edit"/>
			</td>
			<td style="width: 12%" align="center">
				<xform:address propertyName="kmImeetingAgendaForms[${vstatus.index}].docReporterName" propertyId="kmImeetingAgendaForms[${vstatus.index}].docReporterId" 
					orgType="ORG_TYPE_PERSON" showStatus="edit"></xform:address>
			</td>
			<td style="width: 10%" align="center">
				<xform:text property="kmImeetingAgendaForms[${vstatus.index}].docReporterTime" style="width:65%;" showStatus="edit"/>
				<bean:message key="date.interval.minute"/>
			</td>
			<td style="width: 16%" align="center">
				<xform:text property="kmImeetingAgendaForms[${vstatus.index}].attachmentName" style="width:98%;" subject="${lfn:message('km-imeeting:kmImeetingAgenda.attachmentName') }" showStatus="edit"/>
			</td>
			<td style="width: 12%" align="center">
				<xform:address propertyName="kmImeetingAgendaForms[${vstatus.index}].docResponsName" propertyId="kmImeetingAgendaForms[${vstatus.index}].docResponsId" orgType="ORG_TYPE_PERSON" showStatus="edit"></xform:address>
			</td>
			<td style="width: 10%" align="center">
				<bean:message bundle="km-imeeting" key="kmImeetingAgenda.attachmentSubmitTime.tip1"/>
				<xform:text property="kmImeetingAgendaForms[${vstatus.index}].attachmentSubmitTime" style="width:20%;" showStatus="edit"/>
				<bean:message bundle="km-imeeting" key="kmImeetingAgenda.attachmentSubmitTime.tip2"/>
			</td>
			<!-- 删除 -->
			<td width="7%" align="center">
				<a href="javascript:void(0);" onclick="DocList_MoveRow(-1);">
					<img src="${KMSS_Parameter_StylePath}/icons/up.gif" border="0" />
				</a>
				<a href="javascript:void(0);" onclick="DocList_MoveRow(1);">
					<img src="${KMSS_Parameter_StylePath}/icons/down.gif" border="0" />
				</a>
				<a href="javascript:void(0);" onclick="DocList_DeleteRow();">
					<img src="${KMSS_Parameter_StylePath}/icons/delete.gif" border="0" />
				</a>
			</td>
		</tr>
	</c:forEach>
	
</table>
<c:if test="${kmImeetingMainForm.method_GET=='add' && copyMeeting != true}">
	<script type="text/javascript">
		LUI.ready(function(){
			setTimeout(function(){
				for (var i = 0; i < 1; i ++) {
				DocList_AddRow('TABLE_DocList');
				}
			},50);
		});
	</script>
</c:if>