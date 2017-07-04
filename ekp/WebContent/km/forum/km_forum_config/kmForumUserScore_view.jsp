<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%@ page import="com.landray.kmss.km.forum.model.KmForumConfig"%>
<%@ page import="org.springframework.context.ApplicationContext"%>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(session.getServletContext());
%>
<script type="text/javascript">
Com_IncludeFile("post.css", "style/"+Com_Parameter.Style+"/forum/");
</script>

<div id="optBarDiv">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<center>
<table cellspacing="0" cellpadding="0" width="98%" align="center" border="0">
	<tr>
		<td>
		<table class="tdz" cellspacing="1" cellpadding="4" width="100%" align="center" border="0">
			<tr class="topic" align="middle">
				<td colspan="3"><b><bean:message bundle="km-forum" key="kmForumConfig.fdLevel"/></b></td>
			</tr>
			<tr class="outable">
				<td width="40%"><bean:message bundle="km-forum" key="kmForumConfig.fdLevel.name"/></td>
				<td width="30%"><bean:message bundle="km-forum" key="table.kmForumScore"/></td>
				<td width="30%"><bean:message bundle="km-forum" key="kmForumConfig.fdLevel.pic"/></td>
			</tr>
			<%
			KmForumConfig forumConfig = new KmForumConfig();
			int[] scores = forumConfig.getAllLevels();
			if(scores!=null){
				for(int i=0;i<scores.length;i++){
			%>
			<tr class="outable" align="left">
				<td><%=forumConfig.getLevelByScore(scores[i])%></td>
				<td><%=scores[i]%></td>
				<td>
				<%if(forumConfig.getLevelIcon().equals("0")){%>
				<bean:message bundle="km-forum" key="kmForumConfig.fdLevel.noPic"/>
				<%}else{%>
				<img src="${KMSS_Parameter_StylePath}forum/level/<%=forumConfig.getLevelIcon()%>.gif" border="0">
				<%}%>
				</td>
			</tr>
				<%}
			}%>
		</table>
		</td>
	</tr>
</table>

</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>