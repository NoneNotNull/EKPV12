<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<div id="optBarDiv">
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="km-smissive" key="kmSmissiveMain.bookMarks.title"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=50%>
			<center>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.bookMarks.chinese"/>
			</center>
		</td>
		<td class="td_normal_title" width=50%>
			<center>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.bookMarks.code"/>
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docSubject"/>
			</center>
		</td>
		<td width=50%>
			<center>
				docSubject
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docAuthorId"/>
			</center>
		</td>
		<td width=50%>
			<center>
				docAuthorName
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdUrgency"/>
			</center>
		</td>
		<td width=50%>
			<center>
				fdUrgency
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdTemplateId"/>
			</center>
		</td>
		<td width=50%>
			<center>
				fdTemplateName
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docCreateTime"/>
			</center>
		</td>
		<td width=50%>
			<center>
				docCreateTime
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docCreateTime"/>Cn
			</center>
		</td>
		<td width=50%>
			<center>
				docCreateTimeCn
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdSecret"/>
			</center>
		</td>
		<td width=50%>
			<center>
				fdSecret
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdFileNo"/>
			</center>
		</td>
		<td width=50%>
			<center>
				fdFileNo
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdMainDeptId"/>
			</center>
		</td>
		<td width=50%>
			<center>
				fdMainDeptName
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdSendDeptId"/>
			</center>
		</td>
		<td width=50%>
			<center>
				fdSendDeptNames
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdCopyDeptId"/>
			</center>
		</td>
		<td width=50%>
			<center>
				fdCopyDeptNames
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdIssuerId"/>
			</center>
		</td>
		<td width=50%>
			<center>
				fdIssuerName
			</center>
		</td>
	</tr>
	<tr>
		<td width=50%>
			<center>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docCreatorId"/>
			</center>
		</td>
		<td width=50%>
			<center>
				docCreatorName
			</center>
		</td>
	</tr>
	
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>