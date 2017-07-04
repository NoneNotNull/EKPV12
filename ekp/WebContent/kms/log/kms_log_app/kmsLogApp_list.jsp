<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/kms/log/kms_log_app/kmsLogApp.do">
<style>
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
<html:form method="POST" action="kms/log/kms_log_app/kmsLogApp.do?method=list">
<div class="filterDiv">
<table class="tb_normal" width="90%">
	<tr>
		<td class="td_normal_title" style="width:30px">
			<bean:message key="kmsLogApp.search.org" bundle="kms-log"/>：
		</td><td width="88%">
			<html:hidden  property="orgElementId"/><html:text property="orgElementName" style="width:250px" readonly="true" styleClass="inputsgl" 
				onclick="Dialog_Address(true, 'orgElementId', 'orgElementName', ';', null);"/>
			<a href="#" onclick="Dialog_Address(true, 'orgElementId', 'orgElementName', ';', null,afterAddress);">
				<bean:message key="dialog.selectOrg"/>
			</a>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title">
			<bean:message bundle="kms-log" key="kmsLogApp.fdCreateTime"/>：
		</td><td width="88%"><div style="display: inline-block">
				<input name="startTime" value="${kmsLogAppForm.startTime}" type="text" class="inputsgl" subject="开始日期" style="width:130px" validate="__date" onclick="selectDate('startTime')" value=""/>
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
	<table id="List_ViewTable" style="word-break : break-all;">
		<tr>
			<td width="10pt">
				<input type="checkbox" name="List_Tongle">
			</td>
			<td width="40pt">
				<bean:message key="page.serial"/>
			</td>
			<td width="12%">
				<bean:message bundle="kms-log" key="kmsLogApp.fdCreateTime"/>
			</td>
			<td width="8%">
				<bean:message bundle="kms-log" key="kmsLogApp.fdOperator"/>
			</td>
			<td width="5%">
				<bean:message bundle="kms-log" key="kmsLogApp.fdOprateMethod"/>
			</td>
			<td width="10%">
				<bean:message bundle="kms-log" key="kmsLogApp.modelName"/>
			</td>
			<td width="10%">
				<bean:message bundle="kms-log" key="kmsLogApp.fdIp"/>
			</td>
			<td width="20%">
				<bean:message bundle="kms-log" key="kmsLogApp.fdSubject"/>
			</td>
			<td width="30%">
				<bean:message bundle="kms-log" key="kmsLogApp.fdTargetId"/>
			</td>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsLogApp" varStatus="vstatus">
			<tr>
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsLogApp.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<kmss:showDate value="${kmsLogApp.fdCreateTime}" />
				</td>
				<td>
					<c:out value="${kmsLogApp.fdOperatorName}" />
				</td>
				<td>
					<c:out value="${kmsLogApp.operateText}" />
				</td>
				<td>
					<c:out value="${kmsLogApp.moduleName}" />
				</td>
				<td>
					<c:out value="${kmsLogApp.fdIp}" />
				</td>
				<td>
					<c:out value="${kmsLogApp.fdSubject}" />
				</td>
				<td>
					<c:out value="${kmsLogApp.fdTargetId}" />
				</td>
			</tr>
		</c:forEach>
	</table>
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
function _submit(){
	var startDateValue = document.getElementsByName('startTime')[0].value;
	var endDateValue = document.getElementsByName('endTime')[0].value; 
	var orgElementId = document.getElementsByName('orgElementId')[0].value; 
	var orgElementName = document.getElementsByName('orgElementName')[0].value; 

	if(orgElementId!=null && orgElementId.length>32){
		alert('<bean:message bundle="kms-log" key="kmsLogApp.select.personal"/>');
		return false ;
	}

	var url  = Com_CopyParameter(Com_Parameter.ContextPath+"kms/log/kms_log_app/kmsLogApp.do?method=list");
	url = Com_SetUrlParameter(url, "startDate", startDateValue);
	url = Com_SetUrlParameter(url, "endDate", endDateValue);
	url = Com_SetUrlParameter(url, "orgElementId", orgElementId);
	url = Com_SetUrlParameter(url, "orgElementName", orgElementName);
	url = Com_SetUrlParameter(url, "pageno", 1);
	window.location.href=url;
}

function afterAddress(rtnVal){
	var fdCreatorId = document.getElementsByName("orgElementId")[0].value ;
	if(fdCreatorId.length > 32){
		document.getElementsByName("orgElementId")[0].value="" ;
		document.getElementsByName("orgElementName")[0].value="" ;
		alert('<bean:message bundle="kms-log" key="kmsLogApp.select.personal"/>');
		return false ;
	}
}
</script>
<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>