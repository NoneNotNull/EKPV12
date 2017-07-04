<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<template:include ref="mobile.list">
	<template:replace name="title">
		<c:if test="${param.moduleName!=null && param.moduleName!=''}">
			<c:out value="${param.moduleName}"></c:out>
		</c:if>
		<c:if test="${param.moduleName==null || param.moduleName==''}">
			知识仓库
		</c:if>
	</template:replace>
	<template:replace name="head">
	</template:replace>
	<template:replace name="content">

		<c:choose>
			<c:when test="${ param.filter == '1' }">
				<c:import url="/kms/knowledge/mobile/filter.jsp"
					charEncoding="UTF-8">
				</c:import>
			</c:when>
			<c:otherwise>
				<c:import url="/kms/knowledge/mobile/listview.jsp"
					charEncoding="UTF-8">
				</c:import>
			</c:otherwise>
		</c:choose>

		<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom">
			<li data-dojo-type="mui/back/BackButton"
				data-dojo-props="align:'left'"></li>
			<li data-dojo-type="mui/tabbar/CreateButton"
				data-dojo-mixins="mui/simplecategory/SimpleCategoryMixin"
				data-dojo-props="createUrl:'/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=add&fdTemplateId=!{curIds}',
		  		modelName:'com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory'"></li>
			<li data-dojo-type="mui/tabbar/TabBarButtonGroup"
				data-dojo-props="icon1:'mui mui-more',align:'right'">
				<div data-dojo-type="mui/back/HomeButton"></div>
			</li>
		</ul>

	</template:replace>
</template:include>
