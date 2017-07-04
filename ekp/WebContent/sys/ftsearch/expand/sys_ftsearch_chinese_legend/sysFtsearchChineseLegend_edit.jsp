<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ include file="/sys/ftsearch/autocomplete_include.jsp" %>
<script>
function checkChineseLegendUniqueness(chineseLegend,method){
	if(chineseLegend==null || chineseLegend=="")
		return null;
	$.ajax({
        url: "${KMSS_Parameter_ContextPath}sys/ftsearch/expand/sys_ftsearch_chinese_legend/sysFtsearchChineseLegend.do?method=checkChineseLegendUniqueness&chineseLegend="+encodeURI(chineseLegend)+"&fdId="+Com_GetUrlParameter(window.location.href, "fdId"),
        success: function(data) {
            if(data=="false"){
                alert("<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchChineseLegend.exist.error" />");
                return;
            }
            else
	            Com_Submit(document.sysFtsearchChineseLegendForm, method);
        }
	 });
}
</script>
<html:form action="/sys/ftsearch/expand/sys_ftsearch_chinese_legend/sysFtsearchChineseLegend.do">
<div id="optBarDiv">
	<c:if test="${sysFtsearchChineseLegendForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="checkChineseLegendUniqueness(document.getElementById('fdSearchWord').value,'update');">
	</c:if>
	<c:if test="${sysFtsearchChineseLegendForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="checkChineseLegendUniqueness(document.getElementById('fdSearchWord').value,'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="checkChineseLegendUniqueness(document.getElementById('fdSearchWord').value,'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-ftsearch-expand" key="table.sysFtsearchChineseLegend"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchChineseLegend.fdUserName"/>
		</td><td width="35%">
			<xform:text property="fdUserName" style="width:85%" showStatus="view"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchChineseLegend.fdSearchTime"/>
		</td><td width="35%">
			<!--<xform:datetime property="fdSearchTime" />-->
			<xform:text property="fdSearchTime" style="width:85%" showStatus="view"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchChineseLegend.fdSearchWord"/>
		</td><td width="35%">
				<xform:text property="fdSearchWord" style="width:85%"  />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchChineseLegend.fdSearchFrequency"/>
		</td><td width="35%">
			<xform:text property="fdSearchFrequency" style="width:85%" />
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchChineseLegend.fdShieldFlag"/>
		</td><td width="35%">
			<xform:radio property="fdShieldFlag">
				<xform:enumsDataSource enumsType="common_yesno" />
			</xform:radio>
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