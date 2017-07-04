<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<tr id="XFomr_${param.fdKey}_CustomTemplateRow" style="display:none">
	<td class="td_normal_title" colspan=4
		id="TD_FormTemplate_${param.fdKey}" onresize="LoadXForm(this);">
		<iframe id="IFrame_FormTemplate_${param.fdKey}" width="100%" height="100%" scrolling="yes" FRAMEBORDER=0></iframe>
	</td>
</tr>
<%@include file="template_script.jsp" %>
<script>
function LoadXForm(dom) {
	XForm_Loading_Show();
	Doc_LoadFrame(dom, '<c:url value="/sys/xform/designer/designPanel.jsp?fdKey=" />${param.fdKey}&fdModelName=${sysFormTemplateForm.modelClass.name}');
	var frame = document.getElementById('IFrame_FormTemplate_${param.fdKey}');
	Com_AddEventListener(frame, 'load', XForm_Loading_Hide);
}
</script>