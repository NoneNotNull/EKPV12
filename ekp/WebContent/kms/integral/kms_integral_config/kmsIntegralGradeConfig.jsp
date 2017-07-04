<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%--个人积分头衔设置----%>
<html:form action="/kms/integral/kms_integral_config/kmsIntegralGradeConfig.do" onsubmit="return validateKmsIntegralGradeConfigForm(this);">
<div id="optBarDiv">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmsIntegralGradeConfigForm, 'update');">
</div>
<p class="txttitle"><bean:message bundle="kms-integral" key="kmsIntegralGradeConfig.score.grade.set"/></p>
<p style="margin:10px;margin-left:30px;"><bean:message bundle="kms-integral" key="kmsIntegralGradeConfig.select"/><select onchange="clickGrade(this.value);" id="sel">
				<option value="level"><bean:message bundle="kms-integral" key="kmsIntegralGradeConfig.use"/></option>	 
  				<c:forEach  items="${levelName}"  var="mymap"  >  
  					<option value="${mymap.key}"> ${mymap.value}</option>
				</c:forEach> 
				
			 </select><span style="margin-left:15px;">&nbsp;</span><a href="javascript:void(0)" onclick="clickGrade(null);">自定义</a>
</p>
<center>
<table class="tb_normal" width=95%> 
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="kms-integral" key="kmsIntegralGradeConfig.level"/>
		</td>
		<td colspan=3>
			<html:textarea property="level" style="width:95%;height:270"/>
		</td>
	</tr>
	<tr> 
		<td class="td_normal_title" colspan="4">
			<bean:message bundle="kms-integral" key="kmsIntegralGradeConfig.description"/>
		</td>
	</tr>

</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<script>
function clickGrade(obj){
	window.location.href="<%=request.getContextPath()%>/kms/integral/kms_integral_config/kmsIntegralGradeConfig.do?method=edit&gradeLevel="+obj ;
}

window.onload = function(){
	var sel = document.getElementById("sel");
	for(i = 0;i<sel.length;i++){
		if(sel.options[i].value == "${param.gradeLevel}"){
			sel.options[i].selected = true;
		}
	}
}
</script>
<script type="text/javascript" language="Javascript1.1"> 
<!-- Begin 
function validateKmsIntegralGradeConfigForm() {                                                                   
	var level = document.getElementsByName("level")[0];
	if(level.value=="")return true;
	var ls = level.value.split("\n");
	for(var i=0;i<ls.length;i++){
		var ks = ls[i].split(":");
		if(ks.length!=3){
			alert("<bean:message bundle='kms-integral' key='kmsIntegralGradeConfig.level'/>:'"+ls[i]+"'<bean:message bundle='kms-integral' key='kmsIntegralGradeConfig.incorrect'/>");
			level.focus();
			return false;
		}
		if(parseInt(ks[2])!=ks[2]|| ks[0]==""|| ks[1]==""){
			alert("<bean:message bundle='kms-integral' key='kmsIntegralGradeConfig.level'/>:'"+ls[i]+"'<bean:message bundle='kms-integral' key='kmsIntegralGradeConfig.incorrect'/>");
			level.focus();
			return false;
		}
		if(-2147483648>parseInt(ks[2])||parseInt(ks[2])>2147483647){
			alert("<bean:message bundle='kms-integral' key='kmsIntegralGradeConfig.level'/>:'"+ls[i]+"'<bean:message bundle='kms-integral' key='kmsIntegralGradeConfig.outOfRange'/>");
			level.focus();
			return false;
		}
	}
	return true;
 } 
//End --> 
</script>

<%@ include file="/resource/jsp/edit_down.jsp"%>
