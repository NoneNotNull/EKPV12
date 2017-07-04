<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<script>
	Com_IncludeFile("dialog.js|calendar.js");
</script>
<script>
	function listFilterChange(){
		var thisUrl = window.location.href;
		var url  = Com_CopyParameter(Com_Parameter.ContextPath+"kms/common/kms_common_recycle_log/kmsCommonRecycleLog.do?method=list");
		var _type = document.getElementsByName("fdOperateName");
		//操作类型
		if(_type != '' || _type != null) {
			for(var i = 0; i < _type.length; i++) {
				if(_type[i].checked == true){
					//操作类型
					url = Com_SetUrlParameter(url, "type", _type[i].value);
					break;
				}
			}
		}
		//操作者
		var _operatorId = document.getElementById("operatorIds").value;
		url = Com_SetUrlParameter(url, "operators", _operatorId);
		var _operatorName = document.getElementById("operatorNames").value;
		url = Com_SetUrlParameter(url, "operatorNames", _operatorName);
		//操作时间
		var _startTime = document.getElementsByName("startTime")[0].value;
		url = Com_SetUrlParameter(url, "startTime", _startTime);
		var _endTime = document.getElementsByName("endTime")[0].value;
		url = Com_SetUrlParameter(url, "endTime", _endTime);
		setTimeout(function() {
					window.location.href = url;
			       },1);
	}
	function resetRadio() {
		var url = location.href.toString();
		var _type = Com_GetUrlParameter(url, "type");
		var fields = document.getElementsByName("fdOperateName");
		if(_type != '' || _type != null) {
			for(var i = 0; i < fields.length; i++) {
				if(fields[i].value == _type){
					fields[i].checked = true;
					break;
				}
			}
		}
	}
	
	function resetPerson() {
		var url = location.href.toString();
		var _personIds = Com_GetUrlParameter(url, "operators");
		var _personNames = Com_GetUrlParameter(url, "operatorNames");
		if(_personIds != '' && _personIds != null){
			var personIds = document.getElementById("operatorIds");
			personIds.value = _personIds;
			var personNames = document.getElementById("operatorNames");
			personNames.value = _personNames;
		}
	}
	
	function resetTime() {
		var url = location.href.toString();
		var _startTime = Com_GetUrlParameter(url, "startTime");
		var _endTime = Com_GetUrlParameter(url, "endTime");
		if(_startTime != '' && _startTime != null){
			var startTime = document.getElementsByName("startTime")[0];
			startTime.value = _startTime;
		}
		if(_endTime != '' && _endTime != null){
			var endTime = document.getElementsByName("endTime")[0];
			endTime.value = _endTime;
		}
	}
	function resetForm() {
		resetRadio();
		resetPerson();
		resetTime();
	}
	
	Com_AddEventListener(window, "load", function() {resetForm();});
</script>
<html:form action="/kms/common/kms_common_recycle_log/kmsCommonRecycleLog.do">
	<!-- 按条件筛选日志 -->
	<table width="100%">
		<tr>
			<td align="left" width="25%">
				<xform:radio property="fdOperateName" showStatus="edit"  onValueChange="listFilterChange"> 
					<xform:enumsDataSource enumsType="kms_common_recycle_log_fd_operate_name"/>
				</xform:radio>
			</td>
			<td align="left" width="45%">操作者 
				<input type="hidden" name="operatorId" id="operatorIds"/>
			    <input type="text" name="operatorName" id="operatorNames" style="width: 75%" class="inputsgl" readonly="true" />
				<a href="#" onclick="Dialog_Address(true, 'operatorId','operatorName', ';', ORG_TYPE_PERSON,listFilterChange);">
				<span><bean:message key="dialog.selectOrg" /></span></a>
		   </td >
		   <td align="left">日期
		   	<!-- 开始日期 -->
		   	<input type="text" readonly="true" class="inputsgl" name="startTime" style="width: 25%;">
			<a href="#" onclick="selectDate('startTime',null,listFilterChange);"> <bean:message
				key="dialog.selectTime" /></a>
			<span>-</span>
			<!-- 结束日期 -->
			<input type="text" readonly="true" class="inputsgl" name="endTime" style="width: 25%;">
			<a href="#" onclick="selectDate('endTime',null,listFilterChange);"> <bean:message
				key="dialog.selectTime" /></a>
		   </td>
		</tr>
	</table>
	<div id="optBarDiv">
		<kmss:auth requestURL="/kms/common/kms_common_recycle_log/kmsCommonRecycleLog.do?method=deleteall">
			<input type="button" value="<bean:message key="button.delete"/>"
				onclick="if(!List_ConfirmDel())return;Com_Submit(document.kmsCommonRecycleLogForm, 'deleteall');">
		</kmss:auth>
	</div>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="10pt">
					<input type="checkbox" name="List_Tongle">
				</td>
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<sunbor:column property="kmsCommonRecycleLog.fdOperateName">
					<bean:message bundle="kms-common" key="kmsCommonRecycleLog.fdOperateName"/>
				</sunbor:column>
				<sunbor:column property="kmsCommonRecycleLog.operateDocSubject">
					<bean:message bundle="kms-common" key="kmsCommonRecycleLog.operateDocSubject"/>
				</sunbor:column>
				<sunbor:column property="kmsCommonRecycleLog.fdOperateTime">
					<bean:message bundle="kms-common" key="kmsCommonRecycleLog.fdOperateTime"/>
				</sunbor:column>
				<sunbor:column property="kmsCommonRecycleLog.fdOperator.fdName">
					<bean:message bundle="kms-common" key="kmsCommonRecycleLog.fdOperator"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="kmsCommonRecycleLog" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/kms/common/kms_common_recycle_log/kmsCommonRecycleLog.do" />?method=view&fdId=${kmsCommonRecycleLog.fdId}">
				<td>
					<input type="checkbox" name="List_Selected" value="${kmsCommonRecycleLog.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<xform:select value="${kmsCommonRecycleLog.fdOperateName}" 
								   property="fdOperateName" showStatus="view">
						<xform:enumsDataSource enumsType="kms_common_recycle_log_fd_operate_name" />
					</xform:select>
				</td>
				<td>
					<c:out value="${kmsCommonRecycleLog.operateDocSubject }"/>
				</td>
				<td>
					<kmss:showDate value="${kmsCommonRecycleLog.fdOperateTime}" />
				</td>
				<td>
					<c:out value="${kmsCommonRecycleLog.fdOperator.fdName}" />
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>