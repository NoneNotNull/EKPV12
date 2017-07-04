<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%> 
<script>
//提交
function kmsAsk_Com_Submit(){
	var fdSamePostVal = $("input[name='fdSamePost']").val();
	var fdDayBaseVal = $("input[name='fdDayBase']").val();
	var fdDayWarnVal = $("input[name='fdDayWarn']").val();
	var fdTopScoreVal = $("input[name='fdTopScore']").val();

	if(fdSamePostVal!=null && parseInt(fdSamePostVal)<=0){
		alert("<bean:message  bundle='kms-ask' key='kmsAsk.samepost.num'/>");
		return false;
	}
	if(fdDayBaseVal!=null && parseInt(fdDayBaseVal)<=0){
		alert("<bean:message  bundle='kms-ask' key='kmsAsk.daybase.num'/>");
		return false;
	}
	if(fdDayWarnVal!=null && parseInt(fdDayWarnVal)<=0){
		alert("<bean:message  bundle='kms-ask' key='kmsAsk.daywarn.num'/>");
		return false;
	}
	if(fdTopScoreVal!=null && parseInt(fdTopScoreVal)<=0){
		alert("<bean:message  bundle='kms-ask' key='kmsAsk.topscore.num'/>");
		return false;
	}
	
	Com_Submit(document.kmsAskConfigForm, 'update');
	return true; 
}
</script>
<html:form action="/kms/ask/kms_ask_config/kmsAskConfig.do" onsubmit="return validateKmsAskConfigForm(this);">
<div id="optBarDiv">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="return kmsAsk_Com_Submit();">
</div>

<p class="txttitle"><bean:message bundle="kms-ask" key="menu.kmsAsk.config"/></p>
<center>
<table class="tb_normal" width=95%> 
	<tr><%--同时可提问题数--%>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="kms-ask" key="kmsAskConfig.fdSamePost"/>
		</td>
		<td colspan=3>
			<html:text property="fdSamePost" size="5"/><span class="txtstrong">*</span>
			<br>
			<font color="red">
				<bean:message  bundle="kms-ask" key="kmsAskConfig.fdSamePost.tip1"/>
				<br><bean:message  bundle="kms-ask" key="kmsAskConfig.fdSamePost.tip2"/> 
			</font> 
		</td>
	</tr> 
	<%--每日最多可推荐问题--%>
	<%--<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="kms-ask" key="kmsAskConfig.fdIntroduceNum"/>
		</td>
		<td colspan=3>
			<html:text property="fdIntroduceNum" size="5"/><span class="txtstrong">*</span>  
		</td>
	</tr>--%>
	<tr><%--问题保留时间(天) --%>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="kms-ask" key="kmsAskConfig.fdDayBase"/>
		</td>
		<td colspan=3>
			<html:text property="fdDayBase" size="5"/><span class="txtstrong">*</span>  
		</td>
	</tr> 
	<tr><%--问题预紧时间(天) --%>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="kms-ask" key="kmsAskConfig.fdDayWarn"/>
		</td>
		<td colspan=3>
			<html:text property="fdDayWarn" size="5"/><span class="txtstrong">*</span>  
		</td>
	</tr>
	<tr><%--高分问题(分数，此分数以上的为高分问题) --%>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="kms-ask" key="kmsAskConfig.fdTopScore"/>
		</td>
		<td colspan=3>
			<html:text property="fdTopScore" size="5"/><span class="txtstrong">*</span>
			&nbsp; &nbsp; 
			<font color="red">
				<bean:message  bundle="kms-ask" key="kmsAskConfig.fdTopScore.tip"/>
			</font>  
		</td>
	</tr> 
</table>
</center>
<html:hidden property="method_GET"/>
</html:form> 
<html:javascript formName="kmsAskConfigForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/> 
<%@ include file="/resource/jsp/edit_down.jsp"%>
