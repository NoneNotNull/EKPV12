<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<center>
<table  class="tb_normal" width="100%" id="TABLE_DocList" style="margin-top: -15px;TABLE-LAYOUT: fixed;WORD-BREAK: break-all;;margin-bottom: -15px;">

    <c:set var="fdTabIconDefault" value='/third/pda/resource/images/icon/module_default.png'/>
 <script>
	function addRow(){
		var fdModule = $('#fdModuleName').val();
		if(fdModule != ""&&fdModule != null){
		  DocList_AddRow();
		}else{
			alert("请先选择模块");
		}
	}
</script>	
	<tr>
		<td width="3%" KMSS_IsRowIndex="1" class="td_normal_title"><bean:message key="page.serial" /></td>
		<td width="15%" class="td_normal_title"><bean:message bundle="third-pda" key="pdaTabViewLabelList.fdTabName"/><span class="txtstrong">*</span></td>
		<td width="10%" class="td_normal_title"><bean:message bundle="third-pda" key="pdaTabViewLabelList.fdTabType"/><span class="txtstrong">*</span></td>
		<td width="55%" class="td_normal_title"><bean:message bundle="third-pda" key="pdaTabViewLabelList.fdConfigurationItem"/><span class="txtstrong">*</span></td>
		<!-- <td width="6%" class="td_normal_title"><bean:message bundle="third-pda" key="pdaTabViewLabelList.fdTabIcon"/><span class="txtstrong">*</span></td> -->
		<td width="85px;" align="center" class="td_normal_title">
		  <img src="${KMSS_Parameter_StylePath}icons/add.gif" style="cursor:pointer" onclick="addRow();" title="<bean:message key="button.insert"/>">
		</td>
	</tr>
	
	<!--基准行-->
	<tr KMSS_IsReferRow="1" style="display:none">
		<td width="3%" KMSS_IsRowIndex="1">${index+1}</td>
		<td width="15%">
		    <input type="hidden" name="fdLabelList[!{index}].fdTabOrder"/>
			<input name="fdLabelList[!{index}].fdTabName" class="inputsgl" style="width: 95%" />
		</td>
		<td width="10%">
			<xform:select property="fdLabelList[!{index}].fdTabType" value="" showPleaseSelect="true" onValueChange="dynamicBuildTdAdd('!{index}');return false;">
				<xform:enumsDataSource enumsType="pda_tabView_labelList_fdTabType" />
			</xform:select>
		</td>
		<td width="55%" height="30px">
		   <div id="fdTabType_module_!{index}" style="display:none">
		      
		   </div>
		   <div id="fdTabType_listcategory_!{index}" style="display:none">
		    <input name="fdLabelList[!{index}].fdTabUrl" class="inputsgl" style="width: 84%" /><a onclick="selectDataUrl(!{index});return false;" href=""><bean:message key="dialog.selectOther" /></a>
			<span class="txtstrong">*</span>
			</div>
			<div id="fdTabType_search_!{index}" style="display:none">
			<input name="fdLabelList[!{index}].fdTabBean" class="inputSgl" style="width:84%;" readonly="readonly" onchange="loadDictPropertyData(!{index});"/>
			<a onclick="selectDictModelByFdUrlPrefix(!{index});return false;" href=""><bean:message key="dialog.selectOther" /></a>
			<span class="txtstrong">*</span>
			</div>
		</td>
		<td align="center" width="85px;">
		    <input type="hidden" name="!{index}"> 
			<a href="javascript:void(0);" onclick="DocList_DeleteRow();" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/delete.gif" border="0"  title="<bean:message key="button.delete"/>"/></a>
			<a href="javascript:void(0);" onclick="DocList_MoveRow(-1);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/up.gif" border="0"  title="<bean:message key="button.moveup"/>"/></a>
			<a href="javascript:void(0);" onclick="DocList_MoveRow(1);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/down.gif" border="0"  title="<bean:message key="button.movedown"/>"/></a>
		</td>
	</tr>
	
	<!--内容行-->
	<c:if test="${pdaTabViewConfigMainForm.method_GET=='edit'}">
		<c:forEach items="${pdaTabViewConfigMainForm.fdLabelList}" var="pdaTabViewLabelListForm" varStatus="vstatus">
		    <c:set var="fdTabType" value="${pdaTabViewLabelListForm.fdTabType}" />
			<tr KMSS_IsContentRow="1">
				<td width="3%" KMSS_IsRowIndex="1" id="KMSS_IsRowIndex_Edit">${vstatus.index+1}</td>
				<td width="15%">
				    <input type="hidden" name="fdLabelList[${vstatus.index}].fdTabOrder"  value="${pdaTabViewLabelListForm.fdTabOrder}"  /> 
					<input name="fdLabelList[${vstatus.index}].fdTabName" class="inputsgl" style="width: 95%"  value="${pdaTabViewLabelListForm.fdTabName}" />
				</td>
				<td width="10%">
					<xform:select property="fdLabelList[${vstatus.index}].fdTabType" value="${fdTabType}" showStatus="readOnly">
						<xform:enumsDataSource enumsType="pda_tabView_labelList_fdTabType" />
					</xform:select>
				</td>
				<td width="55%" height="30px">
				<c:if test="${fdTabType == 'module'}">
				  ${pdaTabViewConfigMainForm.fdModuleName}
				</c:if>
				<c:if test="${fdTabType == 'listcategory'}">
				  <input name="fdLabelList[${vstatus.index}].fdTabUrl" class="inputsgl" style="width: 84%" value="${pdaTabViewLabelListForm.fdTabUrl}"/>
				</c:if>
				<c:if test="${fdTabType == 'search'}">
				  <input name="fdLabelList[${vstatus.index}].fdTabBean" class="inputSgl" style="width:84%;" readonly="readonly" onchange="loadDictPropertyData(${vstatus.index});" value="${pdaTabViewLabelListForm.fdTabBean}"/>
				</c:if>
				</td>
				<input type="hidden" name="fdLabelList[${vstatus.index}].fdStatus" value="1" />
				<td align="center" width="85px;">
				    <input type="hidden" name="${vstatus.index}">
					<a href="javascript:void(0);" onclick="DocList_DeleteRow();" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/delete.gif" border="0" title="<bean:message key="button.delete"/>" /></a>
					<a href="javascript:void(0);" onclick="DocList_MoveRow(-1);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/up.gif" border="0" title="<bean:message key="button.moveup"/>" /></a>
					<a href="javascript:void(0);" onclick="DocList_MoveRow(1);" style="text-decoration: none">&nbsp;<img src="${KMSS_Parameter_StylePath}icons/down.gif" border="0" title="<bean:message key="button.movedown"/>" /></a>
				</td>
			</tr>
		</c:forEach>
	</c:if>
	
