<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit"  sidebar="auto">
<template:replace name="toolbar">
	<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float"> 
		    <ui:button text="${ lfn:message('button.save') }" order="1" onclick="save();">
		    </ui:button>
		    <ui:button text="${ lfn:message('button.close') }" order="2" onclick="Com_CloseWindow();">
		    </ui:button>
	</ui:toolbar>
</template:replace>
<template:replace name="content">
<script language="JavaScript">
		function save() {
			var tName = document.getElementsByName("fdTemplateName");
			if(tName[0].value=="") {
				alert("<bean:message key="message.no.template" bundle="km-imissive"/>");
				return false;
			}
			Com_Submit(document.kmImissiveSendMainForm, 'changeTemplate');
	}
  function selectTemplate(){
		seajs.use(['sys/ui/js/dialog'], function(dialog) {
			dialog.category({
				modelName:"com.landray.kmss.km.imissive.model.KmImissiveSendTemplate",
				idField:"fdTemplateId",
				nameField:"fdTemplateName",
				mulSelect:false,
				winTitle:"选择模板",
				canClose:true,
				isShowTemp:true,
				authType:"01",
				notNull:true
			});
			//dialog.category('com.landray.kmss.km.imissive.model.KmImissiveSendTemplate','fdTemplateId','fdTemplateName',false,null,"选择模板");
	   });
  }
</script>
<html:form action="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do">
	<p class="txttitle"><bean:message bundle="km-imissive" key="kmImissive.title.trans" /></p>
	<center>
	<table class="tb_normal" width=60%>
		<tr>
			<td class="td_normal_title" width=10%>
			   模板
			</td>
			<td>
			<xform:dialog required="true" propertyId="fdTemplateId" propertyName="fdTemplateName" showStatus="edit" style="width:95%"  className="inputsgl" subject="模板">
			   selectTemplate();
			 </xform:dialog>
			</td>
		</tr>

	</table>
	</center>
	<html:hidden property="method_GET" />
</html:form>
</template:replace>
</template:include>

