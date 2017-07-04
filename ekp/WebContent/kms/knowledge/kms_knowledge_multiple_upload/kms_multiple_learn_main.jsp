<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit" sidebar="no">
    <template:replace name="head">
    	<%@ include file="/kms/knowledge/kms_knowledge_multiple_upload/kms_multiple_learn_main_js.jsp"%>  
    	<script>
			seajs.use(['theme!form']);
		</script>
    </template:replace>
    <%-- 当前路径 --%>
	<template:replace name="path">
		<ui:combin ref="menu.path.simplecategory">
			<ui:varParams 
				id="simplecategoryId"
				modelName="${kmsMultipleUploadMainForm.fdCategoryModelName}" 
				moduleTitle="${kmsMultipleUploadMainForm.title}"
				href="${kmsMultipleUploadMainForm.modelPath}"
				categoryId="${kmsMultipleUploadMainForm.fdCategoryId }"
				autoFetch="false"
				
			/>
		</ui:combin>
	</template:replace>
   <template:replace name="content"> 
     <html:form action="/kms/knowledge/kms_knowledge_multiple_upload/kmsMultipleUploadMain.do?method=saveDoc">
        <html:hidden property="attIdAndAttNameJson"  value=""/>
        <html:hidden property="fdCategoryId" value="${kmsMultipleUploadMainForm.fdCategoryId}"/>
        <html:hidden property="fdCategoryName" value="${kmsMultipleUploadMainForm.fdCategoryName}"/>
        <html:hidden property="fdKey"  value="${kmsMultipleUploadMainForm.fdKey}"/>
        <html:hidden property="modelClassName" value="${kmsMultipleUploadMainForm.modelClassName}"/>
        <html:hidden property="fdCategoryModelName" value="${kmsMultipleUploadMainForm.fdCategoryModelName}"/>
        <html:hidden property="fdDocAddIds" value=""/>
        <html:hidden property="fdAttIdsJson" value=""/>
        <html:hidden property="fdDelIds" value=""/>
        <html:hidden property="batchIdJson" value=""/>
        <html:hidden property="categoryIndicateName" value="${kmsMultipleUploadMainForm.categoryIndicateName}"/>
	   	<table class="tb_simple" width=100%>
			<tr style="width: 100%"> 
			   <td>
				 <c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
				 	<c:param name="fdMulti" value="false" />
				     <c:param name="fdKey" value="${kmsMultipleUploadMainForm.fdKey}"/>
					 <c:param name="fdModelName" value="${kmsMultipleUploadMainForm.modelClassName}"/>
					 <c:param name="extParam" value="{'thumb':[{'name':'s1','w':'500','h':'500'},{'name':'s2','w':'2250','h':'1695'}]}" />
				</c:import> 
			 </td>
		 </tr> 
	   </table>  
     </html:form>
     
   </template:replace>
 </template:include>