<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<table id="TABLE_DocList5" class="tb_normal" width="90%">
	<tr class="td_normal_title" >
	    <td width="15%" rowspan="100" align="center"><bean:message bundle="tib-sap" key="tibSapMapping.lang.formControl"/></td>
		<td width="5%"><bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.lang.serialNumber"/></td>
		<td width="20%"><bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.lang.funcName"/></td>
		<td width="35%"><bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.lang.applicationExplain"/></td>
		<td width="15%"><bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.lang.integrationType"/></td>
		
		<td width="10%">
			<img
			src="${KMSS_Parameter_StylePath}icons/add.gif" alt="add"
				onclick="addRowEvent_Control('TABLE_DocList5');" style="cursor: pointer">
		</td>
	</tr>
	<!--基准行-->
	<tr KMSS_IsReferRow="1" style="display:none">
		<td KMSS_IsRowIndex="1">
		</td>
		<td>
		<input type="hidden" name="fdFormControlFunctionListForms[!{index}].fdMainId" value="${tibCommonMappingMainForm.fdId}"/>
		<!--<input type="hidden" name="fdFormControlFunctionListForms[!{index}].fdRfcSettingId" value=""/>
		--><input type="hidden" name="fdFormControlFunctionListForms[!{index}].fdInvokeType"  value="5"/><!--3表示机器人节点-->
		<input type="hidden" name="fdFormControlFunctionListForms[!{index}].fdOrder" value="!{index}"/><!--从0开始，注意不是显示的序号-->
		<input type="hidden" name="fdFormControlFunctionListForms[!{index}].fdRfcParamXml"/><!--函数参数xml格式文件-->
		<input type="hidden" name="fdFormControlFunctionListForms[!{index}].fdJspSegmen"  value=""/><!--jsp片段-->
		<input type="hidden" name="fdFormControlFunctionListForms[!{index}].fdTemplateId"  value="${param.templateId}"/>
		<input type="hidden" name="fdFormControlFunctionListForms[!{index}].fdExtendFormsView"  value=""/>
		<!--<input type="text" name="fdFormControlFunctionListForms[!{index}].fdRfcSettingName" value="" readOnly class="inputread"  style="width:100%">
		
		--><input type="hidden" name="fdFormControlFunctionListForms[!{index}].fdRefId" value=""/>
		<input type="text" name="fdFormControlFunctionListForms[!{index}].fdRefName" value="" readOnly class="inputread"  style="width:100%">
		
		</td>
		<td><input type="text" name="fdFormControlFunctionListForms[!{index}].fdFuncMark" value="" readOnly class="inputread"  style="width:100%"></td>
		
		<td>
		<input type="hidden" name="fdFormControlFunctionListForms[!{index}].fdIntegrationType" value="" readOnly class="inputread" style="width:100%">
		<input type="hidden" name="fdFormControlFunctionListForms[!{index}].fdMapperJsp"/>
		<input type="text" name="fdFormControlFunctionListForms[!{index}].fdIntegrationTypeShow" value="" readOnly class="inputread" style="width:100%">
		</td>
		<td>
			<img
			src="${KMSS_Parameter_StylePath}icons/edit.gif" alt="edit"
			onclick="editControlFunction(this.parentNode.parentNode.rowIndex-1);" style="cursor: hand">
			<img src="${KMSS_Parameter_StylePath}icons/up.gif"
			alt="up" onclick="DocList_MoveRow(-1);switchControlFdOrder(-1,this,'TABLE_DocList3');" style="cursor: hand">
			<img src="${KMSS_Parameter_StylePath}icons/down.gif" alt="down"
			onclick="DocList_MoveRow(1);switchControlFdOrder(1,this,'TABLE_DocList3');" style="cursor: hand">
				<img
			src="${KMSS_Parameter_StylePath}icons/delete.gif" alt="del"
			onclick="DocList_DeleteRow();resetControlFdOrder('TABLE_DocList3');" style="cursor: hand">
		</td>
	</tr>
	
	<!--内容行-->
	<c:forEach items="${tibCommonMappingMainForm.fdFormControlFunctionListForms}" var="fdFormControlFunctionListForms" varStatus="vstatus">
	<tr KMSS_IsContentRow="1">
		<td>${vstatus.index+1}</td>
		<td>
		<input type="hidden" name="fdFormControlFunctionListForms[${vstatus.index}].fdId" value="${fdFormControlFunctionListForms.fdId}"/>
		<input type="hidden" name="fdFormControlFunctionListForms[${vstatus.index}].fdMainId" value="${fdFormControlFunctionListForms.fdMainId}"/>
		
		<input type="hidden" name="fdFormControlFunctionListForms[${vstatus.index}].fdRefId" value="${fdFormControlFunctionListForms.fdRefId }"/>
		
		<input type="hidden" name="fdFormControlFunctionListForms[${vstatus.index}].fdInvokeType"  value="${fdFormControlFunctionListForms.fdInvokeType}"/><!--3表示机器人节点-->
		<input type="hidden" name="fdFormControlFunctionListForms[${vstatus.index}].fdOrder" value="${fdFormControlFunctionListForms.fdOrder}"/><!--从0开始，注意不是显示的序号-->
		<input type="hidden" name="fdFormControlFunctionListForms[${vstatus.index}].fdRfcParamXml" value="${fdFormControlFunctionListForms.fdRfcParamXmlView}"/><!--函数参数xml格式文件-->
		<input type="hidden" name="fdFormControlFunctionListForms[${vstatus.index}].fdJspSegmen" value="${fdFormControlFunctionListForms.fdJspSegmenView}"/><!--jsp片段-->
		<input type="hidden" name="fdFormControlFunctionListForms[${vstatus.index}].fdTemplateId"  value="${fdFormControlFunctionListForms.fdTemplateId}"/>
		<input type="hidden" name="fdFormControlFunctionListForms[${vstatus.index}].fdExtendFormsView"  value="${fdFormControlFunctionListForms.fdExtendFormsView}"/>
		
		<input type="text" name="fdFormControlFunctionListForms[${vstatus.index}].fdRefName" value="${fdFormControlFunctionListForms.fdRefName}" readOnly class="inputread"  style="width:100%">
		
		</td>
		
		<td><input name="fdFormControlFunctionListForms[${vstatus.index}].fdFuncMark" value="${fdFormControlFunctionListForms.fdFuncMark}"readOnly class="inputread"  style="width:100%"></td>
		<td>
		<input type="hidden" name="fdFormControlFunctionListForms[${vstatus.index}].fdIntegrationType" value="${fdFormControlFunctionListForms.fdIntegrationType }"  readOnly class="inputread" style="width:100%">
		<input type="hidden" name="fdFormControlFunctionListForms[${vstatus.index}].fdMapperJsp" readOnly value="${fdFormControlFunctionListForms.fdMapperJsp }"   class="inputread" style="width:100%"/>
		<input type="text" name="fdFormControlFunctionListForms[${vstatus.index}].fdIntegrationTypeShow" readOnly value="${fdFormControlFunctionListForms.fdIntegrationTypeShow }"  class="inputread" style="width:100%">
		</td>
		<td>
			<img src="${KMSS_Parameter_StylePath}icons/edit.gif" alt="edit"
			onclick="editControlFunction(this.parentNode.parentNode.rowIndex-1);" style="cursor: hand">
			<img src="${KMSS_Parameter_StylePath}icons/up.gif"
			alt="up" onclick="DocList_MoveRow(-1);switchControlFdOrder(-1,this,'TABLE_DocList3');" style="cursor: hand">
			<img src="${KMSS_Parameter_StylePath}icons/down.gif" alt="down"
			onclick="DocList_MoveRow(1);switchControlFdOrder(1,this,'TABLE_DocList3');" style="cursor: hand">
		    <img src="${KMSS_Parameter_StylePath}icons/delete.gif" alt="del"
			onclick="DocList_DeleteRow();resetControlFdOrder('TABLE_DocList3');" style="cursor: hand">
		</td>
	</tr>
	</c:forEach>
