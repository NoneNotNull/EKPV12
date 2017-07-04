<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>

<c:set var="sysTagMainForm" value="${requestScope[param.formName].sysTagMainForm}" />
<c:set var="useTab" value="true"></c:set>
<c:if test="${param.useTab!=null && param.useTab==false}">
	<c:set var="useTab" value="false"></c:set>
</c:if>
<%-- 有表格的情况 --%>
<c:if test="${useTab==true && not empty sysTagMainForm.fdTagNames}">
	<tr>
		<td class="td_normal_title" width=15% nowrap>
			<image src="${LUI_ContextPath}/sys/tag/images/tag.png">&nbsp;<bean:message bundle="sys-tag" key="table.sysTagTags"/>
		</td>
		<td colspan="3">
			${sysTagMainForm.fdTagNames}
		</td>
	</tr>
</c:if>
<%-- 无表格的情况 --%>
<c:if test="${useTab!=true && not empty sysTagMainForm.fdTagNames}">
	<script type="text/javascript">
		var tag_params = {
			"model":"view",
			"fdTagNames":"${sysTagMainForm.fdTagNames}"
			};
		Com_IncludeFile("jquery.js");
		Com_IncludeFile("tag.js","${KMSS_Parameter_ContextPath}sys/tag/resource/js/","js",true);
	</script>
	<script type="text/javascript">
		if(window.tag_opt==null){
			window.tag_opt = new TagOpt('${sysTagMainForm.fdModelName}','${sysTagMainForm.fdModelId}','',tag_params);
		}
		Com_AddEventListener(window,'load',function(){
			window.tag_opt.onload(); 
		});
	</script>
	<div class="tag_area">
		<div class="tag_title">
		  	<image src="${LUI_ContextPath}/sys/tag/images/tag.png">&nbsp;<bean:message bundle="sys-tag" key="sysTagTags.title"/>
		</div>
		<div class="tag_content"></div>
	</div>
</c:if>


