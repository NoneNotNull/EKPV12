<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/kms/integral/kms_integral_rule/kmsIntegralConifg.do" method="POST">
<p class="txttitle"><bean:message key="kmsIntegral.tree.reset" bundle="kms-integral" /></p>
<center>
<table class="tb_normal" width=95%>
    <tr>
		<td class="td_normal_title" colspan="2" style="text-align:center;bold;color:#484848">
			开始时间：<xform:datetime property="endTime" subject="开始时间" 
				className="inputsgl" showStatus="edit" style="width:120px" required="true" validators="date" dateTimeType="Date" />
			<div style="display: inline-block;vertical-align:top;margin-top: -8px;">
				<input style="margin-top: 10px; width:40px;heigth:25px" type=button value="执行" 
					onclick=" _submit();">
			</div>
			<div style="text-align:left; line-height:25px; amargin-top:20px; font-size: Microsoft YaHei, Geneva, 'sans-serif', SimSun">
				<strong>说明：</strong><br/>
				<span>1、请选择重新计算开始时间，该时间距今最好不要超过3月，在这段时间所有积分将被清理，请谨慎操作；</span><br/>
				<span>2、执行完此操作需要要重新执行积分定时任务才能积分才能正常；</span><br/>
				<span>3、执行积分定时任务会导致系统变慢，因此最好在服务器空闲时间执行</span><br/>
			</div>
		</td>
	</tr>
</table>
</center>
<script type="text/javascript">
var validate = $KMSSValidation();

function _submit(){
	if(!validate.validate()){
		return;
	}
	var myForm=document.forms[0];		 		
	myForm.action='<c:url value="/kms/integral/kms_integral_rule/kmsIntegralConifg.do" />'+'?method=reset&startDate='
		+$("input[name=endTime]").val();
	myForm.method='POST';   
	myForm.submit();
}

</script>
<html:hidden property="method_GET"/>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
