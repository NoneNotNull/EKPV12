<%@page import="com.landray.kmss.sys.property.model.SysPropertyTemplate"%>
<%@page
	import="com.landray.kmss.sys.property.interfaces.ISysPropertyTemplate"%>
<%@page
	import="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory"%>
<%@page
	import="com.landray.kmss.kms.knowledge.service.IKmsKnowledgeCategoryService"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<div data-dojo-type="mui/header/Header"
	data-dojo-props="height:'3.8rem'">
	<div data-dojo-type="mui/header/HeaderItem"
		data-dojo-mixins="mui/folder/_Folder,mui/back/HrefBackMixin"
		data-dojo-props="href:'/kms/knowledge/mobile/index.jsp'"></div>
	<div data-dojo-type="mui/header/HeaderItem"
		data-dojo-props="label:'${param.moduleName}',referListId:'_filterDataList'">
	</div>
	<div data-dojo-type="mui/header/HeaderItem"
		data-dojo-mixins="mui/folder/_Folder,mui/simplecategory/SimpleCategoryDialogMixin"
		data-dojo-props="icon:'mui mui-ul',
			modelName:'com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory',
			redirectURL:'/kms/knowledge/mobile/index.jsp?moduleName=!{curNames}&filter=1',
			filterURL:'/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDocIndex.do?method=listChildren&categoryId=!{curIds}&q.docStatus=30'">
	</div>

	<%
		Boolean hasTemplate = Boolean.FALSE;
		String queryStr = request.getParameter("queryStr");
		if (StringUtil.isNotNull(queryStr)) {
			String categoryId = StringUtil.getParameter(queryStr,
					"categoryId");
			request.setAttribute("categoryId", categoryId);
			IKmsKnowledgeCategoryService service = (IKmsKnowledgeCategoryService) SpringBeanUtil
					.getBean("kmsKnowledgeCategoryService");
			KmsKnowledgeCategory category = (KmsKnowledgeCategory) service
					.findByPrimaryKey(categoryId);
			if (category instanceof ISysPropertyTemplate) {
				ISysPropertyTemplate __cate = (ISysPropertyTemplate) category;
				SysPropertyTemplate template = __cate
						.getSysPropertyTemplate();
				if (template != null)
					hasTemplate = Boolean.TRUE;
			}
		}

		if (hasTemplate) {
	%>
	<div data-dojo-type="mui/header/HeaderItem"
		data-dojo-mixins="mui/folder/_Folder,mui/property/PropertyDialogMixin"
		data-dojo-props="icon:'mui mui-attachment',modelName:'com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory',fdCategoryId:'${categoryId }',referListId:'_filterDataList'"></div>
	<%
		}
	%>
</div>
<div id="scroll" data-dojo-type="mui/list/StoreScrollableView">
	<div data-dojo-type="mui/search/SearchBar"
		data-dojo-props="modelName:'com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc',needPrompt:false,height:'3.8rem'">
	</div>
	<ul id="_filterDataList" data-dojo-type="mui/list/JsonStoreList"
		data-dojo-mixins="mui/list/ComplexRItemListMixin"
		data-dojo-props="url:'${param.queryStr}', lazy:false">
	</ul>
</div>