</table>
<script>


function addRowEvent_Control(tbId){
	var settingId=$("input[name='settingId']").val();
	if(!settingId){
		alert("<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.lang.noIntegrationType"/>");
		return ;
		}
	var data = new KMSSData();
	data.SendToBean("tibCommonMappingSettingService&settingId="+settingId,
			function(rtnData){
		if (rtnData.GetHashMapArray().length == 0)
			return;
		if(rtnData.GetHashMapArray()[0]["errMsg"]){
		   alert(rtnData.GetHashMapArray()[0]["errMsg"]);
		   return ;
		}
		//处理返回值 itype iname ikey idialogLink
		if(rtnData.GetHashMapArray()[0]["iJson"]);
			var rtnVal= rtnData.GetHashMapArray()[0]["iJson"];
			 var rtnJson= eval("("+rtnVal+")");
			var fieldValues={};
			var pop_i_type=rtnJson[0]["itype"];
			var pop_i_name=rtnJson[0]["iname"];
			var pop_i_link=rtnJson[0]["idialogLink"];
			
			//只获取SAP集成部分 1代表SAP
			var s_rtn=findRtnJson_Control(rtnJson,"1");
			if(s_rtn!=null){
				pop_i_type=s_rtn["itype"];
				pop_i_name=s_rtn["iname"];
				pop_i_link=s_rtn["idialogLink"];
				fieldValues["fdFormControlFunctionListForms[!{index}].fdIntegrationType"]=pop_i_type;
				fieldValues["fdFormControlFunctionListForms[!{index}].fdIntegrationTypeShow"]=pop_i_name; 
				fieldValues["fdFormControlFunctionListForms[!{index}].fdMapperJsp"]=pop_i_link;
				var n_row=DocList_AddRow(tbId,null,fieldValues);
			}
			else{
				return ;
			}
			});
}

function showTypeDialog_Control(rtnJson){
	var title="${KMSS_Parameter_ContextPath}";
	var link="tib/common/resource/jsp/simpleType_dialog.jsp";

	var width = 500;//500==null?640:width;
	var height =220; //height==null?820:height;
	var left = (screen.width-width)/2;
	var top = (screen.height-height)/2;
	var winStyle = "resizable:1;dialogwidth:"+width+"px;dialogheight:"+height+"px;dialogleft:"+left+";dialogtop:"+top;

	var rtnData={};
	rtnData["rtnJson"]=rtnJson;
	rtnData["stype"]="";
	window.showModalDialog(title+link, rtnData, winStyle);
	return rtnData["stype"];
	}

function findRtnJson_Control(rtnJson ,type){
	for(var i=0,len=rtnJson.length;i<len;i++){
		if(rtnJson[i]["itype"]==type){
             return rtnJson[i];
			}
		}
	return null;
	}



//编辑函数信息
function editControlFunction(index){
	var funcObject={"fdJspSegmen":$('input[name="fdFormControlFunctionListForms['+index+'].fdJspSegmen"]').val(),
			"fdFuncMark":$('input[name="fdFormControlFunctionListForms['+index+'].fdFuncMark"]').val(),

			//"fdRfcSettingName":$('input[name="fdFormControlFunctionListForms['+index+'].fdRfcSettingName"]').val(),
			//"fdRfcSettingId":$('input[name="fdFormControlFunctionListForms['+index+'].fdRfcSettingId"]').val(),

			"fdRefName":$('input[name="fdFormControlFunctionListForms['+index+'].fdRefName"]').val(),
			"fdRefId":$('input[name="fdFormControlFunctionListForms['+index+'].fdRefId"]').val(),
			
			"fdInvokeType":$('input[name="fdFormControlFunctionListForms['+index+'].fdInvokeType"]').val(),
			"fdRfcParamXml":$('input[name="fdFormControlFunctionListForms['+index+'].fdRfcParamXml"]').val(),//函数参数xml格式文件
			"fdExtendFormsView":$('input[name="fdFormControlFunctionListForms['+index+'].fdExtendFormsView"]').val()
			};
	var url=$('input[name="fdFormControlFunctionListForms['+index+'].fdMapperJsp"]').val();
	
	var title="${KMSS_Parameter_ContextPath}";
	if(url){
		//alert(url);
	window.showModalDialog(title+url+"?fdInvokeType=5&mainModelName=${param.mainModelName}&fdFormFileName=${fdFormFileName}", funcObject,"dialogWidth=900px;dialogHeight=600px");
	//重置字段值
	 resetControlField(funcObject,index);
	}
	else{
 		alert("<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.lang.noAddressConn"/>");
 		return ;
		}
}
//编辑函数后重置字段值
function resetControlField(funcObject,index){
	$('input[name="fdFormControlFunctionListForms['+index+'].fdJspSegmen"]').val(funcObject.fdJspSegmen);
	$('input[name="fdFormControlFunctionListForms['+index+'].fdFuncMark"]').val(funcObject.fdFuncMark);

	//$('input[name="fdFormControlFunctionListForms['+index+'].fdRfcSettingName"]').val(funcObject.fdRfcSettingName);
	//$('input[name="fdFormControlFunctionListForms['+index+'].fdRfcSettingId"]').val(funcObject.fdRfcSettingId);

	$('input[name="fdFormControlFunctionListForms['+index+'].fdRefName"]').val(funcObject.fdRefName);
	$('input[name="fdFormControlFunctionListForms['+index+'].fdRefId"]').val(funcObject.fdRefId);
	
	$('input[name="fdFormControlFunctionListForms['+index+'].fdRfcParamXml"]').val(funcObject.fdRfcParamXml);
	$('input[name="fdFormControlFunctionListForms['+index+'].fdExtendFormsView"]').val(funcObject.fdExtendFormsView);
}
//当上移或下移时
function switchControlFdOrder(position,_this,tableId){
	var tbInfo = DocList_TableInfo[tableId];
	//此行交换后的行index,注意这里去到的是交换后的index
	var rowIndex=_this.parentNode.parentNode.rowIndex;
	if((position==-1&&rowIndex<tbInfo.firstIndex-1)||(position==1&&rowIndex>tbInfo.lastIndex-1))return;
	//改变当前移动行的fdOrder
	$('input[name="fdFormControlFunctionListForms['+(rowIndex-1)+'].fdOrder"]').val(rowIndex-1);
	//改变交换行的fdOrder
	$('input[name="fdFormControlFunctionListForms['+(rowIndex-position-1)+'].fdOrder"]').val(rowIndex-position-1);
}
//用于删除时重设fdOrder
function resetControlFdOrder(tableId){
	var tbInfo = DocList_TableInfo[tableId];
	for(var i=0;i<tbInfo.lastIndex-1;i++){
		$('input[name="fdFormControlFunctionListForms['+(i)+'].fdOrder"]').val(i);
	}
}
</script>
