<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ page import="com.landray.kmss.sys.transport.model.SysTransportImportConfig" %>
<%@page import="com.landray.kmss.util.comparator.ChinesePinyinComparator"%>	
<%@page import="com.landray.kmss.sys.config.dict.SysDictCommonProperty"%>
<Script>Com_IncludeFile("select.js");</Script>
<script type="text/javascript">
<!--
function addOption(isAll) {
	var form = document.sysTransportImportForm;
	var foreignKeys = ';${sysTransportImportForm.foreignKeyString}';
	var notNullPropertyNames = ';${notNullPropertyNames}';
	
	Select_AddOptions(form.options, form.selectedOptions, isAll);
	
	if (!isAll) { // Add one
		if (form.options.selectedIndex >= 0) {
			var propertyName = form.options[form.options.selectedIndex].value;
			if (foreignKeys.indexOf(';' + propertyName + ';') >= 0) {
				Select_AddOptions(form.options, form.primaryKey1, false);
				Select_AddOptions(form.options, form.primaryKey2, false);
				Select_AddOptions(form.options, form.primaryKey3, false);
			}
		}
	}
	else { // Add all
		for (var i = 0; i < form.options.length; i++) {
			var propertyName = form.options[i].value;
			var notFound = true;
			// 检查下拉列表里是否已有此项，避免重复添加
			for (var j = 0; j < form.primaryKey1.length; j++) {
				if (form.primaryKey1[j].value == propertyName) {
					notFound = false;
					continue;
				}
			}
			if (notFound && foreignKeys.indexOf(';' + propertyName + ';') >= 0) {
				form.primaryKey1[form.primaryKey1.length] = new Option(form.options[i].text, form.options[i].value);
				form.primaryKey2[form.primaryKey2.length] = new Option(form.options[i].text, form.options[i].value);
				form.primaryKey3[form.primaryKey3.length] = new Option(form.options[i].text, form.options[i].value);
			}
		}
	}
	// 设置“已选列表”中必填属性字体为红色
	rePainSelectedOptions();
	reflesh(3);
}

function deleteOption(isAll) {
	var form = document.sysTransportImportForm;
	var selectedOptions = document.sysTransportImportForm.selectedOptions;
	var notNullPropertyNames = '${notNullPropertyNames}';
	var foreignKeys = ';${sysTransportImportForm.foreignKeyString}';
	if (isAll) { // 全部删除（非空项不删除）
		for (var i = selectedOptions.length - 1; i >= 0 ; i--) {
			var selectedProperty = selectedOptions[i].value;
			// 在updateOnly模式下可以删除全部已选项
			if (isUpdateOnly() || notNullPropertyNames.indexOf(selectedProperty) < 0) {
			//if (notNullPropertyNames.indexOf(selectedProperty) < 0) {
				for (var j=form.primaryKey1.length-1; j>=0; j--) {
					// 只删外键
					if (foreignKeys.indexOf(';' + selectedProperty + ';') >= 0 && form.primaryKey1[j].value == selectedProperty) {
					 	form.primaryKey1[j] = null;
					 	form.primaryKey2[j] = null;
					 	form.primaryKey3[j] = null;
					 	break;
					 }
				}
				selectedOptions[i] = null;
			}
		}
		reflesh(2);
	} else { // 删除一项
		if (selectedOptions.selectedIndex < 0) return; // 未选择，则不做动作
		var selectedProperty = selectedOptions[selectedOptions.selectedIndex].value;
		if (!isUpdateOnly() && notNullPropertyNames.indexOf(selectedProperty) >=0) {
			alert('<bean:message  bundle="sys-transport" key="sysTransport.error.deleteNotNullProperty"/>');
		}
		else {
			for (var i=form.primaryKey1.length-1; i>=0; i--) {
				// 只删外键
				if (foreignKeys.indexOf(';' + selectedProperty + ';') >= 0 && form.primaryKey1[i].value == selectedProperty) {
				 	form.primaryKey1[i] = null;
				 	form.primaryKey2[i] = null;
				 	form.primaryKey3[i] = null;
				 	break;
				 }
			}
			reflesh(1);
			selectedOptions[selectedOptions.selectedIndex] = null;
		}
			
	}
}

