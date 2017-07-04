<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>Com_IncludeFile("dialog.js|jquery.js");</script>
<html:form action="/km/imeeting/km_imeeting_res_category/kmImeetingResCategory.do">
	<div id="optBarDiv">
		<c:import url="/sys/simplecategory/sys_simple_category/sysCategoryMain_edit_button.jsp" charEncoding="UTF-8">
			<c:param name="formName" value="kmImeetingResCategoryForm" />
		</c:import>
	</div>
	<p class="txttitle"><bean:message bundle="km-imeeting" key="table.kmImeetingResCategory"/></p>
	<center>
		<table class="tb_normal" width=95%>
			<c:import url="/sys/simplecategory/sys_simple_category/sysCategoryMain_edit_body.jsp" charEncoding="UTF-8">
				<c:param name="formName" value="kmImeetingResCategoryForm" />
				<c:param name="requestURL" value="km/imeeting/km_imeeting_res_category/kmImeetingResCategory.do?method=add" />
				<c:param name="fdModelName" value="com.landray.kmss.km.imeeting.model.KmImeetingResCategory" />
			</c:import>
		</table>
	</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	var validation=$KMSSValidation();
	var kmImeetingResCategoryFdName='<bean:message key="kmImeetingResCategory.fdName" bundle="km-imeeting"/>';
	validation.addValidator("kmImeetingResCategoryRequired",
		'<bean:message key="errors.required" arg0="'+kmImeetingResCategoryFdName+'"/>',
		function(v, e, o){
			if($('input[name="fdName"]').val()){
				return true;
			}else{
				return false;
			}
		});
	$('input[name="fdName"]').attr("validate","kmImeetingResCategoryRequired");
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>