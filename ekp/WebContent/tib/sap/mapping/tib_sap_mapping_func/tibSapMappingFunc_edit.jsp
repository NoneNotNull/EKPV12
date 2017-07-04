<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ include file="/sys/xform/include/sysForm_script.jsp" %>
<script type="text/javascript">
Com_IncludeFile("doclist.js|jquery.js|json2.js|dialog.js|formula.js");
</script>
<script type="text/javascript" src="${KMSS_Parameter_ContextPath}tib/common/resource/js/sapEkp.js">
</script>
<div id="optBarDiv">
<input type=button value="<bean:message bundle="tib-sap" key="tibSapMapping.lang.confirm"/>"
			onclick="submitFunc();">
	<input type=button value="<bean:message bundle="tib-sap" key="tibSapMapping.lang.seeForm"/>"
			onclick="alert('<bean:message bundle="tib-sap" key="tibSapMapping.lang.seeForm"/>');" style="display: none">	
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<center>
<table class="tb_normal" width=95%>
<tr<c:if test="${param.fdInvokeType!=0}">
style="display: none"
</c:if>
>
		<td class="td_normal_title" width=15% id="fdInvokeType">
		<bean:message bundle="tib-common-mapping" key="tibCommonMappingMain.fdFormEvent"/>
		</td>
		<td width="85%">
	<textarea name=""  style="width: 100%" id="fdJspSegmen">
		</textarea>
		</td>
	</tr>
		<tr>
		<td class="td_normal_title" width=15%>
		<bean:message bundle="tib-sap" key="tibSapMapping.lang.useExplain"/>
		</td>
		<td width="85%">
		<textarea name=""  style="width: 100%" id="fdFuncMark">
	
		</textarea>
		</td>
	</tr>
	<!-- 判断是否隐藏此tr,不为机器人节点，且不为流程驳回则隐藏-->
	<tr <c:if test="${param.fdInvokeType!=3&&param.fdInvokeType!=4&&param.fdInvokeType!=6}">
style="display: none"
</c:if>> 
	 	<td class="td_normal_title" width=100% align="center" colspan="2">
	 	   <label><bean:message bundle="tib-sap" key="tibSapMapping.lang.exceptionConfig"/></label>
	 	</td>
	</tr>
		<tr <c:if test="${param.fdInvokeType!=3&&param.fdInvokeType!=4&&param.fdInvokeType!=6}">
style="display: none"
</c:if>>
		<td class="td_normal_title" width=100% colspan="2">
		  <table id="extendForm_table" class="tb_normal" width="100%">
	<tr class="td_normal_title" >
			<%--
			<td><label>序号</label></td> --%>
		<td><label><bean:message bundle="tib-sap" key="tibSapMapping.lang.exceptionType"/></label></td>
		<td><label><bean:message bundle="tib-sap" key="tibSapMapping.lang.exceptionControl"/></label></td>
		<td><label><bean:message bundle="tib-sap" key="tibSapMapping.lang.handleAssignment"/></label></td>
		<td><label toggleElem="true"><bean:message bundle="tib-sap" key="tibSapMapping.lang.formField"/></label></td>
		<td><label toggleElem="true"><bean:message bundle="tib-sap" key="tibSapMapping.lang.assignmentFixValue"/></label></td>
		<%-- 
		<td>
			<img
			src="${KMSS_Parameter_StylePath}icons/add.gif" alt="add"
			onclick="DocList_AddRow();" style="cursor: hand">
		</td>
		--%>
	</tr>
	<tr KMSS_IsReferRow="1" style="display:none">
		<%-- 
		<td KMSS_IsRowIndex="1">
		</td>--%>
		<td>
		<input type="text" class="inputsgl" readonly="readonly" name="fdExtendForms[!{index}].fdExceptionType">
		<%--
		<select name="fdExtendForms[!{index}].fdExceptionType">
			<option value="">==请选择==</option>
			<option value="2">业务数据异常</option>
			<option value="3">程序异常</option>
		</select> 
		 --%>
		</td>
		<td>
		  <label><bean:message bundle="tib-sap" key="tibSapMapping.lang.isStop"/>:</label>
		  <input name="fdExtendForms[!{index}].fdIsIgnore" value="true" type="checkbox" />
		</td>
		<td>
		  <label><bean:message bundle="tib-sap" key="tibSapMapping.lang.isAssignment"/>:</label>
		  <input name="fdExtendForms[!{index}].fdIsAssign" controlElem="true" onclick="toggleImp()" value="true" type="checkbox" />
		</td>
		<td>
		   <label toggleElem="true"><bean:message bundle="tib-sap" key="tibSapMapping.lang.assignmentField"/>:</label>
		   <nobr>
		   <input class="inputsgl" readonly="readonly"  name="fdExtendForms[!{index}].fdAssignField" type="text"  />
		   <input name="fdExtendForms[!{index}].fdAssignFieldid" type="hidden" />
		   <img src="${KMSS_Parameter_StylePath}icons/edit.gif" alt="<bean:message bundle="tib-sap" key="tibSapMapping.lang.edit"/>" name="!{index}"  onclick="formula_field_dialog(this);" style="cursor: hand"></img>
		   </nobr>
		</td >
			<td>
		   <label toggleElem="true"><bean:message bundle="tib-sap" key="tibSapMapping.lang.fixValue"/>:</label>
		   <nobr>
		   <input class="inputsgl" name="fdExtendForms[!{index}].fdAssignVal" type="text" />
		    <input class="inputsgl" name="fdExtendForms[!{index}].fdId" type="hidden" />
		     <input class="inputsgl" name="fdExtendForms[!{index}].fdRefId" type="hidden" />
		   </nobr>
		</td>
		<%-- 
		<td>
				<img
			src="${KMSS_Parameter_StylePath}icons/delete.gif" alt="del"
			onclick="DocList_DeleteRow();" style="cursor: hand">
		</td>
		--%>
	</tr>
