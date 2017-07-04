<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<script type="text/javascript">
Com_IncludeFile("data.js|dialog.js");
</script>
<table id="TABLE_DocList0" class="tb_normal" width="100%">
	<tr class="td_normal_title" >
	     <td width="10%" rowspan="100" align="center"><bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.lang.formEvent"/></td>
		<td width="5%"><bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.lang.serialNumber"/></td>
		<td width="20%"><bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.lang.funcName"/></td>
		<td width="30%"><bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.lang.applicationExplain"/></td>
		<td width="10%"><bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.lang.integrationType"/></td>
		
		<td width="10%">
			<img
			src="${KMSS_Parameter_StylePath}icons/add.gif" alt="add"
			onclick="addRowEvent_FormEvent('TABLE_DocList0');" style="cursor: pointer">
		</td>
	</tr>
	<!--基准行-->
	<tr KMSS_IsReferRow="1" style="display:none">
		<td KMSS_IsRowIndex="1">
		</td>
		<td>
		<input type="hidden" name="fdFormEventFunctionListForms[!{index}].fdMainId" value="${tibCommonMappingMainForm.fdId}"/>
		
		<input type="hidden" name="fdFormEventFunctionListForms[!{index}].fdInvokeType"  value="0"/><!--0表示表单事件-->
		<input type="hidden" name="fdFormEventFunctionListForms[!{index}].fdOrder" value="!{index}"/><!--从0开始，注意不是显示的序号-->
	    <input type="hidden" name="fdFormEventFunctionListForms[!{index}].fdRfcParamXml"  value=""/><!--函数参数xml格式文件-->
		<input type="hidden" name="fdFormEventFunctionListForms[!{index}].fdJspSegmen"  value=""/><!--jsp片段-->
		<input type="hidden" name="fdFormEventFunctionListForms[!{index}].fdTemplateId"  value="${param.templateId}"/>
		<!-- 对外外键 -->
		
		<!--<input type="hidden" name="fdFormEventFunctionListForms[!{index}].fdRefId" value=""/>
		<input type="text" name="fdFormEventFunctionListForms[!{index}].fdRefName" value="" readOnly class="inputread"  style="width:100%">
		
		
		-->
		<input type="hidden" name="fdFormEventFunctionListForms[!{index}].fdRefId" value=""/>
		<input type="text" name="fdFormEventFunctionListForms[!{index}].fdRefName" value="" readOnly class="inputread"  style="width:100%">
		
		<!--<input type="hidden" name="fdFormEventFunctionListForms[!{index}].fdRefName" value=""/>
		
		--><!--<input type="text" name="fdFormEventFunctionListForms[!{index}].fdRfcSettingName" value="" readOnly class="inputread"  style="width:100%">
		-->
		<!--<input type="hidden" name="fdFormEventFunctionListForms[!{index}].fdSettingId" value=""/>
		-->
		
		<!--<input type="text" name="fdFormEventFunctionListForms[!{index}].fdRfcSettingName" value="" readOnly class="inputread"  style="width:100%">
		-->
		
		</td>
		<td><input type="text" name="fdFormEventFunctionListForms[!{index}].fdFuncMark" value="" readOnly class="inputread" style="width:100%"></td>
		<td>
		<input type="hidden" name="fdFormEventFunctionListForms[!{index}].fdIntegrationType" value="" readOnly class="inputread" style="width:100%">
		<input type="hidden" name="fdFormEventFunctionListForms[!{index}].fdMapperJsp"/>
		<input type="text" name="fdFormEventFunctionListForms[!{index}].fdIntegrationTypeShow" value="" readOnly class="inputread" style="width:100%">
		</td>
		<td>
			<img
			src="${KMSS_Parameter_StylePath}icons/edit.gif" alt="edit"
			onclick="editFormEventFunction(this.parentNode.parentNode.rowIndex-1);" style="cursor: pointer">
			<img src="${KMSS_Parameter_StylePath}icons/up.gif"
			alt="up" onclick="DocList_MoveRow(-1);switchFormEventFdOrder(-1,this,'TABLE_DocList0');" style="cursor: pointer">
			<img src="${KMSS_Parameter_StylePath}icons/down.gif" alt="down"
			onclick="DocList_MoveRow(1);switchFormEventFdOrder(1,this,'TABLE_DocList0');" style="cursor: pointer">
				<img
			src="${KMSS_Parameter_StylePath}icons/delete.gif" alt="del"
			onclick="DocList_DeleteRow();resetFormEventFdOrder('TABLE_DocList0');" style="cursor: pointer">
		</td>
	</tr>
	
	<!--内容行-->
	<c:forEach items="${tibCommonMappingMainForm.fdFormEventFunctionListForms}" var="fdFormEventFunctionForm" varStatus="vstatus">
	<tr KMSS_IsContentRow="1">
		<td>${vstatus.index+1}</td>
		<td>
		<input type="hidden" name="fdFormEventFunctionListForms[${vstatus.index}].fdId" value="${fdFormEventFunctionForm.fdId}"/>
		<input type="hidden" name="fdFormEventFunctionListForms[${vstatus.index}].fdMainId" value="${fdFormEventFunctionForm.fdMainId}"/>
		
		<%--<input type="hidden" name="fdFormEventFunctionListForms[${vstatus.index}].fdSettingId" value="${fdFormEventFunctionForm.fdSettingId}"/>
		
		<input type="hidden" name="fdFormEventFunctionListForms[${vstatus.index}].fdRfcSettingId" value="${fdFormEventFunctionForm.fdRfcSettingId}"/>--%>
		
		<input type="hidden" name="fdFormEventFunctionListForms[${vstatus.index}].fdRefId" value="${fdFormEventFunctionForm.fdRefId }"/>
		
		
		<input type="hidden" name="fdFormEventFunctionListForms[${vstatus.index}].fdInvokeType"  value="${fdFormEventFunctionForm.fdInvokeType}"/><!--0表示表单事件-->
		<input type="hidden" name="fdFormEventFunctionListForms[${vstatus.index}].fdOrder" value="${fdFormEventFunctionForm.fdOrder}"/><!--从0开始，注意不是显示的序号-->
		<input type="hidden" name="fdFormEventFunctionListForms[${vstatus.index}].fdRfcParamXml" value="${fdFormEventFunctionForm.fdRfcParamXmlView}"/><!--函数参数xml格式文件-->
		<input type="hidden" name="fdFormEventFunctionListForms[${vstatus.index}].fdJspSegmen" value="${fdFormEventFunctionForm.fdJspSegmenView}"/><!--jsp片段-->
		<input type="hidden" name="fdFormEventFunctionListForms[${vstatus.index}].fdTemplateId"  value="${fdFormEventFunctionForm.fdTemplateId}"/>
		
		<%--<input type="text" name="fdFormEventFunctionListForms[${vstatus.index}].docSubject" value="${fdFormEventFunctionForm.docSubject}" readOnly class="inputread"  style="width:100%">
		
		<input type="text" name="fdFormEventFunctionListForms[${vstatus.index}].fdRfcSettingName" value="${fdFormEventFunctionForm.fdRfcSettingName}" readOnly class="inputread"  style="width:100%">
		<input type="text" name="fdFormEventFunctionListForms[${vstatus.index}].fdRfcSettingName" value="${fdFormEventFunctionForm.fdRfcSettingName}" readOnly class="inputread"  style="width:100%">--%>
		
		<input type="text" name="fdFormEventFunctionListForms[${vstatus.index}].fdRefName" value="${fdFormEventFunctionForm.fdRefName}" readOnly class="inputread"  style="width:100%">
		
		</td>
		<td><input name="fdFormEventFunctionListForms[${vstatus.index}].fdFuncMark" value="${fdFormEventFunctionForm.fdFuncMark}"readOnly class="inputread"  style="width:100%"></td>
		<td>
		<input type="hidden" name="fdFormEventFunctionListForms[${vstatus.index}].fdIntegrationType" value="${fdFormEventFunctionForm.fdIntegrationType }"  readOnly class="inputread" style="width:100%">
		<input type="hidden" name="fdFormEventFunctionListForms[${vstatus.index}].fdMapperJsp" readOnly value="${fdFormEventFunctionForm.fdMapperJsp }"   class="inputread" style="width:100%"/>
		<input type="text" name="fdFormEventFunctionListForms[${vstatus.index}].fdIntegrationTypeShow" readOnly value="${fdFormEventFunctionForm.fdIntegrationTypeShow }"  class="inputread" style="width:100%">
		</td>
		
		<td>
			<img src="${KMSS_Parameter_StylePath}icons/edit.gif" alt="edit"
			onclick="editFormEventFunction(this.parentNode.parentNode.rowIndex-1);" style="cursor: pointer">
			<img src="${KMSS_Parameter_StylePath}icons/up.gif"
			alt="up" onclick="DocList_MoveRow(-1);switchFormEventFdOrder(-1,this,'TABLE_DocList0');" style="cursor: pointer">
			<img src="${KMSS_Parameter_StylePath}icons/down.gif" alt="down"
			onclick="DocList_MoveRow(1);switchFormEventFdOrder(1,this,'TABLE_DocList0');" style="cursor: pointer">
		    <img src="${KMSS_Parameter_StylePath}icons/delete.gif" alt="del"
			onclick="DocList_DeleteRow();resetFormEventFdOrder('TABLE_DocList0');" style="cursor: pointer">
		</td>
	</tr>
	</c:forEach>
