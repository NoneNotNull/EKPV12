<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.dialog">
	<template:replace name="content" >
		<script type="text/javascript">Com_IncludeFile("validation.jsp|validation.js|plugin.js|eventbus.js|xform.js", null, "js");</script>
		<script>
			$KMSSValidation();//校验框架
			seajs.use(['lui/dialog', 'lui/jquery'],function(dialog,$) {
				//确认
				window.clickOk=function(){
					var formObj = document.kmImeetingMainHastenForm;
					Com_Submit(formObj, "hastenMeeting");
				};
			});
		</script>
		<div style="margin:10px auto;text-align: center;">
			<div class="txttitle">
				<bean:message bundle="km-imeeting" key="kmImeeting.btn.hastenMeeting" />
			</div>
			<br/>
			<html:form action="/km/imeeting/km_imeeting_main_hasten/kmImeetingMainHasten.do">
			<table id="Table_Main" class="tb_normal"width="80%"align="center">
				<tr>
					<td class="td_normal_title" width="15%">
						<bean:message bundle="km-imeeting" key="kmImeetingMain.fdNotifyPerson" />
					</td>
					<td width="85%" colspan="3">
						<xform:address propertyName="hastenNotifyPersonNames" propertyId="hastenNotifyPersonIds" style="width:95%" mulSelect="true"
							textarea="true" showStatus="edit" required="true" subject="${lfn:message('km-imeeting:kmImeetingMain.fdNotifyPerson') }"></xform:address>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width="15%">
						通知方式
					</td>
					<td width="85%" colspan="3">
						 <kmss:editNotifyType property="fdNotifyType"  />
					</td>
				</tr>
			</table>
			<div style="width:50px;margin: 10px auto;">
			<ui:button text="${lfn:message('button.ok') }" onclick="clickOk();" >	</ui:button>
			</div>
			</html:form>
		</div>
		<div style="height: 60px;"></div>
	</template:replace>
</template:include>