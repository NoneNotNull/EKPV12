<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script>Com_IncludeFile("data.js|dialog.js");</script>
<style>
	#a_close{
	link   {color:#190552;   text-decoration:none}  
	active   {color:#190552;   text-decoration:none}  
	visited   {color:#29098A;   text-decoration:none}  
	hover   {color:#29098A;   text-decoration:underline}
	}
</style>
<Script type="text/javascript">
	function afterSelectValue(rtnVal){
		if(rtnVal==null)
			return;
		var names=document.getElementsByName("sysTagMainForm.fdTagNames")[0].value;
		var ids=document.getElementsByName("sysTagMainForm.fdTagIds")[0].value;	
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
		document.getElementsByName("sysTagMainForm.fdTagNames")[0].value=names+' '+name;
		document.getElementsByName("sysTagMainForm.fdTagIds")[0].value=ids+' '+id;
	}
</Script>

<script language="JavaScript">
	function submitTagApp(){
		var queryConditionName = '${param.fdQueryCondition}';
		var queryConditionNames = queryConditionName.split(";");
		var queryCondition = "";
		for(var i = 0; i < queryConditionNames.length; i++){
			var condition = queryConditionNames[i];
			var conditionObj = document.getElementsByName(condition);
			if(conditionObj != null){
				queryCondition = queryCondition + conditionObj[0].value+";";
				
			}
		}
		document.getElementsByName("sysTagMainForm.fdQueryCondition")[0].value=queryCondition;
	}
	function showTagApplication(param){
		var divObj = document.getElementById("id_application_div");
		var queryCondition = '';
		var queryConditionName = '${param.fdQueryCondition}';
		var queryConditionNames = queryConditionName.split(";");
		for(var i = 0; i < queryConditionNames.length; i++){
			var condition = queryConditionNames[i];
			var conditionObj = document.getElementsByName(condition);
			if(conditionObj != null){
				queryCondition = queryCondition + conditionObj[0].value+";";
				
			}
		}
		document.getElementsByName("sysTagMainForm.fdQueryCondition")[0].value=queryCondition;
		var modelName = '${param.modelName}';
		var kmssData = new KMSSData(); 
		kmssData.AddBeanData("sysTagApplicationLogSupplyService&queryCondition="+queryCondition+"&modelName="+modelName);
		var templetData=kmssData.GetHashMapArray();		
		if(templetData.length > 0){	
			var hotTitle = templetData[0]['hotTitle'];
			document.getElementById("hot_id").innerHTML = "<font size='2px' color='red'><b><bean:message bundle='sys-tag' key='sysTagMain.message.1'/></b></font> "+hotTitle;
			var usedTitle = templetData[1]['usedTitle'];
			document.getElementById("used_id").innerHTML = "<font size='2px' color='red'><b><bean:message bundle='sys-tag' key='sysTagMain.message.2'/></b></font> "+usedTitle;
		}
		if(param == true){
			divObj.style.display = "";
		}else{
			divObj.style.display = "none";
		}
		
	}
	function onSelectValue(obj){
		var tagObj = document.getElementsByName("sysTagMainForm.fdTagNames")[0];
		var obj_value = tagObj.value;
		var position = obj_value.indexOf(obj.childNodes[0].nodeValue);
		if(position >= 0){
			if(position == 0){
				if(position+obj.childNodes[0].nodeValue.length == obj_value.length){
					return false;
				}else if(obj_value.charAt(position+obj.childNodes[0].nodeValue.length) == " "){
					return false;
				}
			}else{
				if(obj_value.charAt(position-1)== " " ){
					if(position+obj.childNodes[0].nodeValue.length == obj_value.length){
						return false;
					}else if(obj_value.charAt(position+obj.childNodes[0].nodeValue.length) == " "){
						return false;
					}
				}
			}
		}
		if(obj_value != ''){
			obj_value = obj_value + " " + obj.childNodes[0].nodeValue ;
		}else{
			obj_value = obj_value + obj.childNodes[0].nodeValue;
		}
		tagObj.value = obj_value;
	}
</script>
<c:set var="sysTagMainForm" value="${requestScope[param.formName].sysTagMainForm}" />
 
	<html:hidden property="sysTagMainForm.fdId"/> 
	<html:hidden property="sysTagMainForm.fdKey" value="${param.fdKey}"/>
	<html:hidden property="sysTagMainForm.fdModelName"/>
	<html:hidden property="sysTagMainForm.fdModelId"/> 
	<html:hidden property="sysTagMainForm.fdQueryCondition"/> 
	 
	 
		<input type="hidden" name="sysTagMainForm.fdTagIds" />
		<html:text property="sysTagMainForm.fdTagNames" styleClass="i_l m_r5"  onfocus="showTagApplication(true);"  />
		
		<span class="btn_g">
		 <a href="#" onclick="Dialog_Tree(true,null,null,' ','sysTagCategorApplicationTreeService&fdCategoryId=!{value}','<bean:message key="sysTagTag.tree" bundle="sys-tag"/>',false,afterSelectValue,null,false,true,null)">
		 <span><bean:message key="dialog.selectOther"/>
 		  </span></a></span>
		
 	    <div id = "id_application_div"  style="padding-left:10px; margin-left:0px;width:76%;display:none;background:#FFFFCC">
				
				<div style="float:right;"><span style="align:right">
				<a id="a_close" href="#" onclick="showTagApplication(false);"><font size="5px">×</font></a>&nbsp;&nbsp;</span></div>
				<div style="width:100%;height:20%;margin-top:10px;"><b><bean:message bundle="sys-tag" key="sysTagMain.message.0"/></div>
				<div id = "hot_id" style="width:100%;margin-top:10px;"><bean:message bundle="sys-tag" key="sysTagMain.message.1"/></div>
				<div id = "used_id" style="width:100%;margin-top:10px;margin-bottom:10px;"><bean:message bundle="sys-tag" key="sysTagMain.message.2"/></div>			
 	
 		</div>

