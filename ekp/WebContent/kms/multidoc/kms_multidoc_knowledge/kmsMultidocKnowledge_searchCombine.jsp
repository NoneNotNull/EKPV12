<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<%@ page import="com.landray.kmss.util.ModelUtil"%>
<%@ page import="com.landray.kmss.sys.search.web.SearchResultColumn"%>
<%@ page import="com.landray.kmss.sys.search.web.SearchConditionEntry" %>
<%@ page import="java.util.HashMap"%>
<%@ page import="com.landray.kmss.sys.search.web.SearchConditionUtil"%>
<kmss:windowTitle
	subject="${searchConditionInfo.title}" />
<script type="text/javascript">
Com_IncludeFile("document.css", "style/"+Com_Parameter.Style+"/doc/");
</script>
<%-- 条件 start --%>
<center>
<p class="txttitle"><c:out value="${searchConditionInfo.title}" /></p>
<form name="searchConditionForm" onsubmit="return false;">
<table width=100% class="tb_normal" id="TB_Condition">
<% Object info = request.getAttribute("searchConditionInfo");
if (info instanceof com.landray.kmss.sys.search.web.SearchCondition) { %>
<c:set var="parameters" value="<%=new HashMap()%>" />
<% } else { %>
<c:set var="parameters" value="${searchConditionInfo.parameters}" />
<% } %>
<c:set var="tdIndex" value="0" />
<c:forEach items="${searchConditionInfo.entries}" var="conditionEntry" varStatus="vStatus">
	<c:set var="tdIndex" value="${vStatus.index}" />
	<c:set var="entryIndex" value="${vStatus.index}" />
	<c:set var="propertyName" value="${conditionEntry.property.name}" />
<c:if test="${(vStatus.index+1)%3 == 1}">
	<tr>
