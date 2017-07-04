<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="config.list">
	<c:if test="${queryPage.totalrows<=0}">
		<template:replace name="toolbar">
			<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float" var-navwidth="95%">
				<kmss:auth requestURL="/sys/zone/sys_zone_person_data_cate/sysZonePersonDataCate.do?method=add">
					<ui:button text="${ lfn:message('button.add') }" 
						onclick="add();">
					</ui:button>
				</kmss:auth>
<%-- 				<kmss:auth requestURL="/sys/zone/sys_zone_person_data_cate/sysZonePersonDataCate.do?method=deleteall"> --%>
<%-- 					<ui:button text="${ lfn:message('button.delete') }" --%>
<%-- 						onclick="if(!List_ConfirmDel())return;Com_Submit(document.sysZonePersonDataCateForm, 'deleteall');"> --%>
<%-- 					</ui:button> --%>
<%-- 				</kmss:auth> --%>
			</ui:toolbar>
		</template:replace>
	</c:if>
	
 
	<template:replace name="content">
	
<html:form action="/sys/zone/sys_zone_person_data_cate/sysZonePersonDataCate.do">
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
<!-- 				<td width="10pt"> -->
<!-- 					<input type="checkbox" name="List_Tongle"> -->
<!-- 				</td> -->
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<sunbor:column property="sysZonePersonDataCate.fdName">
					<bean:message bundle="sys-zone" key="sysZonePersonDataCate.fdName"/>
				</sunbor:column>
<%-- 				<sunbor:column property="sysZonePersonDataCate.docStatus"> --%>
<%-- 					<bean:message bundle="sys-zone" key="sysZonePersonDataCate.docStatus"/> --%>
<%-- 				</sunbor:column> --%>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="sysZonePersonDataCate" varStatus="vstatus">
			<tr
				kmss_href="<c:url value="/sys/zone/sys_zone_person_data_cate/sysZonePersonDataCate.do" />?method=view&fdId=${sysZonePersonDataCate.fdId}">
<!-- 				<td> -->
<%-- 					<input type="checkbox" name="List_Selected" value="${sysZonePersonDataCate.fdId}"> --%>
<!-- 				</td> -->
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysZonePersonDataCate.fdName}" />
				</td>
<!-- 				<td> -->
<%-- 					${sysZonePersonDataCate.docStatus eq '1' ? '启用' : '禁用'} --%>
<!-- 				</td> -->
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
	<script>
	Com_IncludeFile("jquery.js");
		function add() {
			var canAdd = true;
			//校验
			$.ajax({
				async:false,
				type:"post",
				url:"${LUI_ContextPath}/sys/zone/sys_zone_person_data_cate/sysZonePersonDataCate.do?method=validateAdd",
				success:function(data) {
					if(data == "false") {
						canAdd = false;
					}
				}
			});
			if(canAdd) {
				Com_OpenWindow('${LUI_ContextPath}/sys/zone/sys_zone_person_data_cate/sysZonePersonDataCate.do?method=add');
			} else {
				alert("目录模版已存在，请尝试刷新页面");
			}
		}
	</script>
	</template:replace>
</template:include>