</table>


<script type="text/javascript">

	function addRowEvent_FormEvent(tbId){
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
					var itype=showTypeDialog_FormEvent(rtnJson);
					if(itype){
					var s_rtn=findRtnJson_FormEvent(rtnJson,itype);
					pop_i_type=s_rtn["itype"];
					pop_i_name=s_rtn["iname"];
					pop_i_link=s_rtn["idialogLink"];
					}
					}
				fieldValues["fdFormEventFunctionListForms[!{index}].fdIntegrationType"]=pop_i_type;
				fieldValues["fdFormEventFunctionListForms[!{index}].fdIntegrationTypeShow"]=pop_i_name; 
				fieldValues["fdFormEventFunctionListForms[!{index}].fdMapperJsp"]=pop_i_link;
				var n_row=DocList_AddRow(tbId,null,fieldValues);
				});
	}
	
	function showTypeDialog_FormEvent(rtnJson){
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

	function findRtnJson_FormEvent(rtnJson ,type){
		for(var i=0,len=rtnJson.length;i<len;i++){
			if(rtnJson[i]["itype"]==type){
                 return rtnJson[i];
				}
			}
		return null;
		}



//编辑函数信息
function editFormEventFunction(index){
	var funcObject={"fdJspSegmen":$('input[name="fdFormEventFunctionListForms['+index+'].fdJspSegmen"]').val(),
			"fdFuncMark":$('input[name="fdFormEventFunctionListForms['+index+'].fdFuncMark"]').val(),

			//"fdRfcSettingName":$('input[name="fdFormEventFunctionListForms['+index+'].fdRfcSettingName"]').val(),
			//"fdRfcSettingId":$('input[name="fdFormEventFunctionListForms['+index+'].fdRfcSettingId"]').val(),

			"fdRefName":$('input[name="fdFormEventFunctionListForms['+index+'].fdRefName"]').val(),
			"fdRefId":$('input[name="fdFormEventFunctionListForms['+index+'].fdRefId"]').val(),

			"fdInvokeType":$('input[name="fdFormEventFunctionListForms['+index+'].fdInvokeType"]').val(),
			"fdRfcParamXml":$('input[name="fdFormEventFunctionListForms['+index+'].fdRfcParamXml"]').val()//函数参数xml格式文件
			};
	
	var url=$('input[name="fdFormEventFunctionListForms['+index+'].fdMapperJsp"]').val();
	
	var title="${KMSS_Parameter_ContextPath}";
	if(url){
		window.showModalDialog(title+url+"?fdInvokeType=0&mainModelName=${param.mainModelName}&fdFormFileName=${fdFormFileName}", funcObject,"dialogWidth=900px;dialogHeight=600px");
		//重置字段值
		resetFormEventField(funcObject,index);
	} else {
 		alert("<bean:message bundle="tib-common-mapping" key="tibCommonMappingFunc.lang.noAddressConn"/>");
 		return ;
	}

}
//编辑函数后重置字段值
function resetFormEventField(funcObject,index){
	$('input[name="fdFormEventFunctionListForms['+index+'].fdJspSegmen"]').val(funcObject.fdJspSegmen);
	$('input[name="fdFormEventFunctionListForms['+index+'].fdFuncMark"]').val(funcObject.fdFuncMark);
	//$('input[name="fdFormEventFunctionListForms['+index+'].fdRfcSettingName"]').val(funcObject.fdRfcSettingName);
	//$('input[name="fdFormEventFunctionListForms['+index+'].fdRfcSettingId"]').val(funcObject.fdRfcSettingId),
	
	//$('input[name="fdFormEventFunctionListForms['+index+'].docSubject"]').val(funcObject.docSubject);
	//$('input[name="fdFormEventFunctionListForms['+index+'].fdSettingId"]').val(funcObject.fdSettingId),
	//"fdRefName":$('input[name="fdFormEventFunctionListForms['+index+'].fdRefName"]').val(),
	//"fdRefId":$('input[name="fdFormEventFunctionListForms['+index+'].fdRefId"]').val(),
	
	$('input[name="fdFormEventFunctionListForms['+index+'].fdRefName"]').val(funcObject.fdRefName);
	$('input[name="fdFormEventFunctionListForms['+index+'].fdRefId"]').val(funcObject.fdRefId);
	
	$('input[name="fdFormEventFunctionListForms['+index+'].fdRfcParamXml"]').val(funcObject.fdRfcParamXml);
}
//当上移或下移时
function switchFormEventFdOrder(position,_this,tableId){
	var tbInfo = DocList_TableInfo[tableId];
	//此行交换后的行index,注意这里去到的是交换后的index
	var rowIndex=_this.parentNode.parentNode.rowIndex;
	if((position==-1&&rowIndex<tbInfo.firstIndex-1)||(position==1&&rowIndex>tbInfo.lastIndex-1))return;
	//改变当前移动行的fdOrder
	$('input[name="fdFormEventFunctionListForms['+(rowIndex-1)+'].fdOrder"]').val(rowIndex-1);
	//改变交换行的fdOrder
	$('input[name="fdFormEventFunctionListForms['+(rowIndex-position-1)+'].fdOrder"]').val(rowIndex-position-1);
}
//用于删除时重设fdOrder
function resetFormEventFdOrder(tableId){
	var tbInfo = DocList_TableInfo[tableId];
	for(var i=0;i<tbInfo.lastIndex-1;i++){
		$('input[name="fdFormEventFunctionListForms['+(i)+'].fdOrder"]').val(i);
	}
}
</script>
