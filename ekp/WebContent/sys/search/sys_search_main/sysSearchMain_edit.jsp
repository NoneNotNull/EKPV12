<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>
<%@page import="com.landray.kmss.sys.search.forms.SysSearchMainForm"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%
	SysSearchMainForm sysSearchMainForm = (SysSearchMainForm)request.getAttribute("sysSearchMainForm");
	sysSearchMainForm.setLocale(request.getLocale());
	sysSearchMainForm.setFdModelName(request.getParameter("fdModelName"));
%>
<script type="text/javascript">
Com_IncludeFile("select.js");
Com_IncludeFile("dialog.js");
function submitForm(method){
	var str = "";
	var options = document.getElementsByName("tmp_ConditionSel")[0].options;
	for(var i=0; i<options.length; i++)
		str += ";"+options[i].value;
	document.getElementsByName("fdCondition")[0].value = str.substring(1);
	
	str = "";
	options = document.getElementsByName("tmp_DisplaySel")[0].options;
	for(i=0; i<options.length; i++)
		str += ";"+options[i].value;
	document.getElementsByName("fdDisplay")[0].value = str.substring(1);

	str = "";
	options = document.getElementsByName("tmp_OrderBySel")[0].options;
	for(i=0; i<options.length; i++)
		str += ";"+options[i].value;
	document.getElementsByName("fdOrderBy")[0].value = str.substring(1);
	Com_Submit(document.sysSearchMainForm, method);
}
</script>
<html:form action="/sys/search/sys_search_main/sysSearchMain.do" onsubmit="return validateSysSearchMainForm(this);">
<div id="optBarDiv">
	<c:if test="${sysSearchMainForm.method_GET=='edit' || sysSearchMainForm.method_GET=='editTemplate'}">
		<input type=button value="<bean:message bundle="sys-search" key="search.btn.editTemplate"/>"
			onclick="submitForm('editTemplate');">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="submitForm('update');">
	</c:if>
	<c:if test="${sysSearchMainForm.method_GET=='add'}">
		<input type=button value="<bean:message bundle="sys-search" key="search.btn.rtnToParam"/>"
			onclick="submitForm('rtnEditParam');">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="submitForm('save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="submitForm('saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message  bundle="sys-search" key="table.sysSearchMain"/><bean:message key="button.edit"/></p>

<center>
<html:hidden property="fdId"/>
<html:hidden property="fdModelName"/>
<html:hidden property="fdKey"/>
<html:hidden property="fdParemNames"/>
<html:hidden property="fdParameters"/>
<html:hidden property="fdTemplateId"/>
<html:hidden property="fdTemplateName"/>
<table class="tb_normal" width="600px">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-search" key="sysSearchMain.fdName"/>
		</td><td>
			<html:text property="fdName" style="width:90%"/>
			<span class="txtstrong">*</span>
		</td>
	</tr>
	<c:if test="${not empty sysSearchMainForm.fdTemplateId}">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-search" key="sysSearchMain.fdTemplateId"/>
		</td>
		<td>
			${sysSearchMainForm.fdTemplateName}
		</td>
	</tr>
	</c:if>
	<c:if test="${not empty sysSearchMainForm.fdParemNames}">
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-search" key="sysSearchMain.fdParemNames"/>
		</td><td>
			${sysSearchMainForm.paremNamesText}
		</td>
	</tr>
	</c:if>
	<%-- 搜索项 --%>
	<tr class="tr_normal_title">
		<td colspan="2">
			<bean:message  bundle="sys-search" key="sysSearchMain.fdCondition"/>
			<html:hidden property="fdCondition"/>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<table    class="tb_normal" width="100%">
				<tr class="tr_normal_title">
					<td><bean:message key="dialog.optList"/></td>
					<td>&nbsp;</td>
					<td><bean:message key="dialog.selList"/></td>
				</tr>
				<tr>
					<td style="width:220px">
						<select name="tmp_ConditionOpt" multiple="true" size="15" style="width:220px"
							ondblclick="Select_AddOptions('tmp_ConditionOpt', 'tmp_ConditionSel');">
							${sysSearchMainForm.optConditionHTML}
						</select>
					</td>
					<td>
						<center>
							<input class="btnopt" type="button" value="<bean:message key="dialog.add"/>"
								onclick="Select_AddOptions('tmp_ConditionOpt', 'tmp_ConditionSel');"><br><br>
							<input class="btnopt" type="button" value="<bean:message key="dialog.delete"/>"
								onclick="Select_DelOptions('tmp_ConditionSel');"><br><br>
							<input class="btnopt" type="button" value="<bean:message key="dialog.addAll"/>"
								onclick="Select_AddOptions('tmp_ConditionOpt', 'tmp_ConditionSel', true);"><br><br>
							<input class="btnopt" type="button" value="<bean:message key="dialog.deleteAll"/>"
								onclick="Select_DelOptions('tmp_ConditionSel', true);"><br><br>
							<input class="btnopt" type="button" value="<bean:message key="dialog.moveUp"/>"
								onclick="Select_MoveOptions('tmp_ConditionSel', -1);"><br><br>
							<input class="btnopt" type="button" value="<bean:message key="dialog.moveDown"/>"
								onclick="Select_MoveOptions('tmp_ConditionSel', 1);">
						</center>
					</td>
					<td style="width:220px">
						<select name="tmp_ConditionSel" multiple="true" size="15" style="width:220px"
							ondblclick="Select_DelOptions('tmp_ConditionSel');">
							${sysSearchMainForm.selConditionHTML}
						</select>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<%-- 显示项 --%>
	<tr class="tr_normal_title">
		<td colspan="2">
			<bean:message  bundle="sys-search" key="sysSearchMain.fdDisplay"/>
			<html:hidden property="fdDisplay"/>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<table class="tb_normal" width="100%">
				<tr class="tr_normal_title">
					<td><bean:message key="dialog.optList"/></td>
					<td>&nbsp;</td>
					<td><bean:message key="dialog.selList"/></td>
				</tr>
				<tr>
					<td style="width:220px">
						<select name="tmp_DisplayOpt" multiple="true" size="15" style="width:220px"
							ondblclick="Select_AddOptions('tmp_DisplayOpt', 'tmp_DisplaySel');">
							${sysSearchMainForm.optDisplayHTML}
						</select>
					</td>
					<td>
						<center>
							<input class="btnopt" type="button" value="<bean:message key="dialog.add"/>"
								onclick="Select_AddOptions('tmp_DisplayOpt', 'tmp_DisplaySel');"><br><br>
							<input class="btnopt" type="button" value="<bean:message key="dialog.delete"/>"
								onclick="Select_DelOptions('tmp_DisplaySel');"><br><br>
							<input class="btnopt" type="button" value="<bean:message key="dialog.addAll"/>"
								onclick="Select_AddOptions('tmp_DisplayOpt', 'tmp_DisplaySel', true);"><br><br>
							<input class="btnopt" type="button" value="<bean:message key="dialog.deleteAll"/>"
								onclick="Select_DelOptions('tmp_DisplaySel', true);"><br><br>
							<input class="btnopt" type="button" value="<bean:message key="dialog.moveUp"/>"
								onclick="Select_MoveOptions('tmp_DisplaySel', -1);"><br><br>
							<input class="btnopt" type="button" value="<bean:message key="dialog.moveDown"/>"
								onclick="Select_MoveOptions('tmp_DisplaySel', 1);">
						</center>
					</td>
					<td style="width:220px">
						<select name="tmp_DisplaySel" multiple="true" size="15" style="width:220px"
							ondblclick="Select_DelOptions('tmp_DisplaySel');">
							${sysSearchMainForm.selDisplayHTML}
						</select>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-search" key="sysSearchMain.fdResultUrl"/>
		</td>
		<td>
			<label>
			<input type="checkbox" name="fdUseResultUrl" 
				onclick="showResultUrlDiv(this.checked);" value="true" 
				<c:if test="${sysSearchMainForm.fdUseResultUrl eq 'true'}">checked</c:if>>
			<bean:message bundle="sys-search" key="sysSearchMain.fdUseResultUrl"/>
			</label>
			<div id="resultUrlDiv"<c:if test="${sysSearchMainForm.fdUseResultUrl != 'true'}"> style="display: none;"</c:if>>
			<c:if test="${not empty sysSearchMainForm.fdResultUrl}">
			<html:text property="fdResultUrl" style="width:90%" />
			</c:if>
			<c:if test="${empty sysSearchMainForm.fdResultUrl}">
			<html:text property="fdResultUrl" value="${sysSearchMainForm.defaultResultUrl }" style="width:90%"/>
			</c:if>
			</div>
		</td>
	</tr>
	<%-- 排序项 --%>
	<tr class="tr_normal_title">
		<td colspan="2">
			<bean:message bundle="sys-search" key="sysSearchMain.fdOrderBy"/>
			<html:hidden property="fdOrderBy"/>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<table class="tb_normal" width="100%">
				<tr class="tr_normal_title">
					<td><bean:message key="dialog.optList"/></td>
					<td>&nbsp;</td>
					<td><bean:message key="dialog.selList"/></td>
				</tr>
				<tr>
					<td style="width:220px">
						<select name="tmp_OrderByOpt" multiple="true" size="15" style="width:220px"
							ondblclick="Select_AddOptions('tmp_OrderByOpt', 'tmp_OrderBySel');">
							${sysSearchMainForm.optOrderByHTML}
						</select>
					</td>
					<td>
						<center>
							<input class="btnopt" type="button" value="<bean:message key="dialog.add"/>"
								onclick="Select_AddOptions('tmp_OrderByOpt', 'tmp_OrderBySel');"><br><br>
							<input class="btnopt" type="button" value="<bean:message key="dialog.delete"/>"
								onclick="Select_DelOptions('tmp_OrderBySel');"><br><br>
							<input class="btnopt" type="button" value="<bean:message key="dialog.addAll"/>"
								onclick="Select_AddOptions('tmp_OrderByOpt', 'tmp_OrderBySel', true);"><br><br>
							<input class="btnopt" type="button" value="<bean:message key="dialog.deleteAll"/>"
								onclick="Select_DelOptions('tmp_OrderBySel', true);"><br><br>
							<input class="btnopt" type="button" value="<bean:message key="dialog.moveUp"/>"
								onclick="Select_MoveOptions('tmp_OrderBySel', -1);"><br><br>
							<input class="btnopt" type="button" value="<bean:message key="dialog.moveDown"/>"
								onclick="Select_MoveOptions('tmp_OrderBySel', 1);">
						</center>
					</td>
					<td style="width:220px">
						<select name="tmp_OrderBySel" multiple="true" size="15" style="width:220px"
							ondblclick="Select_DelOptions('tmp_OrderBySel');">
							${sysSearchMainForm.selOrderByHTML}
						</select>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
		<bean:message bundle="sys-search" key="sysSearchMain.fdOrderType"/>
		</td>
		<td>
			<label>
			<html:radio property="fdOrderType" value="asc"/>
			<bean:message bundle="sys-search" key="sysSearchMain.fdOrderType.asc"/>
			</label>
			<label>
			<html:radio property="fdOrderType" value="desc"/>
			<bean:message bundle="sys-search" key="sysSearchMain.fdOrderType.desc"/>
			</label>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%><kmss:message key="model.tempReaderName"/></td>
		<td><html:hidden property="authSearchReaderIds" /><html:textarea property="authSearchReaderNames" readonly="true" style="width:90%;height:90px" styleClass="inputmul" /> 
					<a href="#" onclick="Dialog_Address(true, 'authSearchReaderIds','authSearchReaderNames', ';', ORG_TYPE_ALL);">
					   <bean:message key="dialog.selectOrg" /> </a><br/>
					   <%-- 为空则所有用户都可使用 --%>
					   <bean:message bundle="sys-search" key="sysSearchMain.allUsersCanUse"/>
					   </td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-search" key="sysSearchMain.fdCreator"/>
		</td><td>
			${sysSearchMainForm.fdCreatorName}
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-search" key="sysSearchMain.fdCreateTime"/>
		</td><td>
			${sysSearchMainForm.fdCreateTime}
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<script>
function showResultUrlDiv(show) {
	var div = document.getElementById('resultUrlDiv');
	div.style.display = show ? '' : 'none';
}
function validateResultUrl() {
	var fdUseResultUrl = document.getElementsByName('fdUseResultUrl')[0];
	if (fdUseResultUrl.checked) {
		var fdResultUrl = document.getElementsByName('fdResultUrl')[0];
		fdResultUrl.value = Com_Trim(fdResultUrl.value);
		if (fdResultUrl.value == '') {
			alert('<bean:message bundle="sys-search" key="sysSearchMain.fdResultUrl.alert"/>');
			fdResultUrl.focus();
			return false;
		}
	}
	return true;
}
Com_Parameter.event["submit"].push(validateResultUrl);
</script>
<html:javascript formName="sysSearchMainForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>