function moveOption(direct) {
	var form = document.sysTransportImportForm;
	var option = form.selectedOptions.options[form.selectedOptions.selectedIndex];
	Select_MoveOptions(form.selectedOptions, direct);
}

function Select_MoveOptions(selField, direct){
	if(typeof selField == "string")
		selField = document.getElementsByName(selField)[0];
	if(selField==null)
		return;
	var i1 = selField.selectedIndex;
	var i2 = i1 + direct;
	if(i1==-1 || i2<0 || i2>=selField.options.length)
		return;
	var opt1 = new Option(selField.options[i1].text, selField.options[i1].value);
	var opt2 = new Option(selField.options[i2].text, selField.options[i2].value);
	// 新增代码段，设置字体颜色 begin
	if (selField.options[i1].style != null) {
		opt1.setAttribute("style", selField.options[i1].style);
		opt1.style.color = selField.options[i1].style.color;
	}
	if (selField.options[i2].style != null) {
		opt2.setAttribute("style", selField.options[i2].style);
		opt2.style.color = selField.options[i2].style.color;
	}
	// 新增代码段，设置字体颜色 end
	selField.options[i1] = opt2;
	selField.options[i2] = opt1;
	selField.selectedIndex = i2;
}

function rePainSelectedOptions(){
	var notNullPropertyNames = '${notNullPropertyNames}';
	var selectedOptions = document.sysTransportImportForm.selectedOptions;
	for (var i = 0; i < selectedOptions.options.length; i++) {
		var selectedOption = selectedOptions.options[i];
		if (notNullPropertyNames.indexOf(selectedOption.value) >= 0 ) {
			selectedOption.style.color = "red";
		}
	}
}

