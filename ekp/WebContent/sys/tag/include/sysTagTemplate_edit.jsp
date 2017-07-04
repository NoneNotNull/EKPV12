<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysTagTemplate_Key" value="${param.fdKey}" />
<c:set var="sysTagTemplateFormPrefix"
	   value="sysTagTemplateForms.${param.fdKey}." />
<c:set var="sysTagTemplateForm"
	   value="${requestScope[param.formName].sysTagTemplateForms[param.fdKey]}" />
<Script type="text/javascript">
	function afterSelectValue(rtnVal){
		if(rtnVal==null)
			return;
		var names=document.getElementsByName("${sysTagTemplateFormPrefix}fdTagNames")[0].value;
		var ids=document.getElementsByName("${sysTagTemplateFormPrefix}fdTagIds")[0].value;	
		var nameStr=new Array();
		nameStr=names.split(" ");
		var name='';
		var id='';
		for(var i=0;i<rtnVal.GetHashMapArray().length;i++){
			var newName=rtnVal.GetHashMapArray()[i]['name'];
			var newId=rtnVal.GetHashMapArray()[i]['id'];
			if(i==0){
				if(names==''){
					name=newName;
					id=newId;
				}else{
					//如果有原值，则判断原值中是否已存在此标签名，如果不存在，则添加
					var isExist=1;
					for(var j=0;j<nameStr.length;j++){
						var oldName=nameStr[j];
						if(newName==oldName){
							isExist=0;
						}
					}
					if(isExist==1){
						name=newName;
						id=newId;
					}
				}
				
			}else{
				if(names==''){
					name=name+' '+newName;
					id=id+' '+newId;
				}else{
					var isExist=1;
					for(var j=0;j<nameStr.length;j++){
						var oldName=nameStr[j];
						if(newName==oldName){
							isExist=0;
						}
					}
					if(isExist==1){
						name=name+' '+newName;
						id=id+' '+newId;
					}
				}
				
 			}
		}
		document.getElementsByName("${sysTagTemplateFormPrefix}fdTagNames")[0].value=names+' '+name;
		document.getElementsByName("${sysTagTemplateFormPrefix}fdTagIds")[0].value=ids+' '+id;
	}
</Script>

<tr>
	<html:hidden property="${sysTagTemplateFormPrefix}fdId"/> 
	<html:hidden property="${sysTagTemplateFormPrefix}fdKey" value="${param.fdKey}"/>
	<html:hidden property="${sysTagTemplateFormPrefix}fdModelName"/>
	<html:hidden property="${sysTagTemplateFormPrefix}fdModelId"/> 
	<td class="td_normal_title" width=15% nowrap>
		<bean:message bundle="sys-tag" key="table.sysTagTags"/>
	</td>
	<td colspan="3">
		<html:hidden property="${sysTagTemplateFormPrefix}fdTagIds"/> 
		<html:text property="${sysTagTemplateFormPrefix}fdTagNames" styleClass="inputsgl" style="width:85%"/>
		<a href="#" onclick="Dialog_Tree(true,null,null,' ','sysTagCategorApplicationTreeService&fdCategoryId=!{value}','<bean:message key="sysTagTag.tree" bundle="sys-tag"/>',false,afterSelectValue,null,false,true,null)"><bean:message key="dialog.selectOther"/></a>
	</td>
</tr>
