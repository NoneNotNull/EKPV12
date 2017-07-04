<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
	<div id="optBarDiv">
		<input type="button" id='btn_search'
		value="搜索"
		onclick="searchSelect();">
		<input type="button"
		value="确定"
		onclick="checkSelect();">
		
		
	</div>
<style>
#My_List_Table{ margin:0px 0 !important; border:0; border-collapse:collapse;}
#My_List_Table td{ border:0; border-collapse:collapse;padding:0px 10px;}
#My_List_Table tr{magrin:0 10px}
</style>
<script type="text/javascript">
	Com_IncludeFile("jquery.js");
	Com_IncludeFile('json2.js');
</script>
<script>
	var objData=window.opener.Com_Parameter.Dialog.data;
	var callback=window.opener.Com_Parameter.Dialog.AfterShow;
</script>
<script>
	var checkedRows=[];
	function checkedRowsClick(obj){
		if(obj.type=='radio'){
			checkedRows=[];
			checkedRows.push(objData.data.rows[obj.value]);
		}
		else{
			var curRow=objData.data.rows[obj.value];
			if(obj.checked){
				curRow.pageSize=objData.paramsJSON.pageSize;
				curRow.checkedIndex=obj.value;
				checkedRows.push(curRow);
			}
			else{
				var idx=0;
				for(var i=0;i<checkedRows.length;i++){
					if(checkedRows[i].pageSize==objData.paramsJSON.pageSize&&checkedRows[i].checkedIndex==obj.value){
						idx=i;
						break;
					}
				}
				checkedRows.splice(idx,1);
			}
		}
	}
	function checkSelect(){
		/**
		var checkeds = $("input:checked[name='List_Selected']");
		var checkedValues = new Array();
		checkeds.each(function(){
			checkedValues.push(this.value);
		});
		if (checkeds.size() == 0) {
			alert("<bean:message key="page.noSelect"/>");
			return false;
		}
		**/
		if (checkedRows.length == 0) {
			alert("<bean:message key="page.noSelect"/>");
			return false;
		}
		if(callback){
			var rtn={};
			rtn.checkedRows=checkedRows;
			rtn.objData=objData;
			callback(rtn);
		}
		//window.returnValue=checkedValues;
		//window.opener.setValueByRowIndex(checkedValues,data);
		window.close();
		return true;
	}
	function checkAll(obj){
		if(obj.checked){
			$("input[name='List_Selected']").each(function(){
				if(!this.checked){
					var curRow=objData.data.rows[this.value];
					curRow.pageSize=objData.paramsJSON.pageSize;
					curRow.checkedIndex=obj.value;
					checkedRows.push(curRow);
				}
				this.checked=true;
			});
		}
		else{
			//如果已经选中了,就需要移除
			$("input[name='List_Selected']").each(function(){
				if(this.checked){
					var idx=0;
					for(var i=0;i<checkedRows.length;i++){
						if(checkedRows[i].pageSize==objData.paramsJSON.pageSize&&checkedRows[i].checkedIndex==this.value){
							idx=i;
							break;
						}
					}
					checkedRows.splice(idx,1);
				}
			});
			$("input[name='List_Selected']").removeAttr("checked");
		}
	}
	function searchSelect(){
		//执行搜索,清空已选列表
		checkedRows=[];
		
		var searchsJSON=JSON.parse(objData.paramsJSON.searchs);
		$("input[name='searchText']").each(function(){
			var isIn=false;
			for(var i=0;i<searchsJSON.length;i++){
				if(searchsJSON[i].fieldId==this.id){
					searchsJSON[i].fieldValue=this.value;
					isIn=true;
					break;
				}
			}
			//不在搜索列表里面,初始化一个
			if(!isIn){
				var tempSearch={};
				tempSearch.fieldId=this.id;
				tempSearch.fieldValue=this.value;
				searchsJSON.push(tempSearch);
			}
		});
		//是否分页,分页则搜索后置为首页
		if(/[\d][1]/g.test(objData.paramsJSON.listRule)){
			objData.paramsJSON.pageSize=1;
		}
		objData.paramsJSON.searchs=JSON.stringify(searchsJSON);
		window.opener.loadEventRows(objData,reLoadTableRows);
	}
</script>

<div id='tableContent'></div>
<div id='tablePage' style="margin:5px 0px"></div>
<script>
$(function(){
	loadTable(objData);
	loadPage(objData);
	
});
</script>

