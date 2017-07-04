<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>

<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%><style>
.tb_normal tr{
	line-height: 30px;
}
.tb_normal tr td{
	vertical-align: middle;
}
.td_normal_title{
	text-align: right;
	font-weight: bold;
	font-size: 14px;
}
.inputselectsgl{
	display:inline-block;
}
.inputselectsgl input {	
	color: #0066FF;
	border-color: #999999;
	border-style: solid;
	border-width: 0px 0px 1px 0px;
	font-size:12px
}
.td_search{
	display:inline-block;
	float:right;
	width:60px;
	text-align: right;
}
.validation-advice{
	display:inline-block;
	vertical-align: middle; 
	
}
.validation-advice td{
	color: red;
}
.input{
	width:100px;
}
</style>
<script>
Com_IncludeFile("dialog.js|plugin.js");
</script>
<html:form method="POST" action="/kms/log/kms_log_search/kmsLogSearch.do?method=list">
<div class="filterDiv">
<table class="tb_normal" width="90%">
	<tr>
		<td class="td_normal_title" style="width:30px">
			<bean:message key="kmsLogApp.search.org" bundle="kms-log"/>：
		</td><td width="88%">
			<html:hidden  property="fdOperator"/><html:text property="fdOperatorName" style="width:250px" readonly="true" styleClass="inputsgl" 
				onclick="Dialog_Address(true, 'fdOperator', 'fdOperatorName', ';', null,afterAddress);"/>
			<a href="#" onclick="Dialog_Address(true, 'fdOperator', 'fdOperatorName', ';', null,afterAddress);">
				<bean:message key="dialog.selectOrg"/>
			</a>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="kms-log" key="kmsLogApp.fdCreateTime"/>：
		</td><td width="88%"><div style="display: inline-block">
				<input name="startTime" value="${kmsLogSearchForm.startTime}" type="text" onpropertychange="dateValidate();" class="inputsgl" subject="开始日期" style="width:130px" validate="__date" onclick="selectDate('startTime')" value=""/>
				 <bean:message key="kmsLogApp.search.date.until" bundle="kms-log"/> <xform:datetime 
				property="endTime" validators="maxDate();" subject="结束日期" className="inputsgl" showStatus="edit" style="width:120px" 
				dateTimeType="Date" />
			</div>
			<div class="td_search">
				<input type=button style="width:65px;height:25px;" value="<bean:message key="button.search"/>"
					onclick="if(!validate.validate())return;_submit();" />
			</div>
			<div style="display:none" class="validation-advice" id="advice-_validate_0" _reminder="true">
				<table class="validation-table"><tbody><tr><td>
					<div class="lui_icon_s lui_icon_s_icon_validator"></div>
				</td>
				<td class="validation-advice-msg"><bean:message bundle="kms-log" key="kmsLogApp.searchDateMsg"/></td>
				</tr></tbody></table>
			</div>
		</td>
	</tr>
</table>	
</div>
</html:form>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="5%"> 
					<input type="checkbox" name="List_Tongle">
				</td>
				<td width="5%">
					<bean:message key="page.serial"/>
				</td>
				<td width="15%">
					<bean:message bundle="kms-log" key="kmsLogSearch.fdCreateTime"/>
				</td>
				<td width="10%">
					<bean:message bundle="kms-log" key="kmsLogSearch.fdOperator"/>
				</td>
				<td width="20%">
					<bean:message bundle="kms-log" key="kmsLogSearch.fdSearchKey"/>
				</td>
				<td width="10%">
					<bean:message bundle="kms-log" key="kmsLogSearch.openDoc"/>
				</td>
				<td width="15%">
					<bean:message bundle="kms-log" key="kmsLogSearch.fdIp"/>
				</td>
			</sunbor:columnHead>
		</tr>

		<%   
			List list = ((Page) request.getAttribute("queryPage")).getList();     
			for(int i=0;i<list.size();i++)      {        
				Object[] obj = (Object[])list.get(i);     
		%>
			<tr>
<%//	kmss_href="<c:url value="/kms/log/kms_log_search/kmsLogSearch.do" />?method=view&fdId=<=obj[0]>">   %>	
				<td>
					<input type="checkbox" name="List_Selected" value="<%=obj[0]%>">
				</td>
				<td >
					<%=i+1%>
				</td>
				<td>
					<%=obj[1]%>
				</td>
				<td>
					<%=obj[2]==null?"":obj[2]%>
				</td>
				<td>
					<%=obj[3]%>
				</td>
				<td>
					<%=obj[4]%>
				</td>
				<td>
					<%=obj[5]%>
				</td>
			</tr>
		<%} %>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