</table>
		</td>
		</tr>
</table>
</center>
<br/>
<br/>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<bean:message bundle="tib-sap" key="tibSapMapping.lang.funcName"/>:
<input type="text" value=""  class="inputsgl"  id="fdRfcSettingName"  name="fdRfcSettingName"  readonly  style="width: 23%"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="hidden"  class="inputsgl"  id="fdRfcSettingId"  name="fdRfcSettingId"/>
<input readonly="readonly" type=button value="<bean:message bundle="tib-sap" key="tibSapMapping.lang.chooseFunc"/>" class="btnopt"
onclick="doDialog_TreeList()">
<br/>
<br/>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td id="param">
	<table id="TABLE_0" class="tb_normal" width="100%" >
	<!-- 固定两行 -->
	<tr class="td_normal_title"  style="">
		<td width="50px" rowspan="1000" align="center"><bean:message bundle="tib-sap" key="tibSapMapping.lang.inputParam"/></td>
		<td colspan="3">SAP</td>
		<td colspan="3"><bean:message bundle="tib-sap" key="tibSapMapping.lang.currentForm"/></td>
	</tr>
		<tr class="td_normal_title"  style="">
		<td><bean:message bundle="tib-sap" key="tibSapMapping.lang.paramType"/></td>
		<td><bean:message bundle="tib-sap" key="tibSapMapping.lang.fieldName"/></td>
		<td><bean:message bundle="tib-sap" key="tibSapMapping.lang.fieldExplain"/></td>
		<td><bean:message bundle="tib-sap" key="tibSapMapping.lang.mappingExplain"/></td>
		<td><bean:message bundle="tib-sap" key="tibSapMapping.lang.mappingForm"/></td>
		<!-- 
		<td>表名</td>
		 -->
		<td><img src="${KMSS_Parameter_StylePath}calendar/finish.gif" 
			alt="<bean:message bundle="tib-sap" key="tibSapMapping.lang.oneMapping"/>" 
			onclick="oneKeyMatch('TABLE_0');" style="cursor: hand"/></td>
	</tr>
	<!-- 固定两行 -->
	
</table><br>
		<table id="TABLE_1" class="tb_normal" width="100%">
	<tr class="td_normal_title"  style="">
		<td width="50px" rowspan="1000" align="center"><bean:message bundle="tib-sap" key="tibSapMapping.lang.outputParam"/></td>
		<td colspan="3">SAP</td>
		<td colspan="3"><bean:message bundle="tib-sap" key="tibSapMapping.lang.currentForm"/></td>
	</tr>
	<tr class="td_normal_title"  style=""> 
		<td><bean:message bundle="tib-sap" key="tibSapMapping.lang.paramType"/></td>
		<td><bean:message bundle="tib-sap" key="tibSapMapping.lang.fieldName"/></td>
		<td><bean:message bundle="tib-sap" key="tibSapMapping.lang.fieldExplain"/></td>
		<td><bean:message bundle="tib-sap" key="tibSapMapping.lang.mappingExplain"/></td>
		<td><bean:message bundle="tib-sap" key="tibSapMapping.lang.mappingForm"/></td>
		<!-- 
		<td>表名</td>
		 -->
		<td><img src="${KMSS_Parameter_StylePath}calendar/finish.gif" alt="<bean:message bundle="tib-sap" key="tibSapMapping.lang.oneMapping"/>" onclick="oneKeyMatch('TABLE_1');" style="cursor: hand"/></td>
	</tr>
	<!-- 固定两行 -->
</table><br>
   
  <!-- 用于table类型的参数copy的表格代码 -->
		</td>
	</tr>
