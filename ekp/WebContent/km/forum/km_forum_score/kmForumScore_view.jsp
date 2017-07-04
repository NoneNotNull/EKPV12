<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%@ page import="com.landray.kmss.km.forum.model.KmForumConfig"%>
<%@ page import="com.landray.kmss.util.UserUtil" %>
<%@ page import="org.springframework.context.ApplicationContext"%>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils"%>
<%
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(session.getServletContext());
%>
<%
    request.setAttribute("canModifyRight",new KmForumConfig().getCanModifyRight());
	request.setAttribute("userId",UserUtil.getUser(request).getFdId());
%> 
<!-- 
<script type="text/javascript">
Com_SetWindowTitle("<bean:message  bundle="km-forum" key="kmForumScore.userInfo.title"/>");
</script>
 -->
 
 
		
		
<html:form action="/km/forum/km_forum_score/kmForumScore.do">
<c:if test="${param.type !='portlet'}">
<div id="optBarDiv">
	<c:if test="${canModifyRight==true and userId eq kmForumScoreForm.personId}">
		<input type="button"
				value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('kmForumScore.do?method=edit&fdId=${userId}','_self');">
	</c:if>
	<input type="button"
		value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle">
<bean:message
		bundle="km-forum"
		key="kmForumScore.userInfo.title" />
</p>
</c:if>
<center>

<table class="tb_normal" width=95%>
		<html:hidden name="kmForumScoreForm" property="fdId"/> 
	 
	
	<tr>
		<td width="15%" class="td_normal_title">
			<bean:message  bundle="km-forum" key="kmForumScore.userName.title"/>
		</td>
		<td width="70%">
			<bean:write name="kmForumScoreForm" property="userName"/>
		</td>
		<td rowspan="6" width="150" align="center"  >
			<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8"> 
				<c:param name="fdKey" value="spic"/>
				<c:param name="fdAttType" value="pic"/>
				<c:param name="fdMulti" value="false"/>
				<c:param name="fdShowMsg" value="false"/>
				<c:param name="fdImgHtmlProperty" value="width=100 height=100"/>
				<c:param name="fdModelId" value="${param.fdId }"/>
				<c:param name="fdModelName" value="com.landray.kmss.km.forum.model.KmForumScore"/>
				
			</c:import>
		</td>
	</tr>

	<tr>
		<td width="15%" class="td_normal_title">
			<bean:message  bundle="km-forum" key="kmForumScore.fdNickName"/>
		</td>
		<td  >
			<bean:write name="kmForumScoreForm" property="fdNickName"/>
		</td>
	</tr>

	<tr>
		<td width="15%" class="td_normal_title">
			<bean:message  bundle="km-forum" key="kmForumPost.from.title"/>
		</td>
		<td  >
			<bean:write name="kmForumScoreForm" property="dept"/>
		</td>
	</tr>

	<tr>
		<td width="15%" class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgElement.post"/>
		</td>
		<td  >
			<bean:write name="kmForumScoreForm" property="post"/>
		</td>
	</tr>

	<tr>
		<td width="15%" class="td_normal_title">
			<bean:message  bundle="km-forum" key="kmForumScore.fdPostCount"/>
		</td>
		<td  >
			<bean:write name="kmForumScoreForm" property="postCount"/>
		</td>
	</tr>

	<tr>
		<td width="15%" class="td_normal_title">
			<bean:message  bundle="km-forum" key="kmForumScore.fdScore"/>
		</td>
		<td  >
			<bean:write name="kmForumScoreForm" property="score"/>
		</td>
	</tr>

	<tr>
		<td width="15%" class="td_normal_title">
			<bean:message  bundle="km-forum" key="kmForumScore.fdSign"/>
		</td>
		<td   colspan=2>
			${kmForumScoreForm.fdSign}
		</td>
	</tr>

</table>
</center>
</html:form>
<script>
var _hight = 100,_width=100;
function setPicProperty(){
	var pics = document.getElementsByName("pic");
	for(var i=0;i<pics.length;i++){
		if(pics[i].style.hight>_hight)
			pics[i].style.hight=_hight;
		if(pics[i].width>_width)
			pics[i].width=_width;
	}
}

setPicProperty();

</script>
<%@ include file="/resource/jsp/view_down.jsp"%>