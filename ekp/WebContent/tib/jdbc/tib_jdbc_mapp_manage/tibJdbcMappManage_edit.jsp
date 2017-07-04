<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ include file="/tib/common/resource/plumb/jsp/includePlumb.jsp" %>
<%
  String type= (String)request.getAttribute("type");
%>
<script type="text/javascript" src="${KMSS_Parameter_ContextPath}tib/jdbc/resource/js/jdbc-jsplumb.js"></script>
<script type="text/javascript" src="${KMSS_Parameter_ContextPath}tib/jdbc/resource/js/zDialog.js"></script>
<script  type="text/javascript">
Com_IncludeFile("dialog.js|formula.js|json2.js");
Com_IncludeFile("tools.js","${KMSS_Parameter_ContextPath}tib/common/resource/js/","js",true);

//选择类型
function categoryJs(){
	Dialog_Tree(false, 'docCategoryId', 'docCategoryName', ',', 
		'tibJdbcMappCategoryTreeService&parentId=!{value}', 
		'<bean:message key="table.tibJdbcMappCategory" bundle="tib-jdbc"/>', 
		null, null, '${tibJdbcMappManageForm.fdId}', null, null, 
		'<bean:message  bundle="tib-jdbc" key="table.tibJdbcMappCategory"/>');
}

//清除数据源SQL
function clearDataSourceSql(){
    $("#fd_sourceSql").attr("value","");
}

</script>

