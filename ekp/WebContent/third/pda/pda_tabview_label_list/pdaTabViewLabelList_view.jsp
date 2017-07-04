<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<center>
<table  class="tb_normal" width="100%" id="TABLE_DocList" style="margin-top: -15px;TABLE-LAYOUT: fixed;WORD-BREAK: break-all;;margin-bottom: -15px;">

    <c:set var="fdTabIconDefault" value='/third/pda/resource/images/icon/module_default.png'/>
   
	<tr>
		<td width="3%" KMSS_IsRowIndex="1" class="td_normal_title"><bean:message key="page.serial" /></td>
		<td width="15%" class="td_normal_title"><bean:message bundle="third-pda" key="pdaTabViewLabelList.fdTabName"/><span class="txtstrong">*</span></td>
		<td width="10%" class="td_normal_title"><bean:message bundle="third-pda" key="pdaTabViewLabelList.fdTabType"/><span class="txtstrong">*</span></td>
		<td width="55%" class="td_normal_title"><bean:message bundle="third-pda" key="pdaTabViewLabelList.fdConfigurationItem"/><span class="txtstrong">*</span></td>
		<td width="85px;" align="center" class="td_normal_title"><bean:message bundle="third-pda" key="pdaTabViewConfigMain.fdStatus"/></td>
	</tr>
	
	<!--内容行-->
	<c:forEach items="${pdaTabViewConfigMainForm.fdLabelList}" var="pdaTabViewLabelListForm" varStatus="vstatus">
		<tr KMSS_IsContentRow="1">
			<td width="3%" KMSS_IsRowIndex="1" id="KMSS_IsRowIndex_View">${vstatus.index+1}</td>
			<td width="15%">
			    <c:out value="${pdaTabViewLabelListForm.fdTabName}" />
			</td>
			<td width="10%">
			    <div id = "dynamicBuildFdTabTypeView_${vstatus.index}" style="display:block"></div>
			</td>
			<td width="55%" height="30px">
			    <div id = "dynamicBuildTdView_${vstatus.index}" style="display:block"></div>
			</td>
			<td align="center" width="85px;">
			    <c:if test="${pdaTabViewLabelListForm.fdStatus=='1'}">
				    <bean:message key="message.yes"/>
			    </c:if>
			    <c:if test="${pdaTabViewLabelListForm.fdStatus!='1'}">
				    <bean:message key="message.no"/>
			    </c:if>
			</td>
			<input type="hidden" id="fdLabelList_${vstatus.index}_fdTabUrl" value="${pdaTabViewLabelListForm.fdTabUrl}" />
			<input type="hidden" id="fdLabelList_${vstatus.index}_fdTabBean" value="${pdaTabViewLabelListForm.fdTabBean}" />
			<input type="hidden" id="fdLabelList_${vstatus.index}_fdTabType" value="${pdaTabViewLabelListForm.fdTabType}" />
		</tr>
	</c:forEach>
	
</table>
</center>

<script>

	//页面加载的时候需要加载函数
	$(document).ready(function(){
		initDynamicBuildTdView();
	})
	
	//初始化编辑页面 动态构建“选择组件”列
	function initDynamicBuildTdView(){
		var updateRow = $('#TABLE_DocList').find('tr').length-1;
		if(updateRow>0){
			for(var i=0;i<updateRow;i++){
				dynamicBuildTdView(i);
			}
		}
	}

	//编辑界面 动态构建“选择组件”列
	function dynamicBuildTdView(index) {
		var dynDiv = '';
		var fdModuleName = $('#fdModuleName').val();
		var fdTabType_index = $("#fdLabelList_"+index+"_fdTabType").val();
		var fdLabelList_index_fdTabUrl = $("#fdLabelList_"+index+"_fdTabUrl").val();
		var fdLabelList_index_fdTabBean = $("#fdLabelList_"+index+"_fdTabBean").val();
		if (fdTabType_index == 'module') {
			dynDiv += '<div id=fdTabType_module_'+index+' style="display:block">'+fdModuleName+'</div>';
		}
		if (fdTabType_index == 'list') {
			dynDiv += '<div id=fdTabType_list_'+index+' style="display:block">'+fdLabelList_index_fdTabUrl+'</div>';
		}
		if (fdTabType_index == 'listcategory') {
			dynDiv += '<div id="fdTabType_listcategory_'+index+'" style="display:block">'+fdLabelList_index_fdTabUrl+'</div>';
		}
		if (fdTabType_index == 'doc') {
			dynDiv += '<div id="fdTabType_doc_'+index+'" style="display:block">'+fdLabelList_index_fdTabUrl+'</div>';
		}
		if (fdTabType_index == 'search') {
			dynDiv += '<div id="fdTabType_search_'+index+'" style="display:block">'+fdLabelList_index_fdTabBean+'</div>';
		}
		setFdTabNameByFdTabType(index,fdTabType_index);
		$('#dynamicBuildTdView_'+index).html(dynDiv);
	}

    //根据标签类型，设置标签名
	function setFdTabNameByFdTabType(index,fdTabType_index){
		if(fdTabType_index!=null && fdTabType_index!='' && typeof(fdTabType_index)!='undefined'){
			var fdTabType_index_msg = getFdTabTypeIndexMsg(fdTabType_index);
			if(fdTabType_index_msg!=''){
				var dynDiv= '<div id=dyn_fdTabType__'+index+' style="display:block">'+fdTabType_index_msg+'</div>';
				$('#dynamicBuildFdTabTypeView_'+index).html(dynDiv);
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

<%@ include file="/resource/jsp/view_down.jsp"%>