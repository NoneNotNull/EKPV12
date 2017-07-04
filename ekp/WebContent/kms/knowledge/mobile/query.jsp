<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<div data-dojo-type="mui/query/QueryList" data-dojo-props="topHeight:!{topHeight}">
	<div data-dojo-type="mui/query/QueryListItem" 
		data-dojo-mixins="mui/simplecategory/SimpleCategoryDialogMixin" 
		data-dojo-props="label:'${lfn:message("portlet.cate") }',icon:'mui mui-Csort',
			modelName:'com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory',
			redirectURL:'/kms/knowledge/mobile/index.jsp?moduleName=!{curNames}&filter=1',
			filterURL:'/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDocIndex.do?method=listChildren&orderby=docPublishTime&ordertype=down&categoryId=!{curIds}'">
	</div>
	<div data-dojo-type="mui/query/QueryListItem"
		data-dojo-mixins="mui/search/SearchBarDialogMixin" 
		data-dojo-props="label:'${lfn:message("button.search") }',icon:'mui mui-Csearch', modelName:'com.landray.kmss.kms.wiki.model.KmsWikiMain;com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge'">
	</div>
	<div data-dojo-type="mui/query/QueryListItem"
		data-dojo-mixins="mui/query/CommonQueryDialogMixin" 
		data-dojo-props="label:'${lfn:message("list.search") }',icon:'mui mui-query',
			redirectURL:'/kms/knowledge/mobile/index.jsp?moduleName=!{text}&filter=1',
			store:[{'text':'${ lfn:message('list.create') }','dataURL':'/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDocIndex.do?method=listChildren&orderby=docPublishTime&q.mydoc=create'},
			{'text':'${ lfn:message('list.approval') }','dataURL':'/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDocIndex.do?method=listChildren&orderby=docPublishTime&q.mydoc=approval'},
			{'text':'${ lfn:message('list.approved') }','dataURL':'/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDocIndex.do?method=listChildren&orderby=docPublishTime&q.mydoc=approved'},
			{'text':'${lfn:message('kms-knowledge:kmsKnowledge.introduced')}','dataURL':'/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDocIndex.do?method=listChildren&orderby=docPublishTime&q.docIsIntroduced=1'},
			{'text':'${ lfn:message('list.alldoc') }','dataURL':'/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDocIndex.do?method=listChildren&orderby=docPublishTime'},
			{'text':'我的草稿箱','dataURL':'/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDocIndex.do?method=listChildren&orderby=docPublishTime&q.docStatus=10'}
			]">
	</div>
</div>

