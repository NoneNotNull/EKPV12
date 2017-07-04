<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@page import="java.util.Date"%>
<%@page import="com.landray.kmss.util.DateUtil"%>
<%@page import="com.landray.kmss.km.imeeting.forms.KmImeetingMainForm"%>
<%--会议主持人/参加人/列席人员/抄送人员看到的会议通知单详情--%>
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
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingMain.kmImeetingDevices"/>
		</td>
		<td width="85%" colspan="3" >
			<c:out value="${kmImeetingMainForm.kmImeetingDeviceNames}"></c:out>
		</td>
	</tr>
	<tr>
 		<%--会议布场要求--%>
 		<td class="td_normal_title" width=15%>
 			<bean:message bundle="km-imeeting" key="kmImeetingMain.fdArrange"/>
 		</td>
 		<td width="85%" colspan="3" >
 			<xform:textarea property="fdArrange" value="${kmImeetingMainForm.fdArrange }" showStatus="view"></xform:textarea>
		</td>
 	</tr>
 	<tr>
		<%--协助人员--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-imeeting" key="kmImeetingMain.fdAssistPersons"/>
		</td>			
		<td width="85%"  colspan="3">
			<c:if test="${not empty kmImeetingMainForm.fdAssistPersonNames }">
				<div>
	 				<img src="${LUI_ContextPath}/km/imeeting/resource/images/inner_person.png" />
					<span style="vertical-align: top;">
						<bean:message bundle="km-imeeting" key="kmImeetingMain.fdInnerPerson"/>：<c:out value="${kmImeetingMainForm.fdAssistPersonNames }"></c:out>
					</span>
				</div>
			</c:if>
			<%--外部协助人--%>
			<c:if test="${not empty kmImeetingMainForm.fdOtherAssistPersons }">
				<div>
					<img src="${LUI_ContextPath}/km/imeeting/resource/images/other_person.png" />
					<span style="vertical-align: top;">
						<bean:message bundle="km-imeeting" key="kmImeetingMain.fdOtherAssistPersons"/>：<c:out value="${kmImeetingMainForm.fdOtherAssistPersons }"></c:out>
					</span>
				</div>
			</c:if>
		</td>
	</tr>
 	<tr>
 		<%--会议组织人--%>
 		<td class="td_normal_title" width=15%>
 			<bean:message bundle="km-imeeting" key="kmImeetingTemplate.fdEmcee"/>
 		</td>
 		<td width="35%" >
 			<c:out value="${kmImeetingMainForm.fdEmceeName}"></c:out>
		</td>
		<%--组织部门--%>
 		<td class="td_normal_title" width=15%>
 			<bean:message bundle="km-imeeting" key="kmImeetingMain.docDept"/>
 		</td>
 		<td width="35%" >
 			<c:out value="${kmImeetingMainForm.docDeptName}"></c:out>
		</td>
 	</tr>
</table>