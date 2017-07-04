<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

[ 
	{ 
		url : '/km/doc/km_doc_knowledge/kmDocKnowledgeIndex.do?method=listChildren&q.docStatus=30&orderby=docCreateTime&ordertype=down', 
		text : '${lfn:message('km-doc:kmDoc.tree.myJob.alldoc')}'
	},
	{
		url : '/km/doc/km_doc_knowledge/kmDocKnowledgeIndex.do?method=listChildren&q.mydoc=create&orderby=docCreateTime&ordertype=down',
		text: '${lfn:message('km-doc:kmDoc.myhome.doc')}'
	}
]