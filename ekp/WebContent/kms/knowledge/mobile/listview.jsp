<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<div data-dojo-type="mui/header/Header"
	data-dojo-props="height:'3.8rem'">
	<div data-dojo-type="mui/nav/MobileCfgNavBar"
		data-dojo-props="defaultUrl:'/kms/knowledge/mobile/nav.jsp',modelName:'com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc'">
	</div>
	<div data-dojo-type="mui/header/HeaderItem"
		data-dojo-mixins="mui/folder/Folder"
		data-dojo-props="tmplURL:'/kms/knowledge/mobile/query.jsp'"></div>
</div>

<div data-dojo-type="mui/list/NavSwapScrollableView">
	<ul data-dojo-type="mui/list/JsonStoreList"
		data-dojo-mixins="mui/list/ComplexRItemListMixin">
	</ul>
</div>

