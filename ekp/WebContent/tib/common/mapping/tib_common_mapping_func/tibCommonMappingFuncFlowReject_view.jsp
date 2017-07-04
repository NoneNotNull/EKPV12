<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/common.jsp"%>
<script type="text/javascript">
Com_IncludeFile("data.js|dialog.js");
</script>
<table id="TABLE_DocList${param.fdOrder}" class="tb_normal" width="100%">
	<tr class="td_normal_title" >
	    <td width="10%" rowspan="100" align="center"><bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.lang.flowReject"/></td>
		<td width="5%"><bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.lang.serialNumber"/></td>
		<td width="20%"><bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.lang.funcName"/></td>
		<td width="30%"><bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.lang.applicationExplain"/></td>
		<td width="10%"><bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.lang.integrationType"/></td>
		
		<td width="10%">
			<img
			src="${KMSS_Parameter_StylePath}icons/add.gif" alt="add"
			onclick="addRowEvent_FlowReject('TABLE_DocList${param.fdOrder}');" style="cursor: pointer">
		</td>
	</tr>
	<!--基准行-->
	<tr KMSS_IsReferRow="1" style="display:none">
		<td KMSS_IsRowIndex="1">
		</td>
		<td>
			<input type="hidden" name="${param.fdFuncForms}[!{index}].fdMainId" value="${tibCommonMappingMainForm.fdId}"/>
			<input type="hidden" name="${param.fdFuncForms}[!{index}].fdInvokeType"  value="${param.fdOrder}"/><!--6表示流程驳回-->
			<input type="hidden" name="${param.fdFuncForms}[!{index}].fdOrder" value="!{index}"/><!--从0开始，注意不是显示的序号-->
		    <input type="hidden" name="${param.fdFuncForms}[!{index}].fdRfcParamXml"  value=""/><!--函数参数xml格式文件-->
			<input type="hidden" name="${param.fdFuncForms}[!{index}].fdJspSegmen"  value=""/><!--jsp片段-->
			<input type="hidden" name="${param.fdFuncForms}[!{index}].fdTemplateId"  value="${param.templateId}"/>
			<input type="hidden" name="${param.fdFuncForms}[!{index}].fdExtendFormsView"  value=""/>
			
			<input type="hidden" name="${param.fdFuncForms}[!{index}].fdRefId" value=""/>
			<input type="text" name="${param.fdFuncForms}[!{index}].fdRefName" value="" readOnly class="inputread"  style="width:100%">
		</td>
		<td>
			<input type="text" name="${param.fdFuncForms}[!{index}].fdFuncMark" value="" readOnly class="inputread" style="width:100%">
		</td>
		<td>
			<input type="hidden" name="${param.fdFuncForms}[!{index}].fdIntegrationType" value="" readOnly class="inputread" style="width:100%">
			<input type="hidden" name="${param.fdFuncForms}[!{index}].fdMapperJsp"/>
			<input type="text" name="${param.fdFuncForms}[!{index}].fdIntegrationTypeShow" value="" readOnly class="inputread" style="width:100%">
		</td>
		<td>
			<img src="${KMSS_Parameter_StylePath}icons/edit.gif" alt="edit"
				onclick="editFlowRejectFunction(this.parentNode.parentNode.rowIndex-1);" style="cursor: pointer">
			<img src="${KMSS_Parameter_StylePath}icons/up.gif"
				alt="up" onclick="DocList_MoveRow(-1);switchFlowRejectFdOrder(-1,this,'TABLE_DocList${param.fdOrder}');" style="cursor: pointer">
			<img src="${KMSS_Parameter_StylePath}icons/down.gif" alt="down"
				onclick="DocList_MoveRow(1);switchFlowRejectFdOrder(1,this,'TABLE_DocList${param.fdOrder}');" style="cursor: pointer">
			<img src="${KMSS_Parameter_StylePath}icons/delete.gif" alt="del"
			onclick="DocList_DeleteRow();resetFlowRejectFdOrder('TABLE_DocList${param.fdOrder}');" style="cursor: pointer">
		</td>
	</tr>
	
	<!--内容行-->
	<c:forEach items="${tibCommonMappingMainForm.fdFlowRejectListForms}" var="fdFlowRejectFunctionForm" varStatus="vstatus">
	<tr KMSS_IsContentRow="1">
		<td>${vstatus.index+1}</td>
		<td>
			<input type="hidden" name="${param.fdFuncForms}[${vstatus.index}].fdId" value="${fdFlowRejectFunctionForm.fdId}"/>
			<input type="hidden" name="${param.fdFuncForms}[${vstatus.index}].fdMainId" value="${fdFlowRejectFunctionForm.fdMainId}"/>
			<input type="hidden" name="${param.fdFuncForms}[${vstatus.index}].fdRefId" value="${fdFlowRejectFunctionForm.fdRefId }"/>
			<input type="hidden" name="${param.fdFuncForms}[${vstatus.index}].fdInvokeType"  value="${fdFlowRejectFunctionForm.fdInvokeType}"/><!--0表示表单事件-->
			<input type="hidden" name="${param.fdFuncForms}[${vstatus.index}].fdOrder" value="${fdFlowRejectFunctionForm.fdOrder}"/><!--从0开始，注意不是显示的序号-->
			<input type="hidden" name="${param.fdFuncForms}[${vstatus.index}].fdRfcParamXml" value="${fdFlowRejectFunctionForm.fdRfcParamXmlView}"/><!--函数参数xml格式文件-->
			<input type="hidden" name="${param.fdFuncForms}[${vstatus.index}].fdJspSegmen" value="${fdFlowRejectFunctionForm.fdJspSegmenView}"/><!--jsp片段-->
			<input type="hidden" name="${param.fdFuncForms}[${vstatus.index}].fdTemplateId"  value="${fdFlowRejectFunctionForm.fdTemplateId}"/>
			<input type="hidden" name="${param.fdFuncForms}[${vstatus.index}].fdExtendFormsView"  value="${fdFlowRejectFunctionForm.fdExtendFormsView}"/>
			<input type="text" name="${param.fdFuncForms}[${vstatus.index}].fdRefName" value="${fdFlowRejectFunctionForm.fdRefName}" readOnly class="inputread"  style="width:100%">
		</td>
		<td><input name="${param.fdFuncForms}[${vstatus.index}].fdFuncMark" value="${fdFlowRejectFunctionForm.fdFuncMark}"readOnly class="inputread"  style="width:100%"></td>
		<td>
			<input type="hidden" name="${param.fdFuncForms}[${vstatus.index}].fdIntegrationType" value="${fdFlowRejectFunctionForm.fdIntegrationType }"  readOnly class="inputread" style="width:100%">
			<input type="hidden" name="${param.fdFuncForms}[${vstatus.index}].fdMapperJsp" readOnly value="${fdFlowRejectFunctionForm.fdMapperJsp }"   class="inputread" style="width:100%"/>
			<input type="text" name="${param.fdFuncForms}[${vstatus.index}].fdIntegrationTypeShow" readOnly value="${fdFlowRejectFunctionForm.fdIntegrationTypeShow }"  class="inputread" style="width:100%">
		</td>
		
		<td>
			<img src="${KMSS_Parameter_StylePath}icons/edit.gif" alt="edit"
			onclick="editFlowRejectFunction(this.parentNode.parentNode.rowIndex-1);" style="cursor: pointer">
			<img src="${KMSS_Parameter_StylePath}icons/up.gif"
			alt="up" onclick="DocList_MoveRow(-1);switchFlowRejectFdOrder(-1,this,'TABLE_DocList${param.fdOrder}');" style="cursor: pointer">
			<img src="${KMSS_Parameter_StylePath}icons/down.gif" alt="down"
			onclick="DocList_MoveRow(1);switchFlowRejectFdOrder(1,this,'TABLE_DocList${param.fdOrder}');" style="cursor: pointer">
		    <img src="${KMSS_Parameter_StylePath}icons/delete.gif" alt="del"
			onclick="DocList_DeleteRow();resetFlowRejectFdOrder('TABLE_DocList${param.fdOrder}');" style="cursor: pointer">
		</td>
	</tr>
	</c:forEach>
