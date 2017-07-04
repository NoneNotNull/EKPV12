<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="item" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column  col="docSubject" title="标题" escape="false" style="width:${p_subject}%;padding:5px 0px;text-align:left;">
				<c:if test="${showCate == true }">
					<a href="${LUI_ContextPath}/kms/multidoc/?categoryId=${item.docCategory.fdId}" title="${item.docCategory.fdName}" target="_blank" class="lui_dataview_classic_cate_link" >
						[${item.docCategory.fdName}]
					</a>
				</c:if>
				<a href="${LUI_ContextPath}/kms/multidoc/kms_multidoc_knowledge/kmsMultidocKnowledge.do?method=view&fdId=${item.fdId}" title="${item.docSubject}" target="_blank" class="lui_dataview_classic_link">
					<c:out value="${item.docSubject}"/>
				</a>
		</list:data-column>
		<c:if test="${showCreator == true }">
			<list:data-column escape="false" col="docCreator" title="创建人" style="text-align:center;width:${p_creator}%;">
				<span class="lui_dataview_classic_creator">${item.docCreator.fdName}</span>
			</list:data-column>
		</c:if>
		<c:if test="${showCreated == true }">
			<list:data-column escape="false" col="docCreateTime" title="创建时间" style="text-align:center;width:${p_created}%;">
				<span class="lui_dataview_classic_created"><kmss:showDate value="${item.docCreateTime}" type="date"></kmss:showDate></span>
			</list:data-column>
		</c:if>
		<c:if test="${showIntro == true }">
			<list:data-column escape="false" col="docIntrCount" title="推荐次数" style="text-align:center;width:${p_intro}%;">
				推荐次数<span class="com_number" title="${item.docIntrCount}">${item.docIntrCount}</span>
			</list:data-column>
		</c:if>
	</list:data-columns>
		
	<list:data-paging page="${queryPage }" >
	</list:data-paging>
</list:data>
