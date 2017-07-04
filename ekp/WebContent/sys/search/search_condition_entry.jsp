<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap"%>
<%@ taglib uri="/WEB-INF/sunbor.tld" prefix="sunbor"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="com.landray.kmss.sys.search.web.SearchConditionUtil"%>
<%@ page import="com.landray.kmss.sys.search.web.SearchConditionEntry" %>

<% Object info = request.getAttribute("searchConditionInfo");
if (info instanceof com.landray.kmss.sys.search.web.SearchCondition) { %>
<c:set var="parameters" value="<%=new HashMap()%>" />
<% } else { %>
<c:set var="parameters" value="${searchConditionInfo.parameters}" />
<% } %>
<c:forEach items="${searchConditionInfo.entries}" var="conditionEntry" varStatus="vStatus">
		<c:set var="entryIndex" value="${vStatus.index}" />
		<c:set var="propertyName" value="${conditionEntry.property.name}" />
		<tr kmss_type="${conditionEntry.type}" data_name="${conditionEntry.property.name}">
			<td width="15%" class="td_normal_title">
				<c:if test="${not empty conditionEntry.messageKey}">
				<kmss:message key="${conditionEntry.messageKey}" />
				</c:if>
				<c:if test="${empty conditionEntry.messageKey}">
				${conditionEntry.label}
				</c:if>
			</td>
			<td>
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
						<input name="v0_${entryIndex}" style="width:90%" class="inputSgl" value="${parameters[propertyName].v0_}" >
						</c:if>
						<c:if test="${conditionEntry.hasDialogJS}">
							<input type="hidden" name="v0_${entryIndex}" value="${parameters[propertyName].v0_}"  />
			        		<input name="t0_${entryIndex}" readonly class="inputsgl" style="width=90%;" value="${parameters[propertyName].t0_}" />
<%
	SearchConditionEntry conditionEntry = (SearchConditionEntry)pageContext.getAttribute("conditionEntry");
	String entryIndex = pageContext.getAttribute("entryIndex").toString();
	pageContext.setAttribute("dialogScript", conditionEntry.getDialogJS(new com.landray.kmss.common.actions.RequestContext(request),"v0_"+entryIndex,"t0_"+entryIndex));
