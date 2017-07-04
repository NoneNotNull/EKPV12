<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ include file="/sys/ftsearch/autocomplete_include.jsp" %>
<script>
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("calendar.js|dialog.js");


function checkParticipleUniqueness(participle,method){
	if(participle==null || participle=="")
		return null;
	$.ajax({
        url: "${KMSS_Parameter_ContextPath}sys/ftsearch/expand/sys_ftsearch_participle/sysFtsearchParticiple.do?method=checkParticipleUniqueness&participle="+encodeURI(participle)+"&fdId="+Com_GetUrlParameter(window.location.href, "fdId"),
        success: function(data) {
            if(data=="false"){
                alert("<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchParticiple.exist.error" />");
                return;
            }
            else
	            Com_Submit(document.sysFtsearchParticipleForm, method);
        }
	 });
}

</script>

<c:if test="${sysFtsearchParticipleForm.method_GET=='add'}">
	<script> 
		function checkCategoryParameter(){
		
			var categoryId = Com_GetUrlParameter(location.href, "docCategoryId");
			var version = Com_GetUrlParameter(location.href, "version");
			if(version == null){
				if(categoryId==null || categoryId==""){
			   		Dialog_Tree(false, null, null, null, 'sysFtsearchParticipleCategoryTreeService&parentId=!{value}', 
					'<bean:message bundle="sys-ftsearch-expand" key="table.sysFtsearchParticipleCategory"/>', null, afterCategorySelect, null, null,
					true);
				}
			}
		}
		function afterCategorySelect(rtnVal){
			if(rtnVal==null){
				Com_Parameter.CloseInfo = null;
				Com_CloseWindow();
			}else{
				location.href = Com_SetUrlParameter(location.href, "docCategoryId", rtnVal.GetHashMapArray()[0].id);
				 
			}
		}
		 checkCategoryParameter();
	</script>
</c:if>


<html:form action="/sys/ftsearch/expand/sys_ftsearch_participle/sysFtsearchParticiple.do">
<div id="optBarDiv">
	<c:if test="${sysFtsearchParticipleForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="checkParticipleUniqueness(document.getElementById('fdParticiple').value,'update');">
	</c:if>
	<c:if test="${sysFtsearchParticipleForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="checkParticipleUniqueness(document.getElementById('fdParticiple').value,'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="checkParticipleUniqueness(document.getElementById('fdParticiple').value,'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="sys-ftsearch-expand" key="table.sysFtsearchParticiple"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchParticiple.fdParticiple"/>
		</td><td width="35%">
				<xform:text property="fdParticiple" style="width:55%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchParticiple.fdCategory"/>
		</td>
		<td width="35%">
			<html:hidden property="docCategoryName"/>
			<c:out value="${sysFtsearchParticipleForm.docCategoryName}" />
		</td>
		
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchParticiple.docCreatorName"/>
		</td>
		<td width="35%">
			<html:hidden property="docCreatorName" />
			<c:out value="${sysFtsearchParticipleForm.docCreatorName}"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-ftsearch-expand" key="sysFtsearchParticiple.fdCreateTime"/>
		</td><td width="35%">
			<html:hidden property="docCreateTime" />
			<c:out value="${sysFtsearchParticipleForm.docCreateTime}" />
		</td>
		
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="fdExportState" />
<html:hidden property="method_GET" />
<script>
	Com_IncludeFile("calendar.js");
	$KMSSValidation();
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>