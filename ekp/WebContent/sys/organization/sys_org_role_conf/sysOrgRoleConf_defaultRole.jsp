<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>

<%@page import="com.landray.kmss.sys.organization.forms.SysOrgRoleLineDefaultRoleForm"%><html:form action="/sys/organization/sys_org_role_conf/sysOrgRoleConf.do">
<div id="optBarDiv">
	<input type=button value="<bean:message key="button.update"/>"
		onclick="Com_Submit(document.sysOrgRoleConfForm, 'updateRepeatRole');">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message  bundle="sys-organization" key="sysOrgRoleConf.repeat.check"/></p>
<center>
<table class="tb_normal" width="600px">
	<c:if test="${empty (sysOrgRoleConfForm.defaultRoleList)}">
		<tr>
			<td class="td_normal_title">
				<bean:message  bundle="sys-organization" key="sysOrgRoleConf.repeat.check.ok"/>
			</td>
		</tr>
	</c:if>
	<c:if test="${not empty (sysOrgRoleConfForm.defaultRoleList)}">
		<tr>
			<td class="td_normal_title">
				<bean:message  bundle="sys-organization" key="sysOrgRoleConf.repeat.check.prompt"/>
			</td>
		</tr>
		<tr>
			<td>
				<table width="100%" class="tb_normal" id="mainTable">
					<tr align="center">
						<td class="td_normal_title"><bean:message key="page.serial"/></td>
						<td class="td_normal_title" width=30%>
							<bean:message  bundle="sys-organization" key="sysOrgRoleConf.repeat.check.person"/>
						</td>
						<td class="td_normal_title" width=35%>
							<bean:message  bundle="sys-organization" key="sysOrgRoleConf.repeat.check.belong.role"/>
						</td>
						<td class="td_normal_title" width=35%>
							<bean:message  bundle="sys-organization" key="sysOrgRoleConf.repeat.check.default.role"/>
						</td>
					</tr>
					<c:forEach items="${sysOrgRoleConfForm.defaultRoleList}" var="defaultRoleForm" varStatus="vstatus">
						<tr KMSS_IsContentRow="1">
							<td align="center">
								${vstatus.index + 1}
								<input type="hidden" name="defaultRoleList[${vstatus.index}].fdId" value="${defaultRoleForm.fdId }"/>
								<input type="hidden" name="defaultRoleList[${vstatus.index}].fdRoleLineConfId" value="${sysOrgRoleConfForm.fdId }"/>
								<input type="hidden" name="defaultRoleList[${vstatus.index}].fdRoleLineConfName" value="${sysOrgRoleConfForm.fdName }"/>
							</td>
							<td align="center">
								<input type="hidden" name="defaultRoleList[${vstatus.index}].fdPersonId" value="${defaultRoleForm.fdPersonId }"/>
								<input type="hidden" name="defaultRoleList[${vstatus.index}].fdPersonName" value="${defaultRoleForm.fdPersonName }"/>
								${defaultRoleForm.fdPersonName }
							</td>
							<td align="center">
								<input type="hidden" name="defaultRoleList[${vstatus.index}].fdPostIds" value="${defaultRoleForm.fdPostIds }"/>
								<input type="hidden" name="defaultRoleList[${vstatus.index}].fdPostNames" value="${defaultRoleForm.fdPostNames }"/>
								<c:forTokens items="${defaultRoleForm.fdPostNames }" var="postNames" varStatus="stat" delims=";">
									${postNames }<br>
								</c:forTokens>
							</td>
							<td align="center">
								<select name="defaultRoleList[${vstatus.index}].fdPostId">
								<%
									SysOrgRoleLineDefaultRoleForm form = (SysOrgRoleLineDefaultRoleForm)pageContext.getAttribute("defaultRoleForm");
									String[] ids = form.getFdPostIds().split(";");
									String[] names = form.getFdPostNames().split(";");
									for(int i=0; i<ids.length; i++){
										out.write("<option value=\""+ids[i]+"\"");
										if(ids[i].equals(form.getFdPostId())){
											out.write(" selected");
										}
										out.write(">"+names[i]+"</option>");
									}
								%>
								</select>
							</td>
						</tr>
					</c:forEach>
				</table>
			</td>
		</tr>
	</c:if>
</table>
</center>
<html:hidden property="method_GET"/>
<html:hidden property="fdId" value="${sysOrgRoleConfForm.fdId }"/>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>