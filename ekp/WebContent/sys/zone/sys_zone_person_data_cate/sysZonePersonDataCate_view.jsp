<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.view" sidebar="auto">
	<template:replace name="title">
		<c:out value="${ lfn:message('sys-zone:module.sys.zone') }"></c:out>
	</template:replace>
	<template:replace name="toolbar">
		<script>
		function deleteDoc(delUrl){
			seajs.use(['lui/dialog'],function(dialog){
				dialog.confirm('<bean:message key="page.comfirmDelete"/>',function(isOk){
					if(isOk){
						//校验能否删除
						var fdTempId ="${param.fdId}";
						var candel = true;
						$.ajax({
							async:false,
							type:"post",
							url:"${LUI_ContextPath}/sys/zone/sys_zone_person_data_cate/sysZonePersonDataCate.do?method=validateDel",
							data:"fdTempId=" + fdTempId,
							success: function(data) {
								if(data == "true") {
									seajs.use( [ 'sys/ui/js/dialog' ], function(dialog) {
										dialog.alert('该目录模版已经被关联无法删除', function() {
					
										});
									});
									candel = false;
								}
							}
						});
						if(!candel) {
							return;
						}
						Com_OpenWindow(delUrl,'_self');
					}	
				});
			});
		}
		</script>
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" count="3">
			<kmss:auth requestURL="/sys/zone/sys_zone_person_data_cate/sysZonePersonDataCate.do?method=edit&fdId=${param.fdId}" requestMethod="GET">
				<ui:button text="${lfn:message('button.edit')}" 
							onclick="Com_OpenWindow('sysZonePersonDataCate.do?method=edit&fdId=${param.fdId}','_self');" order="2">
				</ui:button>
			</kmss:auth>
<%-- 			<kmss:auth requestURL="/sys/zone/sys_zone_person_data_cate/sysZonePersonDataCate.do?method=delete&fdId=${param.fdId}" requestMethod="GET"> --%>
<%-- 				<ui:button text="${lfn:message('button.delete')}" order="4" --%>
<%-- 							onclick="deleteDoc('sysZonePersonDataCate.do?method=delete&fdId=${param.fdId}');"> --%>
<%-- 				</ui:button>  --%>
<%-- 			</kmss:auth> --%>
			<ui:button text="${lfn:message('button.close')}" order="5" onclick="Com_CloseWindow();">
			</ui:button>
		</ui:toolbar>
	</template:replace>
	<template:replace name="path">
<%-- 		<ui:menu layout="sys.ui.menu.nav">  --%>
<%-- 			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home"> --%>
<%-- 			</ui:menu-item>	 --%>
<%-- 			<ui:menu-item text="${ lfn:message('sys-zone:module.sys.zone') }"> --%>
<%-- 			</ui:menu-item> --%>
<%-- 		</ui:menu> --%>
	</template:replace>
	<template:replace name="content">
		<div class='lui_form_title_frame'>
			<div class='lui_form_subject'>
				    <bean:write	name="sysZonePersonDataCateForm" property="fdName" />
				<%--
				<c:if test="${isHasNewVersion=='true'}">
				     <span style="color:red">(<bean:message bundle="sys-doc" key="kmDoc.kmDocKnowledge.has" /><bean:message bundle="sys-doc" key="kmDoc.kmDocKnowledge.NewVersion" />)</span>
		        </c:if>
				--%>
			</div>
			<div class='lui_form_baseinfo'>
				<%--
				${ lfn:message('sys-zone:sysZonePersonDataCate.docCreator') }：
				<ui:person bean="${sysZonePersonDataCate.docCreator}"></ui:person>&nbsp;
				<c:if test="${ not empty sysZonePersonDataCateForm.docPublishTime }">
					<bean:write name="sysZonePersonDataCateForm" property="docPublishTime" />
				</c:if>&nbsp;
				<c:if test="${sysZonePersonDataCateForm.docStatus == '30'}">
				 <bean:message key="sysEvaluationMain.tab.evaluation.label" bundle="sys-evaluation"/>
					 <span data-lui-mark='sys.evaluation.fdEvaluateCount' class="com_number">
						 <c:choose>
						   <c:when test="${not empty sysZonePersonDataCateForm.evaluationForm.fdEvaluateCount}">
						      ${ sysZonePersonDataCateForm.evaluationForm.fdEvaluateCount }
						   </c:when>
						   <c:otherwise>(0)</c:otherwise>
						 </c:choose>
					 </span>
				</c:if>
				<bean:message key="sysReadLog.tab.readlog.label" bundle="sys-readlog"/><span data-lui-mark="sys.readlog.fdReadCount" class="com_number">(${ sysZonePersonDataCateForm.readLogForm.fdReadCount })</span>
				 --%>
			</div>
		</div>
		<%-- 文档概览
		<c:if test="${ not empty sysZonePersonDataCateForm.fdDescription }">
			<div class="lui_form_summary_frame">			
				<bean:write	name="sysZonePersonDataCateForm" property="fdDescription" />
			</div>
		</c:if>
		--%>
		<div class="lui_form_content_frame">
			<%-- 文档内容 --%>
