<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("dialog.js", null, "js");
</script>
<script type="text/javascript">
	function validate(){
		var phoneVar=document.getElementsByName("phonePersonIds")[0];
		var isAdd=false;
		if(phoneVar!=null && phoneVar.value!="")
			isAdd=true;
	    if(isAdd==false){
			alert('<bean:message key="pda.license.alert" bundle="third-pda"/>');
			return false;
	    }
		Com_Submit(document.forms[0],'save');
	}
</script>

<form action="<c:url value="/third/pda/third_pda_config/pdaLicenseConfig.do"/>" method="post" autocomplete="off">
	<p class="txttitle"><bean:message key="pda.license.title" bundle="third-pda"/></p>
	<input type="hidden" name="s_forward" value="${s_forward}"/>
	<center>
		<table class="tb_normal" width=95%>
			<!-- 手机版配置 -->
			<c:set var="phoneSize" value="0"/>
			<tr>
				<td class="td_normal_title" width="25%" align="center" <c:out value="${(PhoneUseFlag==0 || PhoneUseFlag==-1)?'colspan=2':''}"/>  >
					<bean:message key="pda.license.phone.title" bundle="third-pda"/>
					<c:choose>
						<c:when test="${PhoneUseFlag==0 }">
							<font color="red"><bean:message key="pda.lecense.warnning.noFunction" bundle="third-pda"/></font>
						</c:when>
						<c:when test="${PhoneUseFlag==-1}">
							<bean:message key="pda.lecense.warnning.unlimit" bundle="third-pda"/>
						</c:when>
						<c:otherwise>
							<c:if test="${phoneMap!=null }">
								<c:set var="phoneSize" value="${fn:length(phoneMap)}"/>
							</c:if>
							<br/>（<bean:message key="pda.lecense.warnning.lincenseinfo" bundle="third-pda"/>${PhoneUseFlag}，
							 <bean:message key="pda.lecense.warnning.lincenseinfo.used" bundle="third-pda"/>${phoneSize}）&nbsp;&nbsp;&nbsp;
						</c:otherwise>
					</c:choose>
				</td>
				<c:if test="${PhoneUseFlag!=0 && PhoneUseFlag!=-1}">
					<td>
						<input type="hidden" name="phonePersonIds" value="${phonePersonIds}"/>
						<span>
							<input type="text" name="phonePersonNames" value="${phonePersonNames}" readonly="true" class="inputmul" style="width:90%"/>
							<a href="#" onclick="Dialog_Address(true, 'phonePersonIds','phonePersonNames', ';',null);">
								<bean:message key="dialog.selectOrg"/>
							</a>
						</span>
						<c:if test="${phoneErrorCount>0}">
							<br>
							<font color="red"><bean:message key="pda.license.warnning.addErrorPre" bundle="third-pda"/>
							${phoneErrorCount}
							<bean:message key="pda.license.warnning.addErrorBak" bundle="third-pda"/></font>
						</c:if>
					</td>
				</c:if>
			</tr>
			<tr>
				<td align="center" colspan="2">
					<c:if test="${PhoneUseFlag!=0 && PhoneUseFlag!=-1}">
						<input type=button class="btnopt" value="<bean:message key="button.ok"/>"
								onclick="validate();">
					</c:if>
					&nbsp;&nbsp;&nbsp;
					<c:if test="${param.isAdd=='1'}">
						<input type="button" class="btnopt" value="<bean:message key="button.cancel"/>" onclick="Com_CloseWindow();">
					</c:if>
				</td>
			</tr>
		</table>
	</center>
</form>
<%@ include file="/resource/jsp/edit_down.jsp"%>