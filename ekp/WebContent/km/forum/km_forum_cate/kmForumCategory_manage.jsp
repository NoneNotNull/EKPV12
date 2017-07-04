<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ page import="com.landray.kmss.km.forum.model.KmForumConfig"%>
<%@ page import="org.springframework.context.ApplicationContext"%>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(session.getServletContext());
%>
<%
    request.setAttribute("globalIsAnonymous",new KmForumConfig().getAnonymous());
%>
<script type="text/javascript">
Com_IncludeFile("common.js|doclist.js|dialog.js");
</script>

<html:form action="/km/forum/km_forum_cate/kmForumCategory.do">
<div id="optBarDiv">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.kmForumCategoryForm, 'manageUpdate');">
</div>

<p class="txttitle"><bean:message bundle="km-forum" key="menu.kmForum.manage"/></p>
<center>
<table class="tb_normal" width=95%>
		<html:hidden property="fdId"/>

	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumCategory.forumPosters"/>
		</td><td colspan=3>
			<html:hidden property="fdPosterIds" />
			<html:textarea property="fdPosterNames" style="width:95%"/>
			
			<a href="#" onclick="Dialog_Address(true, 'fdPosterIds', 'fdPosterNames', ';', ORG_TYPE_ALL);">
				<bean:message key="dialog.selectOrg"/>
			</a>
			<%-- 添加说明 (如果为空则所有人允许发帖) -modify by zhouchao ----%>
			<br>
			<bean:message  bundle="km-forum" key="kmForumCategory.fdPosterNames"/>			
			
		</td>
	</tr>

	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumCategory.fdAnonymous"/>
		</td><td>
		<c:if test="${globalIsAnonymous==true}">
			<sunbor:enums property="fdAnonymous" enumsType="common_yesno" elementType="radio" />
		</c:if>
		<c:if test="${globalIsAnonymous==false}">
			<bean:message  bundle="km-forum" key="kmForumConfig.anonymous.no"/>
		</c:if>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumCategory.fdMainScore"/>
		</td><td>
			<bean:write name="kmForumCategoryForm" property="fdMainScore"/>
		</td>
	</tr>

	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumCategory.fdResScore"/>
		</td><td>
			<bean:write name="kmForumCategoryForm" property="fdResScore"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="km-forum" key="kmForumCategory.fdPinkScore"/>
		</td><td>
			<bean:write name="kmForumCategoryForm" property="fdPinkScore"/>
		</td>
	</tr>

	<tr>
		<td colspan=4><bean:message  bundle="km-forum" key="kmForumCategory.forumManager.msg"/></td>
	</tr>	

</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<script language="JavaScript">Com_IncludeFile("calendar.js");</script>
<html:javascript formName="kmForumCategoryForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>