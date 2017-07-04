<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script language="JavaScript">Com_IncludeFile("data.js|dialog.js");</script>
<template:include ref="default.dialog">
<template:replace name="content">
<script type="text/javascript">
	window.onload = function(){
		setTimeout("initData()", 200);
	}

	//初始化数据
	function initData(){
		document.getElementsByName("fdName")[0].value = "${kmsKmapsMainForm.docSubject}";
		var docCategoryId = "${kmsKmapsMainForm.docCategoryId}";
		if( undefined != docCategoryId){
			document.getElementsByName("docCategoryId")[0].value = "${kmsKmapsMainForm.docCategoryId}";
		}
		document.getElementsByName("authEditorIds")[0].value = "${kmsKmapsMainForm.authEditorIds}";
		document.getElementsByName("authEditorNames")[0].value = "${kmsKmapsMainForm.authEditorNames}";
		document.getElementsByName("authReaderIds")[0].value = "${kmsKmapsMainForm.authReaderIds}";
		document.getElementsByName("authReaderNames")[0].value = "${kmsKmapsMainForm.authReaderNames}";
		document.getElementsByName("docContent")[0].value = "${kmsKmapsMainForm.docContent}";
		document.getElementsByName("fdDescription")[0].value = "${kmsKmapsMainForm.fdDescription}";
		
	}

	//保存
	function Kmaps_submit(){
		var fdName = document.getElementsByName("fdName")[0].value;
		var docCategoryId = document.getElementsByName("docCategoryId")[0].value;
		var authEditorIds = document.getElementsByName("authEditorIds")[0].value;
		var authEditorNames = document.getElementsByName("authEditorNames")[0].value;
		var authReaderIds = document.getElementsByName("authReaderIds")[0].value;
		var authReaderNames = document.getElementsByName("authReaderNames")[0].value;
		var docCategoryId  = document.getElementsByName("docCategoryId")[0].value;

		if(fdName == "" || fdName == null){
			seajs.use(['lui/dialog'], function(dialog) {
				dialog.alert("${lfn:message('kms-kmaps:kmsKmapsMain.docSubjectTip')}");
			});
			return false;
		}
		if(docCategoryId == "" || docCategoryId == null){
			seajs.use(['lui/dialog'], function(dialog) {
				dialog.alert("${lfn:message('kms-kmaps:kmsKmapsMain.categoryTip')}");
			});
			return false;
		}
		var fdDescription = document.getElementsByName("fdDescription")[0].value ;
		if('' != "${param.fdId}" && null != "${param.fdId}"){
			// 基础数据源
			var data = {
					"fdName" : fdName,
					"fdDescription" :  fdDescription ,
					"docCategoryId" :docCategoryId ,
					"docContent" : document.getElementsByName("docContent")[0].value ,
					"authEditorIds":authEditorIds,
					"authEditorNames" : authEditorNames,
					"authReaderIds" : authReaderIds ,
					"authReaderNames" : authReaderNames
					
			};
			  LUI.$.ajax({
	                 url : "<c:url value='/kms/kmaps/kms_kmaps_template/kmsKmapsTemplate.do' />?method=save&mainFdId=${param.fdId}" ,
	                 data:data,
	                 cache : false,  
	                 dataType : "json",
	                 async : false, 
	                 type : "POST",
	                 success : function (result){
		                 seajs.use(['lui/dialog'],function(lui,dialog) {
	                		 $dialog.hide(result);
		                 });
	                 },
	                 error : function(error) {
	         			alert("error");
	         		} 
	           });
			
		}
		return true;
	} 


	function kmsKmaps_AfterCategorySelect(rtnObj) {//选择类别更新可阅读者
		 var kmssData = new KMSSData(); 
	     if('${kmsKmapsMainForm.method_GET}' == 'add'){ 
		 kmssData.AddBeanData("kmsKmapsTemplCategoryDropListService&docCategoryId="+rtnObj.value);  
		 kmssData.PutToField("authReaderIds:authReaderNames:authEditorIds:authEditorNames"
					, "authReaderIds:authReaderNames:authEditorIds:authEditorNames"); 
	     }
	}
</script>
<html:form action="/kms/kmaps/kms_kmaps_template/kmsKmapsTemplate.do?mainFdId=${param.fdId}" > 
<div style="float:right;margin:-10px 15px 0px">
	<ui:button text="${lfn:message('button.save') }"onclick="Kmaps_submit();"></ui:button>
	<ui:button style="padding-left:10px"  text="${lfn:message('button.cancel') }" styleClass="lui_toolbar_btn_gray" onclick="Com_CloseWindow();"></ui:button>
</div>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<%--标题--%>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="kms-kmaps" key="kmsKmapsMain.docSubject"/>
		</td>
		<td width=85%>
			<html:text property="fdName" styleClass="inputsgl"  style="width:80%"/>
			<span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<%--描述--%>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="kms-kmaps" key="kmsKmapsTemplate.fdDescription"/>
		</td>
		<td width=85%>
			<html:textarea property="fdDescription" style="width:85%;height:50"  rows="10"  styleClass="inputmul"/>
		</td>
	</tr>
	<tr>
		<%--所属类别--%>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="kms-kmaps" key="kmsKmapsMain.docCategoryId"/>
		</td>
		<td width=85%> 
			<xform:select property="docCategoryId" showStatus="edit"  required="true" showPleaseSelect="false"
			htmlElementProperties="onchange=\"kmsKmaps_AfterCategorySelect(this)\"" >
				<xform:beanDataSource serviceBean="kmsKmapsTemplCategoryService"  orderBy="kmsKmapsTemplCategory.fdOrder" />
			</xform:select>
		</td>
	</tr>	
	<tr><%--可维护者--%>
		<td class="td_normal_title" width=15%>
			<bean:message bundle="sys-right" key="right.edit.authEditors" />
		</td>
		<td width=85% >
			<xform:address showStatus="edit" textarea="true" mulSelect="true" propertyId="authEditorIds" propertyName="authEditorNames" style="width:85%;height:70px;" ></xform:address>	 
			<br>
			<span class="com_help"><bean:message bundle="sys-right" key="right.read.authEditors.note" /></span>
		</td>
	</tr>
	
	<tr>
		<%--可阅读者--%>
		<td class="td_normal_title" width=15%>
			 <bean:message bundle="sys-right" key="right.read.authReaders" />
		</td>
		<td width=85%>
			<xform:address showStatus="edit" textarea="true" mulSelect="true" propertyId="authReaderIds" propertyName="authReaderNames" style="width:85%;height:70px;" ></xform:address>
			<br>
			<span class="com_help"><bean:message bundle="sys-right" key="right.read.authReaders.note" /></span>
		</td>
	</tr>  
</table>
<html:hidden property="docContent"/>
</center>
</html:form>
</template:replace>
</template:include>
