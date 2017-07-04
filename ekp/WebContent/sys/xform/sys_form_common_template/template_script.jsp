<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
XForm_Loading_Msg = '<bean:message bundle="sys-xform" key="XForm.Loading.Msg"/>';
XForm_Loading_Img = document.createElement('img');
XForm_Loading_Img.src = Com_Parameter.ContextPath + "sys/xform/sys_form_common_template/style/img/_loading.gif";
XForm_Loading_Div = document.createElement('div');
XForm_Loading_Div.id = "XForm_Loading_Div";
XForm_Loading_Div.style.position = "absolute";
XForm_Loading_Div.style.padding = "5px 10px";
XForm_Loading_Div.style.fontSize = "12px";
XForm_Loading_Div.style.backgroundColor = "#F5F5F5";
XForm_loading_text = document.createElement("label");
XForm_loading_text.appendChild(document.createTextNode(XForm_Loading_Msg));
XForm_loading_text.style.color = "#00F";
XForm_loading_text.style.height = "16px";
XForm_loading_text.style.margin = "5px";
XForm_Loading_Div.appendChild(XForm_Loading_Img);
XForm_Loading_Div.appendChild(XForm_loading_text);
function XForm_Loading_Show() {
	document.body.appendChild(XForm_Loading_Div);
	<%--XForm_Loading_Div.style.top = document.body.clientHeight / 2 + document.body.scrollTop -30;--%>
	XForm_Loading_Div.style.top = 180 + document.body.scrollTop;
	XForm_Loading_Div.style.left = document.body.clientWidth / 2 + document.body.scrollLeft -50;
}
function XForm_Loading_Hide() {
	XForm_Loading_Div.style.display = "none";
	var div = document.getElementById('XForm_Loading_Div');
	if (div)
		document.body.removeChild(XForm_Loading_Div);
}
</script>