</table>
  <!-- 用于table类型的参数copy的表格代码 打开时先不显示 动态生成-->
	<table id="TABLE_COPY" class="tb_normal" width="100%"  style="display:none">
	<tr class="td_normal_title" >
		<td width="50px" rowspan="1000" align="center"><bean:message bundle="tib-sap" key="tibSapMapping.lang.tableParam"/></td>
		<td colspan="3"></td>
		<td colspan="3"><bean:message bundle="tib-sap" key="tibSapMapping.lang.currentForm"/></td>
	</tr>
		<tr class="td_normal_title" >
		<td><bean:message bundle="tib-sap" key="tibSapMapping.lang.paramType"/></td>
		<td><bean:message bundle="tib-sap" key="tibSapMapping.lang.fieldName"/></td>
		<td><bean:message bundle="tib-sap" key="tibSapMapping.lang.fieldExplain"/></td>
		<td><bean:message bundle="tib-sap" key="tibSapMapping.lang.mappingExplain"/></td>
		<td><bean:message bundle="tib-sap" key="tibSapMapping.lang.mappingForm"/></td>
		<!-- 
		<td>表名</td>
		 -->
		<td><img src="${KMSS_Parameter_StylePath}calendar/finish.gif" alt="<bean:message bundle="tib-sap" key="tibSapMapping.lang.oneMapping"/>" onclick="oneKeyMatch(this.parentNode.parentNode.parentNode);" style="cursor: hand"/></td>
	</tr>
</table>
</center>
<script>
//定义一些全局变量用于保存函数信息
var funcObject;
var fdRfcParamXmlObject;//操作的时候直接操作这个xml对象

function doDialog_TreeList(){
	var rfcId=document.getElementById("fdRfcSettingId").value;
	Dialog_TreeList(false, 'fdRfcSettingId', 'fdRfcSettingName', ';', 'tibSapMappingFuncTreeListService&selectId=!{value}&type=cate','<bean:message bundle="tib-sap" key="tibSapMapping.lang.funcType"/>','tibSapMappingFuncTreeListService&selectId=!{value}&type=func',function(){getXml(rfcId);},'tibSapMappingFuncTreeListService&type=search&keyword=!{keyword}',null,null,null,'<bean:message bundle="tib-sap" key="tibSapMapping.lang.chooseFunc"/>');
	
}


$(document).ready(function(){
	//打开页面为相关字段赋值
	//funcObject = window.dialogArguments;
	if (!!window.ActiveXObject || "ActiveXObject" in window){  
		funcObject = window.dialogArguments;  
	} else {  
	    // Firefox浏览器（画面自提交后，window.dialogArguments会丢失，同时window.opener属性存在），  
	    if (window.opener.funcObject == undefined) {  
	        window.opener.funcObject = window.dialogArguments;  
	    }  
	    funcObject = window.opener.funcObject;  
	}  
	if(funcObject.fdJspSegmen==""||funcObject.fdJspSegmen==null)
		document.getElementById("fdJspSegmen").value="<script>\nfunction xxx(){\n      doBAPI(); \n}\n<\/script>";//$("#fdJspSegmen").text('');
	else
		document.getElementById("fdJspSegmen").value=funcObject.fdJspSegmen.replace("&lt;script&gt;", "<script>").replace("&lt;/script&gt;", "<\/script>");//$("#fdJspSegmen").text(funcObject.fdJspSegmen);
	$("#fdFuncMark").text(funcObject.fdFuncMark);
	$("#fdRfcSettingName").val(funcObject.fdRefName);
	$("#fdRfcSettingId").val(funcObject.fdRefId);
	if(funcObject.fdRfcParamXml==null||funcObject.fdRfcParamXml=="")return;//如果初次打开或xml格式内容为空，直接返回，不需要对象化和构造表
	//把得到的函数xml信息转化为对象，赋给全局变量fdRfcParamXmlObject
    fdRfcParamXmlObject=XML_CreateByContent(funcObject.fdRfcParamXml);
    //alert("fdRfcParamXmlObject="+XML2String(fdRfcParamXmlObject));
    //构建TABLE_0
	var importNode=$(fdRfcParamXmlObject).find("jco import");//XML_GetNodes(fdRfcParamXmlObject,"/jco/import")[0];
	buildParamTable2("TABLE_0",importNode,"/jco/import");
	 //构建TABLE_1
	var exportNode=$(fdRfcParamXmlObject).find("jco export");//XML_GetNodes(fdRfcParamXmlObject,"/jco/export")[0];	
	buildParamTable2("TABLE_1",exportNode,"/jco/export");
	//构造table类型的参数表
	var tables=$(fdRfcParamXmlObject).find("jco tables table");//XML_GetNodes(fdRfcParamXmlObject,"/jco/tables/table");	
	buildTables(tables);
}
);

