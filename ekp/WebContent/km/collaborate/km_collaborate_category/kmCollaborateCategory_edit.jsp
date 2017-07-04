<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<style>
<!--
.notNull{padding-left:10px;border:solid #DFA387 1px;padding-top:8px;padding-bottom:8px;background:#FFF6D9;color:#C30409;margin-top:3px;}
-->
</style>
<script>
	Com_IncludeFile("jquery.js");
</script>
<html:form action="/km/collaborate/km_collaborate_category/kmCollaborateCategory.do">
<div id="optBarDiv">
	<c:if test="${kmCollaborateCategoryForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="commitMethod('update');">
	</c:if>
	<c:if test="${kmCollaborateCategoryForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="commitMethod('save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="commitMethod('saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle"><bean:message bundle="km-collaborate" key="table.kmCollaborateCategory.tilte"/></p>

<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-collaborate" key="kmCollaborateCategory.fdName"/>
		</td><td colspan="3">
			<c:if test="${!(kmCollaborateCategoryForm.method_GET=='edit')}">
				<xform:text property="fdName" style="width:85%" onValueChange="isSameName();" />
			</c:if>
			<c:if test="${kmCollaborateCategoryForm.method_GET=='edit'}">
				<xform:text property="fdName" style="width:85%" onValueChange="isSameName();"/>
			</c:if>
			<div class="notNull" id="fdName">×&nbsp;&nbsp;&nbsp;<bean:message bundle="km-collaborate" key="kmCollaborateMain.fdName.issame"/></div>
		</td>
		
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-collaborate" key="kmCollaborateCategory.fdOrder"/>
		</td><td width="35%">
			<xform:text property="fdOrder" style="width:85%" />
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="km-collaborate" key="kmCollaborateCategory.fdDeleted"/>
		</td><td width="35%">
			<c:if test="${kmCollaborateCategoryForm.method_GET=='add'}">
				<xform:radio property="fdDeleted" value="true" >
					<xform:enumsDataSource enumsType="common_yesno" />
				</xform:radio>
			</c:if>
			<c:if test="${!(kmCollaborateCategoryForm.method_GET=='add')}">
				<xform:radio property="fdDeleted" value="${fdDeleted}" onValueChange="placeNull();">
					<xform:enumsDataSource enumsType="common_yesno" />
				</xform:radio>
			</c:if>
			<div class="notNull" id="fdRadio">×&nbsp;&nbsp;&nbsp;<bean:message bundle="km-collaborate" key="kmCollaborateMain.fdRadio.isNotNull"/></div>
		</td>
	</tr>
</table>
</center>
<html:hidden property="fdId" />
<html:hidden property="method_GET" />
<script>
	$(function() {
		$("#fdName").hide();
		$("#fdRadio").hide();
	});
	function isSameName(){
		var fdName = $("input[name='fdName']").val();
		$.getJSON('<c:url value="/km/collaborate/km_collaborate_category/kmCollaborateCategory.do?method=isSameName"/>',{'fdName':fdName},function(data){
			if(data.success){
				$("#fdName").show();
			}else{
				$("#fdName").hide();
			}
		});
	}
	$KMSSValidation();
	function commitMethod(method){
		if($("#fdName").is(":hidden") && $("#fdRadio").is(":hidden")){
			Com_Submit(document.kmCollaborateCategoryForm, method);
		}
	}
	function placeNull(){
		var fdId = '${param.fdId}';
		var fdRadio = $("input:checked").val();
		
		// 如果选择为是，则隐藏div，若为否，则判断分类中是否存在，若不存在，则隐藏。
		$.getJSON('<c:url value="/km/collaborate/km_collaborate_category/kmCollaborateCategory.do?method=fdDeleted"/>',{'fdId':fdId,'fdRadio':fdRadio},function(data){
			if(data.success){
				$("#fdRadio").show();
			}else{
				$("#fdRadio").hide();
			}
		}); 
	}
</script>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>