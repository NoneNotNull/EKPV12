<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="person.cfg">
	<template:replace name="title">
		<template:super/> - ${lfn:message('km-forum:kmForumScore.userInfo.title') }
	</template:replace>
<%@ page import="com.landray.kmss.util.UserUtil" %>
<%
	request.setAttribute("userId",UserUtil.getUser(request).getFdId());
%>  
<template:replace name="content"> 
<html:form action="/km/forum/km_forum_score/kmForumScore.do" styleId="kmForumScoreForm">
  <ui:panel layout="sys.ui.panel.light" scroll="false" toggle="false">
	 <ui:content title="${lfn:message('km-forum:kmForumScore.userInfo.title') }">
		<table class="tb_normal" width=95%>
				<html:hidden property="fdId" value="${userId}"/>
			<tr>
				<td width="15%" class="td_normal_title">
					<bean:message  bundle="km-forum" key="kmForumScore.userName.title"/>
				</td>
				<td width="55%">
					<html:text property="userName" readonly="true" style="width:90%"/>
				</td>
				 <td rowspan="6" width="25%" align="center">
					<c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
						<c:param name="fdKey" value="spic"/>
						<c:param name="fdAttType" value="pic"/>
						<c:param name="fdShowMsg" value="true"/>
						<c:param name="fdMulti" value="false"/>
						<c:param name="fdImgHtmlProperty" value="width=100 height=100"/>
						<c:param name="fdModelId" value="${userId}"/>
						<c:param name="fdModelName" value="com.landray.kmss.km.forum.model.KmForumScore"/>
						<%---个人信息  上传图片缩小 压缩图片 与新闻一样 modify by zhouchao 20110510----%> 
					    <c:param name="fdViewType" value="pic_single"/>
					    <c:param name="fdLayoutType" value="pic"/>
				        <c:param name="picWidth" value="312" />
						<c:param name="picHeight" value="234" />
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
					<html:text property="dept" readonly="true"  style="width:90%"/>
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
			<tr>
			     <td colspan="3" align="center">
			     	 <ui:button text="${lfn:message('button.save') }" order="2" onclick="formSubmit();"></ui:button>
			    </td>						
		    </tr>
		</table>
	  <html:hidden property="method_GET"/>
	</ui:content>
 </ui:panel>
</html:form>
<script>
//获取富文本框内容
function RTF_GetContent(prop) {
	var instance = CKEDITOR.instances[prop];
	if (instance) {
		return instance.getData();
	}
	return "";
}

seajs.use(['lui/jquery', 'lui/dialog'], function($, dialog) {
	window.formSubmit = function() {
		// 提交之前补全附件已上传附件id隐藏域
		var ___att = attachmentObject_spic,
			___upSuccess = ___att.isUploaded();
		if (!___upSuccess) {
			dialog.alert(Attachment_MessageInfo["msg.uploading"]);
			return;
		} else {
			if (___att.editMode == "edit" || ___att.editMode == "add") {
				___att.updateInput();
			}
		}
		var v = RTF_GetContent("fdSign");
		document.getElementsByName("fdSign")[0].value = v;
		LUI.$.ajax({
			url: '${LUI_ContextPath}/km/forum/km_forum_score/kmForumScore.do?method=updateScore',
			type: 'POST',
			dataType: 'text',
			async: false,
			data: $("#kmForumScoreForm").serialize(),
			success: function(data, textStatus, xhr) {
				if (data == 'true') {
					dialog.success('<bean:message key="return.optSuccess" />');
				} else {
					dialog.failure('<bean:message key="return.optFailure" />');
				}
			}
		});
	}
});

var _hight = 100,
	_width = 100;

function setPicProperty() {
	var pics = document.getElementsByName("pic");
	for (var i = 0; i < pics.length; i++) {
		if (pics[i].style.hight > _hight)
			pics[i].style.hight = _hight;
		if (pics[i].width > _width)
			pics[i].width = _width;
	}
}

setPicProperty();
</script>
</template:replace>
</template:include>