function XML2String(xmlObject) {
	// for IE
	if (!!window.ActiveXObject || "ActiveXObject" in window) {
		return xmlObject.xml;
	} else {
		// for other browsers
		return (new XMLSerializer()).serializeToString(xmlObject);
	}
} 

//构建表格类型参数的表格
function buildParamTable(table,tableId,tableNum){
	var records=table.childNodes;
	var isin=XML_GetAttribute(table,"isin");
	var insertRowNum=2;
	for(var i=0;i<records.length;i++){
		var fields=records[i].childNodes;
		var fieldsLength=fields.length;
		var optionArray = new Array();
		for(var j=0;j<fieldsLength;j++){
			var newRow=document.getElementById(tableId).insertRow(insertRowNum);
			if ("0;1" == isin) {
				var optionName = XML_GetAttribute(fields[j],"title");
				var optionValue = XML_GetAttribute(fields[j],"name");
				optionArray.push("<option value='"+ optionValue +"'>"+ optionName +"</option>");
			}
			if(j==0){
				setCellHtml(newRow,fields[j],"/jco/tables/table["+tableNum+"]/records["+i+"]/field["+j+"]",isin);
				//结构的第一行，有些地方需重新设置
				newRow.cells[0].rowSpan=fieldsLength;
				newRow.id="/jco/tables/table["+tableNum+"]/records["+i+"]/field["+j+"]";//设置行id为xpath路径(行的id不是必须的，因为现在可以在图片函数中传xpath了)
				//增加判断是传入表格还是传出表格
				if(isin=="0"){
					 newRow.cells[0].innerHTML="<bean:message bundle="tib-sap" key="tibSapMapping.lang.outputTable"/>";
				} else if (isin == "1") {
			    	newRow.cells[0].innerHTML="<bean:message bundle="tib-sap" key="tibSapMapping.lang.inputTable"/>";
				} else {
					// 传入或传出， isin=="0;1"
					newRow.cells[0].innerHTML="<bean:message bundle="tib-sap" key="tibSapMapping.lang.inputTable"/>&<bean:message bundle="tib-sap" key="tibSapMapping.lang.outputTable"/>";
				}
			} else{
				newRow.id="/jco/tables/table["+tableNum+"]/records["+i+"]/field["+j+"]";//设置行id为xpath路径
				setStruFieldCellHtml(newRow,fields[j],"/jco/tables/table["+tableNum+"]/records["+i+"]/field["+j+"]",isin);//和基本的传入和传出参数可共用这个函数
			}
		    insertRowNum++;
		}
		// 为传入并传出的选择Key填充值
		if ("0;1" == isin) {
			$("#"+ tableId +"_Key").html(optionArray);
			var writeKey = $(table).attr("writeKey");
			if (writeKey) {
				$("#"+ tableId +"_Key").val(writeKey);
			}
		}
	}
}
//选择函数后重置参数表,用在传入和传出参数表
function buildParamTable2(tableId,node,xpath){
	var nodeList=$(node).children();//node.childNodes;
	var insertRowNum=2;//2是因为固定的表头两行,用于记录插入行位置
	var structureNum=0;//用于记录structure的个数，用于xpath记录路径
	var fieldNum=0;//用于记录单独field的个数，用于xpath记录路径
	for(var i=0;i<nodeList.length;i++){	
		var node=nodeList[i];//nodeList.item(i);
		//如果此节点为结构类型的
		if(node.nodeName=="structure"){
			var struFieldNodeList=node.childNodes;
			var struFieldLength=struFieldNodeList.length;		
			for(var j=0;j<struFieldLength;j++){
				var newRow=document.getElementById(tableId).insertRow(insertRowNum);
				if(j==0){
					setCellHtml(newRow,struFieldNodeList[j],xpath+"/structure["+structureNum+"]/field["+j+"]");
					//结构的第一行，有些地方需重新设置
					newRow.cells[0].rowSpan=struFieldLength;
					newRow.id=xpath+"/structure["+structureNum+"]/field["+j+"]";//设置行id为xpath路径
				    newRow.cells[0].innerHTML="结构：<br/>"+XML_GetAttribute(node,"name");			    
				}
				else{
					newRow.id=xpath+"/structure["+structureNum+"]/field["+j+"]";//设置行id为xpath路径
					setStruFieldCellHtml(newRow,struFieldNodeList[j],xpath+"/structure["+structureNum+"]/field["+j+"]");//和基本的传入和传出参数可共用这个函数
					}
				insertRowNum++;
			}	
			structureNum++;
		}
		else if(node.nodeName=="field")	{
			var newRow=document.getElementById(tableId).insertRow(insertRowNum);
			setCellHtml(newRow,node,xpath+"/field["+fieldNum+"]");
			newRow.id=xpath+"/field["+fieldNum+"]";
			newRow.cells[0].innerHTML="<bean:message bundle="tib-sap" key="tibSapMapping.lang.field"/>";
			fieldNum++;
			insertRowNum++;
	}
}
    //合并行
   // alert(document.getElementById(tableId).rows[0].cells[0].rowSpan);
	document.getElementById(tableId).rows[0].cells[0].rowSpan=document.getElementById(tableId).rows.length;
	}
