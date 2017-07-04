<%@page import="com.landray.kmss.sys.organization.model.SysOrgElement"%>
<%@page
	import="com.landray.kmss.sys.organization.interfaces.ISysOrgCoreService"%>
<%@page
	import="com.landray.kmss.kms.knowledge.util.KmsKnowledgeConstantUtil"%>
<%@page import="java.util.List"%>
<%@page import="com.landray.kmss.util.ModelUtil"%>
<%@page import="com.landray.kmss.sys.attachment.model.SysAttMain"%>
<%@page
	import="com.landray.kmss.sys.attachment.service.ISysAttMainCoreInnerService"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page
	import="com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc"%>
<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
	ISysAttMainCoreInnerService sysAttMainCoreInnerService = (ISysAttMainCoreInnerService) SpringBeanUtil
			.getBean("sysAttMainService");

	ISysOrgCoreService sysOrgCoreService = (ISysOrgCoreService) SpringBeanUtil
			.getBean("sysOrgCoreService");
	String prefix = request.getContextPath();
%>

<list:data>
	<list:data-columns var="item" list="${queryPage.list }" mobile="true">
		<list:data-column property="fdId">
		</list:data-column>
		<!-- 文档类型 -->
		<list:data-column property="fdKnowledgeType" />
		<list:data-column col="label"
			title="${lfn:message('kms-knowledge:kmsKnowledgeBaseDoc.docSubjects')}"
			property="docSubject">
		</list:data-column>
		<!-- 描述 -->
		<list:data-column col="summary" property="fdDescription"
			title="${lfn:message('kms-knowledge:kmsKnowledgeBaseDoc.fdDescription')}">
		</list:data-column>
		<!--缩略图-->
		<list:data-column col="icon" title="icon" escape="false">
			<%
				KmsKnowledgeBaseDoc basedocObj = (KmsKnowledgeBaseDoc) pageContext
									.getAttribute("item");
							List list = sysAttMainCoreInnerService.findByModelKey(
									KmsKnowledgeConstantUtil
											.getTemplateModelName(basedocObj
													.getFdKnowledgeType()
													.toString()), basedocObj
											.getFdId(), "spic");
							if (list != null && list.size() > 0) {
								SysAttMain att = (SysAttMain) list.get(0);
								out.print(prefix + ModelUtil.getModelUrl(att));
							}
			%>
		</list:data-column>
		<!-- 创建者 -->
		<list:data-column col="creator"
			title="${lfn:message('kms-knowledge:kmsKnowledgeBaseDoc.list.docAuthor') }"
			escape="false">
			<c:if test="${not empty item.docAuthor.fdId }">
				<%
					KmsKnowledgeBaseDoc basedocObj = (KmsKnowledgeBaseDoc) pageContext
											.getAttribute("item");

									SysOrgElement element = sysOrgCoreService
											.findByPrimaryKey(basedocObj.getDocAuthor()
													.getFdId());
									out.print(element.getFdName());
				%>
			</c:if>
			<c:if test="${empty item.docAuthor.fdId }">
				${item.outerAuthor}
			</c:if>
		</list:data-column>

		<!-- 创建时间 -->
		<list:data-column col="created"
			title="${lfn:message('kms-knowledge:kmsKnowledge.docPublishTime') }">
			<kmss:showDate value="${item.docPublishTime}" type="date" />
		</list:data-column>

		<!-- 阅读量 -->
		<list:data-column col="count"
			title="${lfn:message('kms-knowledge:kmsKnowledge.read') }"
			escape="false">
			<c:if test="${item.docStatus=='30' ||item.docStatus=='40'}">
				${not empty item.docReadCount ? item.docReadCount : 0}
			</c:if>
		</list:data-column>
		<!--链接 -->
		<list:data-column col="href" escape="false">
	       	/kms/knowledge/kms_knowledge_base_doc/kmsKnowledgeBaseDoc.do?method=view&fdId=${item.fdId}&fdKnowledgeType=${item.fdKnowledgeType}
		</list:data-column>
		<!--是否精华-->
		<list:data-column col="status" escape="false">
			<c:if test="${item.docIsIntroduced==true}">
				<span class="muiComplexrStatusBorder" style="color: red">精华</span>
			</c:if>
		</list:data-column>
	</list:data-columns>
	<list:data-paging page="${queryPage }">
	</list:data-paging>
</list:data>
