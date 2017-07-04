<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
request.setAttribute("sys.ui.theme", "default");
%>
<template:include ref="default.simple">
	<template:replace name="title">${ lfn:message('sys-portal:desgin.msg.configtable') }</template:replace>
	<template:replace name="body">
	<ui:toolbar layout="sys.ui.toolbar.float" count="10" var-navwidth="100%">
		<ui:button onclick="onEnter()" text="${ lfn:message('sys-portal:sysPortalPage.msg.enter') }"></ui:button>
	</ui:toolbar>
<style type="text/css">
#boxWidth {
	color:red;
}
.columnWidth {
	color:#1b83d8;
	width: 42px;
	height: 21px;
	border-bottom: 1px solid #b4b4b4;
	text-align: center;
	margin: 0 auto;
	background-color: rgb(235, 235, 228);
}
.cent td {
	text-align: center;
}
.cent td input {
	text-align: center;
}
.cent td.tex {
	text-align: right;
}
</style>	<script>
		seajs.use(['theme!form']);
		</script>
<script>

function onEnter(){ 
	var x = parseInt(document.getElementById("column").value);
	if(x<=0){
		alert("输入列数");
		return;
	}
	if($('#column').attr("old") != null){
		if(x < parseInt($("#column").attr("old"))){
			alert("列数不能小于"+$("#column").attr("old"));
			return;
		}
	}	
	var val ={};
	val.column = x;
	val.cols = [];
	val.boxWidth = parseInt($('#boxWidth').text()); 
	val.boxStyle = $('#boxStyle').val();
	for(var i=0;i<x;i++){
		var col = {};
		col.columnProportion=$($("#vboxProportion td").get(i*2+1)).find("input").val();
		col.columnWidth=$($("#vboxWidth td").get(i*2+1)).find(".columnWidth").text();
		if(i==0)
			col.hSpacing=null;
		else
			col.hSpacing= $($("#vboxWidth td").get(i*2)).find("input").val();
		col.vSpacing= $($("#vSpacingWidth td").get(i*2+1)).find("input").val();

		col.columnStyle=$($("#vboxStyle td").get(i*2+1)).find("input").val();
		col.columnLock=$($("#vboxLock td").get(i*2+1)).find(":checkbox").is(":checked");
		val.cols.push(col);
	}
	var allLock = true;
	for(var i=0;i<val.cols.length;i++){
		if(!val.cols[i].columnLock){
			allLock = false;
		}
	}
	if(allLock){
		alert("不允许所有列都锁定缩放");
		return;
	}
	window.$dialog.hide(val);
}
function DigitInput(el,e) {
	el.value=el.value.replace(/\D/gi,"");
}
function _columnWidth(alculate){
	var newl = parseInt($('#column').val());
	if(newl<=0)
		return;
	var hSpacingVal = $("#hSpacing").val();
	var vSpacingVal = $("#vSpacing").val();
	var oldl = 0;
	if($("#vboxNumber").find("td").length > 1){
		oldl = $("#vboxNumber").find("td").length / 2;
	}
	
	if(newl > oldl){ 
		for(var i=oldl;i<newl;i++){
			if(i>0){
				$("#vboxNumber").append("<td>${lfn:message('sys-portal:sysPortalPage.desgin.c.spacing')}</td>");
				$("#vboxProportion").append("<td></td>");
				var disb = "";
				if($("#showhSpacingDetailCofnig").is(":checked")){
				}else{
					disb = " disabled='disabled' ";					
				}
				$("#vboxWidth").append("<td><input class='inputsgl' type='text' "+disb+" value='"+hSpacingVal+"' style='width:40px;' onkeyup='DigitInput(this,event);alculateWidth();' /></td>");
				$("#vSpacingWidth").append("<td></td>");
				$("#vboxStyle").append("<td></td>");
				$("#vboxLock").append("<td></td>");
			}
			$("#vboxNumber").append("<td>列${lfn:message('sys-portal:sysPortalPage.desgin.c.column')}"+(i+1)+"</td>"); 
			$("#vboxProportion").append("<td><input class='inputsgl' type='text' value='1' style='width:40px;' onkeyup='DigitInput(this,event);alculateWidth();' /></td>");
			$("#vboxWidth").append("<td><div class='columnWidth'></div></td>");
			$("#vboxStyle").append("<td><input class='inputsgl' type='text' value='' style='width:40px;' ></td>");
			$("#vboxLock").append("<td><input type='checkbox' style='width:40px;' ></td>");
			var disb = "";
			if($("#showvSpacingDetailCofnig").is(":checked")){
			}else{
				disb = " disabled='disabled' ";					
			}
			$("#vSpacingWidth").append("<td><input class='inputsgl' type='text' "+disb+" value='"+vSpacingVal+"' onkeyup='DigitInput(this,event);'  style='width:40px;'/></td>");
		}
	}else{
		for(var i=oldl;i>=newl;i--){			 
			$($("#vboxNumber").find("td")[i*2+1]).remove();
			$($("#vboxNumber").find("td")[i*2]).remove();

			$($("#vboxProportion").find("td")[i*2+1]).remove();
			$($("#vboxProportion").find("td")[i*2]).remove();

			$($("#vboxWidth").find("td")[i*2+1]).remove();
			$($("#vboxWidth").find("td")[i*2]).remove();
			
			$($("#vSpacingWidth").find("td")[i*2+1]).remove();
			$($("#vSpacingWidth").find("td")[i*2]).remove();	
			
			$($("#vboxStyle").find("td")[i*2+1]).remove();
			$($("#vboxStyle").find("td")[i*2]).remove();	
			
			$($("#vboxLock").find("td")[i*2+1]).remove();
			$($("#vboxLock").find("td")[i*2]).remove();
		}
	}
	if(alculate==null)
		alculateWidth();
}
function alculateWidth(){
	//宽度计算
	var boxWidth =  parseInt($('#boxWidth').text());
	var tdsWidth = $("#vboxWidth").find("td");
	var tdsProportion = $("#vboxProportion").find("td");
	var totalSpacing = 0;
	var total = 0;
	for(var i=0;i<tdsProportion.length;i++){
		if($(tdsProportion[i]).find("input").length > 0){
			total += parseInt($(tdsProportion[i]).find("input").val());		
		}		
	}
	for(var i=0;i<tdsWidth.length;i++){
		if($(tdsWidth[i]).find("input").length > 0){
			totalSpacing += parseInt($(tdsWidth[i]).find("input").val());
		}
	}
	var tempTotal = 0;
	boxWidth = boxWidth - totalSpacing;
	for(var i=0;i<tdsWidth.length;i++){
		var cw = $(tdsWidth[i]).find(".columnWidth");
		if(cw.length > 0){	
			var w = 0;
			if(i==tdsWidth.length-1){
				//最后一列等于总数减去前面所有列的和
				w=boxWidth-tempTotal;	
			}else{
				w=Math.round(boxWidth * (parseInt($(tdsProportion[i]).find("input").val()) / total));	
				tempTotal += w;
			}
			cw.text(w);
		}
	} 
}
function showhSpacingDetailCofnig(){
	var hSpacingVal = $("#hSpacing").val();
	var dis = $("#showhSpacingDetailCofnig").is(":checked");
	$("#hSpacing").attr("disabled",dis);
	
	$("#vboxWidth").find("td").each(function(i){
		if($(this).find("input").length > 0){
			$(this).find("input").val(hSpacingVal);
			$(this).find("input").attr("disabled",!dis);
		}
	});
}
function hSpacingChange(){
	var hSpacingVal = $("#hSpacing").val();
	
	$("#vboxWidth").find("td").each(function(i){
		if($(this).find("input").length > 0){
			$(this).find("input").val(hSpacingVal);
		}
	});

	alculateWidth();
}
function showvSpacingDetailCofnig(){
	var vSpacingVal = $("#vSpacing").val();
	var dis = $("#showvSpacingDetailCofnig").is(":checked");
	$("#vSpacing").attr("disabled",dis);
	
	$("#vSpacingWidth").find("td").each(function(i){
		if($(this).find("input").length > 0){
			$(this).find("input").val(vSpacingVal);
			$(this).find("input").attr("disabled",!dis);
		}
	});
}
function vSpacingChange(){
	var vSpacingVal = $("#vSpacing").val();	
	$("#vSpacingWidth").find("td").each(function(i){
		if($(this).find("input").length > 0){
			$(this).find("input").val(vSpacingVal);
		}
	});
}
function onReady(){
	if(window.$dialog == null){
		window.setTimeout(onReady, 100);
		return
	}
	window.$ = LUI.$;
	var value = window.$dialog.dialogParameter;
	if(value.column){
		$('#boxWidth').text(value.boxWidth);
		$('#boxStyle').val(value.boxStyle);
		$('#column').val(value.column);
		$('#column').attr("old",value.column);
		
		for(var i=value.column;i<=5;i++){
			$('#column').append("<option value='"+i+"'>"+i+"</option>");
		}
		$('#column').val(value.column);
		
		_columnWidth("noalculate");

		var showHDetail = false;
		var showVDetail = false;
		for(var i=0;i<value.cols.length;i++){
			if(i>0){
				$($("#vboxWidth td").get(i*2)).find("input").val(value.cols[i].hSpacing);
				if(value.cols[i].hSpacing != value.cols[1].hSpacing){
					showHDetail = true;
				}
				if(i==1)
					$("#hSpacing").val(value.cols[1].hSpacing);
			}
		}
		if($("#hSpacing").val()=="")
			$("#hSpacing").val(15);
		for(var i=0;i<value.cols.length;i++){
			$($("#vSpacingWidth td").get(i*2+1)).find("input").val(value.cols[i].vSpacing);
			if(value.cols[i].vSpacing != value.cols[0].vSpacing){
				showVDetail = true;
			}			

			$($("#vboxProportion td").get(i*2+1)).find("input").val(value.cols[i].columnProportion);
			$($("#vboxStyle td").get(i*2+1)).find("input").val(value.cols[i].columnStyle);
			//debugger;
			if(value.cols[i].columnLock!=null&&Boolean(value.cols[i].columnLock)){
				$($("#vboxLock td").get(i*2+1)).find(":checkbox").attr("checked",true);
			}else{
				$($("#vboxLock td").get(i*2+1)).find(":checkbox").attr("checked",false);
			}
			$($("#vboxWidth td").get(i*2+1)).find(".columnWidth").text(value.cols[i].columnWidth);
			if(i==0)
				$("#vSpacing").val(value.cols[0].vSpacing);
		}
		$("#showhSpacingDetailCofnig").attr("checked",showHDetail);
		$("#showvSpacingDetailCofnig").attr("checked",showVDetail);
		alculateWidth();
	}else{
		for(var i=1;i<=5;i++){
			$('#column').append("<option value='"+i+"'>"+i+"</option>");
		}
		$('#column').val(2);
		$('#hSpacing').val(15);
		$('#vSpacing').val(15);
		$('#boxWidth').text(value.boxWidth);
		_columnWidth(); 
	} 
	
	
	var hdis = $("#showhSpacingDetailCofnig").is(":checked");
	$("#hSpacing").attr("disabled",hdis);	
	$("#vboxWidth").find("td").each(function(i){
		if($(this).find("input").length > 0){ 
			$(this).find("input").attr("disabled",!hdis);
		}
	}); 
	var vdis = $("#showvSpacingDetailCofnig").is(":checked");
	$("#vSpacing").attr("disabled",vdis);	
	$("#vSpacingWidth").find("td").each(function(i){
		if($(this).find("input").length > 0){ 
			$(this).find("input").attr("disabled",!vdis);
		}
	}); 
}

