<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<link href="${KMSS_Parameter_ResPath}style/common/list/list.css"
	rel="stylesheet" type="text/css" />
<script type="text/javascript"
	src="${KMSS_Parameter_ResPath}style/common/fileIcon/fileIcon.js"></script>
<%@ include file="/sys/ftsearch/autocomplete_include.jsp"%>
<input type="hidden" id="srcSynonym"
	value="${sysFtsearchSynonymForm.fdId}" />
<script>
	Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
	Com_IncludeFile("calendar.js|dialog.js");

	function getFdOriginal(){
		var fdOriginal = document.getElementById();
	}

	function setSelectText(el,start,end){
		if(el.createTextRange){
			var Range=el.createTextRange();
			Range.collapse();
			Range.moveEnd('character',end);
			Range.moveStart('character',start);
			Range.select();
		}
		if(el.setSelectionRange){
		        el.focus();  
		        el.setSelectionRange(start,end);  //设光标 
		    }
	}
		

	function getRelatedSynonyms(obj,isSubmit,method) {
		if(isSubmit!=true && event.keyCode!=13)
			return null;
		var synonyms = obj.value;
		var strSplit = null ;
		var replaceStr = synonyms.replace(new RegExp(";","gm"),"");
		if(synonyms.indexOf("\r\n") >=0){
			strSplit = replaceStr.split("\r\n").sort();
		} else {
			strSplit = replaceStr.split("\n").sort();
		}
		if(strSplit.length < 2 || strSplit[1]==""){
			alert("同义词不能只是一个词");
			return null;
		}
		for(var i=0;i<strSplit.length;i++){
			 if(strSplit[i] != ""){
				 if (strSplit[i]==strSplit[i+1]){
				  	alert("<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchSynonym.exist.error" />"+strSplit[i]);
				  	return false;
				 }
			 }
		}
		if(synonyms==null || synonyms=="")
			return null;
		return sendAjax(obj,synonyms,isSubmit,method);	
		
	}

	function sendAjax(obj,synonyms,isSubmit,method){
		$.ajax({	
	        url: "${KMSS_Parameter_ContextPath}sys/ftsearch/expand/sys_ftsearch_synonym/sysFtsearchSynonym.do?method=querySynonymbyAjax&fdSynonym="+encodeURI(synonyms)+"&fdId="+Com_GetUrlParameter(window.location.href, "fdId"),
	        success: function(data) {
	        	var synonym = $.parseJSON(data);
	        	var alertStr = ""; 
	        	for(var key in  synonym){
	        		var srcSynonym = $("#srcSynonym").val();
					if(srcSynonym.indexOf(key) >= 0){
						continue;
					}
					var words = synonym[key];
					alertStr +=  "输出词("
					for(var i in words){
						alertStr +=  words[i]+"  ";		
					}
					alertStr += ")在同义词("+key+")已经存在\r\n";
		        }
		        if(alertStr.length > 0){
			        alert(alertStr);
		        	return ;
				 }
		        if(method == "save"){
		        	var url ="<c:url value='/sys/ftsearch/expand/sys_ftsearch_synonym/sysFtsearchSynonym.do?method=addSynonym'/>"; 
	            	var targetSynonym = $("#fdSynonymSet").val();
	            	targetSynonym = formatSynonym(targetSynonym);
	            	 url = Com_SetUrlParameter(url, "synonymWord", targetSynonym);
	            	 var control  = confirm('你确定要将('
								+targetSynonym+')添加到词库吗'); 
		            	 if(control !='0'){
		            		 window.location.href =url;
		            	 }
			     }else{
			    	 var url ="<c:url value='/sys/ftsearch/expand/sys_ftsearch_synonym/sysFtsearchSynonym.do?method=updateSynonym'/>"; 
						var srcSynonym =  $("#srcSynonym").val();
						var targetSynonym = $("#fdSynonymSet").val();
						targetSynonym = formatSynonym(targetSynonym);
						if(validataSynonym(srcSynonym,targetSynonym)){
							 alert('<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchSynonym.has.no.replace"/>'); 
							return null;
						}
		            	 url = Com_SetUrlParameter(url, "srcSynonym",srcSynonym);
		            	 url = Com_SetUrlParameter(url, "targetSynonym", targetSynonym);
						var control  = confirm('你确定要将('
								+srcSynonym+')修改为（'+targetSynonym+')'); 
		            	 if(control !='0'){
		            		 window.location.href=url;
		            	 }

				 }
		    }
	    });
		return null;
	}

	
	function validataSynonym(srcSynonym,targetSynonym){
		if(srcSynonym == targetSynonym){
			return true;
		}
		var srcwords = srcSynonym.split(",");
		var targetwords = targetSynonym.split(",");
		if(srcwords.length != targetwords.length){
			return false;
		}
		var sortFlag = false;
		for(var i in targetwords){
			var targetword = targetwords[i];
			var flag = true;
			for(var j in  srcwords){
				if(targetword == srcwords[j]){
					flag = false;
					break;
				}
			}
			if(flag){
				return false;
			}
			sortFlag = true;
		}
		if(sortFlag){
			return sortFlag;
		}
		if(srcSynonym.indexOf(targetSynonym) == 0){
			return true;
		}
		return false;
	}

	function formatSynonym(targetSynonym){
		var result = null;
		if(targetSynonym.indexOf("\r\n")>=0){
			result = targetSynonym.replace(new RegExp("\r\n","gm"),",");
		}else{
			result = targetSynonym.replace(new RegExp("\n","gm"),",");
		}
		while(result.substring(result.length-1) ==","){
			result = result.substring(0,result.length-1);
		}
		
		result = result.replace(new RegExp(";,","gm"),";");
		result = result.replace(new RegExp("；,","gm"),";");
		return result;
	}
	
	function save() {
		getRelatedSynonyms(document.getElementById('fdSynonymSet'),true);
		
	}



</script>

<html:form
	action="/sys/ftsearch/expand/sys_ftsearch_synonym/sysFtsearchSynonym.do">
	<div id="optBarDiv"><c:if
		test="${sysFtsearchSynonymForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="getRelatedSynonyms(document.getElementById('fdSynonymSet'),true,'update');">
	</c:if> <c:if test="${sysFtsearchSynonymForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="getRelatedSynonyms(document.getElementById('fdSynonymSet'),true,'save');">
	</c:if> <input type="button" value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();"></div>

	<p class="txttitle"><bean:message bundle="sys-ftsearch-expand"
		key="table.sysFtsearchSynonym" /></p>

	<center>
	<table class="tb_normal" width=95%>

		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-ftsearch-expand" key="sysFtsearchSynonym.fdSynonymSet" />
			</td>
			<td width="85%" colspan="3"><%--
				<xform:textarea name="fdSynonymSet" property="fdSynonymSet" style="width:40%" />
			 --%> <textarea id="fdSynonymSet" name="fdSynonymSet"
				       style="width: 40%">${sysFtsearchSynonymForm.fdSynonymSet}</textarea>
			<bean:message bundle="sys-ftsearch-expand"
				key="sysFtsearchSynonym.tips" /></td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><bean:message
				bundle="sys-ftsearch-expand" key="sysFtsearchSynonym.docCreatorName" />
			</td>
			<td width="35%"><html:hidden property="docCreatorName" /> <c:out
				value="${sysFtsearchSynonymForm.docCreatorName}" /></td>
		</tr>
	</table>
	</center>

	<html:hidden property="fdSynchState" />
	<html:hidden property="fdId" />
	<html:hidden property="method_GET" />
	<script>
	Com_IncludeFile("calendar.js");
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>