<script>
var win=this;
function loadPage(objData){
	//校验是否需要分页
	if(!/[\d][1]/g.test( objData.paramsJSON.listRule)){
		return;
	}
	var page=[];
	page.push("<a href='#' style='margin:5px 5px' onclick='event_first_page();'>首页</a>");
	page.push("<a href='#' style='margin:5px 5px' onclick='event_prve_page();'>上一页</a>");
	page.push("<a href='#' style='margin:5px 5px' onclick='event_next_page();'>下一页</a>");
	
	$("#tablePage").html(page.join(""));
}
function event_first_page(){
	objData.paramsJSON.pageSize=1;
	window.opener.loadEventRows(objData,reLoadTableRows);
}
function event_prve_page(){
	if(objData.paramsJSON.pageSize==1){
		alert('已经第一页');
		return ;
	}
	objData.paramsJSON.pageSize=parseInt(objData.paramsJSON.pageSize)-1;
	window.opener.loadEventRows(objData,reLoadTableRows);
}
function event_next_page(){
	if(objData.data.rows.length<objData.paramsJSON.pageNum){
		alert('已经是最后一页');
		return ;
	}
	objData.paramsJSON.pageSize=parseInt(objData.paramsJSON.pageSize)+1;
	window.opener.loadEventRows(objData,reLoadTableRows);
}
function loadTable(objData){
	var table=[];
	table.push('<table id="My_List_Table">');
	
	table.push(loadTableHeader(objData));
	table.push(loadTableSearch(objData));
	table.push(loadTableRows(objData));
	
	table.push('</table>');
	$("#tableContent").html(table.join(""));
}
function reLoadTableRows(objData){
	var rows=loadTableRows(objData);
	//保留标题行和搜索行
	$("#My_List_Table tr:gt(1)").remove();
	$("#My_List_Table").append(rows);
};

function loadTableHeader(objData){
	//加载表头
	var headers=[];
	headers.push("<tr class='tr_listfirst' style='white-space:nowrap'>")
	headers.push("<td style='width:25px;'>");
	if(/[0][\d]/g.test(objData.paramsJSON.listRule)){
		headers.push("&nbsp;");
	}
	else{
		headers.push("<input type='checkbox' onclick='checkAll(this);'></input>");
	}
	headers.push("</td>");
	var width=100.0/objData.data.headers.length+"%";
	for(var i=0;i<objData.data.headers.length;i++){
		headers.push("<td style='width:"+width+"'>");
		headers.push(objData.data.headers[i].fieldNameForm);
		headers.push("</td>");
	}
	headers.push("</tr>")
	return headers.join("");
}
function loadTableSearch(objData){
	//加载搜索行
	var searchs=[];
	searchs.push("<tr class='tr_listfirst'>")
	searchs.push("<td style='width:25px;'>");
	searchs.push("&nbsp;");
	searchs.push("</td>");
	var width=100.0/objData.data.headers.length+"%";
	//是否存在搜索字段
	var hasSearch=false;
	var columnsCount=0;
	for(var i=0;i<objData.data.headers.length;i++){
		columnsCount++;
		searchs.push("<td style='width:"+width+"'>");
		if(objData.data.headers[i].canSearch){
			hasSearch=true;
			searchs.push("<input type='text' class='inputsgl' name='searchText' id='"+objData.data.headers[i].fieldId+"' value=''/>");
		}
		else{
			searchs.push("&nbsp;");
		}
		
		searchs.push("</td>");
	}
	searchs.push("</tr>")
	//没有搜索字段返回空串
	if(!hasSearch){
		//隐藏搜索按钮
		$("#btn_search").hide();
		return "<tr style='display:none'><td colspan="+(columnsCount+1)+"></td></tr>";
	}
	return  searchs.join("");
}
function loadTableRows(objData){
	var rows=[];
	for(var i=0;i<objData.data.rows.length;i++){
		var tr_class="tr_listrow"+(i%2+1);
		rows.push("<tr class='"+tr_class+"'>");
		//处理复选框
		rows.push("<td>");
		if(/[0][\d]/g.test(objData.paramsJSON.listRule)){
			rows.push("<input type='radio' name='List_Selected' value='"+i+"' onclick='checkedRowsClick(this)'></input>");
		}else{
			rows.push("<input type='checkbox' name='List_Selected' value='"+i+"' onclick='checkedRowsClick(this)'></input>");
		}
		rows.push("</td>");
		for(var j=0;j<objData.data.headers.length;j++){
			rows.push("<td>");
			rows.push(objData.data.rows[i][j]);
			rows.push("</td>");
		}
		rows.push("</tr>");
	}
	return rows.join("");
}
</script>
<%@ include file="/resource/jsp/list_down.jsp"%>