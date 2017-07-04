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
var selData;
var optDataBackup = null;
var selectedOptionId;
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
		Com_SetInnerText(Div_SearchResult,"");
	}
	if(data!=null)
		optData = data.Format("id:name:info", null, false);
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
	storeDescription(optData);
}
<%-- 设置已选项 --%>
function setSelData(data){
	if(data!=null)
		selData = data.Format("id:name:info", null, false);
	if(!(selData instanceof KMSSData))
		selData = new KMSSData(selData);
	selData.PutToSelect("F_SelectedList", "id", "name");
}
function optionAdd(isAll){
	if(isAll){
		selData.AddKMSSData(optData);
	}else{
		var optHashMapArr = optData.GetHashMapArray();
		var obj = document.getElementsByName("F_OptionList")[0].options;
		for(var i=0; i<obj.length; i++){
			if(obj[i].selected)
				selData.AddHashMap(optHashMapArr[i]);
		}
	}
	setSelData();
}
function optionDelete(isAll){
	if(isAll)
		setSelData(new KMSSData());
	else{
		var obj = document.getElementsByName("F_SelectedList")[0].options;
		for(var i=obj.length-1; i>=0; i--){
			if(obj[i].selected)
				selData.Delete(i);
		}
		setSelData();
	}
}
function optionMove(direct){
	var obj = document.getElementsByName("F_SelectedList")[0].options;
	var i, j, tmpData;
	var selIndex = new Array;
	var n1 = 0;
	var n2 = obj.length - 1;
	for(i=direct>0?obj.length-1:0; i>=0 && i<obj.length; i-=direct){
		j = i + direct;
		if(obj[i].selected){
			if(j>=n1 && j<=n2){
				selData.SwitchIndex(i, j);
				selIndex[selIndex.length] = j;
			}else{
				if(direct<0)
					n1 = i + 1;
				else
					n2 = i - 1;
				selIndex[selIndex.length] = i;
			}
		}
	}
	setSelData();
	for(i=0; i<selIndex.length; i++)
		obj[selIndex[i]].selected = true;
}