//选择函数后重新设置table类型参数的表格
function buildTables(tables){
for(var i=0;i<tables.length;i++){
	var invokeType="${param.fdInvokeType}";
	var headHtml = "<bean:message bundle="tib-sap" key="tibSapMapping.lang.tableName"/>"+XML_GetAttribute(tables[i],"name");
    var isin = XML_GetAttribute(tables[i],"isin");
    var idCount = i + 2;
    if ("0;1" == isin) {
        if (invokeType=='5') {
        	// 表单控件没有传出&传入，那么跳出当前循环
    		continue;
        } else {
            var tableName = $(tables[i]).attr("name");
            var writeType = $(tables[i]).attr("writeType");
            var xpath = "/jco/tables/table[@name='"+ tableName +"']";
            var writeKeyId = "TABLE_"+ idCount +"_Key";
            var checked = "";
            var checkedUpdate = "";
            var writeKeyHide = "";
            if ("1" == writeType) {
                // 更新
            	checkedUpdate = "checked";
            } else {
                // 删除后新增
            	checked = "checked";
                writeKeyHide = "style='display:none;'";
            }
        	headHtml += "<input type='radio' onclick=\"tableKeyControl('TABLE_"+ idCount +"_Key_Span', '"+writeKeyId+"', '"+tableName+"', true);\" "+ checkedUpdate +" name='TABLE_WriteType' id='TABLE_"+ idCount +"_Update' value='1'/>更新&nbsp;";
        	headHtml += "<input type='radio' onclick=\"tableKeyControl('TABLE_"+ idCount +"_Key_Span', '"+writeKeyId+"', '"+tableName+"', false);\" "+ checked +" name='TABLE_WriteType' id='TABLE_"+ idCount +"_DeleteAdd'' value='2'/>删除后新增";
        	headHtml += "<br/><span id='TABLE_"+ idCount +"_Key_Span' "+writeKeyHide+">Key：<select id='"+ writeKeyId +"' onchange=\"writeKeyControl('"+tableName+"', this.value);\"></select></span>";
			var attr_value = {"writeType" : writeType ? writeType : "2"};
			// 把写入类型的属性设置好（初始为删除后新增）
        	XML_SetNodeAttribute(fdRfcParamXmlObject, xpath, attr_value);
        }
    }
	var table=$("#TABLE_COPY").clone();
	table.attr("id","TABLE_"+ idCount);//已经有两个表格(不算影藏的那个)
	table.attr("style","");
   // table.insertAfter("#TABLE_COPY"); ?
    $("#param").append(table); //在指定id为param的单元格里面追加table
    $("#param").append("<br>");
    document.getElementById("TABLE_"+ idCount).rows[0].cells[1].innerHTML=headHtml;
    buildParamTable(tables[i],"TABLE_"+ idCount,i);//多传一个i用于拼装xpath table序号 从0开始
    //调整第一行的高度,防止重线
    document.getElementById("TABLE_"+ idCount).rows[0].cells[0].rowSpan=document.getElementById("TABLE_"+ idCount).rows.length;
}
}
//设置普通field行单元格的html
function setCellHtml(row,node,xpath,isin){
//表明去掉
	for(var j=0;j<6;j++){
		row.insertCell(j);
	} 
	row.cells[1].innerHTML=XML_GetAttribute(node,"name");
	var fieldTitle=XML_GetAttribute(node,"title");
	row.cells[2].innerHTML=fieldTitle;
	var ekpid=XML_GetAttribute(node,"ekpid");
	var ekpname=XML_GetAttribute(node,"ekpname");
	row.cells[3].innerHTML='<input  onchange="resetFormNameField(\''+xpath+'\');" class="inputread"  name="'+xpath+'.name" value=\''+(ekpname==undefined?"":ekpname)+'\'>';//用xpath路径加name拼装公式定义器赋值的name,注意引号转义还有xml中引号问题
	row.cells[4].innerHTML='<input  class="inputread" readonly name="'+xpath+'.id" value=\''+(ekpid==undefined?"":ekpid)+'\'>';//用xpath路径加id拼装公式定义器赋值的id
	//最后一格为操作按钮 注意这里xpath处的单引号转化
	if (!isin) {
		isin = "";
	}
	row.cells[5].innerHTML='<img src="${KMSS_Parameter_StylePath}icons/edit.gif" alt="<bean:message bundle="tib-sap" key="tibSapMapping.lang.oneMapping"/>" onclick="show_formula_dialog(\''
		+xpath+'\',\''+isin+'\');" style="cursor: hand"><img src="${KMSS_Parameter_StylePath}icons/delete.gif" alt="<bean:message bundle="tib-sap" key="tibSapMapping.lang.empty"/>" onclick="clearParam(\''+xpath+'\');" style="cursor: hand"/>';
	}
