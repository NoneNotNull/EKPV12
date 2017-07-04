<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/sap/mapping/plugins/controls/list/tib_sap_mapping_list_control_main/tibSapMappingListControlMain.do">
	<div id="optBarDiv">
		<input type="button" value="<bean:message bundle="tib-sap" key="sapPlugin.controls.checked"/>"
			onclick="SapDataByList_SubmitData();">
		<input type="button" value="<bean:message key="button.reset"/>"
			onclick="SapDataByList_Reset();">
		<input type="button" value="<bean:message key="button.search"/>"
			onclick="SapDataByList_SearchSubmit();">
	</div>
<p class="txttitle" align="center"><b>${rfcName }</b></p>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable" width="900px">
		<tr id="headTr">
			<td width="10pt">
				<c:if test="${isMulti == 1 }">
				<input type="checkbox" name="List_Tongle">
				</c:if>
			</td>
			<td width="40pt">
				<bean:message key="page.serial"/>
			</td>
		</tr>
		<tr id="searchTr">
			<td width="10pt">
			</td>
			<td width="40pt" align="center" nowrap>
				<a  href="#"onclick="SapDataByList_SearchSubmit();">
					<img alt="<bean:message key="button.search"/>" src="${KMSS_Parameter_ResPath}style/default/icons/summary4.gif" width="22" height="17" style="border:none;"/></a>
			</td>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibSapMappingListControlMain" varStatus="vstatus">
			<tr id="contentTr${vstatus.index }" onclick="SapDataByList_CheckRadio(this.id)" ondblclick="SapDataByList_DBLCheckRadio(this.id);">
				<td>
					<c:if test="${isMulti == 1 }">
					<input type="checkbox" name="List_Selected" value="${tibSapMappingListControlMain.fdShowData }" id="checked${vstatus.index }"/>
					</c:if>
					<c:if test="${isMulti == 0 }">
					<input type="radio" name="List_Selected" value="${tibSapMappingListControlMain.fdShowData }" id="checked${vstatus.index }"
							ondblclick="SapDataByList_DblEvent(this.value);"/>
					</c:if>
				</td>
				<td>
					${vstatus.index+1}
					<!--<textarea id="trJsonValue${vstatus.index }">${tibSapMappingListControlMain.fdShowData }</textarea>-->
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/tib/sap/mapping/plugins/controls/list/tib_sap_mapping_list_control_main/list_pagenav_down.jsp" %>
</c:if>
<script type="text/javascript">
Com_IncludeFile("jquery.js");
</script>
<script type="text/javascript">
	$(function(){
		var showJsonStr = parent.document.getElementById("tempShowJson").value;
		var tableJson = eval("("+showJsonStr+")").TABLE_DocList;
		var searchKey = "${searchKeys}";
		var searchKeys = searchKey.split("-split-");
		
		<c:forEach items="${queryPage.list}" var="main" varStatus="vstatus">
			var vstatus = "${vstatus.index}";
			var fdShowData = "${main.fdShowData}";
			var showDataJson = eval("("+ fdShowData +")");
			// 搜索行
			var searchTrObj = document.getElementById("searchTr");
			// 表头行
			var headTrObj = document.getElementById("headTr");
			// 内容行
			var contentTrObj = document.getElementById("contentTr${vstatus.index }");
			var count = 0;
			// 遍历作为显示值的JSON
			for (var t = 0, lenT = tableJson.length; t < lenT; t++) {
				for (var i = 0, len = showDataJson.length; i < len; i++) {
					var value = showDataJson[i].value;
					if (value == tableJson[t].sapValue) {
						// 设置head表头
						if(vstatus == 0) {
							var thObj = document.createElement("td");
							thObj.innerHTML = tableJson[t].sapDesc +"<br/>";
							headTrObj.appendChild(thObj);
							// 搜索关键字
							var searchTdObj = document.createElement("td");
							var inputSearchObj = $("<input type='text' name='searchKey' class='inputsgl'/>");
							if (searchKeys[count] != undefined) {
								$(inputSearchObj).val(searchKeys[count]);
								count ++;
							}
							$(searchTdObj).append(inputSearchObj);
							$(searchTrObj).append(searchTdObj);
							// 隐藏域，存name
							var nameObj = $("<input type='hidden' name='fieldName'/>");
							$(nameObj).val(value);
							$(thObj).append(nameObj);
							// 隐藏域，存title
							var titleObj = $("<input type='hidden' name='titleName' />");
							$(titleObj).val(showDataJson[i].th);
							$(thObj).append(titleObj);
						}
						var tdObj = document.createElement("td");
						tdObj.innerHTML = showDataJson[i].td;
						contentTrObj.appendChild(tdObj);
					}
				}
			}
		</c:forEach>
	});
	function SapDataByList_SubmitData() {
		var checkedValues = new Array();
		var listCheckedObjs = document.getElementsByName("List_Selected");
		for (var i = 0, len = listCheckedObjs.length; i < len; i++) {
			if (listCheckedObjs[i].checked) {
				checkedValues.push(listCheckedObjs[i].value);
			}
		}
		if (checkedValues.length == 0) {
			alert("<bean:message key="page.noSelect"/>");
			return false;
		}
		parent.window.returnValue = checkedValues;
		parent.window.close();    
		return true;
	}

	function SapDataByList_Reset() {
		window.location.href = "tibSapMappingListControlMain.do?method=sapSearch"+
				"&isMulti=${param.isMulti }&fdKey="+ encodeURIComponent("${param.fdKey }")+
				"&rfcName="+ encodeURIComponent("${param.rfcName }");
	}

	// 单选按钮双击选择事件
	function SapDataByList_DblEvent(value) {
		var checkedValues = new Array();
		checkedValues.push(value);
		window.returnValue = checkedValues;
		window.close();
	}

	function SapDataByList_SearchSubmit() {				
		var searchKeysObj = document.getElementsByName("searchKey");
		var fieldNamesObj = document.getElementsByName("fieldName");
		var titleNamesObj = document.getElementsByName("titleName");
		var searchContent = "";
		var searchKeys = new Array();
		var fieldNames = new Array();
		var titleNames = new Array();
		for (var i = 0; i < searchKeysObj.length; i++){
			searchKeys.push(searchKeysObj[i].value);
			fieldNames.push(fieldNamesObj[i].value);
			titleNames.push(titleNamesObj[i].value);
		}
		window.location.href = "tibSapMappingListControlMain.do?method=sapSearch"+
			"&isMulti=${param.isMulti }&fdKey="+ encodeURIComponent("${param.fdKey }")+
			"&rfcName="+ encodeURIComponent("${param.rfcName }")+
			"&searchKeys="+ encodeURIComponent(searchKeys.join("-split-"))+
			"&fieldNames="+ encodeURIComponent(fieldNames.join("-split-"))+
			"&titleNames="+ encodeURIComponent(titleNames.join("-split-"));
	}

	// 单击行选中单选按钮
	function SapDataByList_CheckRadio(trId) {
		radioId = trId.replace("contentTr", "checked");
		if (document.getElementById(radioId).checked) {
			<c:if test="${isMulti != 0 }">
				document.getElementById(radioId).checked = false;	
			</c:if>
		} else {
			document.getElementById(radioId).checked = true;
		}
	}

	// 双击行填充数据
	function SapDataByList_DBLCheckRadio(trId) {
		<c:if test="${isMulti == 0 }">
			radioId = trId.replace("contentTr", "checked");
			var trValue = document.getElementById(radioId).value;
			SapDataByList_DblEvent(trValue);
		</c:if>
	}
	
	// 跳转到上一个url
	function SapDataByList_HistoryGo(){
		window.location.href = document.referrer;
	}
</script>
</html:form>
