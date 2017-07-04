<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="mobile.view" compatibleMode="true">
	<template:replace name="title">
		<c:out value="${ kmsMultidocKnowledgeForm.docSubject }" />
	</template:replace>
	<template:replace name="content">
		<div data-dojo-type="mui/view/DocScrollableView" id="scrollView">
			<div class="muiDocFrame">
				<div class="muiDocSubject">
					<c:out value="${ kmsMultidocKnowledgeForm.docSubject }" />
				</div>
				<div class="muiDocInfo">
					<c:if test="${not empty publishTime }">
						<span> <c:out value="${publishTime  }" />
						</span>
						&nbsp;&nbsp;&nbsp;&nbsp; 
					</c:if>
					<span> ${lfn:message('sys-doc:sysDocBaseInfo.docAuthor') } ：
						<c:if test="${not empty kmsMultidocKnowledgeForm.docAuthorId }">
							<c:out value="${ kmsMultidocKnowledgeForm.docAuthorName }" />
						</c:if> <c:if test="${not empty kmsMultidocKnowledgeForm.docAuthorId }">
							<c:out value="${ kmsMultidocKnowledgeForm.outerAuthor }" />
						</c:if>
					</span> &nbsp;&nbsp;&nbsp;&nbsp;
					<c:if test="${kmsMultidocKnowledgeForm.docStatus >= '30' }">
						<span> 阅读量： <c:out
								value="${ kmsMultidocKnowledgeForm.docReadCount }" />
						</span>
					</c:if>
				</div>
				<c:if
					test="${kmsMultidocKnowledgeForm.fdDescription!=null && kmsMultidocKnowledgeForm.fdDescription!='' }">
					<div class="muiDocSummary">
						<div class="muiDocSummarySign">摘要</div>
						<c:out value="${ kmsMultidocKnowledgeForm.fdDescription }" />
					</div>
				</c:if>
				<span class="muiDocContent"> <xform:rtf property="docContent"
						mobile="true"></xform:rtf>
				</span>
				<!-- 附件 -->
				<c:import url="/sys/attachment/mobile/import/view.jsp"
					charEncoding="UTF-8">
					<c:param name="formName" value="kmsMultidocKnowledgeForm"></c:param>
					<c:param name="fdKey" value="attachment"></c:param>
				</c:import>
			</div>
			<div data-dojo-type="mui/panel/AccordionPanel">
				<div data-dojo-type="mui/panel/Content"
					data-dojo-props="title:'知识属性',icon:'mui-ul'">
					<div class="muiFormContent">
						<table class="muiSimple" cellpadding="0" cellspacing="0">
							<c:import url="/sys/property/include/sysProperty_pda.jsp"
								charEncoding="UTF-8">
								<c:param name="formName" value="kmsMultidocKnowledgeForm" />
							</c:import>
						</table>
					</div>
				</div>
				<c:if test="${kmsMultidocKnowledgeForm.docStatus < '30' }">
					<div data-dojo-type="mui/panel/Content"
						data-dojo-props="title:'流程日志',icon:'mui-ul'">
						<c:import
							url="/sys/lbpmservice/mobile/lbpm_audit_note/import/view.jsp"
							charEncoding="UTF-8">
							<c:param name="fdModelId"
								value="${kmsMultidocKnowledgeForm.fdId }"></c:param>
							<c:param name="fdModelName"
								value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge"></c:param>
							<c:param name="formBeanName" value="kmsMultidocKnowledgeForm"></c:param>
						</c:import>
					</div>
				</c:if>
			</div>
			<c:if test="${kmsMultidocKnowledgeForm.docStatus >= '30' }">
				<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom">
					<!-- 返回 -->
					<li data-dojo-type="mui/back/BackButton"></li>
					<!-- 点评 -->
					<c:import url="/sys/evaluation/mobile/import/view.jsp"
						charEncoding="UTF-8">
						<c:param name="formName" value="kmsMultidocKnowledgeForm"></c:param>
					</c:import>
					<!-- 推荐 -->
					<c:import url="/sys/introduce/mobile/import/view.jsp"
						charEncoding="UTF-8">
						<c:param name="formName" value="kmsMultidocKnowledgeForm"></c:param>
					</c:import>
					<!-- 收藏 -->
					<c:import url="/sys/bookmark/mobile/import/view.jsp"
						charEncoding="UTF-8">
						<c:param name="fdSubject"
							value="${kmsMultidocKnowledgeForm.docSubject}" />
						<c:param name="fdModelId" value="${kmsMultidocKnowledgeForm.fdId}" />
						<c:param name="fdModelName"
							value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge" />
					</c:import>
					<!-- 更多 -->
					<li data-dojo-type="mui/tabbar/TabBarButtonGroup"
						data-dojo-props="icon1:'mui mui-more'">
						<div data-dojo-type="mui/back/HomeButton"></div> <c:import
							url="/sys/relation/mobile/import/view.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmsMultidocKnowledgeForm"></c:param>
						</c:import>
					</li>
				</ul>
			</c:if>

			<c:if test="${kmsMultidocKnowledgeForm.docStatus < '30' }">
				<template:include file="/sys/lbpmservice/mobile/import/bar.jsp"
					docStatus="${kmsMultidocKnowledgeForm.docStatus}"
					editUrl="javascript:building();"
					formName="kmsMultidocKnowledgeForm">
					<template:replace name="group">
						<template:super />
						<c:import url="/sys/relation/mobile/import/view.jsp"
							charEncoding="UTF-8">
							<c:param name="formName" value="kmsMultidocKnowledgeForm"></c:param>
						</c:import>
					</template:replace>
				</template:include>
			</c:if>
		</div>

		<c:import url="/sys/lbpmservice/mobile/import/view.jsp"
			charEncoding="UTF-8">
			<c:param name="formName" value="kmsMultidocKnowledgeForm" />
			<c:param name="fdKey" value="mainDoc" />
			<c:param name="viewName" value="lbpmView" />
			<c:param name="backTo" value="scrollView" />
		</c:import>
	</template:replace>
</template:include>