function storeDescription(data){
	if(selData==null || selData.IsEmpty())
		return;
	var hashMapArr = selData.GetHashMapArray();
	for(var i=0; i<hashMapArr.length; i++){
		if(hashMapArr[i].info==null){
			var index = data.IndexOf("id", hashMapArr[i].id);
			if(index==-1)
				continue;
			hashMapArr[i].info = data.GetHashMapArray()[index].info;
		}
	}
}
function showDescription(data, index){
	var hashMapArr = data.GetHashMapArray();
	if(hashMapArr[index]!=null){
		var info = hashMapArr[index].info;
		if(info==null){
			<%--延迟0.5秒检查当前选中的选项是否已经重新选择了 --%>
			selectedOptionId = hashMapArr[index].id;
			setTimeout("checkSelectedIndex()","500");   
			//info = hashMapArr[index].name + " [<a href=\"javascript:showDescriptionById('"+hashMapArr[index].id+"')\"><bean:message bundle="sys-organization" key="sysOrg.address.info.more" /></a>]";
		}else{
			document.getElementById("Span_MoreInfo").innerHTML = info;
		}
	}
}
function checkSelectedIndex(){
	var selectListObj = document.getElementsByName("F_SelectedList")[0];
	var mapArr = selData.GetHashMapArray();
	var curSelectOption = mapArr[selectListObj.selectedIndex];
	if (curSelectOption && curSelectOption.id == selectedOptionId){
		showDescriptionById(mapArr[selectListObj.selectedIndex].id);
	}
}
function showDescriptionById(id){
	var data = new KMSSData();
	data.AddBeanData(dialogObject.searchBeanURL+"&id="+id);
	var result = data.GetHashMapArray();
	if(result.length==0 || result.length==0)
		return;
	document.getElementById("Span_MoreInfo").innerHTML = result[0].info;
	storeDescription(data);
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
	var accurate = document.getElementsByName("F_Accurate")[0].checked;
	kmssData.AddHashMap({key:obj.value, accurate:accurate});
	kmssData.SendToBean(searchBeanUrl, function(rtnData){
		var resultArr = rtnData.GetHashMapArray();
		if(!accurate){
			<%-- 模糊搜索，直接写入备选项 --%>
			if (resultArr.length > <%=OrgDialogSearch.LIMIT_SEARCH_RESULT_SIZE%>) {
				alert("<bean:message 
					bundle="sys-organization" 
					key="sysOrg.address.search.limit" 
					arg0="<%=String.valueOf(OrgDialogSearch.LIMIT_SEARCH_RESULT_SIZE)%>" 
					arg1="<%=String.valueOf(OrgDialogSearch.LIMIT_SEARCH_RESULT_SIZE)%>" />");
			}
			setOptData(rtnData, true);
		}else{
			<%-- 精确搜索，肯定有返回值，每条记录存储了key（搜索关键字）、id、name、info的信息，id为空时说明key没有找到对应值 --%>
			storeDescription(rtnData);
			var notFound = "";
			var optDataNew = new KMSSData();
			for(var i=0; i<resultArr.length; i++){
				var result = resultArr[i];
				if(result.id==null){
					notFound+="; "+result.key;
					continue;
				}
				if(i>0 && result.key==resultArr[i-1].key || i<resultArr.length-1 && result.key==resultArr[i+1].key){
					<%-- 有重复值，则加到备选列表 --%>
					optDataNew.AddHashMap(result);
				}else{
					<%-- 无重复值，则加到已选列表 --%>
					selData.AddHashMap(result);
				}
			}
			setOptData(optDataNew, true);
			setSelData();
			if(notFound==""){
				Com_SetInnerText(Div_SearchResult, "");
			}else{
				Com_SetInnerText(Div_SearchResult, "<bean:message bundle="sys-organization" key="sysOrg.address.search.notFound" />"+ notFound.substring(2));
			}
		}
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
	var selectType = dialogObject.addressBookParameter.selectType;
	if ((selectType & 64) != 64){
		document.getElementById("role").style.display="block";
	}
	initDefaultOptData();
	setOptData(dialogObject.optionData);
	setSelData(dialogObject.valueData);
	buildSearchFilterOption();
}

function getAddress(){
	var urlPrex = Com_Parameter.ContextPath+'resource/jsp/frame.jsp?url=';
	var url = '<c:url value='/sys/organization/sys_org_person/sysOrgPerson.do?method=addressModify' />';
	Dialog_PopupWindow(urlPrex+encodeURIComponent(url),'800','420');
}
/**
* 升序排序规则
*/
function sortAscRule(a,b) {
	var x = a._name;
	var y = b._name;
	return x.localeCompare(y);
}
/**
 * 降序排序规则
 */
function sortDescRule(a,b) {
	var x = a._name;
	var y = b._name;
	return y.localeCompare(x);
}
function op(){
	var _id;
	var _name;
}
/**
* 已选列表排序
* type: asc(A->Z);desc(Z-A)
*/
function sortSelOption(sortSrc){
	var sortSrcObj = document.getElementById(sortSrc);
	var obj = selData.data;
	var tmp = new Array();
	//将已选列表值放入临时变量中
	for(var i=0;i<obj.length;i++){
		var ops = new op();
		ops._id = obj[i].id;
		ops._name = obj[i].name;
		tmp.push(ops);
	}
	//按规则排序
	if(sortSrcObj.src.indexOf('sort_asc.png')!=-1){
		tmp.sort(sortAscRule);
		sortSrcObj.src = "${KMSS_Parameter_StylePath}icons/sort_desc.png";
	}else{
		tmp.sort(sortDescRule);
		sortSrcObj.src = "${KMSS_Parameter_StylePath}icons/sort_asc.png";
	}
	//将排好序的值放入已选列表中
	for(var i=0;i<tmp.length;i++){
		obj[i].id = tmp[i]._id;
		obj[i].name = tmp[i]._name;
	}
	setSelData();
}
</script>
</head>
<body topmargin=5>
<table id="TB_Search" width=100% border=0 cellspacing=0 cellpadding=0 style="display:none">
	<tr valign=middle height=20>
		<td width=50><bean:message key="message.keyword" /></td>
		<td>
			<textarea name="F_Keyword" value="" rows="1" style="width:100%;height: 25px" class="inputdialog"
				onkeydown="var eventObj = Com_GetEventObject(); if(eventObj.keyCode==13){eventObj.returnValue=false;searchUseXML();}"
				title="<bean:message bundle="sys-organization" key="sysOrg.address.search.mul.help"/>"></textarea>
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
<table border=1 cellspacing=2 cellpadding=0 bordercolor=#003048 width=100%>
	<tr valign=middle height=25 align=center>
		<td width=50%><bean:message key="dialog.optList" /></td>
		<td><img src="${KMSS_Parameter_StylePath}icons/blank.gif" border=0 height=1 width=94></td>
		<td width=50%>
			<bean:message key="dialog.selList" />
			&nbsp;&nbsp;
			<img id="sortSrc" src="${KMSS_Parameter_StylePath}icons/sort_asc.png" border="0" align="middle" onclick="sortSelOption('sortSrc')" style="cursor:pointer">
		</td>
	</tr>
	<tr valign=middle align=center>
		<td style="padding:0px">
			<select name="F_OptionList" multiple class="namelist" style="width:100%; height:216px;"
				ondblclick="optionAdd();"
				onclick="showDescription(optData, selectedIndex);"
				onchange="showDescription(optData, selectedIndex);">
			</select>
		</td>
		<td>
			<input type=button class="btndialog" style="width:70px" value="<bean:message key="dialog.add"/>" onclick="optionAdd();">
			<br><br>
			<input type=button class="btndialog" style="width:70px" value="<bean:message key="dialog.delete"/>" onclick="optionDelete();">
			<br><br>
			<input type=button class="btndialog" style="width:70px" value="<bean:message key="dialog.addAll"/>" onclick="optionAdd(true);">
			<br><br>
			<input type=button class="btndialog" style="width:70px" value="<bean:message key="dialog.deleteAll"/>" onclick="optionDelete(true);">
			<br><br>
			<input type=button class="btndialog" style="width:33px" value="<bean:message key="dialog.moveUp"/>" onclick="optionMove(-1);">
			<input type=button class="btndialog" style="width:33px" value="<bean:message key="dialog.moveDown"/>" onclick="optionMove(1);">
		</td>
		<td style="padding:0px">
			<select name="F_SelectedList" multiple class="namelist" style="width:100%; height:216px;"
				ondblclick="optionDelete();"
				onclick="showDescription(selData, selectedIndex);"
				onchange="showDescription(selData, selectedIndex);">
			</select>
		</td>
	</tr>
	<tr valign=middle height=55>
		<td colspan=3 align=center>
			<input type=button class="btndialog" style="width:50px" value="<bean:message key="button.ok"/>"
				onclick="parent.Com_DialogReturn(selData.GetHashMapArray());">&nbsp;
			<input type=button class="btndialog" style="width:50px" value="<bean:message key="button.cancel"/>"
				onclick="parent.Com_DialogReturn();">
			<span id="role" style="display: none;"><br style="font-size:5px"><a href="javascript:getAddress();" style="color:black"><bean:message bundle="sys-organization" key="sysOrgPersonAddressType.modifyMyAddress"/></a><br></span>
		</td>
	</tr>
	<tr valign=top height=75>
		<td colspan=3 style="padding:3px">
			<bean:message key="dialog.description" /><span id="Span_MoreInfo"></span><br><br style="font-size:5px">
			<div id="Div_SearchResult" style="color:red;"></div>
		</td>
	</tr>
</table>
</body>
</html>