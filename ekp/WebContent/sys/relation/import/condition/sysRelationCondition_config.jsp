<%@page import="com.landray.kmss.sys.relation.util.SysRelationExtendPluginUtil"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.landray.kmss.sys.relation.web.RelationConditionUtil"%>
<%@page import="com.landray.kmss.sys.relation.web.RelationCondition"%>
<template:include ref="default.dialog">
	<template:replace name="content"> 
		<script type="text/javascript" >
			Com_IncludeFile("jquery.js|dialog.js|calendar.js", null, "js");
			Com_IncludeFile("rela_condition_cfg.js","${KMSS_Parameter_ContextPath}sys/relation/import/resource/","js",true);
		</script>
		<script type="text/javascript">
			new RelationConditionCfgSetting({'varName':'rela_opt'});
		</script>
		<div class="rela_scope"></div>
		<div class="rela_config_subset">
			<table width=100% class="tb_simple" id="rela_condition">
				<c:forEach items="${relationEntry.conditions}" var="condition" varStatus="vStatus">
					<c:set var="entryIndex" value="${vStatus.index}"/>
					<tr kmss_type="${condition.type}" <c:if test="${entryIndex >= 20}">style="display:none;"</c:if> >
						<td width="20%" valign="top">
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
										beginText="<label>" 
										endText="</label>" 
										property="fdParameter1_${entryIndex}" />
								</c:when>
								
								<c:when test="${condition.type=='string' and (empty condition.property.enumValues)}">
									<input name="fdParameter1_${entryIndex}" style="width:90%" class="inputsgl">
								</c:when>
								<c:when test="${condition.type=='number' and (empty condition.property.enumValues)}">
									<select name="fdParameter1_${entryIndex}" onchange="rela_opt.refreshLogicDisplay(this, 'span_fdParameter3_${entryIndex}');">
										<option value="eq"><bean:message bundle="sys-relation" key="relation.logic.number.eq" /></option>
										<option value="lt"><bean:message bundle="sys-relation" key="relation.logic.number.lt" /></option>
										<option value="le"><bean:message bundle="sys-relation" key="relation.logic.number.le" /></option>
										<option value="gt"><bean:message bundle="sys-relation" key="relation.logic.number.gt" /></option>
										<option value="ge"><bean:message bundle="sys-relation" key="relation.logic.number.ge" /></option>
										<option value="bt"><bean:message bundle="sys-relation" key="relation.logic.number.bt" /></option>
									</select>
									<input name="fdParameter2_${entryIndex}" class="inputsgl" style="width:22%">
									<span id="span_fdParameter3_${entryIndex}" style="display:none">&nbsp;&nbsp;&nbsp;<bean:message bundle="sys-relation" key="relation.logic.middleStr" />
									<input name="fdParameter3_${entryIndex}" class="inputsgl" style="width:22%">
									&nbsp;&nbsp;&nbsp;<bean:message bundle="sys-relation" key="relation.logic.rightStr" /></span>
								</c:when>
								<c:when test="${condition.type=='date'}">
									<select name="fdParameter1_${entryIndex}" style="vertical-align: top;"
										onchange="rela_opt.refreshLogicDisplay(this, 'span_fdParameter3_${entryIndex}');">
										<option value="eq"><bean:message bundle="sys-relation" key="relation.logic.date.eq" /></option>
										<option value="lt"><bean:message bundle="sys-relation" key="relation.logic.date.lt" /></option>
										<option value="le"><bean:message bundle="sys-relation" key="relation.logic.date.le" /></option>
										<option value="gt"><bean:message bundle="sys-relation" key="relation.logic.date.gt" /></option>
										<option value="ge"><bean:message bundle="sys-relation" key="relation.logic.date.ge" /></option>
										<option value="bt"><bean:message bundle="sys-relation" key="relation.logic.date.bt" /></option>
									</select>
									<xform:datetime property="fdParameter2_${entryIndex}" dateTimeType="date" showStatus="edit" style="width:22%">
									</xform:datetime>
									<span id="span_fdParameter3_${entryIndex}" style="display:none">&nbsp;&nbsp;&nbsp;
										<bean:message bundle="sys-relation" key="relation.logic.middleStr" />
										<xform:datetime property="fdParameter3_${entryIndex}" dateTimeType="date" showStatus="edit" style="width:22%">
										</xform:datetime>
										&nbsp;&nbsp;&nbsp;<bean:message bundle="sys-relation" key="relation.logic.rightStr" />
									</span>
								</c:when>
								<c:when test="${condition.type=='foreign'}">
									<table class="tb_simple" width="100%" rela_Detail="1">
										<tr>
											<c:if test="${condition.name ne 'docKeyword' }">
												<td style="padding: 0px;">
												<%
													RelationCondition condition = (RelationCondition) pageContext.getAttribute("condition");
													if (condition.getProperty().getDialogJS() != null) {
														String entryIndex = pageContext
																.getAttribute("entryIndex")
																.toString();
														String dialogJs = condition
																.getDialogJS(
																		new com.landray.kmss.common.actions.RequestContext(
																				request),
																		"fdParameter1_"
																				+ entryIndex,
																		"t0_"
																				+ entryIndex);
														pageContext.setAttribute("dialogScript",dialogJs);
												%> 
													<%@include file="/sys/relation/import/condition/sysRelationCondition_property.jsp" %>
												
													<xform:dialog style="width:90%;" showStatus="edit" dialogJs="${dialogScript}"
														propertyId="fdParameter1_${entryIndex}" propertyName="t0_${entryIndex}" >
													</xform:dialog>
													
											        <c:if test="${condition.treeModel}">
														<br><label><input name="t1_${entryIndex}" type="checkbox">
														<bean:message bundle="sys-relation" key="relation.includeChild"/>
														</label>
													</c:if>
													<%	} %>
												</td>
												<td style="display:none">
													<input name="fdParameter2_${entryIndex}" style="width:90%;" class="inputsgl"/>
												</td>
											</c:if>
											<c:if test="${condition.name eq 'docKeyword' }">
												<td style="display:none" style="padding: 0px;">
						        					<input type="hidden" name="fdParameter1_${entryIndex}" />
						        					<input type="hidden" name="t0_${entryIndex}" />
												</td>
												<td>
													<input name="fdParameter2_${entryIndex}" style="width:90%;" class="inputsgl"/>
												</td>
											</c:if>
										</tr>
									</table>
								</c:when>
								<c:when test="${condition.type=='enum'}">
									<sunbor:multiSelectCheckbox beginText="<label>" endText="</label>" 
									enumsType="${condition.enumsType}" assignProperty="true" property="fdParameter1_${entryIndex}" />
								</c:when>
							</c:choose>
						</td>
						<td style="display:none">
						<div id="tipDiv_${entryIndex}"><bean:message bundle="sys-relation" key="relation.word.relationChebox.Tip"/></div>
						</td>
						<c:if test="${param.currModelName!=''}">
							<td width="50px">
								<c:forEach items="${currModelProps}" var="prop" varStatus="vs">
									<c:if test="${prop==condition.name }">
									<label>
										<input name="fdVarName_${entryIndex}" value="${prop}" type="checkbox" onclick="rela_opt.refreshRelationDisplay(${entryIndex});"><bean:message bundle="sys-relation" key="relation.word.rela"/>
									</label>
									</c:if>						
								</c:forEach>
							</td>
						</c:if>
						<c:if test="${condition.type!='foreign'}">
							<td width="80px">
								<input name="fdBlurSearch_${entryIndex}" disabled="true" checked=true type="checkbox" value="1" onclick="rela_opt.refreshMatchDisplay(${entryIndex});">
								<bean:message bundle="sys-relation" key="relation.blurSearch"/>
							</td>
						</c:if>
						<c:if test="${condition.type=='foreign'}">
							<td width="80px">
								<label>
								<input name="fdBlurSearch_${entryIndex}" type="checkbox" value="1" onclick="rela_opt.refreshMatchDisplay(${entryIndex});">
								<bean:message bundle="sys-relation" key="relation.blurSearch"/>
								</label>
							</td>
						</c:if>
					</tr>
				</c:forEach>
				<tr><td colspan="5" align="center">
					<p id="viewAllP" style="display:none"><a onclick="viewAllConditions();"><span style="cursor:pointer"><img src="${KMSS_Parameter_StylePath}icons/collapse.gif" height="15px"><bean:message bundle="sys-relation" key="sysRelationForeignParam.showAll" /></span></a></p>
				</td></tr>
				<tr><td colspan="5" align="center" class="rela_scope_button">
					<ui:button text="${lfn:message('button.ok')}" id="rela_config_save"></ui:button>
					&nbsp;&nbsp;&nbsp;
					<ui:button styleClass="lui_toolbar_btn_gray"  text="${lfn:message('button.cancel')}" id="rela_config_close"></ui:button>
					&nbsp;&nbsp;&nbsp;
					<ui:button text="${lfn:message('sys-relation:button.preview.setting')}" id="rela_config_preview"></ui:button>
				</td></tr>
			</table>
		</div>
	</template:replace>
</template:include>

