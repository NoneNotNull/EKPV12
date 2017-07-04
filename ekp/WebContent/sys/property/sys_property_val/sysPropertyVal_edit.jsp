<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
 
<script>
Com_IncludeFile("jquery.js");
</script>
<script>
$(document).ready(function(){
     var v='${valStr}' ;
     $('#valStr').val(v) ;
});

function submitForm(){
   var action=  "<c:url value='/sys/property/sys_property_val/sysPropertyVal.do?method=update'/>";
    action = Com_SetUrlParameter(action, "templateId",  "${templateId}");
	action = Com_SetUrlParameter(action, "referenceId", "${referenceId}");
	action = Com_SetUrlParameter(action, "valStr", document.getElementById('valStr').value);
   document.getElementById('sysPropertyValForm').action=action ;
   document.getElementById('sysPropertyValForm').submit() ;
}

</script>
 
 <form id="sysPropertyValForm" method="post" action="">
 
<div id="optBarDiv">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="submitForm()">
		<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();"> 
</div>
<p class="txttitle">属性值设置</p>
<center>
<table class="tb_normal" width=95%>
	 <tr>
		<td class="td_normal_title" width=15%>
			 <c:out value="${propertyName}" />
		</td><td width="85%" colspan="3">
			<xform:textarea property="valStr"  htmlElementProperties="id='valStr'" style="height:200px;width:70%" />
			<font style="vertical-align:top">图例</font>
				<span style="border:1px dashed black;"><img src="${KMSS_Parameter_ContextPath}sys/property/define/images/sample.jpg" border="0"  align="bottom"/> </span> <br />
				（在此输入需要设置的属性值，每行一个，如图例所示） 
		</td>
	</tr>
	 
</table>
</center>

 <iput type="hidden" name="templateId"  id="templateId"  value='000' />
 <iput type="hidden" name="referenceId" id="referenceId"  value='999' />
</form> 
<%@ include file="/resource/jsp/edit_down.jsp"%>