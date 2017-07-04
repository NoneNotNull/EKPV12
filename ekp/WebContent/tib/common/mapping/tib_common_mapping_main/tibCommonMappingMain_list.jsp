<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ taglib uri="/tib/common/resource/tld/erp-ekp.tld" prefix="erp"%>

<%@page import="java.net.URLEncoder"%>
<template:include file="/tib/common/tib_ui_list.jsp">
	<template:replace name="title">${ lfn:message('tib-common:module.tib.manage') }</template:replace>
	<template:replace name="path">
		<ui:combin ref="menu.path.tib.category">
			<ui:varParams 
				id="categoryId"
				subHome="${ lfn:message('tib-common:module.tib.common') }" 
				moduleTitle="${ lfn:message('tib-common-mapping:tree.form.flow.mapping') }" 
				href="javascript:parent.tibLoadList('/tib/common/mapping/tib_common_mapping_main/tibCommonMappingMain.do?method=listTemplate&parentId=!{value}&fdModuleName=encodeURIComponent(${param.fdModuleName})&templateName=${param.templateName }&mainModelName=${param.mainModelName }&settingId=${param.settingId}');"
				modelName="${param.templateName }" 
				categoryId="${param.parentId }" />
		</ui:combin>
	</template:replace>
	<template:replace name="content">
	<%-- 显示列表按钮行 --%>
	<div class="lui_list_operation">
		
	</div>
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	
	<table id="List_ViewTable" class="lui_listview_columntable_table">
		<tr style="background-color:rgb(248, 248, 248);">
			<sunbor:columnHead htmlTag="td">
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
					<td>
					<bean:message key="tibCommonMappingMain.flow.template.name"  bundle="tib-common-mapping" />
				</td>
					<td>
					<bean:message key="tibCommonMappingMain.relation.func"  bundle="tib-common-mapping" />
				</td>
			</sunbor:columnHead>
		</tr>
		<list:listview id="listview">
		<c:forEach items="${queryPage.list}" var="temp" varStatus="vstatus">
		<%Object[] temp=(Object[])pageContext.getAttribute("temp");//对模板名称name进行编码，把在链接中传递的中文参数编码
		      String name=URLEncoder.encode((String)temp[1], "UTF-8");
		      pageContext.setAttribute("name",name);
		%>
			<tr style="cursor: pointer;"
				onclick="window.open('${LUI_ContextPath}/tib/common/mapping/tib_common_mapping_main/tibCommonMappingMain.do?method=add&templateId=${temp[0]}&name=${name}&mainModelName=${param.mainModelName}&templateName=${param.templateName}&settingId=${param.settingId}');">
				<td>
					${vstatus.index+1}
				</td>	
					<td>
						${temp[1]}	
				</td>
					<td>
				<erp:funcNameList fdTemplateId="${temp[0]}" fdType="${queryPage.orderby }"/>
				</td>
			</tr>
			<%--列表形式--%>
			<list:colTable isDefault="false" layout="sys.ui.listview.columntable" 
				rowHref="/tib/common/mapping/tib_common_mapping_main/tibCommonMappingMain.do?method=add&templateId=${temp[0]}&name=${name}&mainModelName=${param.mainModelName}&templateName=${param.templateName}&settingId=${param.settingId}" name="columntable">
				<list:col-checkbox></list:col-checkbox>
				<list:col-serial></list:col-serial>
				<list:col-auto props=""></list:col-auto>
			</list:colTable> 
		</c:forEach>
		</list:listview>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</template:replace>
</template:include>
<%@ include file="/resource/jsp/list_down.jsp"%>
	
