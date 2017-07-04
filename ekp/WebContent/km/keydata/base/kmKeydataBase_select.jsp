<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@ page import="com.landray.kmss.km.keydata.base.model.KmKeydataBase"%>
<%@ page import="java.util.*"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<style type="text/css">
.btndialog {
font-family: Microsoft YaHei, Geneva, "sans-serif", SimSun;
}
.btndialog {
background-color: #47b5e6;
}
.btndialog {
height: 22px;
width: 50px;
line-height: 22px;
border: 0px;
cursor: pointer;
color: #fff;
}
</style>
<script type="text/javascript">
parent.document.title="关键数据选择";

function windowclose() {
    var browserName = navigator.appName;
    if (browserName=="Netscape") {
        window.open('', '_self', '');
        window.close();
    }
    else {
        if (browserName == "Microsoft Internet Explorer"){
            window.opener = "whocares";
            window.opener = null;
            window.open('', '_top'); 
            window.close();
        }
    } 
}

function doSetValue(value){
	top.returnValue = value;
	//window.close();
	//windowclose();
	Com_CloseWindow();
}

function resizeWindowHeight(){
	var table = document.getElementById("List_ViewTable");
	if(table){
		if(table.clientHeight<1){
			top.dialogHeight = (table.clientHeight+300)+"px";
		}else{
			top.dialogHeight = (table.clientHeight+120)+"px";
		}
	}
}


function doSubmit(){
	var els = document.getElementsByName("List_Selected");
	var v = "";
	for(var i=0;i<els.length;i++){
		if(els[i].checked){
			v = els[i].value;
		}
	}
	if(v!=""){
		a = v.split("_@_");
		var o = {fdId:a[0],fdName:a[1]};
		returnValue = o;
	}

    top.returnValue = o;
	/*
	if (window.opener != undefined) {
       //for chrome
       //window.opener.returnValue = o;
       alert(12321);
       top.returnValue = o;
	}
	else {
       window.returnValue = o;
	}
	*/
	Com_CloseWindow();
}

function doSearch(){
	var keydataName = document.getElementsByName("keydataName")[0].value;
	location.href = '/km/keydata/base/kmKeydataBase.do?method=select&keydataType=${keydataType}&keydataName='+keydataName;
}

function keydown(){
	var e = event || window.event || arguments.callee.caller.arguments[0];        
     if(e && e.keyCode==13){ // enter 键
    	 doSearch();
    }
}
		
//window.onload = resizeWindowHeight();
</script>
<div align="center">
名称：<input type="text" name="keydataName"  value="${keydataName}" onkeydown="keydown()"/>&nbsp;
<input type="button" class="btndialog" value="搜索" onclick="doSearch();" />
</div>					
<html:form action="/km/keydata/base/kmKeydataBase.do">
	<% if (((Page)request.getAttribute("queryPage")).getTotalrows()==0){ %>
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
	<% }else{ %>
	<table id="List_ViewTable">
		<tr>
			<td>
			</td>
			<td width="70%">
				<center>名称</center>
			</td>
			<td width="20%">
					编号
			</td>
			
		</tr>
		<c:forEach items="${queryPage.list}" var="kmKeydataBase" varStatus="vstatus">
			<%
				KmKeydataBase kmKeydataBase = (KmKeydataBase) pageContext.getAttribute("kmKeydataBase");
				StringBuffer js = new StringBuffer();
				js.append("{");
				js.append("fdId:'"+kmKeydataBase.getFdId()+"'");
				js.append(",fdName:'"+kmKeydataBase.getFdName()+"'");
				//js.append(",fdCode:'"+kmKeydataBase.getFdCode()+"'");
				//js.append(",fdValue:'"+reportEnumSettingValue+"'");
				js.append("}");
			
				String tmp = kmKeydataBase.getFdId()+"_@_"+kmKeydataBase.getFdName();
			%>
			<tr>
				<td>
					<input type="radio" name="List_Selected" value="<%=tmp%>" ondblclick="doSetValue(<%=js.toString()%>)">
				</td>
				<td ondblclick="doSetValue(<%=js.toString()%>)">
					<c:out value="${kmKeydataBase.fdName}" />
				</td>
				<td ondblclick="doSetValue(<%=js.toString()%>)">
					<c:out value="${kmKeydataBase.fdCode}" />
				</td>
				
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/km/keydata/base/kmKeydataBase_select_down.jsp"%>
	<center>
		<table>
			<tr>	
				<td>
					<input type="button" class="btndialog" value="<bean:message key="button.ok"/>" onclick="doSubmit();" />
						&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="button" class="btndialog" value="<bean:message key="button.cancel" />" onclick="doSetValue({});" />
						&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="reset" class="btndialog" value="<bean:message key="button.close" />" onclick="Com_CloseWindow();"/>	
				</td>
			</tr>
		</table>
	</center>
<% } %>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>