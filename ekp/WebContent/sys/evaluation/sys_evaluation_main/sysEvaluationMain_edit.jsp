<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
function onValueChg_eval(thisObj){
	var evalStr=thisObj.value.split("");
	var promptVar=document.getElementById("div_prompt_eval");
	var l = 0;
	for (var i = 0; i < evalStr.length; i++) {				
		if (evalStr[i].charCodeAt(0) < 299) {
			l++;
		} else {
			l += 2;
		}
	}
	if(l<280){
		promptVar.innerHTML='<bean:message key="sysEvaluation.pda.alert1" bundle="sys-evaluation"/>'+Math.abs(parseInt((280-l) / 2))+'<bean:message key="sysEvaluation.pda.alert3" bundle="sys-evaluation"/>';
		promptVar.style.color="";
	}else{
		promptVar.innerHTML='<bean:message key="sysEvaluation.pda.alert2" bundle="sys-evaluation"/>'+Math.abs(parseInt((l-280) / 2))+'<bean:message key="sysEvaluation.pda.alert3" bundle="sys-evaluation"/>';
		promptVar.style.color="red";
				
	}	
}
function Eval_Submit(){
	var promptVar=document.getElementById("div_prompt_eval");
	if(promptVar.style.color=="red"){
      alert("点评字数不能超过140字");
	}else{
	   Com_Submit(document.sysEvaluationMainForm, 'save');
	}
	// 点评完毕刷新父窗口
	window.opener.location.reload();
}

</script>
<html:form action="/sys/evaluation/sys_evaluation_main/sysEvaluationMain.do" onsubmit="return validateSysEvaluationMainForm(this);">
	<div id="optBarDiv">
		<input type=button value="<bean:message key="button.submit"/>" onclick="Eval_Submit();">
		<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
	</div>

	<p class="txttitle">
		<bean:message bundle="sys-evaluation" key="table.sysEvaluationMain" />
	</p>
	<center>
		<table class="tb_normal" width=95%>
			<html:hidden property="fdId" />
			<tr>
				<td class="td_normal_title" width=100px>
					<bean:message bundle="sys-evaluation" key="sysEvaluationMain.sysEvaluator" />
				</td>
				<td>
					<html:text property="fdEvaluatorName" readonly="true"/>
				</td>
			</tr>
			<tr>
				<td class="td_normal_title">
					<bean:message bundle="sys-evaluation" key="sysEvaluationMain.fdEvaluationTime" />
				</td>
				<td>
					<html:text property="fdEvaluationTime" readonly="true"/>
				</td>
			</tr>
			<tr>
				<td class="td_normal_title">
					<bean:message bundle="sys-evaluation" key="sysEvaluationMain.fdEvaluationScore" />
				</td>
				<td>
					<sunbor:enums property="fdEvaluationScore" enumsType="sysEvaluation_Score" elementType="select"/>
				</td>
			</tr>
			<tr>
				<td class="td_normal_title">
					<bean:message bundle="sys-evaluation" key="sysEvaluationMain.fdEvaluationContent" />
				</td>
				<td>
					<html:textarea property="fdEvaluationContent" style="width:90%;height:80px" 
					onfocus="onValueChg_eval(this);"  onkeyup="onValueChg_eval(this);"/>
					<div id="div_prompt_eval"></div>
				</td>
			</tr>
			<tr>
				<td class="td_normal_title">
					<bean:message key="sysEvaluationMain.notifyOption" bundle="sys-evaluation" />
				</td>
				<td>
					<input name="isNotify" type="checkbox" value="yes"><bean:message key="sysEvaluationMain.isNotify" bundle="sys-evaluation" />
					<c:if test="${param.notifyOtherName!='' && param.notifyOtherName!= null}">
					<input name="notifyOther" type="checkbox" value="${param.notifyOtherName}" checked="checked"><bean:message key="${param.key}" bundle="${param.bundel}" />
					</c:if>
				</td>
			</tr>
			<tr>
				<td class="td_normal_title">
					<bean:message key="sysNotifySetting.fdNotifyType" bundle="sys-notify" />
				</td>
				<td>
					<kmss:editNotifyType property="fdNotifyType" />
				</td>
			</tr>
		</table>
	</center>
	<html:hidden property="method_GET" />
	<html:hidden property="fdKey" />
	<html:hidden property="fdModelId" />
	<html:hidden property="fdModelName" />
</html:form>
<script language="JavaScript">Com_IncludeFile("calendar.js");</script>
<html:javascript formName="sysEvaluationMainForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>
