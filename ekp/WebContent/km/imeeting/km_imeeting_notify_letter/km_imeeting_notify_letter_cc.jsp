<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@page import="java.util.Date"%>
<%@page import="com.landray.kmss.util.DateUtil"%>
<%@page import="com.landray.kmss.km.imeeting.forms.KmImeetingMainForm"%>
<%--抄送人员、可阅读者看到的会议通知单详情--%>
<div style="float: right;margin:10px;">
	<span style="margin-right: 10px;">
		<bean:message bundle="km-imeeting" key="kmImeetingMain.fdMeetingNum"/>：
		<c:out value="${kmImeetingMainForm.fdMeetingNum}"></c:out>
		<c:if test="${empty  kmImeetingMainForm.fdMeetingNum}">
			<bean:message bundle="km-imeeting" key="kmImeetingMain.createStep.base.fdMeetingNum.tip"/>
		</c:if>
	</span>
	<span>
		<bean:message bundle="km-imeeting" key="kmImeetingMain.docStatus"/>：
		<c:if test="${kmImeetingMainForm.docStatus!='30' && kmImeetingMainForm.docStatus!='41' }">
			<sunbor:enumsShow value="${kmImeetingMainForm.docStatus}" enumsType="common_status" />
		</c:if>
		<%--未召开--%>
		<c:if test="${kmImeetingMainForm.docStatus=='30' && isBegin==false }">
			<bean:message bundle="km-imeeting" key="kmImeeting.status.publish.unHold"/>
		</c:if>
		<%--正在召开--%>
		<c:if test="${kmImeetingMainForm.docStatus=='30' && isBegin==true && isEnd==false }">
			进行中
		</c:if>
		<%--已召开--%>
		<c:if test="${kmImeetingMainForm.docStatus=='30' && isEnd==true }">
			<bean:message bundle="km-imeeting" key="kmImeeting.status.publish.hold"/>
		</c:if>
		<%--已取消--%>
		<c:if test="${kmImeetingMainForm.docStatus=='41' }">
			已取消
		</c:if>
	</span>
