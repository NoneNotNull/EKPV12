<%@ page language="java" contentType="text/html; charset=UTF-8"	
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:forEach items="${foreignModule.fdRelationParams}" var="foreignParam" varStatus="varStatus">
		<c:set var="foreignEntryIndex" value="${varStatus.index}" />
		<tr kmss_type="${foreignParam.fdParamType}">
			<td width="15%" valign="top" class="td_normal_title">
				${foreignParam.fdParamName}
				<input type="hidden" name="fdItemName_${foreignEntryIndex}" value="${foreignParam.fdParam}">
			</td>
			<td>
				<c:choose>
					<c:when test="${foreignParam.fdParamType=='string'}">
						<input name="fdParameter1_${foreignEntryIndex}" style="width:90%" class="inputSgl">
					</c:when>
					<c:when test="${foreignParam.fdParamType=='number'}">
						<select name="fdParameter1_${foreignEntryIndex}" onchange="refreshLogicDisplay(this, 'span_fdParameter3_${foreignEntryIndex}');">
							<option value="eq"><bean:message bundle="sys-relation" key="relation.logic.number.eq" /></option>
							<option value="lt"><bean:message bundle="sys-relation" key="relation.logic.number.lt" /></option>
							<option value="le"><bean:message bundle="sys-relation" key="relation.logic.number.le" /></option>
							<option value="gt"><bean:message bundle="sys-relation" key="relation.logic.number.gt" /></option>
							<option value="ge"><bean:message bundle="sys-relation" key="relation.logic.number.ge" /></option>
							<option value="bt"><bean:message bundle="sys-relation" key="relation.logic.number.bt" /></option>
						</select>
						<input name="fdParameter2_${foreignEntryIndex}" class="inputSgl" style="width:22%">
						<span id="span_fdParameter3_${foreignEntryIndex}" style="display:none">&nbsp;&nbsp;&nbsp;<bean:message bundle="sys-relation" key="relation.logic.middleStr" />
						<input name="fdParameter3_${foreignEntryIndex}" class="inputSgl" style="width:22%">
						&nbsp;&nbsp;&nbsp;<bean:message bundle="sys-relation" key="relation.logic.rightStr" /></span>
					</c:when>
					<c:when test="${foreignParam.fdParamType=='date'}">
						<select name="fdParameter1_${foreignEntryIndex}" onchange="refreshLogicDisplay(this, 'span_fdParameter3_${foreignEntryIndex}');">
							<option value="eq"><bean:message bundle="sys-relation" key="relation.logic.date.eq" /></option>
							<option value="lt"><bean:message bundle="sys-relation" key="relation.logic.date.lt" /></option>
							<option value="le"><bean:message bundle="sys-relation" key="relation.logic.date.le" /></option>
							<option value="gt"><bean:message bundle="sys-relation" key="relation.logic.date.gt" /></option>
							<option value="ge"><bean:message bundle="sys-relation" key="relation.logic.date.ge" /></option>
							<option value="bt"><bean:message bundle="sys-relation" key="relation.logic.date.bt" /></option>
						</select>
						<input name="fdParameter2_${foreignEntryIndex}" class="inputSgl" style="width:22%"><a href="#" onclick="selectDate('fdParameter2_${foreignEntryIndex}');"><bean:message key="dialog.selectTime" /></a>
						<span id="span_fdParameter3_${foreignEntryIndex}" style="display:none">&nbsp;&nbsp;&nbsp;<bean:message bundle="sys-relation" key="relation.logic.middleStr" />
						<input name="fdParameter3_${foreignEntryIndex}" class="inputSgl" style="width:22%"><a href="#" onclick="selectDate('fdParameter3_${foreignEntryIndex}');"><bean:message key="dialog.selectTime" /></a>
						&nbsp;&nbsp;&nbsp;<bean:message bundle="sys-relation" key="relation.logic.rightStr" /></span>
					</c:when>					
				</c:choose>
			</td>
		</tr>
</c:forEach>
