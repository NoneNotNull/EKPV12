<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include file="/kms/common/pda/template/view.jsp">
	<template:replace name="header">
		<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/kms/wiki/pda/css/view.css">
		<header class="lui-header">
			<ul class="clearfloat">
				<li style="float: left;padding-left: 10px;">
					<a id="column_button" data-lui-role="button">
						<script type="text/config">
						{
							currentClass : 'lui-icon-s lui-back-icon',
						    onclick : "setTimeout(function(){history.go(-1)},0)"
						}
						</script>		
					</a>
				</li>
				<li class="lui-docSubject">
					<h2 class="textEllipsis">${kmsWikiMainForm.docSubject }</h2>
				</li>
			</ul>
		</header>
	</template:replace>
	<template:replace name="message">
		<section class="lui-mesg">
			<ul class="lui-grid-b clearfloat">
				<li><em class="lui-icon-s-s lui-eval-icon">${kmsWikiMainForm.docEvalCount }</em></li>
				<li><em class="lui-icon-s-s lui-read-icon">${kmsWikiMainForm.docReadCount }</em></li>
				<li><em class="lui-icon-s-s lui-intro-icon">${kmsWikiMainForm.docIntrCount }</em></li>
			</ul>
		</section>
	</template:replace>
	<template:replace name="description">
		<section class="lui-fdDescription">
			${kmsWikiMainForm.fdDescription }
		</section>
	</template:replace>
	<template:replace name="photoswipe">
		<section class="lui-attachment">
			<c:import url="/kms/common/pda/core/attachment/attachment.jsp" charEncoding="utf-8">
				<c:param name="formBeanName" value="kmsWikiMainForm" />
				<c:param name="fdModelId" value="${param.fdId}" />
			</c:import>
		</section>
	</template:replace>
	
	<template:replace name="docContent">
		<c:forEach items="${kmsWikiMainForm.fdCatelogList}" var="kmsWikiCatelogForm" varStatus="status">
			<div class="lui-wiki-catalog" id="catalog_${kmsWikiCatelogForm.fdId}">
				${status.index + 1}
				<c:out value="${kmsWikiCatelogForm.fdName}" /> 
			</div>
			<div class="lui-wiki-catalog-content clearfloat" 
				 id="catalog_content_${kmsWikiCatelogForm.fdId}">
				${kmsWikiCatelogForm.docContent}
			</div>
		</c:forEach>
	</template:replace>
	
	<template:replace name="footer">
		<table class="lui-tb-footer" width="100%">
			<tr>
				<td>
					<c:import url="/kms/wiki/pda/view/view_info.jsp" charEncoding="utf-8">
						<c:param name="formName" value="kmsWikiMainForm" />
						<c:param name="attFdKey" value="attachment"/>
					</c:import>
				</td>
				<td>
					<c:import url="/kms/common/pda/core/relation/relation.jsp" charEncoding="utf-8">
						<c:param name="formName" value="kmsWikiMainForm" />
					</c:import>
				</td>
				<c:if test="${kmsWikiMainForm.docStatus == '30' }">
					<td>
						<c:import url="/kms/common/pda/core/bookmark/bookmark.jsp" charEncoding="utf-8">
							<c:param name="fdModelId" value="${kmsWikiMainForm.fdId }"></c:param>
							<c:param name="fdModelName" value="com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge"></c:param>
						</c:import>
					</td>
					<td>
						<c:import url="/kms/common/pda/core/evaluation/evaluation.jsp" charEncoding="utf-8">
							<c:param name="fdModelId" value="${kmsWikiMainForm.fdId }"></c:param>
							<c:param name="formName" value="kmsWikiMainForm" />
						</c:import>
					</td>
					<td>
						<c:import url="/kms/common/pda/core/introduce/introduce.jsp" charEncoding="utf-8">
							<c:param name="fdCateModelName" value="com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory" />
							<c:param name="formName" value="kmsWikiMainForm" />
							<c:param name="fdKey" value="mainDoc" />
							<c:param name="toEssence" value="true" />
							<c:param name="toNews" value="true" />
						</c:import>
					</td>
				</c:if>
				<c:if test="${(kmsWikiMainForm.docStatus>='20' && kmsWikiMainForm.docStatus<'30') || kmsWikiMainForm.docStatus == '11'}">
					<td>
						<c:import url="/kms/common/pda/core/lbpm/lbpm.jsp" charEncoding="utf-8">
							<c:param name="formName" value="kmsWikiMainForm" />
						</c:import>
					</td>
				</c:if>
			</tr>
		</table>
	</template:replace>
</template:include>