function reflesh(condition) {
	var form = document.sysTransportImportForm;
	var selectedOptions = form.selectedOptions;
	var foreignKeys = ';${sysTransportImportForm.foreignKeyString}';
	var notNullPropertyNames = '${notNullPropertyNames}';
	var table = document.getElementById("transportTable");
	
	switch (condition) {
	case 1: // 删除一个
		for (var i = 4; i < table.rows.length; i++) {
			var tr = table.rows[i];
			var propertyName = tr.getAttribute("kmss_propertyName");
			var selectedValue = form.selectedOptions[form.selectedOptions.selectedIndex].value;
			// 在已选列表中查找value等于当前行对应的属性名的option，如果找到说明该option要删除
			for (var j = 0; j < selectedOptions.length; j++) {
				if (selectedValue == propertyName) {
					table.deleteRow(i);
					return;
				}
			}
		}
		break;
	case 2: // 全部删除
		for (var i = table.rows.length - 1; i >= 4; i--) {
			var tr = table.rows[i];
			var propertyName = tr.getAttribute("kmss_propertyName");
			var found = false;
			// 在已选列表中查找value等于当前行对应的属性名的option，如果没找到说明该option已删除
			for (var j = 0; j < selectedOptions.length; j++) {
				if (propertyName == selectedOptions[j].value) {
					found = true;
					break;
				}
			}
			if (!found)	table.deleteRow(i);
		}
		break;
	default:
		for (var j = 0; j < selectedOptions.length; j++) { // 遍历“已选列表”
			var propertyName = selectedOptions[j].value;
			if (foreignKeys.indexOf(';' + propertyName + ';') >= 0) { // 如果是外键，则在下面的表格行中查找
				var found = false;
			 	for (var i = 3; i < table.rows.length; i++) {
					var tr = table.rows[i];
					if (propertyName == tr.getAttribute("kmss_propertyName")) {
						found = true;
						break;
					}
				}
				if (!found) { // 没找到则添加一行
					var optionHtmlArray = new Array();
					<c:forEach var="entry" items="${sysTransportImportForm.foreignKeyPropertyOptionHtmlMap}">
					optionHtmlArray["${entry.key}"] = '${entry.value}';
					</c:forEach>
					var tr = table.insertRow(table.rows.length);
					tr.setAttribute("kmss_propertyName", propertyName);
					var td = tr.insertCell(0);
					td.setAttribute("colSpan", "2");
					var tdContent = '<font color="blue">';
					tdContent += selectedOptions[j].text;
					tdContent += '</font>';
					tdContent += '  <bean:message  bundle="sys-transport" key="sysTransport.label.foreignKey"/>  ';
					var selectHtml = '<select name="' + propertyName + '" style="width:20%">';
					selectHtml += '<option></option>';
					selectHtml += optionHtmlArray[propertyName];
					selectHtml += '</select>';
					tdContent += selectHtml + '<span class="txtstrong">*</span>';
					tdContent += selectHtml;
					tdContent += selectHtml;
					td.insertAdjacentHTML('afterBegin',tdContent);
				}
			}
		}
	}
}
function beforeSubmit() {
 
	var form = document.sysTransportImportForm;
	var selectedOptions = form.selectedOptions;
	if (selectedOptions.length == 0) {
		alert('<bean:message  bundle="sys-transport" key="sysTransport.error.none.selected"/>');
		return false;
	}
	if (validateSysTransportImportForm(form) && checkForeignKeyProperty() && checkPrimaryKey() ) {
		for (var j = 0; j < selectedOptions.length; j++) { // 遍历“已选列表”
			var propertyName = selectedOptions[j].value;
			form.selectedPropertyNames.value += propertyName + ';';
		}
		return true;
	}
	else return false;
}
function checkForeignKeyProperty() {
	var flag = true;
	var table = document.getElementById("transportTable");
	var alertString = "";
	for (var i = 4; i < table.rows.length; i++) {
		var tr = table.rows[i];
		var propertyName = tr.getAttribute("kmss_propertyName");
		var selectObjects = document.getElementsByName(propertyName);
		if (selectObjects[0].selectedIndex <= 0) {
			var foreignKeyPropertyName = tr.getElementsByTagName('td')[0].getElementsByTagName('font')[0].innerText||tr.getElementsByTagName('td')[0].getElementsByTagName('font')[0].textContent;
			alertString +='<bean:message bundle="sys-transport" key="sysTransport.error.foreignKeyProperty.empty" arg0="' + foreignKeyPropertyName + '"/>\n'
			flag = false;
		}
	}
	if(!flag){
		alert(alertString);
	}
	return flag;
}

function getImportTypeValue() {
	var fdImportType = document.sysTransportImportForm.fdImportType;
	for (var i = 0; i < fdImportType.length; i++) {
		if (fdImportType[i].checked) return fdImportType[i].value;
	}
}

function isUpdateOnly() {
	return getImportTypeValue() == 2;
}