<%-- 			<c:if test="${not empty sysZonePersonDataCateForm.docContent}"> --%>
<!-- 				<div style="min-height: 200px;"> -->
<%-- 					${sysZonePersonDataCateForm.docContent }	 --%>
<!-- 				</div>			 -->
<%-- 			</c:if> --%>
			<%-- 其它字段 --%>
			<table class="tb_normal" width=100%>
				<tr>
					<td class="td_normal_title" width=15%>
						<bean:message bundle="sys-zone" key="sysZonePersonDataCate.fdName"/>
					</td>
					<td width="85%" colspan="2">
						<xform:text property="fdName" style="width:85%" />
					</td>
<!-- 					<td class="td_normal_title" width=15%> -->
<%-- 						<bean:message bundle="sys-zone" key="sysZonePersonDataCate.docStatus"/> --%>
<!-- 					</td> -->
<!-- 					<td width="35%"> -->
<%-- 						<xform:text property="docStatus" style="width:85%" /> --%>
<%-- 							${sysZonePersonDataCateForm.docStatus eq '1' ? '启用' : '禁用'} --%>
<!-- 					</td> -->
				</tr>
				<%-- 标题行 == 开始 --%>
				<tr>
					<td align="center" width=15% class="td_normal_title">
						<bean:message bundle="sys-zone" key="sysZonePerDataTempl.fdOrder"/>
					</td>
					<td align="center" width=30% class="td_normal_title">
						<bean:message bundle="sys-zone" key="sysZonePerDataTempl.fdName"/>
					</td>
					<td align="center" width=40% colspan="2" class="td_normal_title">
						<bean:message bundle="sys-zone" key="sysZonePerDataTempl.docContent"/>
					</td>
				</tr>
				<%-- 标题行 == 结束 --%>
				<c:forEach items="${ sysZonePersonDataCateForm.fdDataCateTemplForms}" var="fdDataCateTemplForm">
					<tr>
						<!-- 排序号 -->
						<td align="center">
							${ fdDataCateTemplForm.fdOrder}
						</td>
						<!-- 目录名 -->
						<td align="center">
							${ fdDataCateTemplForm.fdName}
						</td>
						<!-- 内容 -->
						<td colspan="2">
							${ fdDataCateTemplForm.docContent}
						</td>
					</tr>
				</c:forEach>
			</table> 
		</div>
		<ui:tabpage expand="false">
		</ui:tabpage>
	</template:replace>
	<%--
	<template:replace name="nav">
		<div style="min-width:200px;"></div>
		<ui:accordionpanel style="min-width:200px;"> 
			<ui:content title="${ lfn:message('sys-doc:kmDoc.kmDocKnowledge.docInfo') }" toggle="false">
				<c:import url="/sys/evaluation/import/sysEvaluationMain_view_star.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="sysZonePersonDataCateForm" />
				</c:import>
				<ul class='lui_form_info'>
					<li><bean:message bundle="sys-zone" key="sysZonePersonDataCate.docCreator" />：
					<ui:person personId="${sysZonePersonDataCateForm.docCreatorId}" personName="${sysZonePersonDataCateForm.docCreatorName}"></ui:person></li>
					<li><bean:message bundle="sys-zone" key="sysZonePersonDataCate.docDept" />：${sysZonePersonDataCateForm.docDeptName}</li>
					<li><bean:message bundle="sys-zone" key="sysZonePersonDataCate.docStatus" />：<sunbor:enumsShow value="${sysZonePersonDataCateForm.docStatus}" enumsType="common_status" /></li>
					<li><bean:message bundle="sys-zone" key="sysZonePersonDataCate.docCreateTime" />：${sysZonePersonDataCateForm.docCreateTime }</li>				
				</ul>
			</ui:content>
		</ui:accordionpanel>
	</template:replace>
	--%>
</template:include>