</c:if>
		<td width="5%" class="td_normal_title">
			<c:if test="${not empty conditionEntry.messageKey}">
			<kmss:message key="${conditionEntry.messageKey}" />
			</c:if>
			<c:if test="${empty conditionEntry.messageKey}">
			<c:out value="${conditionEntry.label}" />
			</c:if>
		</td>
		<td width="25%" kmss_type="${conditionEntry.type}">
			<c:choose>
				<%-- 扩展数据 --%>
				<c:when test="${(conditionEntry.type=='number' or conditionEntry.type=='string') and (not empty conditionEntry.property.enumValues)}">
					<%
					SearchConditionEntry conditionEntry = (SearchConditionEntry)pageContext.getAttribute("conditionEntry");
					SearchConditionUtil.setEnumPropertyValue(pageContext);
					SearchConditionUtil.setPropertyEnumValues(conditionEntry.getProperty(), pageContext);
					%>
					<sunbor:multiSelectCheckbox 
						beanLabelProperty="label"
						beanValueProperty="value"
						avalables="${avalables}" 
						assignProperty="true" 
						propertyValue="${v0}" 
						property="v0_${entryIndex}" />
				</c:when>
				<c:when test="${conditionEntry.type=='string'}">
					<c:if test="${!conditionEntry.hasDialogJS}">
					<input name="v0_${entryIndex}" class="inputSgl" value="${parameters[propertyName].v0_}">
					</c:if>
					<c:if test="${conditionEntry.hasDialogJS}">
					<input type="hidden" name="v0_${entryIndex}" value="${parameters[propertyName].v0_}" />
	        		<input name="t0_${entryIndex}" readonly class="inputsgl" value="${parameters[propertyName].t0_}"/>
					<%
						SearchConditionEntry conditionEntry = (SearchConditionEntry)pageContext.getAttribute("conditionEntry");
						String entryIndex = pageContext.getAttribute("entryIndex").toString();
						pageContext.setAttribute("dialogScript", conditionEntry.getDialogJS(new com.landray.kmss.common.actions.RequestContext(request),"v0_"+entryIndex,"t0_"+entryIndex));
					%>
			        <a onclick="${dialogScript}" href="javascript:void(0);"><bean:message key="button.select" /></a>
					</c:if>
				</c:when>
				<c:when test="${conditionEntry.type=='number'}">
					<select name="v0_${entryIndex}" onchange="refreshLogicDisplay(this, 'span_v2_${entryIndex}');">
						<option value="eq" ${parameters[propertyName].v0_ eq "eq" ? "selected" : ""}><bean:message bundle="sys-search" key="search.logic.number.eq" /></option>
						<option value="lt" ${parameters[propertyName].v0_ eq "lt" ? "selected" : ""}><bean:message bundle="sys-search" key="search.logic.number.lt" /></option>
						<option value="le" ${parameters[propertyName].v0_ eq "le" ? "selected" : ""}><bean:message bundle="sys-search" key="search.logic.number.le" /></option>
						<option value="gt" ${parameters[propertyName].v0_ eq "gt" ? "selected" : ""}><bean:message bundle="sys-search" key="search.logic.number.gt" /></option>
						<option value="ge" ${parameters[propertyName].v0_ eq "ge" ? "selected" : ""}><bean:message bundle="sys-search" key="search.logic.number.ge" /></option>
						<option value="bt" ${parameters[propertyName].v0_ eq "bt" ? "selected" : ""}><bean:message bundle="sys-search" key="search.logic.number.bt" /></option>
					</select>
					<input name="v1_${entryIndex}" class="inputSgl" value="${parameters[propertyName].v1_}">
					<span id="span_v2_${entryIndex}" ${parameters[propertyName].v0_ eq "bt" ? "" : "style='display:none'"}>&nbsp;<bean:message bundle="sys-search" key="search.logic.middleStr" />
					<input name="v2_${entryIndex}" class="inputSgl" value="${parameters[propertyName].v2_}">
					&nbsp;<bean:message bundle="sys-search" key="search.logic.rightStr" /></span>
				</c:when>
				<c:when test="${conditionEntry.type=='date'}">
					<select name="v0_${entryIndex}" onchange="refreshLogicDisplay(this, 'span_v2_${entryIndex}');">
						<option value="eq" ${parameters[propertyName].v0_ eq "eq" ? "selected" : ""}><bean:message bundle="sys-search" key="search.logic.date.eq" /></option>
						<option value="lt" ${parameters[propertyName].v0_ eq "lt" ? "selected" : ""}><bean:message bundle="sys-search" key="search.logic.date.lt" /></option>
						<option value="le" ${parameters[propertyName].v0_ eq "le" ? "selected" : ""}><bean:message bundle="sys-search" key="search.logic.date.le" /></option>
						<option value="gt" ${parameters[propertyName].v0_ eq "gt" ? "selected" : ""}><bean:message bundle="sys-search" key="search.logic.date.gt" /></option>
						<option value="ge" ${parameters[propertyName].v0_ eq "ge" ? "selected" : ""}><bean:message bundle="sys-search" key="search.logic.date.ge" /></option>
						<option value="bt" ${parameters[propertyName].v0_ eq "bt" ? "selected" : ""}><bean:message bundle="sys-search" key="search.logic.date.bt" /></option>
					</select>
					<input name="v1_${entryIndex}" class="inputSgl" readonly value="${parameters[propertyName].v1_}"><a href="javascript:void(0);" onclick="return selectDate('v1_${entryIndex}');"><bean:message key="dialog.selectTime" /></a>
					<span id="span_v2_${entryIndex}" ${parameters[propertyName].v0_ eq 'bt' ? '' : 'style=display:none'}>&nbsp;<bean:message bundle="sys-search" key="search.logic.middleStr" />
					<input name="v2_${entryIndex}" class="inputSgl" readonly value="${parameters[propertyName].v2_}"><a href="javascript:void(0);" onclick="return selectDate('v2_${entryIndex}');"><bean:message key="dialog.selectTime" /></a>
					&nbsp;<bean:message bundle="sys-search" key="search.logic.rightStr" /></span>
				</c:when>
				<c:when test="${conditionEntry.type=='foreign'}">
					<table class="tb_noborder" width="100%">
						<tr>
						<c:if test="${conditionEntry.property.name ne 'docKeyword' }">
							<td>
	        					<input type="hidden" name="v0_${entryIndex}" value="${parameters[propertyName].v0_}" />
	        					<input name="t0_${entryIndex}" readonly class="inputsgl" style="width=85%;" value="${parameters[propertyName].t0_}"/>
								<%
									SearchConditionEntry conditionEntry = (SearchConditionEntry)pageContext.getAttribute("conditionEntry");
									if(conditionEntry.getProperty().getDialogJS()!=null){
										String entryIndex = pageContext.getAttribute("entryIndex").toString();
										pageContext.setAttribute("dialogScript", conditionEntry.getDialogJS(new com.landray.kmss.common.actions.RequestContext(request),"v0_"+entryIndex,"t0_"+entryIndex));
								%>
						        <a onclick="${dialogScript}" href="javascript:void(0);"><bean:message key="button.select" /></a>
						        <c:if test="${conditionEntry.treeModel}">
									<br><input name="t1_${entryIndex}" type="checkbox">
									<bean:message bundle="sys-search" key="search.includeChild"/>
								</c:if>
								<%	} %>
							</td>
							<td style="display:none">
								<input name="v1_${entryIndex}" style="width=85%;" class="inputSgl" value="${parameters[propertyName].v1_}"/>
							</td>
							<td width="10px">
								<input name="v2_${entryIndex}" type="checkbox" onclick="refreshMatchDisplay(this);" ${empty parameters[propertyName].v2_ ? "" : "checked"} title="<bean:message bundle="sys-search" key="search.blursearch"/>">
								<c:if test="${not empty parameters[propertyName].v2_}">
									<script>
									Com_AddEventListener(window, 'load', function() {
										refreshMatchDisplay(document.getElementsByName("v2_${entryIndex}")[0]);
									});
									</script>
								</c:if>
							</td>
						</c:if>
						<c:if test="${conditionEntry.property.name eq 'docKeyword' }">
							<td>
	        					<input type="hidden" name="v0_${entryIndex}" value="${parameters[propertyName].v0_}"/>
	        					<input type="hidden" name="t0_${entryIndex}" value="${parameters[propertyName].t0_}"/>
							</td>
							<td>
								<input name="v1_${entryIndex}" style="width=85%;" class="inputSgl" value="${parameters[propertyName].v1_}"/>
							</td>
							<td style="display:none">
								<input name="v2_${entryIndex}" type="checkbox" checked>
							</td>
						</c:if>
						</tr>
					</table>
				</c:when>
				<c:when test="${conditionEntry.type=='enum'}">
				 <% SearchConditionUtil.setEnumPropertyValue(pageContext);  %>
					<sunbor:multiSelectCheckbox enumsType="${conditionEntry.enumsType}" assignProperty="true" propertyValue="${v0}" property="v0_${entryIndex}" />
				</c:when>
			</c:choose>
		</td>