//设置structure的field单元格html或者records类型的
function setStruFieldCellHtml(row,node,xpath,isin){
    //表明去掉 j=5
	for(var j=0;j<5;j++){
		row.insertCell(j);
	}
	row.cells[0].innerHTML=XML_GetAttribute(node,"name");
	var fieldTitle=XML_GetAttribute(node,"title");
	row.cells[1].innerHTML=fieldTitle;
	var ekpid=XML_GetAttribute(node,"ekpid");
	var ekpname=XML_GetAttribute(node,"ekpname");
	row.cells[2].innerHTML='<input onchange="resetFormNameField(\''+xpath+'\');"  class="inputread"  name="'+xpath+'.name" value=\''+(ekpname==undefined?"":ekpname)+'\'>';//用xpath路径加name拼装公式定义器赋值的name,可以编辑
	row.cells[3].innerHTML='<input  class="inputread" readonly name="'+xpath+'.id" value=\''+(ekpid==undefined?"":ekpid)+'\'>';//用xpath路径加id拼装公式定义器赋值的id
	//最后一格为操作按钮
	if (!isin) {
		isin = "";
	}
	row.cells[4].innerHTML='<img src="${KMSS_Parameter_StylePath}icons/edit.gif" alt="<bean:message bundle="tib-sap" key="tibSapMapping.lang.edit"/>" onclick="show_formula_dialog(\''
		+xpath+'\',\''+isin+'\');" style="cursor: hand"><img src="${KMSS_Parameter_StylePath}icons/delete.gif" alt="<bean:message bundle="tib-sap" key="tibSapMapping.lang.empty"/>" onclick="clearParam(\''+xpath+'\');" style="cursor: hand"/>';
}

