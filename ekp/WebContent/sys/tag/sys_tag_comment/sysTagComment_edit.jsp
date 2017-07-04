<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html:form action="/sys/tag/sys_tag_comment/sysTagComment.do" onsubmit="return validateSysTagCommentForm(this);">
<div id="optBarDiv">
	<c:if test="${sysTagCommentForm.method_GET=='add'}">
		<input type=button value="<bean:message key="sysTagComment.button" bundle="sys-tag"/>"
			onclick="Com_Submit(document.sysTagCommentForm, 'save');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message  bundle="sys-tag" key="table.sysTagComment"/></p>

<center>
<table class="tb_normal" width=95%>
		<html:hidden property="fdId"/>
		<html:hidden property="fdTagId" value="${param.fdTagId}"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagComment.fdAppraise"/>
		</td><td width=35%>
			<sunbor:enums property="fdAppraise" enumsType="sysTagComment_fdAppraise" elementType="select" bundle="sys-tag"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-tag" key="sysTagComment.fdRemark"/>
		</td><td width=35%>
			<html:textarea property="fdRemark" style="width:90%;height:80px" />
			<span class="txtstrong">*</span>
		</td>
	</tr>

</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="sysTagCommentForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>