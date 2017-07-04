<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script language="JavaScript">
Com_IncludeFile("dialog.js");
</script>
<html:form action="/sys/ftsearch/expand/t_att_ekp_sys/tattEkpSys.do" enctype="multipart/form-data"  method="post">
<div id="optBarDiv">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.tattEkpSysForm, 'Upload');">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message  bundle="sys-ftsearch-expand" key="tattEkpSys.tile"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-ftsearch-expand" key="tattEkpSys.Filedpath"/>
		</td><td width=35%>
			<html:file property="file"></html:file>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>