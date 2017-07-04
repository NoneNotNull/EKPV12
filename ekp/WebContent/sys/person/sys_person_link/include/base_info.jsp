<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
				<tr>
					<td class="td_normal_title">
						<bean:message bundle="sys-person" key="sysPersonSysNavCategory.fdName"/>
					</td>
					<td colspan="3">
						<c:set var="_showStatus" value="${param.readOnly eq 'true' ? 'view' : 'edit'}" />
						<xform:text property="fdName" style="width:90%" showStatus="${_showStatus }" htmlElementProperties="maxlength='150'" required="true" subject="${lfn:message('sys-person:sysPersonSysNavCategory.fdName') }" />
						<xform:text property="fdType" showStatus="noShow" />
					</td>
				</tr>
				<c:if test="${param.shortName eq 'true'}">
				<tr>
					<td class="td_normal_title">
						<bean:message bundle="sys-person" key="sysPersonSysNavCategory.fdShortName"/>
					</td>
					<td colspan="3">
						<xform:text property="fdShortName" style="width:65%" showStatus="${_showStatus }" htmlElementProperties="maxlength='150'" required="false" subject="${lfn:message('sys-person:sysPersonSysNavCategory.fdShortName') }" />
					</td>
				</tr>
				</c:if>
				<tr>
					<td class="td_normal_title">
						<bean:message bundle="sys-person" key="sysPersonSysNavCategory.fdStatus"/>
					</td>
					<td <c:if test="${param.linkType != 'hotlink' and param.linkType != 'shortcut' and param.mng != 'true'}">colspan="3"</c:if>>
						<xform:select property="fdStatus" required="true" showPleaseSelect="false">
							<xform:enumsDataSource enumsType="sysPerson_fdStatus" />
						</xform:select>
					</td>
					<c:if test="${param.mng eq 'true' }">
					<td class="td_normal_title">
						<bean:message bundle="sys-person" key="sysPersonSysNavCategory.fdOrder"/>
					</td>
					<td>
						<xform:text property="fdOrder" style="width:60px" htmlElementProperties="maxlength='10'" />
					</td>
					</c:if>
					<c:if test="${param.linkType eq 'hotlink' or param.linkType eq 'shortcut' }">
					<td class="td_normal_title" rowspan="2">
						<bean:message bundle="sys-person" key="sysPersonSysNavCategory.example"/>
					</td>
					<td rowspan="2">
						<c:if test="${param.linkType eq 'shortcut' }">
							<img src="<c:url value="/sys/ui/extend/dataview/render/help/picmenu-portlet.jpg"/>" style="max-height:60px;">
						</c:if>
						<c:if test="${param.linkType eq 'hotlink' }">
							<img src="<c:url value="/sys/ui/extend/dataview/render/help/textmenu.jpg"/>" style="max-height:60px;">
						</c:if>
					</tr>
					</c:if>
				</tr>
				<c:if test="${param.linkType eq 'hotlink' or param.linkType eq 'shortcut' }">
				<tr>
					<td class="td_normal_title">
						<bean:message bundle="sys-person" key="sysPersonSysNavCategory.fdTarget"/>
					</td>
					<td>
						<xform:select property="fdTarget" required="true" showPleaseSelect="false">
							<xform:enumsDataSource enumsType="sysPerson_urlTarget" />
						</xform:select>
					</td>
				</c:if>
