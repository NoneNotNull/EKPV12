<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<html:form action="/km/forum/km_forum/kmForumPost.do" >

<script>
Com_SetWindowTitle("${kmForumPostForm.docSubject}--${kmForumPostForm.fdForumName}--<bean:message key="menu.kmForum.title" bundle="km-forum"/>");
</script>

<div id="optBarDiv">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<center>
<table class="tb_normal" width=95%>
		<html:hidden property="fdId"/>
		<html:hidden property="fdTopicId"/>
	<tr>
		<td width="15%" class="td_normal_title"  valign="top">
			<bean:message  bundle="km-forum" key="kmForumTopic.docSubject"/>
		</td>
		<td colspan=3>
			<html:text property="docSubject" readonly="true" style="width:90%"/>	
		</td>
	</tr>
	
	<tr>
		<td width="15%" class="td_normal_title" >
			<bean:message  bundle="km-forum" key="kmForumTopic.fdPosterId"/>
		</td>
		<td>
			<c:if test="${kmForumPostForm.fdIsAnonymous == false}">
				<html:text property="fdPosterName" readonly="true"/>
			</c:if>
			<c:if test="${kmForumPostForm.fdIsAnonymous == true}">
				<bean:message bundle="km-forum" key="kmForumTopic.fdIsAnonymous.title"/>
			</c:if>
		</td>
		<td width="15%" class="td_normal_title" >
			<bean:message  bundle="km-forum" key="kmForumTopic.fdForumId"/>
		</td>
		<td>
			<html:hidden property="fdForumId"/>
			<html:text property="fdForumName" readonly="true"/>
		</td>
	</tr>

	<tr>
		<td width="15%" class="td_normal_title" >
			<bean:message  bundle="km-forum" key="kmForumTopic.docCreateTime"/>
		</td>
		<td>
			<html:text property="docCreateTime" readonly="true"/>
		</td>
		<td width="15%" class="td_normal_title" >
			<bean:message  bundle="km-forum" key="kmForumTopic.docAlterTime"/>
		</td>
		<td>
			<html:text property="docAlterTime" readonly="true"/>
		</td>
	</tr>

	<tr>
		<td width="15%" class="td_normal_title" >
			<bean:message  bundle="km-forum" key="kmForumPost.docContent"/>
		</td>
		<td colspan=3>
		<kmss:showText value="${kmForumPostForm.docContent}"/>
		</td>
	</tr>
	
	<tr>
		<td width="11%" class="td_normal_title">
			<bean:message  bundle="sys-attachment" key="table.sysAttMain"/>
		</td>
		<td width="89%" bgcolor="#ffffff" colspan="3">
						
		<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
			<c:param name="fdKey" value="attachment"/>
			<c:param name="fdAttType" value="byte"/>
			<c:param name="fdModelId" value="${param.fdId }"/>
			<c:param name="formBeanName" value="kmForumPostForm"/>
			<c:param name="fdModelName" value="com.landray.kmss.km.forum.model.KmForumPost"/>
		</c:import>
		</td>
	</tr>	
	
	<tr>
		<td colspan=4 align="right">
		<bean:message  bundle="km-forum" key="kmForum.search.link.topic"/>:
		<a href="<c:url value="/km/forum/km_forum/kmForumPost.do" />?method=view&fdTopicId=${kmForumPostForm.fdTopicId}">
		<bean:write name="kmForumPostForm" property="topicDocSubject"/>
		</a>
		</td>
	</tr>		
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<script language="JavaScript">Com_IncludeFile("calendar.js");</script>
<html:javascript formName="kmForumPostForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/view_down.jsp"%>