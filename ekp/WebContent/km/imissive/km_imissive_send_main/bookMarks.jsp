<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<div id="optBarDiv">
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="km-imissive" key="kmImissive.bookMarks.title"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=50%>
			<center>
				<bean:message  bundle="km-imissive" key="kmImissive.bookMarks.chinese"/>
			</center>
		</td>
		<td class="td_normal_title" width=50%>
			<center>
				<bean:message  bundle="km-imissive" key="kmImissive.bookMarks.code"/>
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-imissive" key="kmImissiveSendMain.docSubject"/>
			</center>
		</td>
		<td width=50%>
			<center>
				docsubject
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-imissive" key="kmImissiveSendMain.fdDocType"/>
			</center>
		</td>
		<td width=50%>
			<center>
				doctype
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-imissive" key="kmImissiveSendMain.fdSendtoDept"/>
			</center>
		</td>
		<td width=50%>
			<center>
				sendunit
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-imissive" key="kmImissiveSendMain.fdDocNum"/>
			</center>
		</td>
		<td width=50%>
			<center>
				docnum
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-imissive" key="kmImissiveSendMain.fdSecretGrade"/>
			</center>
		</td>
		<td width=50%>
			<center>
				secretgrade
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-imissive" key="kmImissiveSendMain.fdEmergencyGrade"/>
			</center>
		</td>
		<td width=50%>
			<center>
				emergency
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-imissive" key="kmImissiveSendMain.fdCheckId"/>
			</center>
		</td>
		<td width=50%>
			<center>
				checker
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-imissive" key="kmImissiveSendMain.fdSignatureId"/>
			</center>
		</td>
		<td width=50%>
			<center>
				signature
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-imissive" key="kmImissiveSendMain.docPublishTime"/>
			</center>
		</td>
		<td width=50%>
			<center>
				signdate
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-imissive" key="kmImissiveSendMain.docPublishTime.chinese"/>
			</center>
		</td>
		<td width=50%>
			<center>
				signdatecn
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-imissive" key="kmImissiveSendMain.fdDraftId"/>
			</center>
		</td>
		<td width=50%>
			<center>
				drafter
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-imissive" key="kmImissiveSendMain.fdDraftDeptId"/>
			</center>
		</td>
		<td width=50%>
			<center>
				draftunit
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-imissive" key="kmImissiveSendMain.fdDraftTime"/>
			</center>
		</td>
		<td width=50%>
			<center>
				drafttime
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-imissive" key="kmImissiveSendMain.fdPrintNum"/>
			</center>
		</td>
		<td width=50%>
			<center>
				printnum
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-imissive" key="kmImissiveSendMain.fdPrintPageNum"/>
			</center>
		</td>
		<td width=50%>
			<center>
				printpagenum
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-imissive" key="table.kmImissiveMainMainto"/>
			</center>
		</td>
		<td width=50%>
			<center>
				maintounit
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-imissive" key="table.kmImissiveMainCopyto"/>
			</center>
		</td>
		<td width=50%>
			<center>
				copytounit
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-imissive" key="table.kmImissiveReportto"/>
			</center>
		</td>
		<td width=50%>
			<center>
				reporttounit
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-imissive" key="kmImissiveSendMain.fdContent"/>
			</center>
		</td>
		<td width=50%>
			<center>
				content
			</center>
		</td>
	</tr>
	<tr>
        <td width=50%>
           <center>
            <bean:message  bundle="km-imissive" key="kmImissiveRedheadset.redhead"/>
           </center>
        </td>
        <td width=50%>
           <center>
             redhead
           </center>
        </td>
 </tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>