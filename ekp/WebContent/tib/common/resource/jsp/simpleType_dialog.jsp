<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
</head>

<body>
<style>
.PromptTB{border: 1px solid #000033;}
.barmsg{border-bottom: 1px solid #000033;}
</style>
<script type="text/javascript">
Com_Parameter.CloseInfo="<bean:message key="message.closeWindow"/>";
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("docutil.js|optbar.js|validator.jsp|validation.js|plugin.js|validation.jsp|eventbus.js|xform.js", null, "js");
</script>
<link href="${KMSS_Parameter_ContextPath}resource/style/default/promptBox/prompt.css" rel="stylesheet" type="text/css" />
<br><br><br><br><br>
<script type="text/javascript">
Com_IncludeFile("data.js|jquery.js");


</script>
<table width=400  border="0" align="center" cellpadding="0" cellspacing="0" class="PromptTB">
	<tr> 
		<td bgcolor="#FFFFFF" height=18 class=barmsg>
			<bean:message bundle="tib-common" key="tibCommon.lang.sysPrompt"/>
		</td>
	</tr>
	<tr>
		<td>
			<table bgcolor="#FFFFFF" border=0 cellspacing=0 cellpadding=0 width=100%>
				<tr>
					<td width=20 class="PromptTD_Left Prompt_error"></td>
					<td class="PromptTD_Center">
						<br>
						<bean:message bundle="tib-common" key="tibCommon.lang.chooseCounterIntegrationType"/>
						<br>
						<select id="iselect">
						<option value=''><bean:message bundle="tib-common" key="tibCommon.lang.pleaseChoose"/></option>
						</select>
						<input value="<bean:message bundle="tib-common" key="tibCommon.lang.confirm"/>" class="btnopt" type="button" onclick="submitSelect('iselect')" />
						
						<br>
						<br>
					</td>
					<td class="PromptTD_Center" width=20>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

</body>
</html>
<script type="text/javascript">
    (function initSelect(){
    	var rtnData = window.dialogArguments;
    	// 兼容IE11
    	if (!!window.ActiveXObject || "ActiveXObject" in window){  
    		rtnData = window.dialogArguments;  
    	} else {  
    	    // Firefox浏览器（画面自提交后，window.dialogArguments会丢失，同时window.opener属性存在），  
    	    if (window.opener.rtnData == undefined) {  
    	        window.opener.rtnData = window.dialogArguments;  
    	    }  
    	    rtnData = window.opener.rtnData;  
    	}  
    	var rtn=rtnData["rtnJson"];
		for(var i=0,len=rtn.length;i<len;i++){
			var str="<option value='!{val}'>!{display}</option>";
			$("#iselect").append(str.replace("!{display}",rtn[i]["iname"]).replace("!{val}",rtn[i]["itype"]));
		}
    })();

    function submitSelect(sid){
    	var rtnData = window.dialogArguments;
    	var rtnVal=$("#"+sid).val();
    	rtnData["stype"]=rtnVal;
    	window.close();
    }
</script>