%>
					        <a onclick="${dialogScript}" href="#">
					        	 <FONT color="#003acc">	
							      	  <bean:message key="button.select" />
							        </FONT>
					        </a>
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
						<input name="v1_${entryIndex}" class="inputSgl" value="${parameters[propertyName].v1_}" >
						<span id="span_v2_${entryIndex}" ${parameters[propertyName].v0_ eq "bt" ? "" : "style=display:none"}>&nbsp;&nbsp;&nbsp;<bean:message bundle="sys-search" key="search.logic.middleStr" />
						<input name="v2_${entryIndex}" class="inputSgl" value="${parameters[propertyName].v2_}" >
						&nbsp;&nbsp;&nbsp;
						
							<bean:message bundle="sys-search" key="search.logic.rightStr" />
							<FONT color="#FF0000">
						</FONT>
						</span>
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
						<input name="v1_${entryIndex}" class="inputSgl" readonly value="${parameters[propertyName].v1_}" ><a href="javascript:void(0);" onclick="return selectDate('v1_${entryIndex}');"><bean:message key="dialog.selectTime" /></a>
						<span id="span_v2_${entryIndex}" ${parameters[propertyName].v0_ eq 'bt' ? '' : 'style=display:none'}>&nbsp;&nbsp;&nbsp;<bean:message bundle="sys-search" key="search.logic.middleStr" />
						<input name="v2_${entryIndex}" class="inputSgl" readonly value="${parameters[propertyName].v2_}" ><a href="javascript:void(0);" onclick="return selectDate('v2_${entryIndex}');"><bean:message key="dialog.selectTime" /></a>
						&nbsp;
							<bean:message bundle="sys-search" key="search.logic.rightStr" />
						<FONT color="#003acc">	
						</FONT>
						</span>
					</c:when>
			
					<c:when test="${conditionEntry.type=='foreign'}">
					<%-- 控制模糊搜索 --%>
						<table class="tb_noborder" width="95%">
							<tr>
								<c:if test="${conditionEntry.property.name ne 'docKeyword' }">
								<td>
		        					<input type="hidden" name="v0_${entryIndex}" value="${parameters[propertyName].v0_}" />
		        					<input name="t0_${entryIndex}" readonly class="inputsgl" style="width=90%;" value="${parameters[propertyName].t0_}" />
									<%
										SearchConditionEntry conditionEntry = (SearchConditionEntry)pageContext.getAttribute("conditionEntry");
										if(conditionEntry.getProperty().getDialogJS()!=null){
											String entryIndex = pageContext.getAttribute("entryIndex").toString();
											pageContext.setAttribute("dialogScript", conditionEntry.getDialogJS(new com.landray.kmss.common.actions.RequestContext(request),"v0_"+entryIndex,"t0_"+entryIndex));
									%><a onclick="${dialogScript}" href="#">
							        <!-- 选择字体为红色 style= "color:#003acc"-->
								        <FONT color="#003acc">	
								      	  <bean:message key="button.select" />
								        </FONT>
							        </a>
							        <c:if test="${conditionEntry.treeModel}">
										<br><input name="t1_${entryIndex}" type="checkbox" ${"true" == parameters[propertyName].t1_ ? "checked" : ""} value="true">
										<bean:message bundle="sys-search" key="search.includeChild"/>
									</c:if>
<%	} %>
								</td>
								<td style="display:none">
									<input name="v1_${entryIndex}" style="width=90%; padding: 1px;" class="inputSgl" value="${parameters[propertyName].v1_}" />
								</td>
								<td width="100px">
									<input name="v2_${entryIndex}" type="checkbox" onclick="refreshMatchDisplay(this);" ${empty parameters[propertyName].v1_ ? "" : "checked"} >
									<%--模糊搜索chickbox --%>
									<bean:message bundle="sys-search" key="search.blursearch"/>
									<c:if test="${not empty parameters[propertyName].v1_}">
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
		        					<input type="hidden" name="v0_${entryIndex}" value="${parameters[propertyName].v0_}" />
		        					<input type="hidden" name="t0_${entryIndex}" value="${parameters[propertyName].t0_}" />
								</td>
								<td style="width:100%">
									<input name="v1_${entryIndex}" style="width:90.3%" class="inputSgl" value="${parameters[propertyName].v1_}" />
								</td>
								<td style="display:none">
									<input name="v2_${entryIndex}" type="checkbox" checked >
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
			<td style="display:none"></td>
			<%-- 
			<td width="100px">
				<c:if test="${conditionEntry.property.notNull!='true' && conditionEntry.property.type !='RTF'}">
					<input name="vv_${entryIndex}" type="checkbox" onclick="refreshReadonlyDisplay(this);" ${empty parameters[propertyName].vv_ ? "" : "checked"} ><bean:message bundle="sys-search" key="search.emptysearch"/>
					<c:if test="${not empty parameters[propertyName].vv_}">
					<script>
					Com_AddEventListener(window, 'load', function() {
						refreshReadonlyDisplay(document.getElementsByName("vv_${entryIndex}")[0]);
					});
					</script>
					</c:if>
				</c:if>
			</td>
			--%>
		</tr>
	</c:forEach>
	

