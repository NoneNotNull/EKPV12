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
				来文单位
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
				来文文号
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
				收文编号
			</center>
		</td>
		<td width=50%>
			<center>
				receivenum
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
				签收人
			</center>
		</td>
		<td width=50%>
			<center>
				signer
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				签收日期
			</center>
		</td>
		<td width=50%>
			<center>
				signtime
			</center>
		</td>
	</tr>
		<tr>
		<td width=50%>
			<center>
				登记人
			</center>
		</td>
		<td width=50%>
			<center>
				recorder
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				登记日期
			</center>
		</td>
		<td width=50%>
			<center>
				recordtime
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				收文日期
			</center>
		</td>
		<td width=50%>
			<center>
				receivetime
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				收文单位
			</center>
		</td>
		<td width=50%>
			<center>
				receiveunit
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				份数
			</center>
		</td>
		<td width=50%>
			<center>
				fdShareNum
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
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>