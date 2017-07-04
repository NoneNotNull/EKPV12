<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page
	import="com.landray.kmss.kms.kmtopic.model.KmsKmtopicCatelogContent"%>
<%@page
	import="com.landray.kmss.kms.knowledge.util.KmsKnowledgeUtil"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page
	import="com.landray.kmss.kms.knowledge.service.IKmsKnowledgeBaseDocService"%>
<%@page
	import="com.landray.kmss.common.model.IBaseModel"%>
<%@page
	import="com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc"%>
<%@page
	import="com.landray.kmss.util.StringUtil"%>

<list:data>
	<list:data-columns var="item" list="${queryPage.list }">
		<list:data-column col="fdId">
			${item.fdKmId}
		</list:data-column>
		<list:data-column col="docSubject"
			title="${lfn:message('kms-kmtopic:kmsKmtopic.topic.docSubject')}">
			${item.kmDocSubject}
		</list:data-column>
		<list:data-column col="fdContentType"
			title="${lfn:message('kms-kmtopic:kmsKmtopicMain.fdContentType')}">
			${item.fdContentType}
		</list:data-column>
		<list:data-column col="docAuthor.fdName"
			title="${lfn:message('kms-kmtopic:kmsKmtopicMain.docAuthor')}">
			${item.fdKmAuthor}
		</list:data-column>
		<list:data-column col="docCategory.fdName"
			title="${lfn:message('kms-kmtopic:kmsKmtopic.docCategory')}">
			${item.fdKmCategory}
		</list:data-column>
		<list:data-column col="docPublishTime"
			title="${lfn:message('kms-kmtopic:kmsKmtopic.docPublishTime')}">
			<kmss:showDate value="${item.kmDocPublishTime}" type="date" />
		</list:data-column>
		
		<list:data-column col="fdKnowledgeType">
			${item.fdKnowledgeType}
		</list:data-column>
		
		<list:data-column col="fdDescription"
			title="${lfn:message('kms-kmtopic:kmsKmtopicMain.description')}">
			${item.fdKmDescription}
		</list:data-column>
		
		<list:data-column col="rowHref" escape="false">
			${item.fdKmLink}
		</list:data-column>
		
		<list:data-column col="fdImageUrl" title="imageLink">
				<c:if test="${loadImg == true}">
				<%
					Object basedocObj = pageContext.getAttribute("item");
					if(basedocObj != null) {
						KmsKmtopicCatelogContent logContent = (KmsKmtopicCatelogContent)basedocObj;
						String docId = logContent.getFdKmId();
						
						if(StringUtil.isNotNull(docId)){
							IBaseModel model = ((IKmsKnowledgeBaseDocService)SpringBeanUtil.getBean("kmsKnowledgeBaseDocService"))
													.findByPrimaryKey(docId,null, true);
							if(model!=null){
								out.print("/kms/kmtopic/kms_kmtopic_main/kmsKmtopicMain.do?method=getCoverPic&" +
										"modelName=com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc&fdId=" + 
										model.getFdId()+"&knowledgeType="+((KmsKnowledgeBaseDoc)model).getFdKnowledgeType());
							}else{
								out.print("/resource/style/default/attachment/default.png");
							}
						}else{
							out.print("/resource/style/default/attachment/default.png");
						}
					}
				%>
				</c:if>
		</list:data-column>
	</list:data-columns>

	<list:data-paging page="${queryPage }">
	</list:data-paging>
</list:data>