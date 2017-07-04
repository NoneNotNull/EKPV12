<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.relation.web.RelationCondition" %>
<%@ page import="com.landray.kmss.sys.relation.web.RelationConditionUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%> 
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ include file="sysRelationCondition_select_script.jsp"%>
<center>
<div id="div_conditionCon">
<form name="conditionForm">
<table width=100% class="tb_normal" cellpadding="0px" cellspacing="0px" id="TB_Condition">
	<c:forEach items="${relationEntry.conditions}" var="condition" varStatus="vStatus">
		<c:set var="entryIndex" value="${vStatus.index}" />
		<tr kmss_type="${condition.type}" <c:if test="${entryIndex >= 20}">style="display:none;"</c:if> >
			<td width="15%" valign="top" class="td_normal_title">
				<c:if test="${not empty condition.messageKey}">
					<kmss:message key="${condition.messageKey}" />
				</c:if>
				<c:if test="${empty condition.messageKey}">
					${condition.property.label}
				</c:if>
				<input type="hidden" name="fdItemName_${entryIndex}" value="${condition.name}">
			</td>
			<td>				
				<c:choose>
					<c:when test="${(condition.type=='string' or condition.type=='number') and (not empty condition.property.enumValues)}">
						<%
							RelationCondition condition = (RelationCondition)pageContext.getAttribute("condition");
							RelationConditionUtil.setEnumPropertyValue(pageContext);
							RelationConditionUtil.setPropertyEnumValues(condition.getProperty(), pageContext);
						%>
						<sunbor:multiSelectCheckbox 
							beanLabelProperty="label"
							beanValueProperty="value"
							avalables="${avalables}" 
							assignProperty="true" 
							propertyValue="${v0}" 
							property="fdParameter1_${entryIndex}" />
						
						<%--<input name="fdParameter1_${entryIndex}" style="width:90%" class="inputSgl">--%>
					</c:when>
					
					<c:when test="${condition.type=='string' and (empty condition.property.enumValues)}">
						<input name="fdParameter1_${entryIndex}" style="width:90%" class="inputSgl">
						<%--<c:if test="${empty condition.property.dialogJS}">
							<input name="fdParameter1_${entryIndex}" style="width:90%" class="inputSgl" >
						</c:if>
						<c:if test="${not empty condition.property.dialogJS}">
							<input type="hidden" name="fdParameter1_${entryIndex}" />
		        			<input name="t0_${entryIndex}" readonly class="inputsgl" style="width=90%;"/>
							<%
								RelationCondition condition = (RelationCondition)pageContext.getAttribute("condition");
								String entryIndex = pageContext.getAttribute("entryIndex").toString();
								pageContext.setAttribute("dialogScript", condition.getDialogJS(new com.landray.kmss.common.actions.RequestContext(request),"fdParameter1_"+entryIndex,"t0_"+entryIndex));
							%>
					        <a onclick="${dialogScript}" href="#"><bean:message key="button.select" /></a>
						</c:if>--%>
					</c:when>
					
					<c:when test="${condition.type=='number' and (empty condition.property.enumValues)}">
						<select name="fdParameter1_${entryIndex}" onchange="refreshLogicDisplay(this, 'span_fdParameter3_${entryIndex}');">
							<option value="eq"><bean:message bundle="sys-relation" key="relation.logic.number.eq" /></option>
							<option value="lt"><bean:message bundle="sys-relation" key="relation.logic.number.lt" /></option>
							<option value="le"><bean:message bundle="sys-relation" key="relation.logic.number.le" /></option>
							<option value="gt"><bean:message bundle="sys-relation" key="relation.logic.number.gt" /></option>
							<option value="ge"><bean:message bundle="sys-relation" key="relation.logic.number.ge" /></option>
							<option value="bt"><bean:message bundle="sys-relation" key="relation.logic.number.bt" /></option>
						</select>
						<input name="fdParameter2_${entryIndex}" class="inputSgl" style="width:22%">
						<span id="span_fdParameter3_${entryIndex}" style="display:none">&nbsp;&nbsp;&nbsp;<bean:message bundle="sys-relation" key="relation.logic.middleStr" />
						<input name="fdParameter3_${entryIndex}" class="inputSgl" style="width:22%">
						&nbsp;&nbsp;&nbsp;<bean:message bundle="sys-relation" key="relation.logic.rightStr" /></span>
					</c:when>
					<c:when test="${condition.type=='date'}">
						<select name="fdParameter1_${entryIndex}" onchange="refreshLogicDisplay(this, 'span_fdParameter3_${entryIndex}');">
							<option value="eq"><bean:message bundle="sys-relation" key="relation.logic.date.eq" /></option>
							<option value="lt"><bean:message bundle="sys-relation" key="relation.logic.date.lt" /></option>
							<option value="le"><bean:message bundle="sys-relation" key="relation.logic.date.le" /></option>
							<option value="gt"><bean:message bundle="sys-relation" key="relation.logic.date.gt" /></option>
							<option value="ge"><bean:message bundle="sys-relation" key="relation.logic.date.ge" /></option>
							<option value="bt"><bean:message bundle="sys-relation" key="relation.logic.date.bt" /></option>
						</select>
						<input name="fdParameter2_${entryIndex}" class="inputSgl" style="width:22%"><a href="#" onclick="selectDate('fdParameter2_${entryIndex}');"><bean:message key="dialog.selectTime" /></a>
						<span id="span_fdParameter3_${entryIndex}" style="display:none">&nbsp;&nbsp;&nbsp;<bean:message bundle="sys-relation" key="relation.logic.middleStr" />
						<input name="fdParameter3_${entryIndex}" class="inputSgl" style="width:22%"><a href="#" onclick="selectDate('fdParameter3_${entryIndex}');"><bean:message key="dialog.selectTime" /></a>
						&nbsp;&nbsp;&nbsp;<bean:message bundle="sys-relation" key="relation.logic.rightStr" /></span>
					</c:when>
					<c:when test="${condition.type=='foreign'}">
						<table class="tb_noborder" width="100%">
							<tr>
							
