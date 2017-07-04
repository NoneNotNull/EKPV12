<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple" sidebar="no">
	<template:replace name="body">
<script language="JavaScript">
seajs.use(['theme!form']);
Com_IncludeFile("validation.jsp|validation.js|plugin.js|eventbus.js|xform.js", null, "js");
Com_IncludeFile("dialog.js|optbar.js");
</script>
<html:form action="/sys/circulation/sys_circulation_main/sysCirculationMain.do">
	<p class="txttitle">
	<bean:message bundle="sys-circulation"
		key="table.sysCirculationMain" />
	</p>

	<center>
	<table class="tb_normal" width=95%>
	<html:hidden property="fdId" />
		<tr>
			<td class="td_normal_title" width=18%>
			<bean:message
				bundle="sys-circulation" key="sysCirculationMain.fdCirculatorId" />
			</td>
			<td>
			<html:text property="fdCirculatorName" readonly="true" />
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=18%>
			<bean:message
				bundle="sys-circulation" 
				key="sysCirculationMain.fdCirculationTime" />
			</td>
			<td>
			<html:text property="fdCirculationTime" readonly="true"/>
			</td>
		</tr>
		<%-- 
		<tr>
			<td class="td_normal_title" width=15%>
			<bean:message
				bundle="sys-circulation" key="sysCirculationMain.fdContent" />
			</td>
			<td width=35%>
			<html:text property="fdContent" />
			</td>
		</tr>
		--%>
		<tr>
			<td class="td_normal_title" width=18%>
			<bean:message
				bundle="sys-circulation" key="table.sysCirculationCirculors" />
			</td>
			<td>
			<xform:address propertyId="receivedCirCulatorIds"  propertyName="receivedCirCulatorNames"  mulSelect="true"
				orgType="ORG_TYPE_ALLORG" required="true" subject="${ lfn:message('sys-circulation:table.sysCirculationCirculors') }" 
				style="width:80%"></xform:address>
		</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=18%>
			<bean:message
				bundle="sys-circulation" key="sysCirculationMain.fdNotifyType" />
				</td>
			<td>
			<kmss:editNotifyType property="fdNotifyType" />
			</td>
		</tr>
		<tr>
		   <td class="td_normal_title" width=18%>
			<bean:message
				bundle="sys-circulation" key="sysCirculationMain.fdRemark" />
				</td>
			<td>
			<html:textarea property="fdRemark" style="width:80%"/>
			</td>
		</tr>
		
	</table>
	<div style="padding-top: 17px;">
		    <ui:button text="${ lfn:message('button.submit') }"   onclick="Com_Submit(document.sysCirculationMainForm, 'save');">
			</ui:button>
		<ui:button text="${ lfn:message('button.close') }"  styleClass="lui_toolbar_btn_gray"  onclick="Com_CloseWindow()">
		</ui:button>
    </div>
	</center>
	<html:hidden property="method_GET" />
	<html:hidden property="fdKey" />
	<html:hidden property="fdModelId" />
	<html:hidden property="fdModelName" />
</html:form>
<script language="JavaScript">
			$KMSSValidation(document.forms['sysCirculationMainForm']);
</script>
	</template:replace>
</template:include>
