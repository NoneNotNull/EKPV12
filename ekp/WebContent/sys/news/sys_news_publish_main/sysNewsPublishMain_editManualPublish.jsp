<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.dialog">
	<template:replace name="content">	
<script language="JavaScript">
	Com_IncludeFile("dialog.js");
</script>
<script language="JavaScript">
seajs.use(['lui/dialog'],function(dialog) {
	//提交验证新闻类别不可为空
	window.SNP_validateForm=function (){
	var fdCategoryId=document.getElementsByName("fdTemplateId")[0].value;
		if(fdCategoryId==null||fdCategoryId==""){
			dialog.alert("${lfn:message('sys-news:sysNewsPublishMain.checkCategory')}");
		return false;
		}
		return true;
	 }
	});

 
</script>
<html:form action="/sys/news/sys_news_main/sysNewsMain.do" onsubmit="return SNP_validateForm();">
<hr>
<center>
<p class="txttitle">
<bean:message  bundle="sys-news" key="sysNewsPublishMain.fdTitle"/></p>
<table class="tb_normal" width=95%>
 	<html:hidden property="fdId" />
 	<html:hidden property="fdKey" value="${fdKeyParam}"/>
    <html:hidden property="fdModelId" value="${fdModelIdParam}"/>
	<html:hidden property="fdModelName" value="${fdModelNameParam}"/>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-news" key="sysNewsPublishCategory.fdCategoryId"/>
		</td>
		<td width=35%>			
			<html:hidden property="fdTemplateId"/>			
			<div class="inputselectsgl"  style="width:90%">
			   <div class="input">
			       <html:text property="fdTemplateName" readonly="true" styleClass="" onclick="Dialog_SimpleCategoryForNewFile('com.landray.kmss.sys.news.model.SysNewsTemplate',
											'fdTemplateId::fdTemplateName',false,true,null);"/> 		
				</div>
				<div class="selectitem" id="tag_selectItem" onclick="Dialog_SimpleCategoryForNewFile('com.landray.kmss.sys.news.model.SysNewsTemplate',
								'fdTemplateId::fdTemplateName',false,true,null);">
				</div>
		    </div>		
			<span class="txtstrong">*</span>	
		 </td>
		<td class="td_normal_title" width=17%>
			<bean:message  bundle="sys-news" key="sysNewsPublishCategory.fdImportance"/>
		</td>
		<td width=35%> 
			<sunbor:enums  property="fdImportance" elementType="radio"  enumsType="sysNewsMain_fdImportance" bundle="sys-news"/>
	  </td> 
	</tr>
	 
	<c:if test="${not empty listPublishRecord}" > 
	<tr>
	<td colspan=4 >
		<table id="List_ViewTable"  class="tb_normal" width=100%>
		<tr>
		 <td colspan=6>		
			<bean:message  bundle="sys-news" key="sysNewsPublishMain.newsRecord"/>
		</td>
		</tr>
		<tr>   
			<td width="40pt"><bean:message key="page.serial" /></td> 
			<td><bean:message  bundle="sys-news" key="sysNewsPublishMain.submitor"/></td>
			<td><bean:message  bundle="sys-news" key="sysNewsPublishMain.subTime"/></td>			
			<td><bean:message  bundle="sys-news" key="sysNewsPublishMain.fdCayegoryName"/></td>
			<td><bean:message  bundle="sys-news" key="sysNewsPublishMain.docStatus"/></td> 
		</tr>
		<c:forEach
				items="${listPublishRecord}"
				var="sysNewsMain"
				varStatus="vstatus"> 
		<tr> 
			 <td>${vstatus.index+1}</td>	 
			 <td>${sysNewsMain.docCreator.fdName}</td>
			 <td><kmss:showDate value="${sysNewsMain.docCreateTime}"  type="datetime" /></td>
			 <td>${sysNewsMain.fdTemplate.fdName}</td>
			 <td><sunbor:enumsShow  value="${sysNewsMain.docStatus}" enumsType="common_status" /></td>
		</tr>
		</c:forEach> 
		</table>
		</td>
		</tr>
    </c:if>
</table>
<div id="optBarDiv" style="padding-top:17px">
	    <ui:button  text="${lfn:message('button.update') }"onclick="Com_Submit(document.sysNewsMainForm, 'manualPublishAdd');"></ui:button>
        <ui:button style="padding-left:5px" text="${lfn:message('button.close') }" styleClass="lui_toolbar_btn_gray" onclick="Com_CloseWindow();"></ui:button>
</div>
</center>
<html:hidden property="method_GET"/>
</html:form> 
</template:replace>
</template:include>