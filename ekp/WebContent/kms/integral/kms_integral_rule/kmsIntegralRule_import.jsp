<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="/resource/jsp/jsperror.jsp"%>
<%@ page import="
	com.landray.kmss.util.KmssMessageWriter,
	com.landray.kmss.util.KmssReturnPage" %>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<% response.addHeader("X-UA-Compatible", "IE=5"); %>
<script type="text/javascript">
Com_Parameter.CloseInfo="<bean:message key="message.closeWindow"/>";
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("docutil.js|optbar.js|validator.jsp|validation.js|plugin.js|validation.jsp|eventbus.js|xform.js", null, "js");
</script>
<base target="_self">
</head>
<body>
<html:form action="kms/integral/kms_integral_rule/kmsIntegralRule.do">
<div id="optBarDiv">
	<input type="button" value="<bean:message key='button.update'/>"
		onclick="_submit();">
</div>
<p class="txttitle"><bean:message bundle="kms-integral" key="kmsIntegralRule.importTitle"/></p>
<div  style="float: right;width:150px;">
<label style="cursor:pointer"><input type="checkbox" id="selectAll_opt" onclick="selectAll();" >
			<bean:message bundle="kms-integral" key="selectAll"/>
		</input></label>
</div>
<center>
<input type='hidden'  name ='attribute'  />
<table class="tb_normal" width=80% id="ruleTable">
</table>
</center>
<script>
Com_AddEventListener(window,"load",function(){
	var ruleJson = jQuery.parseJSON('${logRules}');
	var ruleTable = $("#ruleTable");
	var tr,td,model,modelName;
	var map = {};
	for(var i=0;i<ruleJson.length;i++){
		var rule = ruleJson[i];
		if(!map[rule.model]){
			modelName = rule.model;
			tr = $('<tr name="module">');
			td = $('<td name='+modelName+' width=25% style="line-height: 25px">');
			model= $('<strong><label>'+rule.model+'：</label></strong>'+
					'<label style="cursor:pointer"><input type="checkbox" name="selectAll_area" onclick="areaSelectAll(this);" >'+
					'<bean:message bundle="kms-integral" key="selectAll"/></input></label><br>');
			td.append(model);
			tr.append(td);
			ruleTable.append(tr);
			map[rule.model]= td;
		}
		var checked = rule.isSelected?'checked':'';
		map[rule.model].append('<label><input id="'+rule.id+'" name="logRule" type="checkbox" value="'
				+rule.model+'" '+checked+' >'+rule.text+'</label>');
	}
});

function selectAll(){ 
	var selectAll_opt = $("#selectAll_opt");
	if(selectAll_opt.prop("checked")){
		$("input[name='logRule']").prop("checked",true);
		$("input[name='selectAll_area']").prop("checked",true);
	}else{
		$("input[name='logRule']").prop("checked",false);
		$("input[name='selectAll_area']").prop("checked",false);
	}
}

function areaSelectAll(dom){
	var modelName = $(dom.parentElement.parentElement).attr("name");
	if($(dom).prop("checked")){
		$("td[name="+modelName+"] :input").prop("checked",true);
	}else{
		$("td[name="+modelName+"] :input").prop("checked",false);
	}
}

function _submit(){
	var fdSelectedRule = document.getElementsByName('attribute')[0];
	var  kmslogRules="";
	$("input[name='logRule']:checked").each(function(){
		kmslogRules+=this.id+";";
	});
	fdSelectedRule.value=kmslogRules;
	var myForm=document.forms['kmsIntegralRulesForm'];
	Com_Submit(myForm,"saveRule");
}

</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>