</table>


<script type="text/javascript">

	function addRowEvent_FlowReject(tbId){
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
				if(rtnJson.length>1){
					var itype=showTypeDialog_FlowReject(rtnJson);
					if(itype){
						var s_rtn=findRtnJson_FlowReject(rtnJson,itype);
						pop_i_type=s_rtn["itype"];
						pop_i_name=s_rtn["iname"];
						pop_i_link=s_rtn["idialogLink"];
					}
				}
				// 添加验证，验证流程驳回事件sap或soap只能有一行记录
				var fdIntegTypes = $("input[name^='${param.fdFuncForms}'][name$='.fdIntegrationType'][value='"+ pop_i_type +"']");
				/*if (fdIntegTypes.length > 0) {
					alert(pop_i_name +"<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.unique.fdIntegType"/>");
					return;
				}*/
				fieldValues["${param.fdFuncForms}[!{index}].fdIntegrationType"]=pop_i_type;
				fieldValues["${param.fdFuncForms}[!{index}].fdIntegrationTypeShow"]=pop_i_name; 
				fieldValues["${param.fdFuncForms}[!{index}].fdMapperJsp"]=pop_i_link;
				var n_row=DocList_AddRow(tbId,null,fieldValues);
			}
		);
	}
	
	function showTypeDialog_FlowReject(rtnJson){
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

	function findRtnJson_FlowReject(rtnJson ,type){
		for(var i=0,len=rtnJson.length;i<len;i++){
			if(rtnJson[i]["itype"]==type){
                 return rtnJson[i];
			}
		}
		return null;
	}



//编辑函数信息
function editFlowRejectFunction(index){
	
	var funcObject={"fdJspSegmen":$('input[name="${param.fdFuncForms}['+index+'].fdJspSegmen"]').val(),
		"fdFuncMark":$('input[name="${param.fdFuncForms}['+index+'].fdFuncMark"]').val(),
		"fdRefName":$('input[name="${param.fdFuncForms}['+index+'].fdRefName"]').val(),
		"fdRefId":$('input[name="${param.fdFuncForms}['+index+'].fdRefId"]').val(),
		"fdInvokeType":$('input[name="${param.fdFuncForms}['+index+'].fdInvokeType"]').val(),
		"fdRfcParamXml":$('input[name="${param.fdFuncForms}['+index+'].fdRfcParamXml"]').val(),//函数参数xml格式文件
		"fdExtendFormsView":$('input[name="${param.fdFuncForms}['+index+'].fdExtendFormsView"]').val()
	};
	
	var url=$('input[name="${param.fdFuncForms}['+index+'].fdMapperJsp"]').val();
	var title="${KMSS_Parameter_ContextPath}";
	if(url) {
		window.showModalDialog(title+url+"?fdInvokeType=${param.fdOrder}&mainModelName=${param.mainModelName}&fdFormFileName=${param.fdFormFileName}", funcObject,"dialogWidth=900px;dialogHeight=600px");
		//重置字段值
		resetFlowRejectField(funcObject,index);
	} else {
 		alert("<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.lang.noAddressConn"/>");
 		return ;
	}

}
//编辑函数后重置字段值
function resetFlowRejectField(funcObject,index){
	$('input[name="${param.fdFuncForms}['+index+'].fdJspSegmen"]').val(funcObject.fdJspSegmen);
	$('input[name="${param.fdFuncForms}['+index+'].fdFuncMark"]').val(funcObject.fdFuncMark);
	$('input[name="${param.fdFuncForms}['+index+'].fdRefName"]').val(funcObject.fdRefName);
	$('input[name="${param.fdFuncForms}['+index+'].fdRefId"]').val(funcObject.fdRefId);
	$('input[name="${param.fdFuncForms}['+index+'].fdRfcParamXml"]').val(funcObject.fdRfcParamXml);
	$('input[name="${param.fdFuncForms}['+index+'].fdExtendFormsView"]').val(funcObject.fdExtendFormsView);
}
//当上移或下移时
function switchFlowRejectFdOrder(position,_this,tableId){
	var tbInfo = DocList_TableInfo[tableId];
	//此行交换后的行index,注意这里去到的是交换后的index
	var rowIndex=_this.parentNode.parentNode.rowIndex;
	if((position==-1&&rowIndex<tbInfo.firstIndex-1)||(position==1&&rowIndex>tbInfo.lastIndex-1))return;
	//改变当前移动行的fdOrder
	$('input[name="${param.fdFuncForms}['+(rowIndex-1)+'].fdOrder"]').val(rowIndex-1);
	//改变交换行的fdOrder
	$('input[name="${param.fdFuncForms}['+(rowIndex-position-1)+'].fdOrder"]').val(rowIndex-position-1);
}
//用于删除时重设fdOrder
function resetFlowRejectFdOrder(tableId){
	var tbInfo = DocList_TableInfo[tableId];
	for(var i=0;i<tbInfo.lastIndex-1;i++){
		$('input[name="${param.fdFuncForms}['+(i)+'].fdOrder"]').val(i);
	}
}
</script>
