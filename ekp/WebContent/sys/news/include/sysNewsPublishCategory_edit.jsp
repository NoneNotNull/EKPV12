<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysNPCategory_Key" value="${param.fdKey}" />
<c:set var="sysNPCategoryFormPrefix" value="sysNewsPublishCategoryForms.${param.fdKey}." />
<c:set var="sysNPCategoryForm" value="${requestScope[param.formName].sysNewsPublishCategoryForms[param.fdKey]}" />
<tr 
	<c:if test="${empty param.messageKey}">
		LKS_LabelName='<kmss:message key="sys-news:sysNewsPublishMain.tab.publish.label"/>'
	</c:if>
	<c:if test="${not empty param.messageKey}">
		LKS_LabelName='<kmss:message key="${param.messageKey}"/>'
	</c:if>
>
<td>
	<table class="tb_normal" width=100% id="TB_SysNPCategory_${sysNPCategory_Key}">
	<html:hidden property="${sysNPCategoryFormPrefix}fdId"/> 
	<html:hidden property="${sysNPCategoryFormPrefix}fdKey" value="${param.fdKey}"/>
	<html:hidden property="${sysNPCategoryFormPrefix}fdModelName"/>
	<html:hidden property="${sysNPCategoryFormPrefix}fdModelId"/> 
	<tr>
		<td class="td_normal_title" width=15% nowrap>
			<bean:message  bundle="sys-news" key="sysNewsPublishCategory.fdIsAutoPublish"/>
		</td>
		<td width=35% colspan=3 nowrap id='isAuto'> 
			<sunbor:enums  property="${sysNPCategoryFormPrefix}fdIsAutoPublish" elementType="radio"  enumsType="common_yesno" 
			htmlElementProperties="onclick=SNP_ChgDisplay('${sysNPCategory_Key}')" />
			<html:hidden  property="${sysNPCategoryFormPrefix}fdIsAutoPublish"/>
		</td>
	</tr> 	
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-news" key="sysNewsPublishCategory.fdIsFlow"/>
		</td>
		<td width=35% colspan=3>
			<sunbor:enums  property="${sysNPCategoryFormPrefix}fdIsFlow" elementType="radio"  enumsType="common_yesno" />
		</td>
	</tr>
	<tr >
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-news" key="sysNewsPublishCategory.fdCategoryId"/>
		</td>
		<td width=35%>
			<html:hidden property="${sysNPCategoryFormPrefix}fdCategoryId"/> 
			<html:text property="${sysNPCategoryFormPrefix}fdCategoryName" readonly="true" styleClass="inputsgl"
				/> 				
			 <a href="#" id="A_SNP_Category_${sysNPCategory_Key}"
						onclick="Dialog_SimpleCategoryForNewFile('com.landray.kmss.sys.news.model.SysNewsTemplate',
						'${sysNPCategoryFormPrefix}fdCategoryId::${sysNPCategoryFormPrefix}fdCategoryName',false,true,null);">
						<bean:message
						key="dialog.selectOther" /></a>
						
									
			<a href="#"  onclick="SNP_clearCategory('${sysNPCategory_Key}')"/><bean:message  bundle="sys-news" key="sysNewsPublishCategory.clearCategory"/></a>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-news" key="sysNewsPublishCategory.fdIsModify"/>
		</td>
		<td width=35%>
			<sunbor:enums  property="${sysNPCategoryFormPrefix}fdIsModifyCate" elementType="radio"  enumsType="common_yesno" 
			htmlElementProperties="onclick=SNP_ChgCategory('${sysNPCategory_Key}')"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-news" key="sysNewsPublishCategory.fdImportance"/>
		</td>
		<td width=35%>
			<sunbor:enums  property="${sysNPCategoryFormPrefix}fdImportance" elementType="radio"  enumsType="sysNewsMain_fdImportance" bundle="sys-news"/>
		</td>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="sys-news" key="sysNewsPublishCategory.fdIsModify"/>
		</td>
		<td width=35%>
			<sunbor:enums  property="${sysNPCategoryFormPrefix}fdIsModifyImpor" elementType="radio"  enumsType="common_yesno" />
		</td>
	</tr>  
	</table>
</td> 
</tr>

<script type="text/javascript">
 //页面加载显示表格
Com_AddEventListener(window,"load",function(){
	 var key = "${sysNPCategory_Key}";
	 var isAutoPubliush = $('input[name=sysNewsPublishCategoryForms\\.'+key+'\\.fdIsAutoPublish][type=hidden]').val(); 
     SNP_ChgDisplay(key,isAutoPubliush==="true");
}); 
 
//根据是否自动发布的显示表格
function SNP_ChgDisplay(key,isAutoPubliush){;
	var fdIsAutoPublish=$('input[name=sysNewsPublishCategoryForms\\.'+key+'\\.fdIsAutoPublish][type=radio]');
	if(isAutoPubliush!==undefined){
		fdIsAutoPublish[0].checked = isAutoPubliush;
		fdIsAutoPublish[1].checked = !isAutoPubliush;
	}
	var tbObj = document.getElementById("TB_SysNPCategory_"+key);  
	if(!fdIsAutoPublish[0].checked){ 
		for(var i=1; i<tbObj.rows.length; i++) {
	 
			tbObj.rows[i].style.display = "none";
		}  
		tbObj.rows[0].cells[1].style.width='85%';
	}
	else{  
	      for(var i=0; i<tbObj.rows.length ; i++) {
			tbObj.rows[i].style.display = "";
		} 
	}  
} 

//根据是否修改分类
function SNP_ChgCategory(key){
	var fdCategoryId= document.getElementsByName('sysNewsPublishCategoryForms.'+key+'.fdCategoryId')[0];
	var fdCategoryName=document.getElementsByName('sysNewsPublishCategoryForms.'+key+'.fdCategoryName')[0];
	var fdIsAutoPublish=document.getElementsByName('sysNewsPublishCategoryForms.'+key+'.fdIsAutoPublish')[0];
	var fdIsModifyCate=document.getElementsByName('sysNewsPublishCategoryForms.'+key+'.fdIsModifyCate')[0];
	if(fdIsAutoPublish.checked&&!fdIsModifyCate.checked&&fdCategoryId.value==""){
	//如果类别为空则必须允许起草人修改  
	alert("<bean:message  bundle="sys-news" key="sysNewsPublishCategory.fdCheckCategory"/>");
	document.getElementsByName('sysNewsPublishCategoryForms.'+key+'.fdIsModifyCate')[0].checked=true;
	document.getElementsByName('sysNewsPublishCategoryForms.'+key+'.fdIsModifyCate')[1].checked=false;
}
}
//清空分类
function SNP_clearCategory(key){
	 document.getElementsByName('sysNewsPublishCategoryForms.'+key+'.fdCategoryId')[0].value=""; 
	 document.getElementsByName('sysNewsPublishCategoryForms.'+key+'.fdCategoryName')[0].value="";  
}  
 </script> 
 