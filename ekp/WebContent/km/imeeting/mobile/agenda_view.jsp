<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<div data-dojo-type="mui/table/ScrollableHContainer">
	<div data-dojo-type="mui/table/ScrollableHView">
		<table cellspacing="0" cellpadding="0" class="detailTableNormal">
			<tr>
				<td class="detailTableNormalTd">
					<table class="muiAgendaNormal muiNormal" width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
				  			<%--序号--%>
							<td>
								<bean:message key="page.serial"/>
							</td>        	
							<%--会议议题--%>		
							<td>
								<bean:message key="kmImeetingAgenda.docSubject" bundle="km-imeeting"/>
							</td>	
							<%--汇报人--%>
							<td>
								<bean:message key="kmImeetingAgenda.docReporter" bundle="km-imeeting"/>
							</td>	
							<%--汇报时间--%>
							<td>
								<bean:message key="kmImeetingAgenda.docReporterTime" bundle="km-imeeting"/>
							</td>	
				       	</tr>
				       	<c:forEach items="${kmImeetingMainForm.kmImeetingAgendaForms}"  var="kmImeetingAgendaitem" varStatus="vstatus"> 
					 		<tr  KMSS_IsContentRow="1" data-celltr="true">
								<td KMSS_IsRowIndex=1 class="detailTableIndex">
									<span>${vstatus.index+1}</span>
								</td>
								<td>
									<div class="td1"><c:out value="${kmImeetingAgendaitem.docSubject }"></c:out></div>
								</td> 
								<td>
									<div class="td2"><c:out value="${kmImeetingAgendaitem.docReporterName }"></c:out></div>
								</td> 
								<td>
									<div class="td3">
										<c:if test="${not empty kmImeetingAgendaitem.docReporterTime }">
											<c:out value="${kmImeetingAgendaitem.docReporterTime }"></c:out>
											<bean:message key="date.interval.minute"/>
										</c:if>
									</div>
								</td>      							
					 		</tr>
				       	</c:forEach>
					</table>
				</td>
			</tr>
		</table>
	</div>
</div>
