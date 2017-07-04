<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/config/sysConfigParameters.do">
<div id="optBarDiv">
	<input type=button value="<bean:message key="button.update"/>"
		onclick="submint();">
</div>
<p class="txttitle"><bean:message key="sys.config.parameters"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message key="sys.config.parameters.fdRowSize"/>
		</td><td colspan=3>
			<html:text property="fdRowSize" size="10"/><span class="txtstrong">*</span>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<script type="text/javascript">
function submint(){
	var rowSize = document.getElementsByName("fdRowSize")[0].value;
	if(rowSize == null || rowSize == ""){
		alert('<bean:message key="errors.required" argKey0="sys.config.parameters.fdRowSize"/>');
		return;
	}
	var   r   =  /^[1-9]\d*$/;//大于零正整数     
	if(!r.test(rowSize)){
		alert('<bean:message key="errors.integer"  argKey0="sys.config.parameters.fdRowSize"/>');
		return;
	}
	Com_Submit(document.sysConfigParametersForm, 'update');
}
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>