<c:if test="${condition.name ne 'docKeyword' }">
								<td>
		        					<input type="hidden" name="fdParameter1_${entryIndex}" />
		        					<input name="t0_${entryIndex}" readonly class="inputsgl" style="width=90%;"/>
<%
	RelationCondition condition = (RelationCondition)pageContext.getAttribute("condition");
	if(condition.getProperty().getDialogJS()!=null){
		String entryIndex = pageContext.getAttribute("entryIndex").toString();
		pageContext.setAttribute("dialogScript", condition.getDialogJS(new com.landray.kmss.common.actions.RequestContext(request),"fdParameter1_"+entryIndex,"t0_"+entryIndex));
%>
							        <a onclick="${dialogScript}" href="#"><bean:message key="button.select" /></a>
							        <c:if test="${condition.treeModel}">
										<br><input name="t1_${entryIndex}" type="checkbox">
										<bean:message bundle="sys-relation" key="relation.includeChild"/>
									</c:if>
<%	} %>

								</td>
								<td style="display:none">
									<input name="fdParameter2_${entryIndex}" style="width=90%;" class="inputSgl"/>
								</td>
</c:if>
<c:if test="${condition.name eq 'docKeyword' }">
								<td>
		        					<input type="hidden" name="fdParameter1_${entryIndex}" />
		        					<input type="hidden" name="t0_${entryIndex}" />
								</td>
								<td>
									<input name="fdParameter2_${entryIndex}" style="width=90%;" class="inputSgl"/>
								</td>
