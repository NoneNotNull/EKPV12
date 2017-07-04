<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="java.util.List"%>
<link type="text/css" rel="stylesheet" href="${LUI_ContextPath}/km/imissive/resource/css/jquery.qtip.css" />
<template:include ref="default.view" sidebar="no">
	<template:replace name="title">
		<c:out value="${ kmImissiveRegForm.fdName } - ${ lfn:message('km-imissive:module.km.imissive') }"></c:out> 
	</template:replace>
	<template:replace name="toolbar">
		<ui:toolbar  id="toolbar" layout="sys.ui.toolbar.float" count="3">
		<ui:button text="${lfn:message('button.close')}" order="5" onclick="Com_CloseWindow();">
		</ui:button>
		</ui:toolbar>
</template:replace>
<template:replace name="content">
<script language="JavaScript">
	Com_IncludeFile("jquery.js");
</script>
	<div class="lui_form_content_frame" style="padding-top:10px">
		<html:form action="/km/imissive/km_imissive_reg/kmImissiveReg.do"> 
			<input type="hidden" name="fdtempId"/>
			<input type="hidden" name="fdtempName"/>
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
						<a class="com_btn_link" href="javascript:void(0)" onclick="openDoc();"><c:out value="${kmImissiveRegForm.fdName}" /></a>
					</td>
				</tr>
				 <tr>
					<td class="td_normal_title" width=15%>
						发文编号
					</td>
					<td width=35%>
						<c:if test="${empty kmImissiveRegForm.fdNo}">
					          	${lfn:message("km-imissive:kmImissiveSendMain.fdDocNum.auto") }
					    </c:if>
					    <c:if test="${not empty kmImissiveRegForm.fdNo}">
					          <c:out value="${kmImissiveRegForm.fdNo}" />
					    </c:if>
					</td>
					<td class="td_normal_title" width=15%>
						登记日期
					</td>
					<td width=35%>
						<c:out value="${kmImissiveRegForm.docCreateTime}"/>
					</td>
				</tr>
			</table><br>
			<table class="tb_normal" width=100%>
			    <tr>
					<td class="td_normal_title" colspan="4">
						 <p class="txttitle">接收反馈信息</p>
					</td>
				</tr>
				 <tr>
					<td class="td_normal_title" width="50px">
						序号
					</td>
					<td class="td_normal_title">
						发往单位
					</td>
					<td class="td_normal_title">
						接收人
					</td>
					<td class="td_normal_title">
						状态
					</td>
				</tr>
				<c:forEach items="${kmImissiveRegForm.fdDetailListForms}" var="fdDetailListForm" varStatus="vstatus">
					<tr>
						<td>
							${vstatus.index+1}
						</td>
						<td>
							${fdDetailListForm.fdUnitName}
						</td>
						<td>
							${fdDetailListForm.fdOrgNames}
						</td>
						<td>
							 <c:if test="${fdDetailListForm.fdStatus != '3'}">
					            <sunbor:enumsShow value="${fdDetailListForm.fdStatus}" enumsType="kmImissiveReg_status" bundle="km-imissive" />
							 </c:if>
							 <c:if test="${fdDetailListForm.fdStatus eq '3'}">
								<div class="aaa com_btn_link" style="cursor:pointer" id="${fdDetailListForm.fdId}">已退回</div>
							 </c:if>
						</td>
					</tr>
			 </c:forEach>
			</table>
		</html:form>	
		</div>
<script type="text/javascript" src="${LUI_ContextPath}/km/imissive/resource/js/jquery.qtip.js" charset="UTF-8"></script>
<script type="text/javascript" src="${LUI_ContextPath}/km/imissive/resource/js/hogan.js" charset="UTF-8"></script>
<!-- 模板 -->
<script id="equipInfo-Template" type="text/template">
<div style="overflow:hidden;width:200px;">
<ul>
 <li style="font-size:12px;margin-bottom:5px">退回意见:{{fdContent}}</li>
 <li style="font-size:12px;margin-bottom:5px">退回人:{{docCreator}}</li>
 <li style="font-size:12px;margin-bottom:5px">退回单位:{{fdUnitName}}</li>
 <li style="font-size:12px;margin-bottom:5px">退回时间:{{docCreateTime}}</li>
</ul>
</div>
</script>
<script>
function openDoc(){
		var url = "${LUI_ContextPath}${kmImissiveRegForm.fdLink}";
		window.open(url);
}
 function ccc(){
	var source = $("#equipInfo-Template").html();  
	var template = Hogan.compile(source);
	$(".aaa").each(function(){
		$(this).qtip({
			content: {
				text: 'Loading...',
				ajax: {
					url: "${KMSS_Parameter_ContextPath}km/imissive/km_imissive_return_opinion/kmImissiveReturnOpinion.do?method=loadOpinionById&fdDetailId="+this.id,
					type: 'GET', // POST or GET
					dataType:"json",
					success: function(data, status) {
						this.set('content.text', template.render(data));
					}
				}
			},
		    position: {
				my: 'right top',
				at: 'right bottom',
			    effect: false,
			    target: 'mouse'
			}
		})
	});
  }
  $(document).ready(function(){
	  ccc();
 });
</script>
</template:replace>
</template:include>
