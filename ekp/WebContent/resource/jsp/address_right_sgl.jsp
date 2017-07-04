<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.organization.service.spring.OrgDialogSearch" %>
<%@ include file="/resource/jsp/htmlhead.jsp"%>
<script>Com_IncludeFile("dialog.js");</script>
<script>
var dialogObject = parent.dialogObject;
Com_Parameter.XMLDebug = dialogObject.XMLDebug;
var Data_XMLCatche = dialogObject.XMLCatche
Com_IncludeFile("dialog.js", "style/"+Com_Parameter.Style+"/dialog/");
Com_IncludeFile("data.js");
var optData;
var optDataBackup = null;
<%-- 设置备选项 --%>
function setOptData(data, isSearch){
	var obj = document.getElementsByName("clearBtn")[0];
	if(isSearch){
		if(optDataBackup==null)
			optDataBackup = optData;
		obj.disabled = false;
	}else{
		optDataBackup = null;
		obj.disabled = true;
	}
	if(data!=null)
		optData = data.Format("id:name:info");
	if(!(optData instanceof KMSSData))
		optData = new KMSSData(optData);
	var exceptValue = dialogObject.addressBookParameter.exceptValue;
	if(exceptValue!=null){
		if(exceptValue[0]==null){
			var newArr = new Array;
			newArr[0] = exceptValue;
			exceptValue  = newArr;
		}
		for(var i=0; i<exceptValue.length; i++){
			var j = optData.IndexOf("id", exceptValue[i]);
			if(j>-1){
				optData.Delete(j);
			}
		}
	}
	optData.PutToSelect("F_OptionList", "id", "name");
}
<%-- 显示描述信息 --%>
function showDescription(data, index){
	var hashMapArr = data.GetHashMapArray();
	if(hashMapArr[index]!=null)
		document.getElementById("Span_MoreInfo").innerHTML = hashMapArr[index].info;
}
<%-- 搜索 --%>
function searchUseXML(){
	var obj = document.getElementsByName("F_Keyword")[0];
	if(obj.value==""){
		alert("<bean:message key="dialog.requiredKeyword" />");
		obj.focus();
		return;
	}
	<%-- 获取过滤选项，构造查询的BeanUrl --%>
	var filterOption = document.getElementsByName("filterOption");
	var selectType;
	for(var i=0; i<filterOption.length; i++){
		if(filterOption[i].checked)
			selectType = selectType | filterOption[i].value;
	}
	var searchBeanUrl = dialogObject.searchBeanURL;
	if(selectType!=null){
		searchBeanUrl = Com_SetUrlParameter(searchBeanUrl,"orgType",selectType);
	}
	var kmssData = new KMSSData();
	kmssData.AddHashMap({key:obj.value, accurate:document.getElementsByName("F_Accurate")[0].checked});
	kmssData.SendToBean(searchBeanUrl, function(rtnData){
		<%-- 返回值超过数量警告 --%>
		if (rtnData.GetHashMapArray().length > <%=OrgDialogSearch.LIMIT_SEARCH_RESULT_SIZE%>) {
			alert("<bean:message 
				bundle="sys-organization" 
				key="sysOrg.address.search.limit" 
				arg0="<%=String.valueOf(OrgDialogSearch.LIMIT_SEARCH_RESULT_SIZE)%>" 
				arg1="<%=String.valueOf(OrgDialogSearch.LIMIT_SEARCH_RESULT_SIZE)%>" />");
		}
		setOptData(rtnData, true);
	});
}
<%-- 构造左边树点击查询过滤条件 --%>
function setSelectType(){
	var filterOption = document.getElementsByName("filterOption");
	var selectType;
	for(var i=0; i<filterOption.length; i++){
		if(filterOption[i].checked)
			selectType = selectType | filterOption[i].value;
	}
	dialogObject.addressBookParameter.rightSelectType = selectType;
}
<%-- 构造搜索过滤选项 --%>
function buildSearchFilterOption(){
	<%-- 获取搜索类型，根据类型构造选项 --%>
	var selectType = dialogObject.addressBookParameter.selectType;
	var tb_search = document.getElementById("TB_Search");
	var filterHtml = "";
	var i = 0;
	if((selectType & ORG_TYPE_ORG) == ORG_TYPE_ORG){
		filterHtml = "<label><input type='checkbox' name='filterOption' onclick='setSelectType()' value='"+ORG_TYPE_ORG+"'>"+
			"<bean:message bundle="sys-organization" key="sysOrg.address.search.filterOption.org" />"+"</input></label>";
		i++;
	}
	if((selectType & ORG_TYPE_DEPT) == ORG_TYPE_DEPT){
		filterHtml += "<label><input type='checkbox' name='filterOption' onclick='setSelectType()' value='"+ORG_TYPE_DEPT+"'>"+
			"<bean:message bundle="sys-organization" key="sysOrg.address.search.filterOption.dept" />"+"</input></label>";
		i++;
	}
	if((selectType & ORG_TYPE_POST) == ORG_TYPE_POST){
		filterHtml += "<label><input type='checkbox' name='filterOption' onclick='setSelectType()' value='"+ORG_TYPE_POST+"'>"+
			"<bean:message bundle="sys-organization" key="sysOrg.address.search.filterOption.post" />"+"</input></label>";
		i++;
	}
	if((selectType & ORG_TYPE_PERSON) == ORG_TYPE_PERSON){
		filterHtml += "<label><input type='checkbox' name='filterOption' onclick='setSelectType()' value='"+ORG_TYPE_PERSON+"'>"+
			"<bean:message bundle="sys-organization" key="sysOrg.address.search.filterOption.person" />"+"</input></label>";
		i++;
	}
	if((selectType & ORG_TYPE_GROUP) == ORG_TYPE_GROUP){
		filterHtml += "<label><input type='checkbox' name='filterOption' onclick='setSelectType()' value='"+ORG_TYPE_GROUP+"'>"+
			"<bean:message bundle="sys-organization" key="sysOrg.address.search.filterOption.group" />"+"</input></label>";
		i++;
	}
	if((selectType & ORG_TYPE_ROLE) == ORG_TYPE_ROLE){
		filterHtml += "<label><input type='checkbox' name='filterOption' onclick='setSelectType()' value='"+ORG_TYPE_ROLE+"'>"+
			"<bean:message bundle="sys-organization" key="sysOrg.address.search.filterOption.role" />"+"</input></label>";
		i++;
	}
	<%-- 如果只有一种类型，出现过滤选项没有意义，所以多个选项才出现--%>
	if(i>1){
		tb_search.insertRow(1);
		tb_search.rows[1].insertCell(0);
		tb_search.rows[1].insertCell(1);
		tb_search.rows[1].cells[1].innerHTML=filterHtml;
	}else{
		<%-- 如果没有选项则将关键字输入框变成2行--%>
		var obj = document.getElementsByName("F_Keyword")[0];
		obj.rows = 2;
	}
}
//默认初始化待选列表数据
function initDefaultOptData(){
	var startWith = Com_GetUrlParameter(location.href, "startWith");
	startWith = startWith==null?"":startWith;
	//获取父节点信息
	var kmssData = new KMSSData();
	kmssData.AddBeanData("organizationUserDept&startWith="+startWith);
	var parentNodes = kmssData.GetHashMapArray();
	if(parentNodes.length > 0){
		var selectType = dialogObject.addressBookParameter.selectType;
		var para = "organizationDialogList&parent="+parentNodes[0].value+"&orgType="+selectType;
		dialogObject.optionData = new KMSSData().AddBeanData(para);
	}
}
window.onload = function(){
	if(dialogObject.searchBeanURL!=null){
		document.getElementById("Span_Search").style.display = "none";
		document.getElementById("TB_Search").style.display = "";
	}
	if(dialogObject.notNull){
		document.getElementById("btn_selectnone").style.display = "none";
	}
	initDefaultOptData();
	setOptData(dialogObject.optionData);
	if(dialogObject.valueData!=null){
		var data = dialogObject.valueData.GetHashMapArray();
		if(data!=null && data.length>0 && data[0]["name"]!=null && data[0]["name"]!=""){
			var kmssData = new KMSSData();
			kmssData.AddBeanData(dialogObject.searchBeanURL+"&id="+data[0]["id"]);
			var result = kmssData.GetHashMapArray();
			if(result.length==0 || result.length==0)
				var info = data[0]["name"];
			else
				var info = result[0].info;
			document.getElementById("Span_CurValue").innerHTML = "<bean:message key="dialog.currentValue" />"+info;
		}
	}
	var selectType = dialogObject.addressBookParameter.selectType;
	if ((selectType & 64) != 64){
		document.getElementById("role").style.display="block";
	}
	buildSearchFilterOption();
}
function Com_DialogReturnValue(){
	var rtnVal = new Array;
	var obj = document.getElementsByName("F_OptionList")[0];
	if(obj.selectedIndex==-1){
		alert('<bean:message key="dialog.requiredSelect" />');
	}else{
		rtnVal[0] = optData.GetHashMapArray()[obj.selectedIndex];
		parent.Com_DialogReturn(rtnVal);
	}
}
function Com_DialogReturnEmpty(){
	parent.Com_DialogReturn(new Array());
}
function getAddress(){
	var urlPrex = Com_Parameter.ContextPath+'resource/jsp/frame.jsp?url=';
	var url = '<c:url value='/sys/organization/sys_org_person/sysOrgPerson.do?method=addressModify' />';
	Dialog_PopupWindow(urlPrex+encodeURIComponent(url),'800','420');
}
</script>
</head>
<body topmargin=10>
<span id="Span_CurValue"></span>
<table id="TB_Search" width=100% border=0 cellspacing=0 cellpadding=0 style="display:none">
	<tr valign=middle height=20>
		<td width=50><bean:message key="message.keyword" /></td>
		<td>
			<textarea name="F_Keyword" value="" rows="1" style="width:100%;height: 25px" class="inputdialog"
				onkeydown="var eventObj = Com_GetEventObject(); if(eventObj.keyCode==13){eventObj.returnValue=false;searchUseXML();}"
				title="<bean:message bundle="sys-organization" key="sysOrg.address.search.sgl.help"/>"></textarea>
		</td>
		<td align=right rowspan="2" width=90>
			<input type=button onclick="searchUseXML();" value="<bean:message key="button.search"/>" class="btndialog">
			<input name="clearBtn" type=button onclick="setOptData(optDataBackup);" value="<bean:message key="button.clear"/>" class="btndialog" disabled><br>
			<label>
				<input type="checkbox" name="F_Accurate">
				<bean:message bundle="sys-organization" key="sysOrg.address.search.accurate"/>
			</label>
		</td>
	</tr>
</table>
<span id="Span_Search"><br></span>
<table border=1 cellspacing=2 cellpadding=0 bordercolor=#eaeaea width=100%>
	<tr valign=middle height=25 align=center>
		<td width=50%><bean:message key="dialog.optList" /></td>
	</tr>
	<tr valign=middle align=center>
		<td style="padding:0px">
			<select name="F_OptionList" class="namelist" style="width:100%; height:200px;" size=2
				ondblclick="if(selectedIndex>-1)Com_DialogReturnValue();"
				onclick="showDescription(optData, selectedIndex);"
				onchange="showDescription(optData, selectedIndex);">
			</select>
		</td>
	</tr>
	<tr valign=middle height=55>
		<td align=center>
			<input type=button class="btndialog" style="width:50px" value="<bean:message key="button.ok"/>"
				onclick="Com_DialogReturnValue();">&nbsp;
			<input type=button class="btndialog" style="width:50px" value="<bean:message key="button.cancel"/>"
				onclick="parent.Com_DialogReturn();">
			<input id="btn_selectnone" type=button class="btndialog" style="width:80px" value="<bean:message key="dialog.selectNone"/>"
				onclick="Com_DialogReturnEmpty();">
			<span id="role" style="display: none;"><br style="font-size:5px"><a href="javascript:getAddress();" style="color:black"><bean:message bundle="sys-organization" key="sysOrgPersonAddressType.modifyMyAddress"/></a><br></span>
		</td>
	</tr>
	<tr valign=top height=75>
		<td style="padding:3px">
			<bean:message key="dialog.description" /><span id="Span_MoreInfo"></span>
		</td>
	</tr>
</table>
</body>
</html>
