<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ include file="/sys/ftsearch/autocomplete_include.jsp" %>
<script>
function checkHotWordUniqueness(hotWord,method){
	if(hotWord==null || hotWord=="")
		return null;
	$.ajax({
        url: "${KMSS_Parameter_ContextPath}sys/ftsearch/expand/sys_ftsearch_hotword/sysFtsearchHotword.do?method=checkHotWordUniqueness&hotWord="+encodeURI(hotWord)+"&fdId="+Com_GetUrlParameter(window.location.href, "fdId"),
        success: function(data) {
            if(data=="false"){
                alert("<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchHotword.exist.error" />");
                return;
            }
            else
	            Com_Submit(document.sysFtsearchHotwordForm, method);
        }
	 });
}

</script>

<html:form action="/sys/ftsearch/expand/sys_ftsearch_hotword/sysFtsearchHotword.do">
<div id="optBarDiv">
	<c:if test="${sysFtsearchHotwordForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="checkHotWordUniqueness(document.getElementById('fdHotWord').value,'update');">
	</c:if>
	<c:if test="${sysFtsearchHotwordForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="checkHotWordUniqueness(document.getElementById('fdHotWord').value,'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="checkHotWordUniqueness(document.getElementById('fdHotWord').value,'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-ftsearch-expand" key="table.sysFtsearchHotword"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchHotword.fdHotWord"/>
		</td><td width="35%">
				<xform:text property="fdHotWord" style="width:85%"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchHotword.fdSearchFrequency"/>
		</td><td width="35%">
			<xform:text property="fdSearchFrequency" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchHotword.fdShieldFlag"/>
		</td><td width="35%">
			<xform:radio property="fdShieldFlag">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchHotword.fdWordOrder"/>
		</td><td width="35%"> 
			${fdWordOrder }
			<select name="fdWordOrder">
				<option value=""><bean:message bundle="sys-ftsearch-expand" key="sysFtsearchHotword.please.select"/></option>
				<c:if test="${sysFtsearchHotwordForm.fdWordOrder!=null && sysFtsearchHotwordForm.fdWordOrder !='' }">
					<option value="${sysFtsearchHotwordForm.fdWordOrder }" selected="selected">${sysFtsearchHotwordForm.fdWordOrder }</option>
				</c:if>
				<c:forEach var="order" items="${canSelectedList }" >
					<option value=${order }>${order }</option>
                </c:forEach>
			</select>
			<c:if test="${hadSelectedpos!=null}">
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchHotword.position"/>${hadSelectedpos}<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchHotword.had.occupied"/>
			</c:if>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchHotword.fdUserName"/>
		</td><td width="35%">
			<xform:text property="fdUserName" style="width:85%" showStatus="view"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchHotword.fdCreatTime"/>
		</td><td width="35%">
			<!--<xform:datetime property="fdCreatTime" /> 
			<input type="text" value="123" name="fdCreatTime">-->
			<xform:text property="fdCreatTime" style="width:85%" showStatus="view"/>
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	Com_IncludeFile("calendar.js");
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>