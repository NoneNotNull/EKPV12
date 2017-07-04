<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<style>
td, body, input{font-size: 12px;}
.barmsg{text-align:center;font-weight: bold;}
.btnmsg{padding: 2px 5px 0px 5px;border:1px solid #000033;cursor:point}
.barmsg, .btnmsg{background:url(${KMSS_Parameter_StylePath}list/list_nodoc_bg.jpg);}
.errortitle, .msgtitle{color:red;font-weight:bold;}
.errorlist{color:red;}
.msglist{}
.errtrace{margin:5px 15px;border:1px solid #CCCCCC;padding:5px;background:#F3F3F3;}
.maxwinicon{position:absolute;left:10px;width:23px;height:23px;}
</style>
<script>
Com_IncludeFile("docutil.js|data.js");
var idTableBody;
var selectData;
var selectId;
var selectName;
function buttonSearch(){
	var subject = document.getElementsByName("subject")[0].value;
	if(subject == '' || subject == undefined){
			alert("<bean:message bundle='component-bklink' key='compBklink.select.no.input.data.message'/>");
			return;
	}
	subject = encodeURI(subject);	
	idTableBody = document.getElementById("id_table_body");
	var kmssData = new KMSSData();
	kmssData.AddBeanData("compBklinkSearchTreeService&subject="+subject+"&modelName=${param.modelName}&searchCondition=${param.searchCondition}");
	selectData = kmssData.GetHashMapArray();
	var input,row, cell, txtNode;
	clearTableBody();
	document.getElementById("id_search").style.display='';
	if(selectData.length <= 0){	 
		 row = document.createElement("<tr height='100px'>");
		 cell = document.createElement("<td align=\"center\">");
		 txtNode = document.createTextNode("<bean:message bundle='component-bklink' key='compBklink.search.no.data.message'/>");
		 cell.appendChild(txtNode);
		 row.appendChild(cell);
		 idTableBody.appendChild(row);
		 return;
	}
	for(var i = 0; i< selectData.length; i++){
		input = document.createElement("<input type='radio' name='radio_' onclick='selectRadio(this) '/>");
		input.setAttribute("value",i);
		row = document.createElement("<tr height='20px'>");
		cell = document.createElement("td");
		cell.appendChild(input);
		txtNode = document.createTextNode(selectData[i]['name']);
		cell.appendChild(txtNode);
		row.appendChild(cell);
		idTableBody.appendChild(row);
	}	
}
function clearTableBody(){
	var number = idTableBody.childNodes.length;
	for(var i = number-1; i >= 0 ; i--){
		idTableBody.removeChild(idTableBody.childNodes[i]);
	}
}
function selectRadio(obj){
	selectId = selectData[obj.value]['id'];
	selectName = selectData[obj.value]['name'];
}
function definite(){
	var rtnValue = new Array();
	if(selectId == null){
		alert("<bean:message bundle='component-bklink' key='compBklink.select.no.data.message'/>");
		return;
	}
	rtnValue.push(selectId);
	rtnValue.push(selectName);
	window.parent.returnValue = rtnValue;
	window.close();
}
function clearData(){
	var rtnValue = new Array();
	rtnValue.push("");
	rtnValue.push("");
	window.parent.returnValue = rtnValue;
	window.close();
}
</script>
<center>
<table width="95%" border="0">
	<tr>
		<td align="center">
		<input type="text" name="subject" class="inputsgl" value="" style="width:80%"/>
		<input type="button" class="btnmsg"  value="<bean:message key='button.search'/>" onclick="buttonSearch();"/>
		</td>
	</tr>
	<tr id="id_search" style="display:none">
		<td height="100px" align="center">
			<div  id="id_div" style="height:100px;width:91%;position:relative;overflow:auto;z-index:10px;"> 
				<table id="id_table" border="0" width="100%" align="center" class="tb_normal">
					<tbody id="id_table_body"></tbody>				
				</table>			
			</div>
		</td>
	</tr>
	<tr>
		<td align="center"><input type="button" class="btnmsg"  onclick="clearData();"  value="<bean:message key='button.clear'/>"/>&nbsp;&nbsp;&nbsp;
		<input type="button" class="btnmsg"  onclick="definite();"  value="<bean:message key='button.ok'/>"/>&nbsp;&nbsp;&nbsp;
		<input type="button" class="btnmsg"  onclick="javascript:window.close();" value="<bean:message key='button.close'/>"/></td>
	</tr>
</table>
<script language="javascript" for="document" event="onkeydown">   
    if (event.keyCode == 13){   
    	buttonSearch();
    }   
</script> 
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>