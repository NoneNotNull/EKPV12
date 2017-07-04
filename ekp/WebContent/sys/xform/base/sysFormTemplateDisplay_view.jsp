<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.xform.base.config.*" %>
<%-- 已定义表单 --%>
<c:if test="${xFormTemplateForm.fdDisplayType eq 1}">
<%
request.setAttribute("sysFormList", ConfigModel.getInstance().getFormPages(request.getParameter("fdMainModelName")));
%>
<tr>
	<td class="td_normal_title" width=15%>
		<bean:message  bundle="sys-xform" key="sysFormCommonTemplate.fdFormFileName"/>
	</td>
	<td>
	<c:forEach items="${sysFormList}" var="formFileLabel" varStatus="vstatus">
		<c:if test="${formFileLabel.formFileName eq xFormTemplateForm.fdFormFileName}">
			${formFileLabel.label}
		</c:if>
	</c:forEach>
	</td>
</tr>
</c:if>

<%-- 自设计 --%>
<c:if test="${xFormTemplateForm.fdDisplayType eq 2}">
<tr id="XFomr_${param.fdKey}_CustomTemplateRow">
	<input type="hidden" name="${sysFormTemplateFormPrefix}fdDesignerHtml" value="<c:out value="${xFormTemplateForm.fdDesignerHtml}" />">
	<td class="td_normal_title" colspan=4
		id="TD_FormTemplate_${param.fdKey}" 
		${sysFormTemplateFormResizePrefix }onresize="Doc_LoadFormFrame('TD_FormTemplate_${param.fdKey}', '<c:url value="/sys/xform/designer/designPanel.jsp?fdKey=" />${param.fdKey}&fdModelName=${sysFormTemplateForm.modelClass.name}&sysFormTemplateFormPrefix=${sysFormTemplateFormPrefix}&method=${param.method}');">
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

	/* if("view" == "${param.method}"){
		var div = document.getElementById("Div_FormTemplate_${param.fdKey}");
		div.style.position = "absolute";
		div.style.zIndex = 500;
		if (Com_Parameter.IE) {
			div.style.backgroundColor = "beige";
			div.style.filter='progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)';
		} else {
			div.style.backgroundColor = "transparent";
		}
		console.info(Com_Parameter.IE);
		div.onclick = cancelEvent;
		div.onmousedown = cancelEvent;
		div.onmouseup = cancelEvent;
		div.onmousemove = cancelEvent;
		div.onmouseover = cancelEvent;
		div.onmouseout = cancelEvent;
		div.ondblclick = cancelEvent;
		div.onfocus = cancelEvent;
		
		setDivSize(div, iframe);
	} */
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