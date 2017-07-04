<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit" sidebar="no" width="100%">
<%@ page import="com.landray.kmss.util.UserUtil" %>

<%
	request.setAttribute("userId",UserUtil.getUser(request).getFdId());
%> 
<template:replace name="toolbar">
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float"> 
		   <c:if test="${userId eq kmForumScoreForm.personId}">
		     <ui:button text="${lfn:message('button.update') }" order="2" onclick="Com_Submit(document.kmForumScoreForm, 'update');">
			 </ui:button>
		   </c:if>
			<ui:button text="${ lfn:message('button.close') }" order="5"  onclick="Com_CloseWindow()">
			</ui:button>
		</ui:toolbar>
</template:replace>
<template:replace name="content"> 
<html:form action="/km/forum/km_forum_score/kmForumScore.do">
<p class="txttitle">
<bean:message
		bundle="km-forum"
		key="kmForumScore.userInfo.title" />
</p>
<center>
<table class="tb_normal" width=95%>
		<html:hidden property="fdId"/>
	<tr>
		<td width="15%" class="td_normal_title">
			<bean:message  bundle="km-forum" key="kmForumScore.userName.title"/>
		</td>
		<td width="70%">
			<html:text property="userName" readonly="true" style="width:90%"/>
		</td>
		 <td rowspan="6" width="150" align="center">
			<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
				<c:param name="fdKey" value="spic"/>
				<c:param name="fdAttType" value="pic"/>
				<c:param name="fdShowMsg" value="true"/>
				<c:param name="fdMulti" value="false"/>
				<c:param name="fdImgHtmlProperty" value="width=100 height=100"/>
				<c:param name="fdModelId" value="${param.fdId }"/>
				<c:param name="fdModelName" value="com.landray.kmss.km.forum.model.KmForumScore"/>
				<%---个人信息  上传图片缩小 压缩图片 与新闻一样 modify by zhouchao 20110510----%> 
		        <c:param name="picWidth" value="250" />
				<c:param name="picHeight" value="250" />
			</c:import>
		</td>
	</tr>

	<tr>
		<td width="15%" class="td_normal_title">
			<bean:message  bundle="km-forum" key="kmForumScore.fdNickName"/>
		</td>
		<td>
			<html:text property="fdNickName" />
		</td>
	</tr>

	<tr>
		<td width="15%" class="td_normal_title">
			<bean:message  bundle="km-forum" key="kmForumPost.from.title"/>
		</td>
		<td>
			<html:text property="dept" readonly="true" style="width:90%"/>
		</td>
	</tr>

	<tr>
		<td width="15%" class="td_normal_title">
			<bean:message bundle="sys-organization" key="sysOrgElement.post"/>
		</td>
		<td>
			<html:text property="post" readonly="true" style="width:90%"/>
		</td>
	</tr>

	<tr>
		<td width="15%" class="td_normal_title">
			<bean:message  bundle="km-forum" key="kmForumScore.fdPostCount"/>
		</td>
		<td>
			<html:text property="postCount" readonly="true" style="width:90%"/>
		</td>
	</tr>

	<tr>
		<td width="15%" class="td_normal_title">
			<bean:message  bundle="km-forum" key="kmForumScore.fdScore"/>
		</td>
		<td>
			<html:text property="score" readonly="true" style="width:90%"/>
		</td>
	</tr>

	<tr>
		<td width="15%" class="td_normal_title">
			<bean:message  bundle="km-forum" key="kmForumScore.fdSign"/>
		</td>
		<td colspan="2">
			<kmss:editor property="fdSign" height="120px"/>
		</td>
	</tr>
	
</table>
</center>
<html:hidden property="method_GET"/>
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
</template:replace>
</template:include>