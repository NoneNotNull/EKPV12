<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit"  sidebar="no">
<template:replace name="toolbar">
<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float"> 
   <ui:button text="${lfn:message('button.submit')}" order="2" onclick=" Com_Submit(document.kmImissiveReturnOpinionForm,'save');">
   </ui:button>
   <ui:button text="${ lfn:message('button.close')}" order="5"  onclick="Com_CloseWindow();">
   </ui:button>
</ui:toolbar>
</template:replace>
<template:replace name="content">
<html:form action="/km/imissive/km_imissive_return_opinion/kmImissiveReturnOpinion.do">
<p class="txttitle"><bean:message bundle="km-imissive" key="kmImissiveReceiveMain.return.title"/></p>
<center>
<table class="tb_normal" width=95%>
	<html:hidden property="fdId"/>
	<html:hidden property="fdImissiveId"/>
	<html:hidden property="fdDetailId"/>
	<html:hidden property="fdUnitId"/>
	<html:hidden property="fdDeliverType"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-imissive" key="kmImissiveReceiveMain.fdReturnOpinion"/>
		</td>
		<td width=85%>
			<xform:textarea property="docContent" style="width:85%" required="true"></xform:textarea>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<script language="JavaScript">
	$KMSSValidation(document.forms['kmImissiveReturnOpinionForm']);
</script>
</template:replace>
</template:include>