</c:if>

							</tr>
						</table>
					</c:when>
					<c:when test="${condition.type=='enum'}">
						<sunbor:multiSelectCheckbox enumsType="${condition.enumsType}" assignProperty="true" property="fdParameter1_${entryIndex}" />
					</c:when>
				</c:choose>
			</td>
			<td style="display:none"><div id="tipDiv_${entryIndex}"><bean:message bundle="sys-relation" key="relation.word.relationChebox.Tip"/></div></td>
			<c:if test="${param.currModelName!=''}">
				<td width="50px">
					<c:forEach items="${currModelProps}" var="prop" varStatus="vs">
						<c:if test="${prop==condition.name }">
						<input name="fdVarName_${entryIndex}" value="${prop}" type="checkbox" onclick="refreshRelationDisplay(${entryIndex});"><bean:message bundle="sys-relation" key="relation.word.rela"/>
						</c:if>						
					</c:forEach>
				</td>
			</c:if>
			<c:if test="${ condition.type!='foreign'}">
				<td width="80px">
					<input name="fdBlurSearch_${entryIndex}" disabled="true" checked=true type="checkbox" value="1" onclick="refreshMatchDisplay(${entryIndex});">
					<bean:message bundle="sys-relation" key="relation.blurSearch"/>
				</td>
			</c:if>
			<c:if test="${ condition.type=='foreign'}">
				<td width="80px">
					<input name="fdBlurSearch_${entryIndex}" type="checkbox" value="1" onclick="refreshMatchDisplay(${entryIndex});">
					<bean:message bundle="sys-relation" key="relation.blurSearch"/>
				</td>
			</c:if>
		</tr>
	</c:forEach>
	<%-- 
	<c:if test="${fn:length(relationEntry.conditions)>0}">
		<tr>
			<td width="15%" class="td_normal_title">
				<bean:message bundle="sys-relation" key="sysRelationEntry.fdOrderBy" />
			</td>
			<td colspan="3">
				<select name="fdOrderBy_">
					<c:forEach items="${relationEntry.conditions}" var="condition" varStatus="vStatus">
						<c:if test="${condition.conditionClassName!='SysDictListProperty'}">
						<option value="${condition.name}">
							<bean:message bundle="sys-relation" key="relation.word.an" />
							<kmss:message key="${condition.messageKey}" />
						</option>
						</c:if>
					</c:forEach>
				</select>
			</td>
		</tr>
	</c:if>
	<tr>
		<td width="15%" class="td_normal_title">
			<bean:message bundle="sys-relation" key="sysRelationEntry.fdPageSize" />
		</td>
		<td colspan="3">
			<select name="fdPageSize_">
				<option value="10">10</option>
				<option value="15">15</option>
				<option value="20">20</option>
				<option value="50">50</option>
			</select>
		</td>
	</tr>
	 --%>
	<%--外部关联模块条件 --%>
	<%@ include file="/sys/relation/sys_relation_foreign_module/sysRelationForeignCondition_select.jsp"%>
</table>

<%-- 显示全部 --%>
<c:if test="${not empty foreignModule.fdRelationParams }">
	<p id="viewAllP"><a onclick="viewAllConditions();"><span style="cursor:pointer"><img src="${KMSS_Parameter_StylePath}icons/collapse.gif" height="15px"><bean:message bundle="sys-relation" key="sysRelationForeignParam.showAll" /></span></a></p>
</c:if>
<%--
外部关联模块扩展页面
扩展页面需要实现以下2个js函数：
获取自定义数据：config_getThirdRelationConfig(){};
初始化数据：config_iniThirdRelationConfig(xxx){};
--%>
<c:if test="${not empty requestScope.searchJsp}">
	<iframe id="sysRelationExtendCondition" src="<c:url value='${requestScope.searchJsp}' />" frameborder="0" scrolling="no" width="100%"></iframe>
</c:if>
<br /><br />
<input type="button" class="btnopt" value="<bean:message key="button.ok"/>" onclick="doOK();" />
&nbsp;&nbsp;&nbsp;&nbsp;
<input type="reset" class="btnopt" value="<bean:message key="button.close" />" onclick="Com_CloseWindow();" />
</form>
</div>
</center>
<%@ include file="/resource/jsp/edit_down.jsp"%>