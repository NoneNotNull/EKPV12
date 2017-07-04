<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/follow/sys_follow_person_doc_related/sysFollowPersonDocRelated.do">
<div id="optBarDiv">
	<c:if test="${sysFollowPersonDocRelatedForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.sysFollowPersonDocRelatedForm, 'update');">
	</c:if>
	<c:if test="${sysFollowPersonDocRelatedForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.sysFollowPersonDocRelatedForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.sysFollowPersonDocRelatedForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-follow" key="table.sysFollowPersonDocRelated"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-follow" key="sysFollowPersonDocRelated.isread"/>
		</td><td width="35%">
			<xform:radio property="isRead">
				<xform:enumsDataSource enumsType="sys_follow_related_doc_status"></xform:enumsDataSource>
			</xform:radio>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-follow" key="sysFollowPersonDocRelated.readTime"/>
		</td><td width="35%">
			<xform:datetime property="readTime" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-follow" key="sysFollowPersonDocRelated.followConfig"/>
		</td><td width="35%">
			<xform:select property="followConfigId">
				<xform:beanDataSource serviceBean="sysFollowPersonConfigService" selectBlock="fdId,fdSubject" orderBy="" />
			</xform:select>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-follow" key="sysFollowPersonDocRelated.followDoc"/>
		</td><td width="35%">
			<xform:select property="followDocId">
				<xform:beanDataSource serviceBean="sysFollowDocService" selectBlock="fdId,docSubject" orderBy="" />
			</xform:select>
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	Com_IncludeFile("calendar.js");
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>