<script>
var validate = $KMSSValidation();
validate.addValidator('maxDate()','<bean:message bundle="kms-log" key="kmsLogApp.searchDateMsg"/>',
	function(v, e, o){
		var startDateValue = document.getElementsByName('startTime')[0].value; 
		var endDateValue = document.getElementsByName('endTime')[0].value; 
		if (this.getValidator('isEmpty').test(endDateValue)) return true;
		if (this.getValidator('isEmpty').test(startDateValue)) return true;
		var endDate = null;
		var maxStartDate = null;
		var arr = endDateValue.split(/[^0-9]/);
		endDate = new Date(parseInt(arr[0],10),parseInt(arr[1],10)-1,parseInt(arr[2],10),arr[3]==null?0:parseInt(arr[3],10),
						arr[4]==null?0:parseInt(arr[4],10),arr[5]==null?0:parseInt(arr[5],10),arr[6]==null?0:parseInt(arr[6],10),
						arr[7]==null?0:parseInt(arr[7],10)).getTime();
		arr = startDateValue.split(/[^0-9]/);
		startDate = new Date(parseInt(arr[0],10),parseInt(arr[1],10)-1,parseInt(arr[2],10),arr[3]==null?0:parseInt(arr[3],10),
						arr[4]==null?0:parseInt(arr[4],10),arr[5]==null?0:parseInt(arr[5],10),arr[6]==null?0:parseInt(arr[6],10),
						arr[7]==null?0:parseInt(arr[7],10)).getTime();
		maxStartDate = new Date(parseInt(arr[0],10),parseInt(arr[1],10),parseInt(arr[2],10),arr[3]==null?0:parseInt(arr[3],10),
						arr[4]==null?0:parseInt(arr[4],10),arr[5]==null?0:parseInt(arr[5],10),arr[6]==null?0:parseInt(arr[6],10),
						arr[7]==null?0:parseInt(arr[7],10)).getTime();
		if(endDate >= startDate && endDate <=maxStartDate)
			return true;
		return false;
	});
function dateValidate(){
	
}
function _submit(){
	var startDateValue = document.getElementsByName('startTime')[0].value;
	var endDateValue = document.getElementsByName('endTime')[0].value; 
	var fdOperator = document.getElementsByName('fdOperator')[0].value; 
	var fdOperatorName = document.getElementsByName('fdOperatorName')[0].value; 

	if(fdOperator!=null && fdOperator.length>32){
		alert('<bean:message bundle="kms-log" key="kmsLogApp.select.personal"/>');
		return false ;
	}

	var url  = Com_CopyParameter(Com_Parameter.ContextPath+"kms/log/kms_log_search/kmsLogSearch.do?method=list");
	url = Com_SetUrlParameter(url, "startDate", startDateValue);
	url = Com_SetUrlParameter(url, "endDate", endDateValue);
	url = Com_SetUrlParameter(url, "fdOperator", fdOperator);
	url = Com_SetUrlParameter(url, "fdOperatorName", fdOperatorName);
	url = Com_SetUrlParameter(url, "pageno", 1);
	window.location.href=url;
}
function afterAddress(rtnVal){
	var fdOperator = document.getElementsByName("fdOperator")[0].value ;
	if(fdOperator.length > 32){
		document.getElementsByName("fdOperator")[0].value="" ;
		document.getElementsByName("fdOperatorName")[0].value="" ;
		alert('<bean:message bundle="kms-log" key="kmsLogApp.select.personal"/>');
		return false ;
	}
}
</script>
<%@ include file="/resource/jsp/list_down.jsp"%>