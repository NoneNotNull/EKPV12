<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/task/sys_task_overrule/sysTaskOverrule.do" onsubmit="return validateSysTaskOverruleForm(this);">
<div id="optBarDiv">
	<c:if test="${sysTaskOverruleForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysTaskOverruleForm, 'save');">
	</c:if>
	<c:if test="${sysTaskOverruleForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysTaskOverruleForm, 'update');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message  bundle="sys-task" key="table.sysTaskOverrule"/></p>

<center>
<table class="tb_normal" width=95%>
		<html:hidden property="fdId"/>
		<html:hidden property="fdTaskId"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskMain.docSubject"/>
		</td>
		<td width=85% colspan=3>
			<c:out value="${sysTaskOverruleForm.fdTaskName}"/>				
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskOverrule.fdProgress"/>
		</td><td width=85% colspan=3>
			<html:text style="width:25px" property="fdProgress" onchange="sliderImage.setValue(getElementById('fdProgress').value)"/>%
			<span id="sliderProcess" style="height:15px;"></span>		
	    <style type="text/css" media="all">
		.imageSlider { margin:0;padding:0; height:20px; width:285px; background-image:url("${KMSS_Parameter_ContextPath}sys/task/images/horizBg.png"); }
		.imageBar    { margin:0;padding:0; height:15px; width:14px; background-image:url("${KMSS_Parameter_ContextPath}sys/task/images/horizSlider.png"); }
 		</style>
	    	<script type="text/javascript" src="${KMSS_Parameter_ContextPath}sys/task/js/slider_extras.js"></script>
	        <script type="text/javascript">
			 sliderImage = new neverModules.modules.slider(
				{targetId: "sliderProcess",
					sliderCss: "imageSlider",
					barCss: "imageBar",
					min: 0,
					max: 100,
					hints: ""
				});
				sliderImage.onstart  = function () {
					getElementById('fdProgress').value = sliderImage.getValue();
				}
				sliderImage.onchange = function () {
					getElementById('fdProgress').value = sliderImage.getValue();
				};
				sliderImage.onend = function () {
					getElementById('fdProgress').value = sliderImage.getValue();
				}
				sliderImage.create();
				window.onload=function (){
					sliderImage.setValue(getElementById('fdProgress').value);
				};
        </script>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15% valign="middle">
			<bean:message  bundle="sys-task" key="sysTaskOverrule.fdReason"/>
		</td>
		<td width=85% colspan=3>
			<html:textarea property="fdReason" style="width:98%" /><span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskOverrule.fdNotifyType"/>
		</td>
		<td width=85% colspan=3>
			<kmss:editNotifyType property="fdNotifyType" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskOverrule.docCreator"/>
		</td><td width=35%>
			<c:out value="${sysTaskOverruleForm.docCreatorName}"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-task" key="sysTaskOverrule.docCreateTime"/>
		</td><td width=35%>
			<c:out value="${sysTaskOverruleForm.docCreateTime}"/>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="sysTaskOverruleForm" cdata="false"
	dynamicJavascript="true" staticJavascript="false" />
<%@ include file="/resource/jsp/edit_down.jsp"%>