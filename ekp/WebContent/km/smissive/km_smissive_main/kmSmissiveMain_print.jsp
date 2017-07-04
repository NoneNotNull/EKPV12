<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view"   sidebar="auto">
<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float"  count="3">
		<ui:button text="${ lfn:message('km-smissive:kmSmissive.button.print') }"   onclick="Print();">
	    </ui:button>
	    <ui:button text="${ lfn:message('button.close') }"   onclick="Com_CloseWindow()">
	    </ui:button>
		</ui:toolbar>
</template:replace>
<template:replace name="content"> 
<script>
	function Print(){
		print();
	}
</script>
<p class="txttitle"><c:out value="${kmSmissiveMainForm.fdTitle}"/></p>
<center>

<html:hidden name="kmSmissiveMainForm" property="fdId"/>
			<table class="tb_normal" width=95%>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docSubject"/>
			</td><td width=85% colspan="3">
				${kmSmissiveMainForm.docSubject }
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docAuthorId"/>
			</td><td width=35%>
				${kmSmissiveMainForm.docAuthorName }
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docCreateTime"/>
			</td><td width=35%>
				${kmSmissiveMainForm.docCreateTime}
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdUrgency"/>
			</td><td width=35%>
				<sunbor:enumsShow
					value="${kmSmissiveMainForm.fdUrgency}"
					enumsType="km_smissive_urgency" bundle="km-smissive" />
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdSecret"/>
			</td><td width=35%>
				<sunbor:enumsShow
					value="${kmSmissiveMainForm.fdSecret}"
					enumsType="km_smissive_secret" bundle="km-smissive" />
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdTemplateId"/>
			</td><td width=35%>
				${kmSmissiveMainForm.fdTemplateName }
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdFileNo"/>
			</td><td width=35%>
				<c:choose>
					<c:when test="${kmSmissiveMainForm.docStatus == '30'}">
						${kmSmissiveMainForm.fdFileNo }
					</c:when>
					<c:otherwise>
						<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdFileNo.describe"/>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMainProperty.fdPropertyId"/>
			</td><td width=35% colspan="3">
				${kmSmissiveMainForm.docPropertyNames }
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdMainDeptId"/>
			</td><td width=35%>
				${kmSmissiveMainForm.fdMainDeptName }
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docDeptId"/>
			</td><td width=35%>
				${kmSmissiveMainForm.docDeptName }
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdSendDeptId"/>
			</td><td colspan="3" width=35%>
				${kmSmissiveMainForm.fdSendDeptNames }
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdCopyDeptId"/>
			</td><td colspan="3" width=35%>
				${kmSmissiveMainForm.fdCopyDeptNames }
			</td>
			
		</tr>
		<tr>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.fdIssuerId"/>
			</td><td width=35%>
				${kmSmissiveMainForm.fdIssuerName }
			</td>
			<td class="td_normal_title" width=15%>
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.docCreatorId"/>
			</td><td width=35%>
				${kmSmissiveMainForm.docCreatorName }
			</td>
		</tr>
		
		<!-- 标签机制 -->
		<c:import url="/sys/tag/include/sysTagMain_view.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmSmissiveMainForm" />
			<c:param name="fdKey" value="smissiveDoc" /> 
		</c:import>
		<!-- 标签机制 -->	
		
		<!-- 附件 -->	
		<tr>
			<td	class="td_normal_title"	width="15%">
				<bean:message  bundle="km-smissive" key="kmSmissiveMain.main.att"/>
			</td>
			<td width="85%" colspan="3">
				<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
					charEncoding="UTF-8">
					<c:param name="fdKey" value="mainAtt" />
					<c:param name="formBeanName" value="kmSmissiveMainForm" />
				</c:import>
			</td>
		</tr>
		
	</table>
	<table class="tb_normal" width=95%>
		<tr>
			<td width="100%">
				<c:import url="/sys/workflow/include/sysWfProcess_log.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmSmissiveMainForm" />
				</c:import>
			</td>
		</tr>
	</table>
</center>
</template:replace>
</template:include>
