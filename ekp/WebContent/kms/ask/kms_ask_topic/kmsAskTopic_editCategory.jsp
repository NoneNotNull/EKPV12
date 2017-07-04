<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--调整分类--%>
<%@ include file="/resource/jsp/edit_top.jsp"%>  
<script>
	Com_IncludeFile("dialog.js|data.js");
</script>
<script>
//选择知识领域类别
function openCategoryWindow(){ 
  Dialog_Tree(false, 'fdKmsAskCategoryId', 'fdKmsAskCategoryName', ';', 'kmsAskCategoryTreeService&selectId=!{value}', '<bean:message key="dialog.tree.title" bundle="kms-ask"/>', null, null, '${param.fdId}', null, null, '<bean:message key="dialog.tree.title" bundle="kms-ask"/>');
}
function kmsAsk_Com_Submit(type){
	var fdKmsAskCategoryId=document.getElementsByName('fdKmsAskCategoryId')[0].value;
	if(fdKmsAskCategoryId==null||fdKmsAskCategoryId==""){ 
		alert("类别不可为空！");
		return false;
	} 
	Com_Submit(document.kmsAskTopicForm,type);
	return true;
} 

</script>
<html:form action="/kms/ask/kms_ask_topic/kmsAskTopic.do"  >
<div id="optBarDiv">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="return kmsAsk_Com_Submit('updateCategory');">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div> 
<center> 
	<table class="tb_normal" width="98%">  
		<tr> 
			<td class="td_normal_title" width=15%>
				所属分类
			</td> 
			<td width=35% colspan="3">
				<html:hidden property="fdId" value="${param.fdId }"/>
				<html:hidden property="fdKmsAskCategoryId" value="${fdKmsAskCategoryId }"/>
				<html:text property="fdKmsAskCategoryName" style="width:80%" readonly="true"  styleClass="inputsgl" value = "${fdKmsAskCategoryName }" />
		          <span class="txtstrong">*</span>
		          <a href="#" id="selectAreaNames" onclick="openCategoryWindow();"><bean:message key="dialog.selectOther" /></a>	 
			     <br>
			</td>
		</tr> 
	</table> 
</center>
<html:hidden property="method_GET"/>
</html:form>
<%@ include file="/resource/jsp/edit_down.jsp"%>