function checkNotNullProperties(radioObj) {
	var notNullPropertyNames = '${notNullPropertyNames}';
	var form = document.sysTransportImportForm;
	var selectedOptions = form.selectedOptions;
	var options = form.options;
	// 检查所有的必选项是否已被选择
	var notNullPropertyArray = notNullPropertyNames.split(';');
	for (var i = 0; i < notNullPropertyArray.length; i++) {
		var notNullProperty = notNullPropertyArray[i];
		if (notNullProperty.length == 0) continue;
		var found = false;
		// 遍历“已选项”列表，检查是否选择了此必选项
		for (var j = 0; j < selectedOptions.options.length; j++) {
			var selectedOption = selectedOptions.options[j];
			if (selectedOption.value == notNullProperty) {
				found = true;
				break;
			}
		}
		// 如果此必选项未被选择，则需要自动选上
		if (!found) {
			// 在“可选项”里面查找相应option
			for (var j = 0; j < options.options.length; j++) {
				var option = options.options[j];
				if (option.value == notNullProperty) {
					var oldIndex = options.selectedIndex;
					options.selectedIndex = j;
					addOption(false);
					options.selectedIndex = oldIndex;
				}
			}
		}
	}
	 
	if(radioObj.value>1) 
		setStart(true);
	else
		setStart(false);
}
function setStart(flag) {
	if(flag)
        document.getElementById('star').style.display="" ;
	else
		document.getElementById('star').style.display="none" ;	
}
function checkPrimaryKey() {
	var show=document.getElementById('star').style.display ;
	if(show!='none'){
		primaryKey1 =document.getElementById('primaryKey1').value ;
		if(primaryKey1==''){
			alert('请选择'+'<bean:message  bundle="sys-transport" key="sysTransport.label.primaryKey"/>') ;
			return false  ;
		}
		else 
			return true ;
     }else
         return true ;
}
//-->
</script>
<html:form action="/sys/transport/sys_transport_import/SysTransportImport.do" onsubmit="return beforeSubmit();">
<div id="optBarDiv">
	<c:if test="${sysTransportImportForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysTransportImportForm, 'update');">
	</c:if>
	<c:if test="${sysTransportImportForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysTransportImportForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysTransportImportForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><kmss:message key="${modelMessageKey}"/><bean:message  bundle="sys-transport" key="table.sysTransportImportConfig"/><bean:message key="button.edit"/></p>