LUI.ready(onReady);
</script>
<br>
<table class="tb_normal" style="width: 421px;">
	<tbody>
		<tr>
			<td width="30%">${ lfn:message('sys-portal:sysPortalPage.desgin.c.colw') }</td>
			<td>
				<select id="column" name="column" style="width:50px;" onchange="_columnWidth();"></select>
			</td>
			<td>容器${ lfn:message('sys-portal:sysPortalPage.desgin.c.zwidth') }<span id="boxWidth"></span>px</td>
 		</tr>
		<tr>
			<td>${ lfn:message('sys-portal:sysPortalPage.desgin.c.lrs') }</td>
			<td><input class='inputsgl' type="text" id="hSpacing" name="hSpacing" value="" style="width:50px;" onkeyup="DigitInput(this,event);hSpacingChange(this,event);" />px</td>
			<td><label><input type="checkbox" onclick="showhSpacingDetailCofnig()" name="showhSpacingDetailCofnig" id="showhSpacingDetailCofnig" />${ lfn:message('sys-portal:sysPortalPage.desgin.c.configure') }</label></td>
		</tr>
		<tr>
			<td>${ lfn:message('sys-portal:sysPortalPage.desgin.c.tds') }</td>
			<td><input class='inputsgl' type="text" id="vSpacing" name="vSpacing" value="" style="width:50px;" onkeyup="DigitInput(this,event);vSpacingChange(this,event);" />px</td>
			<td><label><input type="checkbox" onclick="showvSpacingDetailCofnig()" name="showvSpacingDetailCofnig" id="showvSpacingDetailCofnig" />${ lfn:message('sys-portal:sysPortalPage.desgin.c.configure') }</label></td>
		</tr>
		<tr style="display:none;">
			<td>容器样式
			</td>
			<td>
				<input class='inputsgl' id="boxStyle" type="text" >
			</td>
			<td>样式代码</td>
		</tr>	
	</tbody>
</table>
<br>
<table class="tb_normal cent" style="min-width: 400px;">
	<tr id="vboxNumber">
		<td>&nbsp;</td>
	</tr>
	<tr id="vboxProportion">
		<td class="tex">${ lfn:message('sys-portal:sysPortalPage.desgin.c.proportion') }</td>
	</tr>
	<tr id="vboxWidth">
		<td class="tex">${ lfn:message('sys-portal:sysPortalPage.desgin.c.width') }(px)</td>
	</tr>
	<tr id="vSpacingWidth">
		<td class="tex">${ lfn:message('sys-portal:sysPortalPage.desgin.c.tds') }(px)</td>
	</tr>
	<tr id="vboxStyle" style="display:none;">
		<td class="tex">容器样式</td>
	</tr>
	<tr id="vboxLock">
		<td class="tex">缩放锁定</td>
	</tr>
</table>  
	</template:replace>
</template:include>