//当点击删除时清空右边的值
function clearParam(xpath){
	//删除对应表中的数据
	$('input[name="'+xpath+'.id"]').val("");
    $('input[name="'+xpath+'.name"]').val("");
	//清除xml对象中对应的字段属性值
	var attr_value={"ekpid":"", "ekpname":""};
    XML_SetNodeAttribute(fdRfcParamXmlObject,xpath,attr_value);
}
//提交函数更改funcObject相应字段,funcObject和父窗口共同引用同一个对象
function submitFunc(){
	var fdJspSegmen = document.getElementById("fdJspSegmen").value;
	fdJspSegmen = fdJspSegmen.replace("<script>", "&lt;script&gt;").replace("<\/script>", "&lt;/script&gt;");
	funcObject.fdJspSegmen=fdJspSegmen;//$("#fdJspSegmen").val();
	funcObject.fdFuncMark=$("#fdFuncMark").text();
	funcObject.fdRefName=$("#fdRfcSettingName").val();
	funcObject.fdRefId=$("#fdRfcSettingId").val();//可以不要，已实现了同步变更
	if(fdRfcParamXmlObject!=null)
		funcObject.fdRfcParamXml=fdRfcParamXmlObject.xml;//将xml对象转化为字符串
	var invokeType="${param.fdInvokeType}";
    <%--只处理机器人节点 && 表单提交 && 流程驳回--%>
    if(invokeType=='3'||invokeType=='4'||invokeType=='6'){
    	funcObject.fdExtendFormsView=JSON.stringify(DetailJsonHelper.getJsonFromDetail());
    }
	window.close();
}
//清空数据
function emptyData(){
	var TABLE_1=document.getElementById("TABLE_1");
	var TABLE_0=document.getElementById("TABLE_0");
	
	var total=document.getElementById("param");
	while(total.firstChild){
		total.removeChild(total.firstChild);
	}
	total.appendChild(TABLE_1);
	total.appendChild(TABLE_0);
	resetTableRows("TABLE_1",2);
	resetTableRows("TABLE_0",2);
	
}
//得到函数对应xml格式数据信息
function getXml(rfcId){
	var fdRfcSettingId=$("#fdRfcSettingId").val();
	if(fdRfcSettingId==null||fdRfcSettingId=="") {
		emptyData();
		return;
	} else if (rfcId==fdRfcSettingId) {
		return ;
	} else{
		var data = new KMSSData();
		data.SendToBean("tibSapMappingFuncXmlService&fdRfcSettingId="+fdRfcSettingId,resetTable);
	}
}
//使用xml信息重设参数表
function resetTable(rtnData){
	if(rtnData.GetHashMapArray().length==0)return;
	//在重新设置fdRfcParamXmlObject前先保留原来的tables的长度，用于删除原有表格用
	if(rtnData.GetHashMapArray()[1]["MSG"]!="SUCCESS"){
		emptyData();   
		alert(rtnData.GetHashMapArray()[1]["MSG"]);
		   return ;
		}
	var tablesLength;
	if(fdRfcParamXmlObject!=null)
	 tablesLength=XML_GetNodes(fdRfcParamXmlObject,"/jco/tables/table").length;
	else tablesLength=0;
	//把得到的函数xml信息转化为对象，重新设置fdRfcParamXmlObject
	fdRfcParamXmlObject=XML_CreateByContent(rtnData.GetHashMapArray()[0]["funcXml"]);
	var importNode=XML_GetNodes(fdRfcParamXmlObject,"/jco/import")[0];
	resetTableRows("TABLE_0",2);
	buildParamTable2("TABLE_0",importNode,"/jco/import");
	var exportNode=XML_GetNodes(fdRfcParamXmlObject,"/jco/export")[0];	
	resetTableRows("TABLE_1",2);
	buildParamTable2("TABLE_1",exportNode,"/jco/export");
	var tables=XML_GetNodes(fdRfcParamXmlObject,"/jco/tables/table");	
	deleteTables(tablesLength);//删除原来的table类型参数表
	buildTables(tables);
}
//当重新选择函数时，在重新构造表格类型的参数前清除原有表格
function deleteTables(tablesLength){
	for(var i=0;i<tablesLength;i++){
		$("#TABLE_"+(i+2)).replaceWith(""); 
	}
}
//当重新选择函数时，在重新构建参数表前删除原来的函数数据
function resetTableRows(tableId,startIndex){
	var table=document.getElementById(tableId);
	var rowLength=table.rows.length;
	for(var i=rowLength-1;i>=startIndex;i--){
		table.deleteRow(i);
	}
}
//显示公式定义器
function show_formula_dialog(xpath,isin){
	var varInfo=XForm_getXFormDesignerObj();
	var fdInvokeType='${param.fdInvokeType}';//得到事件类型
	//如果为传出类型使用订制的变量选择框
	if((isin==""&&xpath.indexOf('export')>-1)||isin.indexOf('0') != -1)
		Dialog_Tree(false,xpath+'.id',xpath+'.name', null,'tibCommonMappingExportTreeService&id=!{value}&modelName=${param.mainModelName}&formFileName=${param.fdFormFileName}','<bean:message bundle="tib-sap" key="tibSapMapping.lang.var"/>');//如果为传出参数或者传出表格参数则采用订制的选择框
		else{
			if(fdInvokeType=='0')//表单事件类型
				{
				show_formula_dialog_formEvent(xpath,varInfo);
				}
			else
			{
				Formula_Dialog(xpath+'.id', xpath+'.name', varInfo,'Object',null,null);	
			}
				}
	//如果映射没有发生变化则不需要改变以下两项
	if($('input[name="'+xpath+'.id"]').val()==XML_GetSingleNodeAttribute(fdRfcParamXmlObject,xpath,"ekpid"))
		return;
	$('input[name="'+xpath+'.name"]').val(getString($('input[name="'+xpath+'.name"]').val()));//去掉字段说明中的$
	resetParam(xpath);
}
//加载对应model数据字典和自定义表单字段到公式定义器树中
function XForm_getXFormDesignerObj(){
	var sysObj = TIB_XForm_GetSysDictObj("${param.mainModelName}");//传递model得到对应的数据字典
	var extObj = _XForm_GetExitFileDictObj("${param.fdFormFileName}");//传递最新模板的路径,为空则表明没有用到自定义表单
	return sysObj.concat(extObj);//返回的同时给formVar赋值
}
//一键匹配功能 注意自定义表单中变量名唯一，所以只要内层循环匹配成功就可以终止内层循环。支持表格参数
function oneKeyMatch(tableId){
	var r=confirm('<bean:message bundle="tib-sap" key="tibSapMapping.lang.mappingConfirm"/>');
	if(r==false)return;
	var table;
	if(typeof(tableId)=="object")
    table=tableId;//表参数类型的
	else
		 table=document.getElementById(tableId);
	var rows=table.rows;
	//如果没有选择函数则返回或者rows的长度为2则返回
	if($("#fdRfcSettingId").val()==""||rows.length==2)return;
	var formVar=XForm_getXFormDesignerObj();
	for(var i=2;i<rows.length;i++){//i从2开始
		var xpath=rows[i].id;
		var fieldTitle=XML_GetSingleNodeAttribute(fdRfcParamXmlObject,xpath,"title");
		for(var j=0;j<formVar.length;j++){
			var field=formVar[j];
			if(typeof(tableId)=="object"){//如果为表格类型参数
				var labels=field["label"].split('.');
			//等于a类型的a或者a.b类型的b
			if((labels.length==1&&labels[0]==fieldTitle)||(labels.length==2&&labels[1]==fieldTitle)){			
					$('input[name="'+xpath+'.id"]').val("$"+field["name"]+"$");
					$('input[name="'+xpath+'.name"]').val(field["label"]);
					resetParam(xpath);
					break;	
				}
			}
			else{
			if(field["label"]==fieldTitle)	{//因明细表中的字段名称不能与非明细表字段相同，so可以采取这种简单匹配方式
				$('input[name="'+xpath+'.id"]').val("$"+field["name"]+"$");
				$('input[name="'+xpath+'.name"]').val(field["label"]);
				resetParam(xpath);
				break;	
			}
			}
		}	
	}
}