<table class="tb_normal" width="600" align="center" id="transportTable">
	<html:hidden property="fdId"/>
	<input type="hidden" name="selectedPropertyNames">
	<c:if test="${sysTransportImportForm.method_GET=='add'}">
		<html:hidden property="fdModelName" value="${param.fdModelName }"/>
	</c:if>
	<c:if test="${sysTransportImportForm.method_GET=='edit'}">
		<html:hidden property="fdModelName"/>
	</c:if>
	<tr>
		<td class="td_normal_title" width="20%">
			<bean:message  bundle="sys-transport" key="fdName"/></td>
		<td>
			<html:text property="fdName" style="width:90%"/><span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width="20%">
			<bean:message  bundle="sys-transport" key="fdImportType"/></td>
		<td>
			<input type="radio" name="fdImportType" value="<%=SysTransportImportConfig.IMPORT_TYPE_ADD_ONLY%>"
				 title='<bean:message  bundle="sys-transport" key="fdImportType.title.add"/>' onclick="checkNotNullProperties(this);">
			<bean:message  bundle="sys-transport" key="fdImportType.add"/>&nbsp;
			<input type="radio" name="fdImportType" value="<%=SysTransportImportConfig.IMPORT_TYPE_UPDATE_ONLY%>"
				title='<bean:message  bundle="sys-transport" key="fdImportType.title.update"/>' onclick="checkNotNullProperties(this);" >
			<bean:message  bundle="sys-transport" key="fdImportType.update"/>&nbsp;
			<input type="radio" name="fdImportType" value="<%=SysTransportImportConfig.IMPORT_TYPE_ADD_OR_UPDATE%>" 
				title='<bean:message  bundle="sys-transport" key="fdImportType.title.addOrUpdate"/>' onclick="checkNotNullProperties(this);">
			<bean:message  bundle="sys-transport" key="fdImportType.addOrUpdate"/>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<table width="100%" class="tb_normal">
				<tr>
					<td width="40%" align="center">
						<bean:message  bundle="sys-transport" key="sysTransport.label.optionList"/><br/>
						<select name="options" size="10" multiple="true" style="width:98%" ondblclick="addOption(false);">
							<c:forEach items="${sysTransportImportForm.optionList }" var="commonProperty">
							<option value="${commonProperty.name }">
								<%
								SysDictCommonProperty commonProperty = (SysDictCommonProperty) pageContext.getAttribute("commonProperty");
								Character c = ChinesePinyinComparator.getFirstPinyinChar(commonProperty.getMessageKey(), request.getLocale()); 
								if (c != null) out.print(c);
								%>
								<kmss:message key="${commonProperty.messageKey }"/>
							</option>
							</c:forEach>
						</select>
					</td>
					<td width="20%" align="center" valign="center">
						<input type="button" value="<bean:message  bundle="sys-transport" key="sysTransport.button.add"/>" 
								onclick="javascript:addOption(false);"><br/><br/>
						<input type="button" value="<bean:message  bundle="sys-transport" key="sysTransport.button.delete"/>" 
								onclick="javascript:deleteOption(false);"><br/><br/>
						<input type="button" value="<bean:message  bundle="sys-transport" key="sysTransport.button.addAll"/>" 
								onclick="javascript:addOption(true);"><br/><br/>
						<input type="button" value="<bean:message  bundle="sys-transport" key="sysTransport.button.delteAll"/>" 
								onclick="javascript:deleteOption(true);"><br/><br/>
						<input type="button" value="<bean:message  bundle="sys-transport" key="sysTransport.button.up"/>" 
								onclick="javascript:moveOption(-1);"><br/><br/>
						<input type="button" value="<bean:message  bundle="sys-transport" key="sysTransport.button.down"/>" 
								onclick="javascript:moveOption(1);">
					</td>
					<td width="40%" align="center">
						<bean:message  bundle="sys-transport" key="sysTransport.label.selectedOptionList"/><br/>
						<select name="selectedOptions" size="10" multiple="true" style="width:98%" ondblclick="deleteOption(false);">
							<c:forEach items="${sysTransportImportForm.propertyList }" var="commonProperty">
							<c:if test="${commonProperty.notNull }">
							<option value="${commonProperty.name }" style="color:red">
							</c:if>
							<c:if test="${!commonProperty.notNull }">
							<option value="${commonProperty.name }">
							</c:if>
							<%
								SysDictCommonProperty commonProperty = (SysDictCommonProperty) pageContext.getAttribute("commonProperty");
								Character c = ChinesePinyinComparator.getFirstPinyinChar(commonProperty.getMessageKey(), request.getLocale()); 
								if (c != null) out.print(c);
								%>
								<kmss:message key="${commonProperty.messageKey }"/>
							</option>
							</c:forEach>
						</select>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<bean:message  bundle="sys-transport" key="sysTransport.label.primaryKey"/>&nbsp;&nbsp;
			<select name="primaryKey1" id="primaryKey1" style="width:20%">
				<option value=""></option>
				<c:forEach items="${sysTransportImportForm.primaryKeyOptionList }" var="commonProperty">
				<c:if test="${commonProperty.name == sysTransportImportForm.primaryKey1}">
				<option value="${commonProperty.name }" selected>
					<%
						SysDictCommonProperty commonProperty = (SysDictCommonProperty) pageContext.getAttribute("commonProperty");
						Character c = ChinesePinyinComparator.getFirstPinyinChar(commonProperty.getMessageKey(), request.getLocale()); 
						if (c != null) out.print(c);
					%>
					<kmss:message key="${commonProperty.messageKey }"/></option>
				</c:if>
				<c:if test="${commonProperty.name != sysTransportImportForm.primaryKey1}">
				<option value="${commonProperty.name }">
					<%
						SysDictCommonProperty commonProperty = (SysDictCommonProperty) pageContext.getAttribute("commonProperty");
						Character c = ChinesePinyinComparator.getFirstPinyinChar(commonProperty.getMessageKey(), request.getLocale()); 
						if (c != null) out.print(c);
					%>
					<kmss:message key="${commonProperty.messageKey }"/></option>
				</c:if>
				</c:forEach>
			</select><font id='star' style='display:none' color='red'>*</font>
			<select name="primaryKey2" style="width:20%">
				<option value=""></option>
				<c:forEach items="${sysTransportImportForm.primaryKeyOptionList }" var="commonProperty">
				<c:if test="${commonProperty.name == sysTransportImportForm.primaryKey2}">
				<option value="${commonProperty.name }" selected>
					<%
						SysDictCommonProperty commonProperty = (SysDictCommonProperty) pageContext.getAttribute("commonProperty");
						Character c = ChinesePinyinComparator.getFirstPinyinChar(commonProperty.getMessageKey(), request.getLocale()); 
						if (c != null) out.print(c);
					%>
					<kmss:message key="${commonProperty.messageKey }"/></option>
				</c:if>
				<c:if test="${commonProperty.name != sysTransportImportForm.primaryKey2}">
				<option value="${commonProperty.name }">
					<%
						SysDictCommonProperty commonProperty = (SysDictCommonProperty) pageContext.getAttribute("commonProperty");
						Character c = ChinesePinyinComparator.getFirstPinyinChar(commonProperty.getMessageKey(), request.getLocale()); 
						if (c != null) out.print(c);
					%>
					<kmss:message key="${commonProperty.messageKey }"/></option>
				</c:if>
				</c:forEach>
			</select>
			<select name="primaryKey3" style="width:20%">
				<option value=""></option>
				<c:forEach items="${sysTransportImportForm.primaryKeyOptionList }" var="commonProperty">
				<c:if test="${commonProperty.name == sysTransportImportForm.primaryKey3}">
				<option value="${commonProperty.name }" selected>
					<%
						SysDictCommonProperty commonProperty = (SysDictCommonProperty) pageContext.getAttribute("commonProperty");
						Character c = ChinesePinyinComparator.getFirstPinyinChar(commonProperty.getMessageKey(), request.getLocale()); 
						if (c != null) out.print(c);
					%>
					<kmss:message key="${commonProperty.messageKey }"/></option>
				</c:if>
				<c:if test="${commonProperty.name != sysTransportImportForm.primaryKey3}">
				<option value="${commonProperty.name }">
					<%
						SysDictCommonProperty commonProperty = (SysDictCommonProperty) pageContext.getAttribute("commonProperty");
						Character c = ChinesePinyinComparator.getFirstPinyinChar(commonProperty.getMessageKey(), request.getLocale()); 
						if (c != null) out.print(c);
					%>
					<kmss:message key="${commonProperty.messageKey }"/></option>
				</c:if>
				</c:forEach>
			</select>
		</td>
	</tr>
	<c:forEach items="${selectedForeignKeyHtmlList }" var="array">
	<tr kmss_propertyName='${array[0]}'>
		<td colspan="2">
			<font color="blue"><kmss:message key='${array[1]}'/></font>&nbsp;
			<bean:message  bundle="sys-transport" key="sysTransport.label.foreignKey"/>&nbsp;
			${array[2] }
		</td>
	</tr>
	</c:forEach>
</table>
<html:hidden property="method_GET"/>
</html:form>
<c:if test="${sysTransportImportForm.method_GET=='add'}">
<script type="text/javascript">
<!--
deleteOption(true);
reflesh(3);
//-->
</script>
</c:if>
<script type="text/javascript">
<!--
var fdImportTypeValue = '${sysTransportImportForm.fdImportType}';
var fdImportType = document.sysTransportImportForm.fdImportType;
if (fdImportTypeValue == 1) fdImportType[0].checked = true;
else if (fdImportTypeValue == 2) fdImportType[1].checked = true;
else if (fdImportTypeValue == 3) fdImportType[2].checked = true;
else fdImportType[0].checked = true;

if(fdImportTypeValue >1){
	setStart(true) ;
}
//-->


</script>
<html:javascript formName="sysTransportImportForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>