<script>
Com_IncludeFile("calendar.js|dialog.js|validator.jsp", null, "js");
function CommitSearch(){
	var resultURL = '${searchConditionInfo.resultUrl}';
	var url = Com_CopyParameter("<c:url value="${searchConditionInfo.resultUrl}" />");
	if (resultURL == "") url = url.replace('method=condition', 'method=result');
	var target = "${param.s_target}";
	var pageno = "0";
	url = Com_SetUrlParameter(url, "s_target", null);
	url = Com_SetUrlParameter(url,"pageno",null);
	var tbObj = document.getElementById("TB_Condition");
	for(var i=0; i<tbObj.rows.length; i++){
		//增加vv_xxx值到url,vv_xxx的值为1，表示该项做空值搜索
		var vv_ = document.getElementsByName("vv_"+i)[0];
		if(vv_!=null && vv_.checked)
			url = Com_SetUrlParameter(url, "vv_"+i, "1");
		
		var type = tbObj.rows[i].getAttribute("kmss_type"); 
		var fields = document.getElementsByName("v0_"+i);
		if(fields.length==0)
			continue;
		switch(type){
		case "string":
			if(fields[0].value!="" && fields[0].type != 'checkbox') {
				url = Com_SetUrlParameter(url, fields[0].name, fields[0].value);
			} else if (fields[0].type == 'checkbox') {
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
				if(field1.value=="" && field2.value=="")
					continue;
				if(field1.value=="" || field2.value==""){
					alert("<kmss:message key="errors.required" />".replace("{0}", tbObj.rows[i].cells[0].innerText||tbObj.rows[i].cells[0].textContent));
					return;
				}
				if(!validateFun(field2, tbObj.rows[i].cells[0].innerText||tbObj.rows[i].cells[0].textContent))
					return;
			}else{
				if(field1.value=="")
					continue;
			}
			if(!validateFun(field1, tbObj.rows[i].cells[0].innerText||tbObj.rows[i].cells[0].textContent))
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
			if(fields[0].value!="")
				url = Com_SetUrlParameter(url, fieldName, fields[0].value);
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
		alert("<bean:message bundle="sys-search" key="search.conditionToLong" />");
	else{
		document.getElementById("searchIframe").src = url;
	}
}
function setCheckedListToUrl(url, fields) {
	var value = "";
	for(var j=0; j<fields.length; j++){
		if(fields[j].checked)
			value += ";"+fields[j].value;
	}
	if(value!="")
		url = Com_SetUrlParameter(url, fields[0].name, value.substring(1));
	return url;
}
function resetDisplay(){
	var tbObj = document.getElementById("TB_Condition");
	for(var i=0; i<tbObj.rows.length; i++){
		//add by wubing date 2007-03-01
		var vv_ = document.getElementById("vv_"+i) ;
		if(vv_!=null && typeof vv_ !="undefined"){
			vv_.checked = false;
			refreshReadonlyDisplay(vv_);
		}
		
		var type = tbObj.rows[i].getAttribute("kmss_type");
		var name = tbObj.rows[i].getAttribute("data_name");
		var fields = document.getElementsByName("v0_"+i);
		switch(type){
		case "date":
		case "number":
			var obj = document.getElementById("span_v2_"+i);
			if(obj)
				obj.style.display = "none";
		break;
		case "foreign":
			fields[0].value = "";
			var obj = tbObj.rows[i].getElementsByTagName("TABLE")[0];
			obj.rows[0].cells[0].style.display = "";
			if(name != 'docKeyword')
			obj.rows[0].cells[1].style.display = "none";
		break;
		}
	}
	if(window.customReset!=null)
		customReset();
}
function refreshMatchDisplay(obj){
	for(var tbObj=obj; tbObj.tagName!="TABLE"; tbObj=tbObj.parentNode);
	tbObj.rows[0].cells[0].style.display = obj.checked?"none":"";
	tbObj.rows[0].cells[1].style.display = obj.checked?"":"none";
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

//add by wubing date 2007-03-01 
function refreshReadonlyDisplay(obj){
	for(var tbObj=obj; tbObj.tagName!="TR"; tbObj=tbObj.parentNode);
	tbObj.cells[1].style.display = obj.checked?"none":"";
	tbObj.cells[2].style.display = obj.checked?"":"none";
}

</script>