//编辑后重新设置xml文件（对象）对应xpath的field相关属性
function resetParam(xpath){//保存到xml字段属性前先将"进行转换
	var attr_value={"ekpid":$('input[name="'+xpath+'.id"]').val(),
                                 "ekpname":$('input[name="'+xpath+'.name"]').val()};
	XML_SetNodeAttribute(fdRfcParamXmlObject,xpath,attr_value);
}
//去除字段说明中的$
function getString(s){
	var startIndex=s.indexOf('$');
	return startIndex>-1?s.substring(startIndex+1,s.lastIndexOf('$')):s;
}
//利用onchange事件重新设置表单的字段说明
function resetFormNameField(xpath){
	var attr_value={
            "ekpname":$('input[name="'+xpath+'.name"]').val()};
XML_SetNodeAttribute(fdRfcParamXmlObject,xpath,attr_value);
}

//订制只属于表单事件的公式定义器，只支持变量和常量，暂不支持类似前端计算的功能
function show_formula_dialog_formEvent(xpath,varInfo){
	//var varInfo=XForm_getXFormDesignerObj();
	var dialog = new KMSSDialog();
	dialog.formulaParameter = {
			varInfo: varInfo,
			returnType: "Object"};
	dialog.BindingField(xpath+'.id', xpath+'.name');
	dialog.URL = Com_Parameter.ContextPath + "tib/common/resource/jsp/formEvent_dialog_edit.jsp";
	dialog.Show(500, 480);
}

function simple_formula(bindId,bindName){
	Dialog_Tree(false,bindId,bindName, null,'tibCommonMappingExportTreeService&id=!{value}&modelName=${param.mainModelName}&formFileName=${param.fdFormFileName}','<bean:message bundle="tib-sap" key="tibSapMapping.lang.var"/>');//如果为传出参数或者传出表格参数则采用订制的选择框

	
}

//替换特殊xml特殊符号之"双引号—暂时没用
function filterString(s){
	return s.replace(/\"/g,"&quot;");
}

// 控制传入&传出表格的Key的显示隐藏
function tableKeyControl(spanId, writeKeyId, tableName, isShow) {
	var xpath = "/jco/tables/table[@name='"+ tableName +"']";
	if (isShow) {
		$("#"+ spanId).show();
		var writeKey = $("#"+ writeKeyId).val();
		XML_SetNodeAttribute(fdRfcParamXmlObject, xpath, {"writeKey" : writeKey});
		XML_SetNodeAttribute(fdRfcParamXmlObject, xpath, {"writeType" : "1"});
	} else {
		$("#"+ spanId).hide();
		XML_SetNodeAttribute(fdRfcParamXmlObject, xpath, {"writeType" : "2"});
	}
	
}

function writeKeyControl(tableName, value) {
	var xpath = "/jco/tables/table[@name='"+ tableName +"']";
	XML_SetNodeAttribute(fdRfcParamXmlObject, xpath, {"writeKey" : value});
}

</script>
<%--引入明细配置js --%>
<jsp:include page="../../../common/mapping/tib_common_mapping_func/ex_config.jsp"></jsp:include>
<script type="text/javascript" src="${KMSS_Parameter_ContextPath}tib/common/mapping/tib_common_mapping_func/ex_config.js"></script>

<script type="text/javascript">
     (function(){
         var invokeType="${param.fdInvokeType}";
         <%--只处理机器人节点 && 表单提交 && 流程驳回--%>
         if(invokeType=='3'||invokeType=='4'||invokeType=='6'){
        	 DetailJsonHelper.initJsonData(window.dialogArguments.fdExtendFormsView);
         }
         toggleImp();
         
     })();
     
</script>
<%@ include file="/resource/jsp/edit_down.jsp"%>