</div>
<table class="tb_normal" width="100%;">
	<%--会议变更原因--%>
	<c:if test="${kmImeetingMainForm.fdChangeMeetingFlag=='true' }">
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message bundle="km-imeeting" key="kmImeetingMain.changeMeetingReason"/>
			</td>
			<td colspan="3" style="color:red;">
				<xform:textarea property="changeMeetingReason" style="width:98%;" value="${kmImeetingMainForm.changeMeetingReason }"></xform:textarea>
				<html:hidden property="beforeChangeContent" value="${kmImeetingMainForm.beforeChangeContent }"/>
			</td>
		</tr>				
	</c:if>
	<tr>
		<%--会议名称--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingMain.fdName"/>
		</td>
		<td width="35%" >
			<c:out value="${kmImeetingMainForm.fdName }"></c:out>
		</td>
		<%--会议类型--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingMain.fdTemplate"/>
		</td>			
		<td width="35%" >
			<c:out value="${kmImeetingMainForm.fdTemplateName }"></c:out>
		</td>
	</tr>
	<tr>
		<%--主持人--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingMain.fdHost"/>
		</td>			
		<td width="35%" >
			<c:out value="${kmImeetingMainForm.fdHostName }"></c:out>
			<c:if test="${not empty kmImeetingMainForm.fdOtherHostPerson }">
				&nbsp;${kmImeetingMainForm.fdOtherHostPerson }
			</c:if>
		</td>
		<%--会议地点--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingMain.fdPlace"/>
		</td>			
		<td width="35%" >
			<c:out value="${kmImeetingMainForm.fdPlaceName }"></c:out>
			<c:if test="${not empty kmImeetingMainForm.fdOtherPlace }">
				<c:out value="${kmImeetingMainForm.fdOtherPlace }"></c:out>
			</c:if>
		</td>
	</tr>
	<tr>
		<%--召开时间--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingMain.fdDate"/>
		</td>			
		<td width="35%" >
			<c:out value="${kmImeetingMainForm.fdHoldDate }"></c:out>&nbsp;~&nbsp;<c:out value="${kmImeetingMainForm.fdFinishDate }"></c:out>
		</td>
		<%--会议历时--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingMain.fdHoldDuration"/>
		</td>			
		<td width="35%" >
			<span id ="fdHoldDurationHour" ></span><bean:message key="date.interval.hour"/>
			<span id="fdHoldDurationMinSpan"><span id ="fdHoldDurationMin" ></span><bean:message key="date.interval.minute"/></span>
		</td>
	</tr>
	<tr>
		<%--会议目的--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingMain.fdMeetingAim"/>
		</td>			
		<td width="85%"  colspan="3">
			<xform:textarea property="fdMeetingAim" value="${kmImeetingMainForm.fdMeetingAim }" showStatus="view"></xform:textarea>
		</td>
	</tr>
	<tr>
		<%--会议参与人员--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingMain.fdAttendPersons"/>
		</td>			
		<td width="85%"  colspan="3" style="word-break:break-all">
			<c:if test="${ not empty kmImeetingMainForm.fdAttendPersonNames }">
				<div>
					<img src="${LUI_ContextPath}/km/imeeting/resource/images/inner_person.png" />
					<span style="vertical-align: top;">
						<bean:message bundle="km-imeeting" key="kmImeetingMain.fdInnerPerson"/>：<c:out value="${kmImeetingMainForm.fdAttendPersonNames }"></c:out>
					</span>
				</div>
			</c:if>
			<%--外部参与人员--%>
			<c:if test="${ not empty kmImeetingMainForm.fdOtherAttendPerson }">
				<div>
					<img src="${LUI_ContextPath}/km/imeeting/resource/images/other_person.png" />
					<span style="vertical-align: top;">
						<bean:message bundle="km-imeeting" key="kmImeetingMain.fdOtherPerson"/>：<c:out value="${kmImeetingMainForm.fdOtherAttendPerson }"></c:out>
					</span>
				</div>
			</c:if>
		</td>
	</tr>
	<tr>
		<%--列席人员--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingMain.fdParticipantPersons"/>
		</td>
		<td width="85%"  colspan="3">
			<c:if test="${not empty kmImeetingMainForm.fdParticipantPersonNames }">
				<div>
					<img src="${LUI_ContextPath}/km/imeeting/resource/images/inner_person.png" />
					<span style="vertical-align: top;">
						<bean:message bundle="km-imeeting" key="kmImeetingMain.fdInnerPerson"/>：<c:out value="${kmImeetingMainForm.fdParticipantPersonNames }"></c:out>
					</span>
				</div>
			</c:if>
			<%--外部列席人员--%>
			<c:if test="${not empty kmImeetingMainForm.fdOtherParticipantPerson }">
				<div>
					<img src="${LUI_ContextPath}/km/imeeting/resource/images/other_person.png" />
					<span style="vertical-align: top;">
						<bean:message bundle="km-imeeting" key="kmImeetingMain.fdOtherPerson"/>：<c:out value="${kmImeetingMainForm.fdOtherParticipantPerson }"></c:out>
					</span>
				</div>
			</c:if>
		</td>
	</tr>
	<tr>
		<%--抄送人员--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingMain.fdCopyToPersons"/>
		</td>			
		<td width="85%"  colspan="3">
			<c:if test="${not empty kmImeetingMainForm.fdCopyToPersonNames }">
				<div>
					<img src="${LUI_ContextPath}/km/imeeting/resource/images/inner_person.png" />
					<span style="vertical-align: top;">
						<bean:message bundle="km-imeeting" key="kmImeetingMain.fdInnerPerson"/>：<c:out value="${kmImeetingMainForm.fdCopyToPersonNames }"></c:out>
					</span>
				</div>
			</c:if>
			<%--外部抄送人员--%>
			<c:if test="${not empty kmImeetingMainForm.fdOtherCopyToPerson }">
				<div>
					<img src="${LUI_ContextPath}/km/imeeting/resource/images/other_person.png" />
					<span style="vertical-align: top;">
						<bean:message bundle="km-imeeting" key="kmImeetingMain.fdOtherPerson"/>：<c:out value="${kmImeetingMainForm.fdOtherCopyToPerson }"></c:out>
					</span>
				</div>
			</c:if>
		</td>
	</tr>
	<tr>	
		<%--明细表--%>
		<td colspan="4">
			<%@include file="/km/imeeting/km_imeeting_agenda/kmImeetingAgenda_view.jsp"%>
		</td>
	</tr>
	<tr>
		<%--相关资料--%>
 		<td class="td_normal_title" width=15%>
 			<bean:message bundle="km-imeeting" key="kmImeetingMain.attachment"/>
 		</td>
		<td width="85%" colspan="3" >
			<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
				<c:param name="formBeanName" value="kmImeetingMainForm" />
				<c:param name="fdKey" value="attachment" />
				<c:param name="fdModelId" value="${param.fdId }" />
				<c:param name="fdModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingMain" />
			</c:import>
		</td>
	</tr>
	<tr>
 		<%--备注--%>
 		<td class="td_normal_title" width=15%>
 			<bean:message bundle="km-imeeting" key="kmImeetingMain.fdRemark"/>
 		</td>
 		<td width="85%" colspan="3" >
 			<xform:textarea property="fdRemark" value="${kmImeetingMainForm.fdRemark }" showStatus="view"></xform:textarea>
		</td>
 	</tr>
 	<tr>
 		<%--会议纪要人--%>
 		<td class="td_normal_title" width=15%>
 			<bean:message bundle="km-imeeting" key="kmImeetingMain.fdSummaryInputPerson"/>
 		</td>
 		<td width="85%" colspan="3" >
 			<c:out value="${kmImeetingMainForm.fdSummaryInputPersonName}"></c:out>
		</td>
 	</tr>
</table>