</table>
</center>

<script>

	//页面加载的时候需要加载函数
	$(document).ready(function(){
	   //initDynamicBuildTdEdit();
	});
	
	//初始化编辑页面 动态构建“选择组件”列
	function initDynamicBuildTdEdit(){
		var method_GET = $('input[name="method_GET"]').val();
		if(method_GET=='edit'){
			var updateRow = $('#TABLE_DocList').find('tr').length-1;
			if(updateRow>0){
				for(var i=0;i<updateRow;i++){
					dynamicBuildTdEdit(i);
				}
			}
		}
	}

	//新增界面 动态构建“选择组件”列
	function dynamicBuildTdAdd(index) {
		var fdModule = $('#fdModuleName').val();
			var fdTabType_index = $('select[name="fdLabelList[' + index + '].fdTabType"]').val();
			if (fdTabType_index == 'module') {
				$('#fdTabType_module_' + index).show();
				$('#fdTabType_module_' + index).html(fdModule);
				$('#fdTabType_listcategory_' + index).hide();
				$('#fdTabType_search_' + index).hide();
			}
			if (fdTabType_index == 'list') {
				dynDiv += '<div id=fdTabType_list_'+index+' style=display:block>'
						+ '  <input name="fdLabelList['+index+'].fdTabUrl" class="inputsgl" style="width:84%" '+'/>'
						+ '  <a onclick="selectLabelListByFdModuleId('+index+');return false;" href=""><bean:message key="dialog.selectOther" /></a>'
						+ '  <span class="txtstrong">*</span>'
						+ '</div>';
			}
			if (fdTabType_index == 'listcategory') {
				$('#fdTabType_module_' + index).hide();
				$('#fdTabType_listcategory_' + index).show();
				$('#fdTabType_search_' + index).hide();
			}
			if (fdTabType_index == 'doc') {
				dynDiv += '<div id=fdTabType_doc_'+index+' style="display:block">'
						+ ' <input name="fdLabelList['+index+'].fdTabUrl" class="inputsgl" style="width: 84%" '+'/>'
						+ ' <a onclick="selectDataUrl('+index+');return false;" href=""><bean:message key="dialog.selectOther" /></a>'
						+ ' <span class="txtstrong">*</span>'
						+ '</div>';
			}
			if (fdTabType_index == 'search') {
				$('#fdTabType_module_' + index).hide();
				$('#fdTabType_listcategory_' + index).hide();
				$('#fdTabType_search_' + index).show();
			}
			setInit(index,fdTabType_index);
	}

	//编辑界面 动态构建“选择组件”列
	function dynamicBuildTdEdit(index) {
		var dynDiv = '';
		var fdModuleName = $('#fdModuleName').val();
		var fdTabType_index = $('select[name="fdLabelList[' + index + '].fdTabType"]').val();
		var fdLabelList_index_fdTabUrl = $("#fdLabelList_"+index+"_fdTabUrl").val();
		var fdLabelList_index_fdTabBean = $("#fdLabelList_"+index+"_fdTabBean").val();
		if (fdTabType_index == 'module') {
			dynDiv += '<div id=fdTabType_module_'+index+' style="display:block">'+fdModuleName+'</div>';
		}
		if (fdTabType_index == 'list') {
			dynDiv += '<div id=fdTabType_list_'+index+' style="display:block">'
 					 + '  <input name="fdLabelList['+index+'].fdTabUrl" class="inputsgl" style="width:84%" value ="'+fdLabelList_index_fdTabUrl+ '"/>'
 					 + '  <a onclick="selectLabelListByFdModuleId('+index+');return false;" href=""><bean:message key="dialog.selectOther" /></a>'
 					 + '  <span class="txtstrong">*</span>'
		             +'</div>';
		}
		if (fdTabType_index == 'listcategory') {
			dynDiv += '<div id="fdTabType_listcategory_'+index+'" style="display:block">'
			         +'  <input name="fdLabelList['+index+'].fdTabUrl" class="inputsgl" style="width:84%" value="'+fdLabelList_index_fdTabUrl+'"/>'
			         + ' <a onclick="selectDataUrl('+index+');return false;" href=""><bean:message key="dialog.selectOther" /></a>'
			         + ' <span class="txtstrong">*</span>'
			         +'</div>';
		}
		if (fdTabType_index == 'doc') {
			dynDiv += '<div id="fdTabType_doc_'+index+'" style="display:block">'
			        + ' <input name="fdLabelList['+index+'].fdTabUrl" class="inputsgl" style="width:84%" value="'+fdLabelList_index_fdTabUrl+'"/>'
			        + ' <a onclick="selectDataUrl('+index+');return false;" href=""><bean:message key="dialog.selectOther" /></a>'
			        + ' <span class="txtstrong">*</span>'
		            + '</div>';
		}
		if (fdTabType_index == 'search') {
			dynDiv += '<div id="fdTabType_search_'+index+'" style="display:block">'
			         + '<input name="fdLabelList['+index+'].fdTabBean" class="inputSgl" style="width:84%;" readonly="readonly" onchange="loadDictPropertyData('+index+');" value="'+fdLabelList_index_fdTabBean+'"/>'
					 + '<a onclick="selectDictModelByFdUrlPrefix('+index+');return false;" href=""><bean:message key="dialog.selectOther" /></a>'
					 + '<span class="txtstrong">*</span>'
		             +'</div>';
		}
		setInit(index,fdTabType_index);
		$('#dynamicBuildTdEdit_'+index).html(dynDiv);
	}

	//选择图标
	function selectIcon(index, _this) {
		//var typeName="fdLabelList["+index+"].fdTabType";
		//var type = $('select[name='+typeName+']').val();
		var type = 'module';
		var objName = "fdLabelList[" + index + "].fdTabIcon";
		var obj = $('input[name="' + objName + '"]')[0];
		var style = "dialogWidth:410px; dialogHeight:315px; status:0;scroll:1; help:0; resizable:1";
		var requestUrl = Com_Parameter.ContextPath+ "third/pda/pda_module_config_main/pdaModuleConfigMain.do?method=selectIcon&type="+ type ;
		var rtnVal = window.showModalDialog(requestUrl, obj, style);
		var iconSrc = obj.value;
		if (iconSrc && iconSrc.substring(0, 1) == "/"){
			iconSrc = iconSrc.substring(1, iconSrc.length);
		}
		if (iconSrc && iconSrc.substring(0, 1) == "h") {
			var searchIndex = iconSrc.search(Com_Parameter.ContextPath);
			var contextPathLeng = Com_Parameter.ContextPath.length;
			iconSrc = iconSrc.substring(searchIndex + contextPathLeng,iconSrc.length);
			obj.value='/'+iconSrc;
		}
		 else {
			iconSrc = "third/pda/resource/images/icon/module_default.png";
		}
		_this.src = Com_Parameter.ContextPath + iconSrc;
	}

    //新增或者编辑时候，设置初始化值
	function setInit(index,fdTabType_index){
		
		//根据当前最大行号，设置动态行当前排序号
		var fdLabelList_index_fdTabOrder = $('input[name="fdLabelList['+index+'].fdTabOrder"]');
		var method_GET = $('input[name="method_GET"]').val();
		var maxLine= $('#TABLE_DocList').find('tr').length-1;
		if(method_GET=='add'){
			fdLabelList_index_fdTabOrder.val(maxLine);
		}else if(method_GET=='edit'){
            if(fdLabelList_index_fdTabOrder.val()==''){
            	fdLabelList_index_fdTabOrder.val(maxLine);
            }
		}

		//根据标签类型，设置标签名
		if(fdTabType_index!=null && fdTabType_index!='' && typeof(fdTabType_index)!='undefined'){
			var fdTabType_index_msg = getFdTabTypeIndexMsg(fdTabType_index);
			if(fdTabType_index_msg!=''){
				var fdLabelList_index_fdTabName = $('input[name="fdLabelList['+index+'].fdTabName"]');
				fdLabelList_index_fdTabName.val(fdTabType_index_msg);
			}
		}
		
	}

	//根据标签类型获取标签名称
	function getFdTabTypeIndexMsg(fdTabType_index){
		 var msg = '';
		 if(fdTabType_index=='module'){
           msg = '<bean:message bundle="third-pda" key="pdaTabViewLabelList.fdTabType.module" />';
		 }else if(fdTabType_index=='list'){
		   msg = '<bean:message bundle="third-pda" key="pdaTabViewLabelList.fdTabType.list" />';
		 }else if(fdTabType_index=='listcategory'){
		   msg = '<bean:message bundle="third-pda" key="pdaTabViewLabelList.fdTabType.listcategory" />';
		 }else if(fdTabType_index=='doc'){
		   msg = '<bean:message bundle="third-pda" key="pdaTabViewLabelList.fdTabType.doc" />';
		 }else if(fdTabType_index=='search'){
		   msg = '<bean:message bundle="third-pda" key="pdaTabViewLabelList.fdTabType.search" />';
		 }
		 return msg;    
	}

</script>

<%@ include file="/resource/jsp/edit_down.jsp"%>