<%@ page
	language="java"
	contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/htmlhead.jsp"%>
<title><bean:message
	bundle="sys-right"
	key="right.choose.first" /></title>
<script language='javascript'>
	Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
</script>
<script language='javascript'>
	function confirmdoc(){ window.returnValue='tmpdoc';window.close(); }
	function confirmtmp(){ window.returnValue='tmp';window.close(); }
</script>
<br />
<br />
<div
	align="center"
	valign="center"><bean:message
	bundle="sys-right"
	key="right.choose.message.tips" /><br />
<br />
<input
	type="button"
	value="<bean:message bundle="sys-right" key="right.change.doc" />"
	onclick="confirmdoc();"
	class="btnopt" /> <input
	type="button"
	value="<bean:message bundle="sys-right" key="right.change.tmp" />"
	onclick="confirmtmp();"
	class="btnopt" /></div>
