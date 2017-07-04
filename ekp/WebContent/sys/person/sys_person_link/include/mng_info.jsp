<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="navForm" value="${requestScope[param.formName] }" scope="page" />
				<tr>
					<td class="td_normal_title">
						<bean:message bundle="sys-person" key="sysPersonSysNavCategory.pushTo"/>
					</td>
					<td colspan="3">
						<div>
							<xform:radio property="fdPushType" onValueChange="switchSelectPushType();">
								<xform:enumsDataSource enumsType="sysPerson_fdPushType" />
							</xform:radio>
						</div>
						<div id="pushElementsSeletor" style="padding-top:8px; <c:if test="${navForm.fdPushType != '3'}" >display:none;</c:if>">
						<xform:address orgType="ORG_TYPE_ALL" propertyId="fdPushElementIds" propertyName="fdPushElementNames"
							textarea="true" style="width:100%" mulSelect="true" />
						</div>
						
						<script>
							function switchSelectPushType() {
								var type = $('[name="fdPushType"]:checked').val();
								if (type == '3') {
									$('#pushElementsSeletor').show();
								} else {
									$('#pushElementsSeletor').hide();
								}
							}
						</script>
					</td>
				</tr>
				<tr>
					<td class="td_normal_title">
						<bean:message bundle="sys-person" key="sysPersonSysNavCategory.authEditors"/>
					</td>
					<td colspan="3">
						<xform:address propertyId="authEditorIds" propertyName="authEditorNames"
							textarea="true" style="width:100%" mulSelect="true" />
					</td>
				</tr>
