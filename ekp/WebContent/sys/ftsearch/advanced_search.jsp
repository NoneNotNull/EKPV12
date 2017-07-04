<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="
	java.util.Iterator,
	com.landray.kmss.sys.ftsearch.config.LksConfigBuilder,
	com.landray.kmss.sys.ftsearch.config.LksConfig,
	com.landray.kmss.util.ResourceUtil,
	com.landray.kmss.util.StringUtil,
	com.landray.kmss.sys.config.dict.SysDataDict" %>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
Com_IncludeFile("calendar.js|dialog.js", null, "js");
function CommitSearch(){
	var url = Com_CopyParameter("<c:url value="/sys/ftsearch/searchBuilder.do?method=search"/>");
	//var target = "${param.s_target}";
	var target ="";
	url = Com_SetUrlParameter(url, "modelName", null);
	url = Com_SetUrlParameter(url, "s_target", null);
	
	var fromCreateTime = document.getElementsByName("fromCreateTime")[0];
	if(fromCreateTime.value!="" && !isDate(fromCreateTime,
			"<bean:message  bundle="sys-ftsearch-db" key="search.search.createTime.from"/>"))return;
	var toCreateTime = document.getElementsByName("toCreateTime")[0];
	if(toCreateTime.value!="" && !isDate(toCreateTime,
			"<bean:message  bundle="sys-ftsearch-db" key="search.search.createTime.to"/>"))return;
		
	url = setUrlParameters(url);
	if(url==null)
		return;
	var i = url.indexOf("?");
	if(url.length-url.indexOf("?")>1000)
		alert("<bean:message bundle="sys-search" key="search.conditionToLong" />");
	else{
		if(target=="")
			Com_OpenWindow(url,"_self");
		else
			Com_OpenWindow(url, target);
	}
}

function setUrlParameters(url){
	var queryString = document.getElementsByName("queryString")[0].value;
	url = Com_SetUrlParameter(url, "queryString",queryString );
	var modelName = document.getElementsByName("modelName")[0].value;
	url = Com_SetUrlParameter(url, "modelName", modelName);
	var category = document.getElementsByName("category")[0].value;
	url = Com_SetUrlParameter(url, "category", category);
	var mimeType = document.getElementsByName("mimeType")[0].value;
	url = Com_SetUrlParameter(url, "mimeType", mimeType);
	var fromCreateTime = document.getElementsByName("fromCreateTime")[0].value;
	url = Com_SetUrlParameter(url, "fromCreateTime", fromCreateTime);
	var toCreateTime = document.getElementsByName("toCreateTime")[0].value;
	url = Com_SetUrlParameter(url, "toCreateTime", toCreateTime);
	return url;
}

function isDate(field, message){
	lq_DateValidations = function(){
		this.a0 = new Array(
			field.name,
			"<kmss:message key="errors.date" />".replace("{0}", message),
			new Function ("varName", "this.datePattern='<bean:message key="date.format.date" />';  return this[varName];")
		);
	}
	return validateDate(document.forms[0]);
}
var searchConditionForm_DateValidations = null;

</script>
<center>
<p class="txttitle"><bean:message  bundle="sys-ftsearch-db" key="search.advanced.button"/></p>
<form name="lq">
<table class="tb_normal" width=80%>
		<tr>
			<td colspan="2" align="center">
				<input name="queryString" style="width:70%" class="inputSgl">
				&nbsp;&nbsp;
				<input type="button" value="<bean:message  bundle="sys-ftsearch-db" key="search.search.button"/>" onclick="CommitSearch();" />
			</td>
		</tr>
		<%
		String mn = request.getParameter("modelName");
		if(StringUtil.isNull(mn)){
		%>
		<tr>
			<td class="td_normal_title" width="15%">
				<bean:message  bundle="sys-ftsearch-db" key="search.search.modelName"/>
			</td>
			<td>
					<select name="modelName" onchange="">
						<option value=""><bean:message  bundle="sys-ftsearch-db" key="search.search.modelName.all"/></option>
						<%
 							LksConfig lc = LksConfigBuilder.getSingletonInstance().getLksConfig(LksConfigBuilder.getLksConfigPath());						
							for (Iterator iter = lc.getTasks().keySet().iterator(); iter.hasNext();) {
								String modelName = (String) iter.next();
								String text = SysDataDict.getInstance().getModel(modelName).getMessageKey();
								out.print("<option value='"+modelName+"'>"+ResourceUtil.getString(text)+"</option>");
				 			}									
						%>
					</select>
			</td>
		</tr>
	<%}else{%>
		<input type="hidden" name="modelName" value="<%=mn%>">
		<%}%>
		<tr>
			<td class="td_normal_title" width="15%">
				<bean:message  bundle="sys-ftsearch-db" key="search.search.category"/>
			</td>
			<td>
				<input name="category" style="width:50%" class="inputSgl">
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width="15%">
				<bean:message  bundle="sys-ftsearch-db" key="search.search.mimeType"/>
			</td>
			<td>
					<select name="mimeType">
						<option value=""><bean:message  bundle="sys-ftsearch-db" key="search.search.mimeType.all"/></option>
						<option value="pdf"><bean:message  bundle="sys-ftsearch-db" key="search.search.mimeType.pdf"/></option>
						<option value="doc"><bean:message  bundle="sys-ftsearch-db" key="search.search.mimeType.doc"/></option>
						<option value="xls"><bean:message  bundle="sys-ftsearch-db" key="search.search.mimeType.xls"/></option>
						<option value="ppt"><bean:message  bundle="sys-ftsearch-db" key="search.search.mimeType.ppt"/></option>
						<option value="rtf"><bean:message  bundle="sys-ftsearch-db" key="search.search.mimeType.rtf"/></option>
						<option value="html"><bean:message  bundle="sys-ftsearch-db" key="search.search.mimeType.html"/></option>
						<option value="swf"><bean:message  bundle="sys-ftsearch-db" key="search.search.mimeType.swf"/></option>
						<option value="zip"><bean:message  bundle="sys-ftsearch-db" key="search.search.mimeType.zip"/></option>
						<option value="mp3"><bean:message  bundle="sys-ftsearch-db" key="search.search.mimeType.mp3"/></option>
					</select>
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width="15%">
				<bean:message  bundle="sys-ftsearch-db" key="search.search.createTime"/>
			</td>
			<td>
				<bean:message  bundle="sys-ftsearch-db" key="search.search.createTime.from"/>
						&nbsp;<input name="fromCreateTime" class="inputSgl"><a href="#" onclick="selectDate('fromCreateTime');"><bean:message key="dialog.selectTime" /></a>
				&nbsp;<bean:message  bundle="sys-ftsearch-db" key="search.search.createTime.to"/>
						&nbsp;<input name="toCreateTime" class="inputSgl"><a href="#" onclick="selectDate('toCreateTime');"><bean:message key="dialog.selectTime" /></a>
			</td>
		</tr>
	</table>	

</form>
</center>
<%@ include file="/resource/jsp/edit_down.jsp"%>