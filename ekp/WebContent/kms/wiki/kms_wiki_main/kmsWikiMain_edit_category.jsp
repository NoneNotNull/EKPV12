<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
Com_IncludeFile("doclist.js|dialog.js|data.js");


function submitForm(method, status){
	var oldCateogryId = "${kmsWikiMainForm.fdCategoryId}";
	var fdCategoryId = document.getElementsByName("fdCategoryId")[0].value;
	if(fdCategoryId==''){
		alert("分类不能为空，请选择分类。");
	}else if(fdCategoryId == oldCateogryId){
		alert("新分类与旧分类相同，请重新选择。");
	}else{
		Com_Submit(document.kmsWikiMainForm, method, 'fdCategoryId:fdCategoryName');
	}
}

function seclectCategory(){
	Dialog_Tree(true, 'fdCategoryId', 'fdCategoryName',';', 'kmsWikiCategoryTree&selectId=!{value}', '<bean:message bundle="kms-wiki" key="kmsWikiMain.fdCategoryList"/>', null, null, '${param.fdId}', null, null, '<bean:message key="dialog.title.allCategory" bundle="kms-wiki"/>');
	var fdCategoryId = document.getElementsByName("fdCategoryId")[0].value;
	var fdCategoryIdArr = fdCategoryId.split(";"); 
	if(fdCategoryIdArr.length>3){
		alert("注意分类不能超过三个");
		document.getElementsByName("fdCategoryId")[0].value="";
		document.getElementsByName("fdCategoryName")[0].value="";
		return false;
	}
}
</script>
<html:form action="/kms/wiki/kms_wiki_main/kmsWikiMain.do">
	<div id="optBarDiv">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="submitForm('updateCategory', 'false');"> 
		<input type="button" value="<bean:message key="button.close"/>"
			onclick="Com_CloseWindow();">
	</div>
		<p class="txttitle"><bean:message bundle="kms-wiki"
			key="kmsWikiMain.btn.editCategory" />
		</p>
		<center>
		<html:hidden property="fdFirstId"/>
		<div id="a1" style="display: none; position: absolute; top: 100px; right: 80px;">
		</div>
			<table class="tb_normal" width="98%"> 
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="kms-wiki" key="kmsWikiMain.btn.editCategory" />
					</td> 
					<td width=35% colspan="3">
						<html:hidden property="fdCategoryId"/>
						<html:text property="fdCategoryName" style="width:80%" readonly="true" styleClass="inputsgl" /> 
						<a href="#" id="selectAreaNames" onclick="seclectCategory();">[<bean:message key="dialog.selectOther" />]</a>
					</td>
				</tr> 
   			</table> 
		<div name="temp"></div>
		</center>
<html:hidden property="method_GET" />
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>