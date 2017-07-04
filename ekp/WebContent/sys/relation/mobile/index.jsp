<%@page import="com.landray.kmss.sys.relation.model.SysRelationMain"%>
<%@page import="java.util.List"%>
<%@page
	import="com.landray.kmss.sys.relation.service.ISysRelationMainService"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="mobile.list">
	<template:replace name="head">
		<%
					String modelName = request.getParameter("modelName");
					String modelId = request.getParameter("modelId");
					ISysRelationMainService service = (ISysRelationMainService) SpringBeanUtil
							.getBean("sysRelationMainService");
					List<SysRelationMain> list = service.findModel(modelName, modelId);
					if(list.size()>0)
						request.setAttribute("relations",list.get(0).getFdRelationEntries());
		%>
	</template:replace>
	<template:replace name="content">
		<div data-dojo-type="mui/view/DocScrollableView" class="muiRelation">
			<div data-dojo-type="mui/panel/AccordionPanel" class="muiRelationAccordion" data-dojo-mixins="mui/panel/_FixedPanelMixin">
				<c:forEach items="${relations }" var="relation" varStatus="status">
					<div data-dojo-type="mui/panel/Content" data-dojo-props="title:'${relation.fdModuleName }',icon:'mui-relaType'">
						<ul class="muiRelationStoreList"
							data-dojo-type="mui/list/JsonStoreList"
							data-dojo-mixins="${LUI_ContextPath}/sys/relation/mobile/js/RelationItemListMixin.js"
							data-dojo-props="url:'/sys/relation/relation.do?method=result&forward=mobileList&currModelId=${param.modelId}&currModelName=${param.modelName}&sortType=time&fdType=${relation.fdType}&moduleModelId=${relation.fdId}&moduleModelName=${relation.fdModuleModelName}&showCreateInfo=true&rowsize=10',lazy:false">
						</ul>
					</div>
				</c:forEach>
			</div>
		</div>
		<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom">
			<li data-dojo-type="mui/back/BackButton"></li>
			<li data-dojo-type="mui/tabbar/TabBarButtonGroup"
				data-dojo-props="icon1:'mui mui-more'">
				<div data-dojo-type="mui/back/HomeButton"></div> 
				<c:import
					url="/sys/relation/mobile/import/view.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmsMultidocKnowledgeForm"></c:param>
				</c:import>
			</li>
		</ul>
	</template:replace>
</template:include>