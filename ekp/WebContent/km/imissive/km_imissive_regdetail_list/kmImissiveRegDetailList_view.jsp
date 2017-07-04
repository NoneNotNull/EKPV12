<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="java.util.List"%>
<template:include ref="default.view" sidebar="no">
	<template:replace name="title">
		<c:out value="${ kmImissiveRegForm.fdName } - ${ lfn:message('km-imissive:module.km.imissive') }"></c:out> 
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar  id="toolbar" layout="sys.ui.toolbar.float" count="3">
	    <kmss:auth requestURL="/km/imissive/km_imissive_regdetail_list/kmImissiveRegDetailList.do?method=editDocNum&fdId=${param.fdId}" requestMethod="GET">
			<c:if test="${kmImissiveRegDetailListForm.fdStatus!='2' and kmImissiveRegDetailListForm.fdStatus!=3}">
			    <ui:button text="签收" order="1" onclick="updateSign();">
				</ui:button>
				<c:if test="${kmImissiveRegDetailListForm.fdRegDeliverType=='2' and kmImissiveRegDetailListForm.fdStatus!='3'}">
				  <ui:button text="退回" order="1" onclick="addBack();">
				  </ui:button>
				</c:if>
			</c:if>
		</kmss:auth>
		<ui:button text="${lfn:message('button.close')}" order="5" onclick="Com_CloseWindow();">
		</ui:button>
		</ui:toolbar>
</template:replace>
<template:replace name="content">
<script>
Com_IncludeFile("dialog.js");
	seajs.use(['sys/ui/js/dialog'], function(dialog) {
		window.dialog=dialog;
	});
	window.updateSign = function(){
			 Dialog_Tree(false, 'fdtempId', 'fdtempName', ',', 
		             'kmImissiveCfgTreeService&type=SR&fdSendId=${kmImissiveRegDetailListForm.fdRegSendId}','办件模板',null, function(){
			             var idString = document.getElementsByName("fdtempId")[0].value;
			             if(idString!=""){
			            	 var idArray = idString.split(";");
				             var fdTemplateId = idArray[0];
				             var fdCfgId =idArray[1];
				             var url = "${LUI_ContextPath}/km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do?method=addReceive&fdTemplateId="+fdTemplateId+"&fdCfgId="+fdCfgId+"&fdSendId=${kmImissiveRegDetailListForm.fdRegSendId}&fdDeliverType=${kmImissiveRegDetailListForm.fdRegDeliverType}&fdReceiveUnitId=${kmImissiveRegDetailListForm.fdUnitId}&fdReceiveUnitName=${kmImissiveRegDetailListForm.fdUnitName}&fddetaiId=${kmImissiveRegDetailListForm.fdId}";
				             window.open(url, "_self");
			             }
				       }, '', false, true);
	};
	window.addBack = function(){
         var url = "${LUI_ContextPath}/km/imissive/km_imissive_return_opinion/kmImissiveReturnOpinion.do?method=add&fdImissiveId=${kmImissiveRegDetailListForm.fdRegSendId}&fdReceiveUnitId=${kmImissiveRegDetailListForm.fdUnitId}&fdReceiveUnitName=${kmImissiveRegDetailListForm.fdUnitName}&fddetaiId=${kmImissiveRegDetailListForm.fdId}";
         window.open(url, "_self");
    };
	window.openDoc = function(){
		var url = "${LUI_ContextPath}${kmImissiveRegDetailListForm.fdRegLink}";
		window.open(url);
	};
</script>
	<div class="lui_form_content_frame" style="padding-top:10px">
		<html:form action="/km/imissive/km_imissive_regdetail_list/kmImissiveRegDetailList.do"> 
			<input type="hidden" name="fdtempId"/>
			<input type="hidden" name="fdtempName"/>
			<input type="hidden" name="fdTableHead"/>
		    <table class="tb_normal" width=100%>
			   <html:hidden property="fdId"/>
			    <tr>
					<td class="td_normal_title" colspan="4">
						 <p class="txttitle">发放登记单</p>
					</td>
				</tr>
			   <tr>
					<td class="td_normal_title" width=15%>
						名称
					</td>
					<td width=35% colspan="3">
						<a class="com_btn_link" href="javascript:void(0)" onclick="openDoc();"><c:out value="${kmImissiveRegDetailListForm.fdRegName}" /></a>
					</td>
				</tr>
				 <tr>
					<td class="td_normal_title" width=15%>
						发文编号
					</td>
					<td width=35%>
					    <c:if test="${empty kmImissiveRegDetailListForm.fdRegNo}">
					          	${lfn:message("km-imissive:kmImissiveSendMain.fdDocNum.auto") }
					    </c:if>
					    <c:if test="${not empty kmImissiveRegDetailListForm.fdRegNo}">
					              <c:out value="${kmImissiveRegDetailListForm.fdRegNo}" />
					    </c:if>
					</td>
					<td class="td_normal_title" width=15%>
						登记日期
					</td>
					<td width=35%>
						<c:out value="${kmImissiveRegDetailListForm.fdRegDocCreateTime}"/>
					</td>
				</tr>
				 <tr>
					<td class="td_normal_title" width=15%>
						发往单位
					</td>
					<td width=85% colspan="3">
						<c:out value="${kmImissiveRegDetailListForm.fdUnitName}" />
					</td>
				</tr>
				<tr>
					<td class="td_normal_title" width=15%>
						接收人
					</td>
					<td width=35%>
						<c:out value="${kmImissiveRegDetailListForm.fdOrgNames}" />
					</td>
					<td class="td_normal_title" width=15%>
						状态
					</td>
					<td width=35%>
						 <sunbor:enumsShow value="${kmImissiveRegDetailListForm.fdStatus}" enumsType="kmImissiveReg_status" bundle="km-imissive" />
					</td>
				</tr>
				<c:if test="${not empty kmImissiveRegDetailListForm.fdSignTime}">
					 <tr>
						<td class="td_normal_title" width=15%>
							签收人
						</td>
						<td width=35%>
							<c:out value="${kmImissiveRegDetailListForm.fdSignerName}"/>
						</td>
						<td class="td_normal_title" width=15%>
							签收时间
						</td>
						<td width=35%>
							<c:out value="${kmImissiveRegDetailListForm.fdSignTime}"/>
						</td>
					</tr>
				</c:if>
				<c:if test="${kmImissiveRegDetailListForm.fdStatus eq '3'}">
					 <tr>
						<td class="td_normal_title" width=15%>
							退回原因
						</td>
						<td width=85% colspan="3">
							<c:out value="${docContent}"/>
						</td>
					</tr>
				</c:if>
			</table>
			
		</html:form>	
		</div>
</template:replace>
</template:include>
