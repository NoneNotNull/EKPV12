<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/kms/common/resource/jsp/include_kms_top.jsp" %>
<title>版本比对</title>
</head>
<div id="optBarDiv">
	<input type="button" value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle">${firstModel.docSubject }</p>
<center>
<table id="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title">
			版本${firstModel.fdVersion}&nbsp;&nbsp;&nbsp;&nbsp;${firstModel.docCreator.fdName}&nbsp;&nbsp;&nbsp;&nbsp;<kmss:showDate value="${firstModel.docCreateTime}" type="datetime" />
		</td>
		<td class="td_normal_title">
			版本${secondModel.fdVersion}&nbsp;&nbsp;&nbsp;&nbsp;${secondModel.docCreator.fdName}&nbsp;&nbsp;&nbsp;&nbsp;<kmss:showDate value="${secondModel.docCreateTime}" type="datetime" />
		</td>
	</tr>
	<tr>
		<td valign="top" height="530px">
			<iframe src="<c:url value='/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=displayVersion&fdId=${ firstId}' />" width="100%" id="left" height="100%" style="overflow-x:hidden;">
			</iframe>
		</td>
		<td valign="top" height="530px">
			<iframe src="<c:url value='/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=displayVersion&fdId=${ secondId}' />" width="100%" id="right" height="100%" style="overflow-x:hidden;">
			</iframe>
		</td>
	</tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
<%@ include file="/kms/common/resource/jsp/include_kms_down.jsp" %>