<html:form action="/tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do">
<div id="optBarDiv">
	<c:if test="${tibJdbcMappManageForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>" onclick="saveInfo('update');">
	</c:if>
	<c:if test="${tibJdbcMappManageForm.method_GET=='add'}">
		<input type=button id="_save" value="<bean:message key="button.save"/>"
			onclick="saveInfo('save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="saveInfo('saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="tib-jdbc" key="table.tibJdbcMappManage"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.docSubject"/>
		</td><td width="85%" colspan="3">
			<xform:text property="docSubject" style="width:85%" />
		</td>
	</tr>
	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.fdIsEnabled"/>
		</td><td width="35%">
		 <input type="radio" name="_fdIsEnabled" value="true" checked="checked">是
		 <input type="radio" name="_fdIsEnabled" value="false">否
		</td>
		
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.docCategory"/>
		</td><td width="35%">
			<xform:dialog style="width:85%;float:left;" required="true" propertyId="docCategoryId" propertyName="docCategoryName" dialogJs="categoryJs()">
			</xform:dialog>
			
		</td>
	</tr>
	
	<tr>
	    <td class="td_normal_title" width=15%>
			<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.tibJdbcDataSet"/>
		</td><td width="35%">
			<input type="hidden" name="fdDataSource" value="${tibJdbcMappManageForm.fdDataSource }"/>
			<input type="hidden" name="tibJdbcDataSetId" value="${tibJdbcMappManageForm.tibJdbcDataSetId }"/>
			<input type="text" name="tibJdbcDataSetName" class="inputsgl" readonly="readonly" 
					value="${tibJdbcMappManageForm.tibJdbcDataSetName }"/>
			<a href="javascript:void(0);" 
				onclick="chooseDataSet('tibJdbcDataSetId', 'tibJdbcDataSetName', chooseDataSet_back);">
				<bean:message key="button.select"/>
			</a>
		</td>
		
		<td class="td_normal_title" width=15%>
			<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.fdTargetSource"/>
		</td><td width="35%">
			<xform:select property="fdTargetSource" onValueChange="getTargetTables();" style="float: left;" showStatus="edit" value="${fdTargetSource }"  required="true">
			 	<xform:beanDataSource serviceBean="compDbcpService" 
					selectBlock="fdId,fdName" orderBy="" />
			</xform:select>
		</td>
	</tr>

	<tr>
		 <td colspan="2" style="padding: 0px;" valign="top">
			 <table  width="100%" height="100%" style="background-color: #99CCFE">
				<tr id="inParamValueBefore">
					<td colspan="2">
						<textarea rows="1" cols="" readonly="readonly" name="fdDataSetSql" 
							style="width:100%;background-color: #99CCFE;">${tibJdbcMappManageForm.fdDataSetSql }</textarea>
						<textarea id="fd_sourceSql" name="fdDataSourceSql" 
							style="display:none;width:100%">${tibJdbcMappManageForm.fdDataSourceSql }</textarea>
					</td>
				</tr>
				<tr valign=middle>
			        <td colspan="2" align=center>
				        <span><input type="button" class="btnopt" align="middle" value='<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.preview"/>'  onclick="getTableData();"/></span>
				        <span><input type="button" class="btnopt" align="middle" value='<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.extraction"/>'  onclick="getTableField();"/></span>	
			        </td>
       			</tr> 
			</table>
		 </td>
	
		 <td colspan="2" style="padding: 0px;" valign="top">
				<table width="100%"  style="background-color: #FEFECC">
				  <tr><td width=100%>
							<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.targetTables"/>:
							<span id='_tabNum'></span>
					  </td>
				  </tr>
				  
				  <tr>
					<td width="100%" >
					   <select id="dest_tableList" name="dest_tableList" multiple="multiple" ondblclick="selectedTable(this);" style="height: 105px;width:100%;">
					   </select>
				   </td>
				 </tr>
				 
				 <tr>
					 <td  width=100% align=left   style="background-color: #FEFECC">
			         	<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.haveSelectedTables"/>
			         </td>
			     </tr>
			     
			     <tr>
				    <td width="100%" >
				    <select id="have_selected_tableList"  name="have_selected_tableList" multiple="multiple" ondblclick="deleteCurrentRow();"  style="height: 72px;width:100%;">
				    </select>
				    </td>
		         </tr>
				 
				 <tr>
					 <td valign=middle width=100% align=center style="background-color: #FEFECC" >
						<span><input type="button"  align="middle" value='<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.extraction"/>'  onclick="getTableFielInfor();"/></span>		
				     </td>
			    </tr>  
			   </table>
	    </td>
     </tr>
</table>

<table class="tb_normal" width=95%>
    <!-- 显示源表和目标表的字段 -->
    <tr>
    	
	    <td width="42%" style="border: none;">       	  	
	         <table id="source_table_field" border=0 align="right" class="tb_normal"></table>	      
	    </td>
	    
	    <td width="15%" style="border: none;"></td>
        <td width="43%" style="border: none;" border=0>	
			<div id="_dest_table_field"></div>
		</td>
		
    </tr> 
</table>   
</center> 
<html:hidden property="fdTargetSourceSelectedTable"/>
<html:hidden property="fdMappConfigJson" value="${tibJdbcMappManageForm.fdMappConfigJson}"/>
<html:hidden property="fdId" />
<html:hidden property="fdIsEnabled"/>
<html:hidden property="method_GET" />
<script type="text/javascript">
$KMSSValidation();

function chooseDataSet(idField, nameField, action) {
	var t_bean="tibJdbcDataSetTreeService&selectId=!{value}&type=cate";
	var d_bean="tibJdbcDataSetTreeService&selectId=!{value}&type=func";
	var s_bean="tibJdbcDataSetTreeService&keyword=!{keyword}&type=search";
	var data = {
		idField : idField,
		nameField : nameField,
		treeBean : t_bean,
		treeTitle :'选择',
		dataBean : d_bean,
		action : action,
		searchBean : s_bean,
		winTitle : '选择'
	};
	TibUtil.tibTreeDialog(data);
}


function init_setInParams() {
	var tibJdbcDataSetId = $("input[name='tibJdbcDataSetId']").val();
	if ("" != tibJdbcDataSetId) {
		var data = new KMSSData();
		data.SendToBean("tibJdbcDataSetJsonBean&funcId="+ tibJdbcDataSetId, init_setInParams_back);
	}
}

function init_setInParams_back(rtnData) {
	var dataObj = rtnData.GetHashMapArray()[0];
	var fdDataJson = dataObj["dataJson"];
	var fdDataSourceSql = $("textarea[name='fdDataSourceSql']").text();
	addInParams(fdDataJson, fdDataSourceSql);
}

function chooseDataSet_back(rtnData) {
	if (rtnData) {
		var dataObj = rtnData.GetHashMapArray()[0];
		$("input[name='fdDataSource']").val(dataObj["dataSource"]);
		$("textarea[name='fdDataSetSql']").text(dataObj["dataSetSql"]);
		$("textarea[name='fdDataSourceSql']").text(dataObj["dataSetSql"]);
		var fdDataJson = dataObj["fdData"];
		// 添加传入参数
		addInParams(fdDataJson);
	}
}

//添加传入参数
function addInParams(fdDataJson, fdDataSourceSql) {
	var inJsonObj = $.parseJSON(fdDataJson)["in"];
	for (var len = inJsonObj.length, i = len - 1; i >= 0 ; i--) {
		var value = "";
		if (fdDataSourceSql) {
			var regArr = fdDataSourceSql.match(/\s(\S+)\s*=(\S+)(\s|$)/g);
			for (var j = 0, len = regArr.length; j < len; j++) {
				var columnArr = regArr[j].split("=");
				var tagNameTemp = columnArr[0].trim();
				if (inJsonObj[i].columnName == tagNameTemp) {
					if ("varchar" == inJsonObj[i].ctype) {
						value = columnArr[1].trim().substr(1, columnArr[1].trim().length - 2);
					} else {
						value = columnArr[1].trim();
					}
				}
			}
		}
		var html = "<tr><td width='30%'>"+ inJsonObj[i].tagName +
			"</td><td><input type='text' name='inParamsValue' class='inputsgl' tagName='"+ inJsonObj[i].tagName +"' "+
			"ctype='"+ inJsonObj[i].ctype +"' onblur='inParamBlur();' value='"+ value +"'/></td></tr>";
		$("#inParamValueBefore").after(html);
	}
}

function inParamBlur() {
	var fdDataSourceSql = $("textarea[name='fdDataSetSql']").text();
	var params = fdDataSourceSql.match(/\s(\S+)\s*:(\S+)(\s|$)/g);
	$("input[name='inParamsValue']").each(function(index, thisObj){
		for (var i = 0; i < params.length; i++) {
			var columns = params[i].split(":");
			if (columns[1].trim() == $(thisObj).attr("tagName").trim()) {
				var reg = eval("/:"+ $(thisObj).attr("tagName") +"/g");
				if ("varchar" == $(thisObj).attr("ctype")) {
					fdDataSourceSql = fdDataSourceSql.replace(reg, "'"+ $(thisObj).val() +"'");
					//$("textarea[name='fdDataSourceSql']").text(fdDataSourceSql.replace(reg, "'"+ thisValue +"'"));
				} else {
					fdDataSourceSql = fdDataSourceSql.replace(reg, $(thisObj).val());
					//$("textarea[name='fdDataSourceSql']").text(fdDataSourceSql.replace(reg, thisValue));
				}
			}
		}
	});
	$("textarea[name='fdDataSourceSql']").text(fdDataSourceSql);
}

var objJson={};

function setTabJson(){
    var options =$("#have_selected_tableList option");
	if(options!=null && options.length>0){
		objJson={};
		for(var i=0;i<options.length;i++){
	        var optionVal = $(options[i]).val();
	        objJson[optionVal] = [];
	        // 保存表字段全部信息，不确定的信息置空
		    $("table[id='mapp_"+ optionVal +"'] tr").each(function(index, obj){
				if (0 != index) {
					var initData = $(obj).children("td:eq(4)").find("input[name='fieldInitData']").val();
					// 存在字段初始值才保存值
					if (initData) {
						var columnName = $(obj).children("td:eq(1)").text();
						var dataType = $(obj).children("td:eq(2)").text();
						var isPK = $(obj).children("td:eq(3)").text();
						//alert("initData="+initData);
						var fieldInfoObj = {};
						fieldInfoObj["fieldName"] = columnName;
						fieldInfoObj["dataType"] = dataType;
						if (isPK.toUpperCase() == 'PRIMARY') {
							fieldInfoObj["required"] = "1";
							fieldInfoObj["primaryKey"] = "1";
						} else {
							fieldInfoObj["required"] = isPK == 'notNull' ? '1' : '0';
							fieldInfoObj["primaryKey"] = "0";
						}
						fieldInfoObj["mappFieldName"] = "";
						fieldInfoObj["tabName"] = "";
						fieldInfoObj["fieldInitData"] = initData;
						objJson[optionVal].push(fieldInfoObj);
					}
				}
		    });
		}
	}
}

function  getFieldDetailInfo( fieldContent){
    if(fieldContent!=null && fieldContent.length>0){
       var startIndex = fieldContent.indexOf("(");
       var endIndex = fieldContent.lastIndexOf(")");
       var fieldInfo = fieldContent.substring(startIndex+1,endIndex);
       var fieldInfoArray= fieldInfo.split(",");
       return fieldInfoArray;
   }
     return null;
}

//保存处理
function saveInfo(method){
	//得到所有的连线
    var obj = jsPlumb.getAllConnections();
    var defaultScope = obj.jsPlumb_DefaultScope;
    if(defaultScope==null || defaultScope==undefined){
        alert('<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.linkfFieldsErrorMessage"/>');
        return;
     }
    var flag= checkPrimaryKey();
     if(flag){
	    //处理连线字段信息
		getLinkedLineInfo();
		
		//选中的目标表
		var selectedTabName="";
	    var options =$("#have_selected_tableList option");
		 if(options!=null && options.length>0){
			 for(var i=0;i<options.length;i++){
	            var optionVal = $(options[i]).val();
	            selectedTabName+=optionVal+",";
			 }
		 }
		  
		if(selectedTabName!=null && selectedTabName.length>0){
			selectedTabName=selectedTabName.substring(0,selectedTabName.length-1);
		}
		
		document.tibJdbcMappManageForm.elements['fdTargetSourceSelectedTable'].value=selectedTabName;
		var fdDataSourceSql = document.tibJdbcMappManageForm.elements['fdDataSourceSql'].value;
		var fdDataSourceSql =$.trim(fdDataSourceSql);
		document.tibJdbcMappManageForm.elements['fdDataSourceSql'].value=fdDataSourceSql;
		document.tibJdbcMappManageForm.elements['fdIsEnabled'].value=$("input[name='_fdIsEnabled']:checked").val();
	    Com_Submit(document.tibJdbcMappManageForm, method);
     }
}

//验证目标表中的主键字段是否被映射
function checkPrimaryKey() {
	var options = $("select[name='have_selected_tableList'] option");
	if (options.length > 0) {
		for ( var i = 0; i < options.length; i++) {
			var optionVal = $(options[i]).val();
			var tabInfo =$("#mapp_" + optionVal);
			if(tabInfo!=null && tabInfo.length>0){
				var trArray = $("#mapp_" + optionVal + ">tbody>tr");
				var flag = false;
				if ($(trArray).length > 0) {
					for ( var j = 0; j < trArray.length; j++) {
						var fieldMessage = $(trArray[j]).children("td:eq(3)")
								.text();
						if (fieldMessage.toUpperCase() == 'PRIMARY') {
							flag = true;
							var targetSpan = $(trArray[j]).children("td:eq(0)").children("span");
							var fieldGenerate=$(trArray[j]).children("td:eq(4)").children("input[name='fieldInitData']").val();
							
							var endpointConn = jsPlumb.getEndpoints(targetSpan)[0].connections;
							
							//如果主键及没有被映射也没有设置主键的生成方式,则不能被保存
							if (endpointConn != null && endpointConn.length < 1 && !(fieldGenerate!=null && fieldGenerate.length>0)) {
								alert("表:" + optionVal + "的主键必须有初始值或进行映射");
								return false;
							}
						}
					}
					//说明该表没有主键
					flag = true;
				}
		   }else{
			   alert(optionVal+'<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.noLinkFieldsMessage"/>');
			   return false;
		   }
		}
		return flag;
	} else {
		alert('<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.noLinkFieldsMessage"/>');
		return false;
	}
}

//处理拉线两端的字段数据
function getLinkedLineInfo() {
	//设置Json模板
	setTabJson();

	// 得到所有的连线
	var obj = jsPlumb.getAllConnections();
	var defaultScope = obj.jsPlumb_DefaultScope;
	if (defaultScope == null || defaultScope == undefined) {
		return false;
	}

	var connInfo;
	if (obj != null && obj.jsPlumb_DefaultScope.length > 0) {
		var jsonObj = objJson;
		connInfo = obj.jsPlumb_DefaultScope;
		for ( var i = 0; i < connInfo.length; i++) {
			//得到目标节点所属的表名称
			var belongTabName = $(connInfo[i].target[0].parentNode).parent().parent().children("tr:eq(0)").text();//$(connInfo[i].target[0].parentNode).parent().parent().attr("id");
			//var indexNum = belongTabName.indexOf("mapp_");
			//belongTabName = belongTabName.substring(indexNum + 5,belongTabName.length);

			// 验证当前表是否被删除
			var currentTab = $("table[id='mapp_" + belongTabName + "']");
			if (currentTab == null || currentTab.length < 1) {
				continue;
			}

			//得到目标节点内容
			//var targetContent = $(connInfo[i].target[0]).text();
			// 得到目标字段名称
			//targetContent.substring(0, targetContent.indexOf("("));
			var targetFieldName =$(connInfo[i].target[0].parentNode).parent().children("td:eq(1)").text();
			

			// 得到源节点内容
			//var sourceContent = $(connInfo[i].source[0]).text();
			// 得到源字段名称
			//var sourceFieldName = sourceContent.substring(0, sourceContent.indexOf("("));
            var sourceFieldName =$(connInfo[i].source[0].parentNode).parent().children("td:eq(3)").text();
            var sourceTabName =$(connInfo[i].source[0].parentNode).parent().children("td:eq(0)").text(); 
            
			// 获得连线的颜色
			var painStyle = connInfo[i].getPaintStyle();

			// 得到关于目标字段的字段类型，长度等信息
			//var targeFieldInfoArr = getFieldDetailInfo(targetContent);
			
            var targeFieldInfoArr=new Array(2);
            var targetFieldDataType=$(connInfo[i].target[0].parentNode).parent().children("td:eq(2)").text();
            targeFieldInfoArr[0]=targetFieldDataType;
            targeFieldInfoArr[1]= $(connInfo[i].target[0].parentNode).parent().children("td:eq(3)").text();
            // 目标字段初始化 
           	var fieldInitData = $(connInfo[i].target[0].parentNode).parent()
           			.children("td:eq(4)").find("input[name='fieldInitData']").val();
            
			// 该字段值是必须还是非必须
			var requirType = "";
			var primaryKey = "";
			if (targeFieldInfoArr[1].toUpperCase() == 'PRIMARY') {
				primaryKey = '1';
				requirType = '1';
			} else {
				primaryKey = '0';
				requirType = targeFieldInfoArr[1] == 'notNull' ? '1' : '0';
			}
			var tabNameObjs = jsonObj[belongTabName];
			// 移除已经存在的字段
			for (var j = 0, len = tabNameObjs.length; j < len; j++) {
				var columnObj = tabNameObjs[j];
				if (columnObj.fieldName == targetFieldName) {
					tabNameObjs.splice(j, 1); 
					break;
				}
			}
			var fieldTemp = "";
			fieldTemp += '{' + '"' + "fieldName" + '"' + ":" + '"'
						+ targetFieldName + '"' + "," + '"' + "dataType" + '"'
						+ ":" + '"' + targeFieldInfoArr[0] + '"' + "," + '"'
						+ "required" + '"' + ":" + '"' + requirType + '"' + ","
						+ '"' + "primaryKey" + '"' + ":" + '"' + primaryKey
						+ '"' + "," + '"' + "mappFieldName" + '"' + ":" + '"'
						+ sourceFieldName + '"' +","
                        + '"' + "tabName" + '"' +  ":" +'"' + sourceTabName
						+ '"'+ ', "fieldInitData" : "'+ fieldInitData +'"}';
			tabNameObjs.push(JSON.parse(fieldTemp));
		}
		document.tibJdbcMappManageForm.elements['fdMappConfigJson'].value = "";
		document.tibJdbcMappManageForm.elements['fdMappConfigJson'].value = JSON
				.stringify(jsonObj);
	} else {
		//设置源表的边框为红色
		if(obj == null && obj.jsPlumb_DefaultScope.length<1){
		   alert('<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.noLinkFieldsMessage"/>');
		}
	}
	return true;
}

//获得目标数据库中的表
function getTargetTables(){
	var dbId = document.getElementsByName("fdTargetSource")[0].value;
	if(dbId.length<1 ||dbId==null){
		alert('<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.dataSourceMessageTip"/>');
		return false;
	}
	clearTargetTab();
	var url = "tibJdbcLoadDBTablService&dbId=" +dbId;
	var data = new KMSSData();
	data.SendToBean(url, afterCallbackFunction);
}

//当数据源发生变化时,将对应的目标库下拉框，已选表，目标映射等信息去掉。
function clearTargetTab(){
	//清空掉原来所选中的目标表
	var tabIds = $('#have_selected_tableList').find("option");
	if(tabIds!=null && tabIds.length>0){
		for(var index=0;index<tabIds.length;index++){
			var tabId= $(tabIds[index]).val();
		    $("#have_selected_tableList option[id='" + tabId + "']").remove();
		    $("table[id='mapp_" + tabId + "']").parent().parent().remove();
		}
	}
	//删除对应的表映射字段
	$("#have_selected_tableList").find("option").remove();
}

//显示目标数据库表
function afterCallbackFunction(rtn) {
	var mapArray = rtn.GetHashMapArray();
	$("#dest_tableList").find("option").remove();
	$("#_tabNum").empty();
	if (mapArray != null && mapArray.length > 0) {
		var tableInfoHtml = "";
		for ( var i = 0; i < mapArray.length; i++) {
			tableInfoHtml += "<option id='" + mapArray[i].name + "' value='"
					+ mapArray[i].name + "' >" + mapArray[i].name + "</option>";
		}
		$("#dest_tableList").append(tableInfoHtml);
		$("#_tabNum").text(mapArray.length);
	}
	checkJsPlumbInit();
}

//设置已经选中的表
function selectedTable(thisObj) {
	if ($(thisObj).val() != null && $(thisObj).val().length > 0) {
		var tabName = $(thisObj).val();
		var options = $("select[name='have_selected_tableList'] option");
		$.each(tabName, function(i, n) {
			var breakFlag = false;
			$.each(options, function(i, m) {
				if ($.trim(n) == $.trim(m.value)) {
					breakFlag = true;
					return;
				}
			});
			if (!breakFlag) {
				var tableInfoHtml = "<option id='" + n + "' value='" + n + "'>"
						+ n + "</option>";
				$("#have_selected_tableList").append(tableInfoHtml);
			}
		});
	}
}


//删除当前行
function deleteCurrentRow() {
	var TabId = $('#have_selected_tableList').find("option:selected").val();
	$("#have_selected_tableList option[id='" + TabId + "']").remove();

	//重新实例化表映射
	//setTimeout("resetTabLine();",50);
	//resetTabLine(TabId);
	//删除对应的表映射字段
	$("table[id='mapp_" + TabId + "']").parent().parent().remove();

	checkJsPlumbInit();
}

function getTableFielInfor() {
	var tableName = "";
	var options = $("select[name='have_selected_tableList'] option");
	if (options != null && options.length > 0) {
		for ( var i = 0; i < options.length; i++) {
			var optionVal = $(options[i]).val();
			tableName += optionVal + ",";
		}

		if (tableName != null && tableName.length > 0) {
			tableName = tableName.substring(0, tableName.length - 1);
		}

		var dbId = document.getElementsByName("fdTargetSource")[0].value;
		if (dbId.length < 1 || dbId == null) {
			alert('<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.dataSourceMessageTip"/>');
			return false;
		}

		if (tableName.length < 1 || tableName == null) {
			alert('<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.tablesSourceMessageTip"/>');
			return false;
		}

		var data = new KMSSData();
		data.SendToUrl(Com_Parameter.ContextPath
								+ "tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do?method=getTabFieldInfo&dbId="
								+ dbId + "&tableName=" + tableName,
						destionTabelField, false);
	}
}


//显示目标表中的字段信息
function destionTabelField(http_request) {
	// 以下得到保存好的映射数据，为了获取字段初始化值，by qiujh
	var fdMappConfigJsonObj = document.tibJdbcMappManageForm.elements['fdMappConfigJson'].value;
	var tabNameJsonObj = null;
	if (fdMappConfigJsonObj != null && fdMappConfigJsonObj.length > 0) {
		tabNameJsonObj = JSON.parse(fdMappConfigJsonObj);
	}
	var fdMappConfigJson = http_request.responseText;
	if (fdMappConfigJson != null && fdMappConfigJson.length > 0) {
		var tabNameJson = JSON.parse(fdMappConfigJson);
		var tableInfoHtml = "<table cellspacing='0' cellpadding='0'>";
		var obj = tabNameJson[0];
		for ( var key in obj) {
			if (key != null && key != undefined) {
				// 字段信息，包括字段初始化值
				var tableInfo = null;
				if (tabNameJsonObj != null) {
					tableInfo = tabNameJsonObj[key];
				}
				var tempHtml="<tr>";
				var tempInfoHtml="<td style='border-color: #FF0000;' >"; 
				var tabHtml= "<table id='mapp_" + key
						+ "' border=0 class='tb_normal' width='100%' cellspacing='0' cellpadding='0'>";
						tabHtml += "<tr><td class='td_normal_title' align=center colspan=5>"
						+ key + "</td></tr>";
                var havePKFlag=false;
				for ( var i = 0; i < obj[key].length; i++) {
					var columnObj = eval("(" + obj[key][i] + ")");
					var fieldValue = columnObj.fieldName;
					// 遍历取字段初始化值
					var fieldInitData = "";
					if (tableInfo != null) {
						for (var j = 0, len = tableInfo.length; j < len; j++) {
							var fieldInfo = tableInfo[j];
							if (fieldValue == fieldInfo.fieldName) {
								fieldInitData = fieldInfo.fieldInitData;
								break;
							}
						}
						
					}
					var tempPk=eval("(" + obj[key][i] + ")").isNull;
					    tempPk=$.trim(tempPk);
					    tempPk =tempPk.toUpperCase();
					    
					if(tempPk=='PRIMARY'){
						havePKFlag=true;
					}
					// 字段的初始化数据，可使用公式定义器
					var fieldInitDataHtml = '<input type="text" size="13" onblur ="changeTabBorderColor(\'fieldInitData'+ key + i +'\')"; class="inputsgl" name="fieldInitData" '
							+ 'id="fieldInitData'+ key + i +'" value=\''+ fieldInitData +'\'/>'
							+ '<img src="'+Com_Parameter.ContextPath 
							+ 'tib/sys/core/provider/resource/tree/img/edit.gif" style="cursor:pointer;" '
							+ 'onclick="getFieldInitData(\'fieldInitData'+ key + i +'\');" />';
					tabHtml += "<tr><td width='2'>&nbsp;<span class='tright'></span></td><td>"
							+ columnObj.fieldName
							+ "</td><td>"
							+ columnObj.dataType
							+ "</td><td>"
							+ columnObj.isNull
							+ "</td><td>"
							+ fieldInitDataHtml
							+ "</td></tr>";

				}
	            if(!havePKFlag){
	            	tempInfoHtml="<td>";
	            }
	            tabHtml += "</table></td></tr>";
	            tableInfoHtml+=tempHtml+tempInfoHtml+tabHtml;
			}
			
		}
		tableInfoHtml += "</table>";
		$("#_dest_table_field").children().remove();
		$("#_dest_table_field").append(tableInfoHtml);
		$("#_destTableField").css("display", "block");
		checkJsPlumbInit();
	}
}

//查看源数据库表数据
function getTableData() {
	var dbId = document.getElementsByName("fdDataSource")[0].value;
	if (dbId.length < 1 || dbId == null) {
		alert('<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.dataSourceMessageTip"/>');
		return false;
	}

	var fd_sourceSql = $("#fd_sourceSql").val();
	if (fd_sourceSql == null || fd_sourceSql.length < 1) {
		alert('<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.dataSourceSqlMessageTip"/>');
		return false;
	}

	var diag = new Dialog();
	IMAGESPATH = '${KMSS_Parameter_ContextPath}tib/jdbc/resource/images/';
	diag.Drag = true;
	diag.Width = 850;
	diag.Height = 450;
	diag.Title = '<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.viewData"/>';
	diag.URL = "${KMSS_Parameter_ContextPath}tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do?method=getData&dbId="
			+ dbId + "&sourceSql=" + fd_sourceSql;
	diag.show();
}

//获取源数据库表的字段信息
function getTableField() {
	var fd_sourceSql = $("#fd_sourceSql").val();
	var dbId = document.getElementsByName("fdDataSource")[0].value;
	if (dbId.length < 1 || dbId == null) {
		alert('<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.dataSourceMessageTip"/>');
		return false;
	}

	if (fd_sourceSql == null || fd_sourceSql.length < 1) {
		alert('<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.dataSourceSqlMessageTip"/>');
		return false;
	}
	var data = new KMSSData();
	data.SendToUrl(Com_Parameter.ContextPath
			+ "tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do?method=getTabFieldInfo&dbId="
			+ dbId + "&sourceSql=" + fd_sourceSql,
	afterFieldFunction, false);
	
}

//显示源数据库表中的字段信息
function afterFieldFunction(http_request) {
	$("#_errorInfor").empty();
	var fdMappConfigJson = http_request.responseText;
	if (fdMappConfigJson != null && fdMappConfigJson.length > 0) {
		 var tabNameJson="";
		try{
		   tabNameJson = JSON.parse(fdMappConfigJson);
		}catch(err){
			$("#_errorInfor").text(alert('<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.sqlError.infor"/>'));
			$("#_errorInfor").css('color','red');
			return;
		}
		var tableInfoHtml = "";
		var fd_message_1 = '<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.tableField.allowNull"/>';
		var fd_message_2 = '<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.tableField.dataType"/>';
		var fd_message_3 = '<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.tableField.columnName"/>';
		tableInfoHtml = "<tr align='center'><td class='td_normal_title' style='display:none;'>tableName</td><td class='td_normal_title'>"
				+ fd_message_1 + "</td><td class='td_normal_title'>"
				+ fd_message_2
				+ "</td><td class='td_normal_title' colspan='2'>"
				+ fd_message_3 + "</td></tr>";
		var obj = tabNameJson[0];
		for ( var key in obj) {
			if (key != null && key != undefined) {
				for ( var i = 0; i < obj[key].length; i++) {
					if (key != null && key != undefined) {
						// tableInfoHtml+="<tr  align=left><td class='tleft'>"+eval("("+obj[key][i]+")").fieldName+"("+eval("("+obj[key][i]+")").dataType+","+eval("("+obj[key][i]+")").isNull+")</td></tr>";
						tableInfoHtml += "<tr align='left'><td style='display:none;'>"
								+ eval("(" + obj[key][i] + ")").tabName
							    + "</td><td>"
								+ eval("(" + obj[key][i] + ")").isNull
								+ "</td><td>"
								+ eval("(" + obj[key][i] + ")").dataType
								+ "</td><td>"
								+ eval("(" + obj[key][i] + ")").fieldName
								+ "</td><td width='2'>&nbsp;<span class='tleft'></span></td></tr>";
					}
				}
			}
		}

		$("#source_table_field tr").remove();
		$("#source_table_field").append(tableInfoHtml);
		$("#_source_table_field").css("display", "block");
		//为源数据表设置可拉线操作
		checkJsPlumbInit();

	}
}

function checkJsPlumbInit() {
	//$("div[class='_jsPlumb_endpoint  ui-draggable ui-droppable']").remove();
	var sourceTr = $("#source_table_field>tbody>tr");
	var desTab = $("#_dest_table_field").children("table");
	var sourceFlag = false;
	var desFlag = false;
	if (sourceTr != null && sourceTr.length > 0) {
		sourceFlag = true;
	}

	if (desTab != null && desTab.length > 0) {
		desFlag = true;
	}

	if (sourceFlag && desFlag) {
		//保存原来的连线信息
		getLinkedLineInfo();

		// 清空原来的连线节点
		jsPlumb.deleteEveryEndpoint();

		// 去掉原来的连线
		jsPlumb.detachEveryConnection();

		// 重新初始化表
		jsPlumbDemo.init();
		// 设置鼠标移动到圆点变粗
		jsPlumbDemo.setTibJsPlumb_endpoint();
		// 将原来字段的映射重新展现出来
		setFieldLinked();
	}
}


//连线处理
function setFieldLinked() {
	var fdMappConfigJson = document.tibJdbcMappManageForm.elements['fdMappConfigJson'].value;
	if (fdMappConfigJson != null && fdMappConfigJson.length > 0) {
		var tabNameJson = JSON.parse(fdMappConfigJson);
		var tableInfoHtml = "";
		for ( var key in tabNameJson) {
			if (key != null && key != undefined) {
				for ( var i = 0; i < tabNameJson[key].length; i++) {
					var fieldInfo = tabNameJson[key][i];
					var fieldName = fieldInfo.fieldName;
					var mappFieldName = fieldInfo.mappFieldName;
					key = $.trim(key);
					setFieldLinkedLine(key, fieldName, mappFieldName);
				}
			}
		}
	}
}
//处理字段映射连线
function setFieldLinkedLine(targetTab, targetField, soureField) {
	var trArray = $('#mapp_' + targetTab + '>tbody>tr');
	if (trArray != null && trArray.length > 0) {
		var targetSpan;

		// 找到目标字段所在的行
		for ( var i = 0; i < trArray.length; i++) {
			var contentValue = $(trArray[i]).children("td:eq(1)").text();
			var targetFieldName = contentValue;//contentValue.substring(0, contentValue.indexOf("("));

			if ($.trim(targetField) == $.trim(targetFieldName)) {
				targetSpan = $(trArray[i]).children("td:eq(0)").children("span");
				break;
			}
		}
	}

	//查找源字段所在的位置  
	var sourceSpan = "";
	var sourceTrArr = $("#source_table_field>tbody>tr");
	if (sourceTrArr != null && sourceTrArr.length > 0) {
		for ( var j = 0; j < sourceTrArr.length; j++) {
			var sourceContentVal = $(sourceTrArr[j]).children("td:eq(3)").text();
			var sourceFieldName = sourceContentVal;//sourceContentVal.substring(0,sourceContentVal.indexOf("("));
			if ($.trim(soureField) == $.trim(sourceFieldName)) {
				sourceSpan = $(sourceTrArr[j]).children("td:eq(4)").children("span");
				break;
			}
		}
	}

	//得到源字段和目标字段所在的连接点
	var endpointTarget;
	var endpointSource;
	if (targetSpan != null && targetSpan.length > 0) {
		endpointTarget = jsPlumb.getEndpoints(targetSpan);
	}
	if (sourceSpan != null && sourceSpan.length > 0) {
		endpointSource = jsPlumb.getEndpoints(sourceSpan);
	}
	if (endpointTarget != null && endpointSource != null) {
		jsPlumb.connect( {
			source : endpointSource[0],
			target : endpointTarget[0]
		});
	}
}

//=========================修改处理===========================================
//初始化数据
$(document).ready( function() {
	init_setInParams();
	var fdIsEnabled=$("input[name='fdIsEnabled']").val();
	$("input[name='_fdIsEnabled'][value='"+fdIsEnabled+"']").attr("checked",true);	
	setTimeout("jdbc_mapp_load();", 50);
});

function jdbc_mapp_load() {
	var type = '${type}';
	if(type!='' && type=='view'){
	    //设置源数据源SQL
		var fdDataSourceSql = $("textarea[name='fdDataSourceSql']").text();
		//$("#fd_sourceSql").attr("value", fdDataSourceSql);
		
		//生成源映射数据表
		if (fdDataSourceSql != null && fdDataSourceSql.length > 0) {
			getTableField();
		}
		//获得目标数据库中的表
		getTargetTables();
		
		//设置目标数据源被选中的表
		var fdMappConfigJson = $("input[name='fdMappConfigJson']").val();//'${tibJdbcMappManageForm.fdMappConfigJson}';
		if (fdMappConfigJson != null && fdMappConfigJson.length > 0) {
			var tabNameJson = JSON.parse(fdMappConfigJson);//eval("("+fdMappConfigJson+")");
			var tableInfoHtml = "";
			for ( var key in tabNameJson) {
				if (key != null && key != undefined) {
					tableInfoHtml += "<option id='" + key + "' value='" + key
							+ "' >" + key + "</option>";
				}
			}
			$('#have_selected_tableList').append(tableInfoHtml);
		}
		
		//生成目标数据表
		getTableFielInfor();
		
		setTabBorderColor();
		//设置字段连线
		//jsPlumb.deleteEveryEndpoint();
		//setTimeout("jsPlumbDemo.init();", 50);
		setTimeout("setFieldLinked();", 50);
	}
}
//设置目标表的边框是否需要显示为红色
function setTabBorderColor(){
	var options = $("select[name='have_selected_tableList'] option");
	if (options != null && options.length > 0) {
		for ( var i = 0; i < options.length; i++) {
			var tableName = $(options[i]).val();
			var tabId="mapp_" + tableName;
			var trArray = $("#"+tabId + ">tbody>tr");
			if ($(trArray).length > 0) {
				for ( var j = 0; j < trArray.length; j++) {
					var fieldMessage = $(trArray[j]).children("td:eq(3)").text();
					if (fieldMessage.toUpperCase() == 'PRIMARY') {
						var targetSpan = $(trArray[j]).children("td:eq(0)").children("span");
						var fieldGenerate=$(trArray[j]).children("td:eq(4)").children("input[name='fieldInitData']").val();
						var endpointConn = jsPlumb.getEndpoints(targetSpan)[0].connections;
						if (endpointConn != null && endpointConn.length > 1 || (fieldGenerate!=null && fieldGenerate.length>0)) {
							 $("#"+tabId).parent().removeAttr("style");
							//$("#"+tabId).parent().css("border-color","none");
						}
				      }
				}
			}
		}
	}
}

// 解决火狐不能居中
function CalcShowModalDialogLocation(dialogWidth, dialogHeight) {
    var iWidth = dialogWidth;
    var iHeight = dialogHeight;
    var iTop = (window.screen.availHeight) / 2;
    var iLeft = (window.screen.availWidth-300) / 2;
    return 'dialogWidth:' + iWidth + 'px;dialogHeight:' + iHeight + 'px;dialogTop: ' + iTop + 'px; dialogLeft: ' + iLeft + 'px;center:yes;scroll:no;status:no;resizable:0;location:no';
}

function getFieldInitData(idField) {
	var idFieldValue = $("#"+ idField).val();
	var params = {"_key": idFieldValue};
	var value = window.showModalDialog(Com_Parameter.ContextPath
			+ "tib/common/resource/jsp/showModalDialog_tree.jsp" 
			+ "?springBean=tibJdbcExpressionBean&value="+encodeURIComponent(idFieldValue), params,
			CalcShowModalDialogLocation("400px", "450px"));
	if (value != undefined) {
		$("#"+ idField).val(JSON.parse(value)._key);
		changeTabBorderColor(idField);
	}
}

function changeTabBorderColor(idField){
	var value=$("input[id='"+idField+"']").attr("value");
	var tabId =$("#"+ idField).parent().parent().parent().parent().attr("id");
	var fieldContext =$("#"+ idField).parent().prev().text();
	if(fieldContext.toUpperCase() == 'PRIMARY') {
	  if(value!=null && value.length>0){
		  $("#"+tabId).parent().removeAttr("style");
	  }else{
		 var targetSpan = $("#"+ idField).parent().parent().children("td:eq(0)").children("span");
		 var endpointConn = jsPlumb.getEndpoints(targetSpan)[0].connections;
		 //var styleValue =$("#"+tabId).parent().attr("style");
		 //如果主键没有被映射设置的主键生成方式也为空，则设置表的边框颜色 
		if (endpointConn != null && endpointConn.length < 1 ) {
			 $("#"+tabId).parent().attr("style","border-color: #FF0000");
		}
      }
	}
}
</script>

</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>