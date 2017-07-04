<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<div class="muiFormContent">
	<table class="muiSimple" cellpadding="0" cellspacing="0">
		<tr>
			<td class="muiTitle">
				<bean:message bundle="km-smissive" key="kmSmissiveMain.docSubject" />
			</td><td>
				<xform:text property="docSubject" mobile="true"/>
			</td>
		</tr>
		<tr>
			<td class="muiTitle">
				<bean:message bundle="km-smissive" key="kmSmissiveMain.fdFileNo" />
			</td><td>
				<xform:text property="fdFileNo" mobile="true"/>
			</td>
		</tr>
		<tr>
			<td class="muiTitle">
				<bean:message bundle="km-smissive" key="kmSmissiveMain.fdMainDeptId" />
			</td><td>
				<xform:text property="fdMainDeptName" mobile="true"/>
			</td>
		</tr>
		<tr>
			<td class="muiTitle">
				<bean:message bundle="km-smissive" key="kmSmissiveMain.fdSendDeptId" />
			</td><td>
				<xform:text property="fdSendDeptNames" mobile="true"/>
			</td>
		</tr>
		<tr>
			<td class="muiTitle">
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdCopyDeptId"/>
			</td><td>
				<xform:text property="fdCopyDeptNames" mobile="true"/>
			</td>
		</tr>
		<tr>
			<td class="muiTitle">
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdUrgency"/>
			</td><td style="padding-top:10px;vertical-align: middle;">
				<sunbor:enumsShow
					value="${kmSmissiveMainForm.fdUrgency}"
					enumsType="km_smissive_urgency" bundle="km-smissive" />
			</td>
		</tr>
		<tr>
			<td class="muiTitle">
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdSecret"/>
			</td><td style="padding-top:10px;vertical-align: middle;">
				<sunbor:enumsShow
					value="${kmSmissiveMainForm.fdSecret}"
					enumsType="km_smissive_secret" bundle="km-smissive" />
			</td>
		</tr>
		<tr>
			<td class="muiTitle">
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdIssuerId"/>
			</td><td>
				 <xform:text property="fdIssuerName" mobile="true"/>
			</td>
		</tr>
		<tr>
			<td class="muiTitle">
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docPublishTime"/>
			</td><td>
				<c:if test="${not empty kmSmissiveMainForm.docPublishTime }">
					<xform:text property="docCreateTime" value="${fn:substring(kmSmissiveMainForm.docPublishTime,0,10)}" mobile="true"/>
				</c:if>
			</td>
		</tr>
		<tr>
			<td class="muiTitle">
				拟稿日期
			</td><td>
				<xform:text property="docCreateTime" mobile="true"/>
			</td>
		</tr>
		<tr>
			<td class="muiTitle">
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docAuthorId"/>
			</td><td>
				<xform:text property="docAuthorName" mobile="true"/>
			</td>
		</tr>
	</table>
</div>