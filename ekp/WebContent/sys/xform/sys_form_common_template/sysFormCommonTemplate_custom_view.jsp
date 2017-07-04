<c:if test="${sysFormCommonTemplateForm.fdType eq false}">
<c:set var="sysFormTemplateFormPrefix" value="sysFormTemplateForms.${param.fdKey}." />
<tr id="XFomr_${param.fdKey}_CustomTemplateRow">
	<input type="hidden" name="${sysFormTemplateFormPrefix}fdFormContent" value="${sysFormCommonTemplateForm.fdFormContent}">
	<td class="td_normal_title" colspan=4
		id="TD_FormTemplate_${param.fdKey}" onresize="Doc_LoadFormFrame(this, '<c:url value="/sys/xform/sys_form_common_template/designPanel.jsp?fdKey=" />${param.fdKey}&fdModelName=${sysFormTemplateForm.modelClass.name}&method=${param.method}');">
		<div id="Div_FormTemplate_${param.fdKey}" offsetWidth=0 offsetHeight=0></div>
		<iframe id="IFrame_FormTemplate_${param.fdKey}" width="100%" height="100%" scrolling="no" FRAMEBORDER=0></iframe>
	</td>
</tr>
<%@include file="template_script.jsp" %>
<script>
function Doc_LoadFormFrame(tdId, loadUrl){
	if(typeof(tdId)=="string"){
		var tdObj = document.getElementById(tdId);
	}else{
		var tdObj = tdId;
	}
	var iframe = tdObj.getElementsByTagName("IFRAME")[0];
	XForm_Loading_Show();
	if(iframe.src==""){
		iframe.src = loadUrl;
	}
	Com_AddEventListener(iframe, 'load', XForm_Loading_Hide);

	if("view" == "${param.method}"){
		var div = document.getElementById("Div_FormTemplate_${param.fdKey}");
		div.style.position = "absolute";
		div.style.zIndex = 500;
		div.style.backgroundColor = "beige";//"transparent";
		div.style.filter='progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)';
		div.onclick = cancelEvent;
		div.onmousedown = cancelEvent;
		div.onmouseup = cancelEvent;
		div.onmousemove = cancelEvent;
		div.onmouseover = cancelEvent;
		div.onmouseout = cancelEvent;
		div.ondblclick = cancelEvent;
		div.onfocus = cancelEvent;
		
		setDivSize(div, iframe);
	}
}

function setDivSize(div, iframe) {
	var pos = absPosition(iframe);
	div.style.width = iframe.offsetWidth + 'px';
	div.style.height = iframe.offsetHeight + 'px';
	div.style.top = pos.y + "px";
	div.style.left = pos.x + "px";
}
function cancelEvent(event) {
	event = event || window.event;
	event.cancelBubble = true;
	if (event.stopPropagation)
		event.stopPropagation();
	return false;
}
function absPosition(node, stopNode) {
	var x = y = 0;
	for (var pNode = node; pNode != null && pNode !== stopNode; pNode = pNode.offsetParent) {
		x += pNode.offsetLeft - pNode.scrollLeft; y += pNode.offsetTop - pNode.scrollTop;
	}
	return {'x':x, 'y':y};
} 

</script>
</c:if>