<c:if test="${(vStatus.index+1)%3 == 0}">
	</tr>
</c:if>
</c:forEach>
<%-- 补全table --%>
<c:if test="${tdIndex != 0 && (tdIndex+1)%3 == 1}">
		<td width="5%" class="td_normal_title"></td>
		<td width="25%">&nbsp;</td>
		<td width="5%" class="td_normal_title"></td>
		<td width="25%">&nbsp;</td>
	</tr>
</c:if>
<c:if test="${tdIndex != 0 && (tdIndex+1)%3 == 2}">
		<td width="5%" class="td_normal_title"></td>
		<td width="25%">&nbsp;</td>
	</tr>
</c:if>
<script>
Com_IncludeFile("calendar.js|dialog.js|validator.jsp", null, "js");
Com_AddEventListener(window, 'load', function() {<%-- 从url读取参数写入表单 --%>
	var url = location.href;
	var tbObj = document.getElementById("TB_Condition");
	var v0_, t0_, v1_, v2_;
	for(var i=0; i<tbObj.cells.length/2; i++){
		var type = tbObj.cells[2*i+1].getAttribute("kmss_type");
		if(type == null)
			continue;
		v0_ = Com_GetUrlParameter(url, "v0_"+i);
		var fields = document.getElementsByName("v0_"+i);
		switch(type){
		case "string":
			if(!v0_)
				continue;
			if(fields[0].type == 'checkbox') {<%-- checkbox --%>
				setCheckedFormValues(fields, v0_);
				break;
			}
			fields[0].value = v0_;
			t0_ = Com_GetUrlParameter(url, "t0_"+i);
			if(t0_) {
				document.getElementsByName("t0_"+i)[0].value = t0_;
			}
			break;
		case "date":
		case "number":
			if(!v0_)
				continue;
			if (fields[0].options == null && fields[0].type == 'checkbox') {<%-- checkbox --%>
				setCheckedFormValues(fields, v0_);
				break;
			}
			setSelectedFormValue(fields[0], v0_);
			refreshLogicDisplay(fields[0], 'span_v2_'+i);
			v1_ = Com_GetUrlParameter(url, "v1_"+i);
			document.getElementsByName("v1_"+i)[0].value = v1_;
			v2_ = Com_GetUrlParameter(url, "v2_"+i);
			if(v2_)
				document.getElementsByName("v2_"+i)[0].value = v2_;
			break;
		case "foreign":
			if(v0_) {<%-- 精确搜索 --%>
				fields[0].value = v0_;
				t0_ = Com_GetUrlParameter(url, "t0_"+i);
				if(t0_)
					document.getElementsByName("t0_"+i)[0].value = t0_;
			}
			v1_ = Com_GetUrlParameter(url, "v1_"+i);
			if(v1_) {<%-- 模糊搜索 --%>
				document.getElementsByName("v1_"+i)[0].value = v1_;
				document.getElementsByName("v2_"+i)[0].checked = true;
				refreshMatchDisplay(document.getElementsByName("v2_"+i)[0]);
			}
			v2_ = Com_GetUrlParameter(url, "v2_"+i);
			if(v2_) {<%-- 树 --%>
				fields[0].value = v2_;
				t0_ = Com_GetUrlParameter(url, "t0_"+i);
				if(t0_)
					document.getElementsByName("t0_"+i)[0].value = t0_;
				document.getElementsByName("t1_"+i)[0].checked = true;
			}
			break;
		case "enum":
			if(!v0_)
				continue;
			setCheckedFormValues(fields, v0_);
			break;
		}
	}
});
function CommitSearch(){
	//var url = Com_CopyParameter('<c:url value="${searchConditionInfo.resultUrl}" />');
	//url = Com_SetUrlParameter(url, "method", "searchCombine");
	var url = Com_CopyParameter('<c:url value="/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=searchCombine" />');
	var tbObj = document.getElementById("TB_Condition");
	for(var i=0; i<tbObj.cells.length/2; i++){
		var type = tbObj.cells[2*i+1].getAttribute("kmss_type");
		if(type == null)
			continue;
		var fields = document.getElementsByName("v0_"+i);
		if(fields.length==0)
			continue;
		switch(type){
		case "string":
			if(fields[0].type != 'checkbox') {
				var fieldt0 = document.getElementsByName("t0_"+i)[0];
				if(fields[0].value == "") {
					url = Com_SetUrlParameter(url, fields[0].name, null);
					if(fieldt0) {
						url = Com_SetUrlParameter(url, fieldt0.name, null);
					}
				} else {
					url = Com_SetUrlParameter(url, fields[0].name, fields[0].value);
					if(fieldt0) {
						url = Com_SetUrlParameter(url, fieldt0.name, fieldt0.value);
					}
				}
			} else {
				url = setCheckedListToUrl(url, fields);
			}
		break;
		case "date":
		case "number":
			if(type=="date")
				var validateFun = isDate;
			else
				var validateFun = isNumber;
			var field1 = document.getElementsByName("v1_"+i)[0];
			var field2 = document.getElementsByName("v2_"+i)[0];
			<%-- 增加对扩展类型支持 --%>
			if (fields[0].options == null && fields[0].type == 'checkbox') {
				url = setCheckedListToUrl(url, fields);
				break;
			}
			var logicStr = fields[0].options[fields[0].selectedIndex].value;
			if(logicStr=="bt"){
				if(field1.value=="" && field2.value=="") {
					url = Com_SetUrlParameter(url, field1.name, null);
					url = Com_SetUrlParameter(url, field2.name, null);
					continue;
				}
				if(field1.value=="" || field2.value==""){
					alert('<kmss:message key="errors.required" />'.replace("{0}", tbObj.cells[2*i].innerText||tbObj.cells[2*i].textContent));
					return;
				}
				if(!validateFun(field2, tbObj.cells[2*i].innerText||tbObj.cells[2*i].textContent))
					return;
			}else{
				if(field1.value=="") {
					url = Com_SetUrlParameter(url, field1.name, null);
					url = Com_SetUrlParameter(url, fields[0].name, null);
					url = Com_SetUrlParameter(url, field2.name, null);
					continue;
				}
			}
			if(!validateFun(field1, tbObj.cells[2*i].innerText||tbObj.cells[2*i].textContent))
				return;
			url = Com_SetUrlParameter(url, fields[0].name, logicStr);
			url = Com_SetUrlParameter(url, field1.name, field1.value);
			if(logicStr=="bt")
				url = Com_SetUrlParameter(url, field2.name, field2.value);
		break;
		case "foreign":
			var typeField = document.getElementsByName("v2_"+i);
			if(typeField.length>0 && typeField[0].checked)
				fields = document.getElementsByName("v1_"+i);
			var fieldName = fields[0].name;
			typeField = document.getElementsByName("t1_"+i);
			if(typeField.length>0 && typeField[0].checked)
				fieldName = "v2_"+i;
			if(fields[0].value!="") {
				url = Com_SetUrlParameter(url, fieldName, fields[0].value);
				var fieldt0 = document.getElementsByName("t0_"+i)[0];
				if(fieldt0.value)
					url = Com_SetUrlParameter(url, fieldt0.name, fieldt0.value);
			} else {
				url = Com_SetUrlParameter(url, "v0_"+i, null);
				url = Com_SetUrlParameter(url, "v1_"+i, null);
				url = Com_SetUrlParameter(url, "v2_"+i, null);
			}
		break;
		case "enum":
			url = setCheckedListToUrl(url, fields);
		break;
		}
	}
	if(window.customSearch!=null)
		url = customSearch(url);
	if(url==null)
		return;
	var i = url.indexOf("?");
	if(url.length-url.indexOf("?")>1000)
		alert('<bean:message bundle="sys-search" key="search.conditionToLong" />');
	else{
		location.href = url;
	}
}
function setCheckedListToUrl(url, fields) {
	var value = "";
	for(var j=0; j<fields.length; j++){
		if(fields[j].checked)
			value += ";"+fields[j].value;
	}
	if(value!="") {
		url = Com_SetUrlParameter(url, fields[0].name, value.substring(1));
	} else {
		url = Com_SetUrlParameter(url, fields[0].name, null);
	}
	return url;
}
function setCheckedFormValues(fields, vals) {
	var valArr = vals.split(";");
	for(var i = 0; i < valArr.length; i++) {
		for(var j = 0; j < fields.length; j++) {
			if(fields[j].value == valArr[i]){
				fields[j].checked = true;
				break;
			}
		}
	}
}
function setSelectedFormValue(objSelect, val) {
	for(var j = 0; j < objSelect.options.length; j++) {
		if(objSelect.options[j].value == val){
			objSelect.options[j].selected = true;
			break;
		}
	}
}
function resetDisplay(){
	var tbObj = document.getElementById("TB_Condition");
	for(var i=0; i<tbObj.cells.length/2; i++){
		var type = tbObj.cells[2*i+1].getAttribute("kmss_type");
		if(type == null)
			continue;
		switch(type){
		case "date":
		case "number":
			var obj = document.getElementById("span_v2_"+i);
			if(obj)
				obj.style.display = "none";
		break;
		case "foreign":
			var obj = tbObj.cells[2*i+1].getElementsByTagName("TABLE")[0];
			obj.rows[0].cells[0].style.display = "";
			obj.rows[0].cells[1].style.display = "none";
		break;
		}
	}
	if(window.customReset!=null)
		customReset();
}
function refreshMatchDisplay(obj){
	for(var tbObj=obj; tbObj.tagName!="TABLE"; tbObj=tbObj.parentNode);
	tbObj.rows[0].cells[0].style.display = obj.checked?"none":"block";
	tbObj.rows[0].cells[1].style.display = obj.checked?"block":"none";
}
function refreshLogicDisplay(obj, id){
	var spanObj = document.getElementById(id);
	if(obj.options[obj.selectedIndex].value=="bt")
		spanObj.style.display = "";
	else
		spanObj.style.display = "none";
}
function isNumber(field, message){
	if(field.value.split(".").length<3)
		if(!(/[^\d\.]/gi).test(field.value))
			return true;
	alert("<bean:message key="errors.number" />".replace("{0}", message));
	field.focus();
	return false;
}
function isDate(field, message){
	searchConditionForm_DateValidations = function(){
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
	<c:if test="${searchConditionInfo.conditionUrl!=null}">
		<c:import url="${searchConditionInfo.conditionUrl}" charEncoding="UTF-8"/>
	</c:if>
</table>
<br />
<input type="button" class="btnopt" name="commitSearch" value="<bean:message key="button.search"/>" onclick="CommitSearch();" />
&nbsp;&nbsp;&nbsp;&nbsp;
<input type="reset" class="btnopt" value="<bean:message key="button.reset" />" onclick="resetDisplay()" />
</form>
</center>
<%-- 条件 end --%>
<%-- 结果数据 start --%>
	<% if (((Page)request.getAttribute("queryPage")).getTotalrows()==0){ %>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<% }else{ %>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="40pt"><bean:message key="page.serial"/></td>
				<c:forEach items="${searchResultInfo.columns}" var="searchResultColumn">
					<c:if test="${searchResultColumn.calculated}">
						<td>${searchResultColumn.label}</td>
					</c:if>
					<c:if test="${!searchResultColumn.calculated}">
						<sunbor:column property="${searchResultColumn.name}">
							${searchResultColumn.label}
						</sunbor:column>
					</c:if>
				</c:forEach>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="resultModel" varStatus="vstatus">
			<%
				Object resultModel = pageContext.getAttribute("resultModel");
				pageContext.setAttribute("modelURL", ModelUtil.getModelUrl(resultModel));
			%>
			<tr kmss_href="<c:url value="${modelURL}"/>">
				<td>${vstatus.index+1}</td>
				<c:forEach items="${searchResultInfo.columns}" var="searchResultColumn">
					<td><%= ((SearchResultColumn)pageContext.getAttribute("searchResultColumn")).getPropertyValue(resultModel, request.getLocale()) %></td>
				</c:forEach>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
<% } %>
<%-- 结果数据 end --%>
<%@ include file="/resource/jsp/list_down.jsp"%>
