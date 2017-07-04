<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.landray.kmss.util.ArrayUtil"%>
<%@page import="com.landray.kmss.kms.expert.model.KmsExpertInfo"%>
<list:data>
	<list:data-columns var="item" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column property="fdPerson.fdId" col="fdPersonId">
		</list:data-column>
		<list:data-column property="fdName" title="姓名">
		</list:data-column>
		<list:data-column property="fdDeptName" title="部门">
		</list:data-column>
		<list:data-column col="fdDeptNameShortName" title="部门缩写" escape="false">
		<%
			KmsExpertInfo kmsExpertInfo = (KmsExpertInfo)pageContext.getAttribute("item");
			if(kmsExpertInfo != null) {
				String depName = kmsExpertInfo.getFdDeptName();
				if(depName != null && depName.trim().length() > 0)
				out.print( depName.substring(depName.lastIndexOf(">>") + 2));
			}
		%>
		</list:data-column>
		<list:data-column property="fdPostNames" title="职位">
		</list:data-column>
		<list:data-column col="fdPostNamesShortName" title="职位缩写" escape="false">
		<%
			KmsExpertInfo kmsExpertInfo = (KmsExpertInfo)pageContext.getAttribute("item");
			if(kmsExpertInfo != null)
				out.print( ArrayUtil.joinProperty(
					kmsExpertInfo.getFdPerson().getFdPosts(), "fdName", ";")[0]); %>
		</list:data-column>
		<list:data-column property="fdMobileNo" title="手机号码">
		</list:data-column>
		<list:data-column property="fdEmail" title="邮箱">
		</list:data-column>
		<list:data-column property="fdWorkPhone" title="电话">
		</list:data-column>
		<c:if test="${not empty countsObject}">
			<list:data-column col="fdDocCount" title="知识数">
				<c:if test="${ countsObject['com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc'] != null}">
					${empty countsObject["com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc"][item.fdPerson.fdId] ? 0 : countsObject["com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc"][item.fdPerson.fdId]}
				</c:if>
			</list:data-column>
			<list:data-column col="fdBookMarkCount" title="收藏数">
				<c:if test="${ countsObject['com.landray.kmss.sys.bookmark.model.SysBookmarkMain'] != null}">
					${empty countsObject["com.landray.kmss.sys.bookmark.model.SysBookmarkMain"][item.fdPerson.fdId] ? 0 : countsObject["com.landray.kmss.sys.bookmark.model.SysBookmarkMain"][item.fdPerson.fdId]}
				</c:if>
			</list:data-column>
			<%-- 
			<list:data-column col="fdFollowCount" title="订阅数">
				<c:if test="${ countsObject['com.landray.kmss.sys.follow.model.SysFollowPersonDocRelated']!=null}">
					${empty countsObject["com.landray.kmss.sys.follow.model.SysFollowPersonDocRelated"][item.fdPerson.fdId]? 0 :countsObject["com.landray.kmss.sys.follow.model.SysFollowPersonDocRelated"][item.fdPerson.fdId]}
				</c:if>
			</list:data-column>
			--%>
		</c:if>
		<%--个人简介 --%>
		<list:data-column property="fdBackground" title="${lfn:message('kms-expert:table.kmsExpertInfo.background')}">
		</list:data-column>
		<list:data-column title="头像URL" col="imgUrl">
			${urlJson[item.fdId]}
		</list:data-column>
		<list:data-column title="是否可提问" col="askTo" >
			${askToJson[item.fdId]}
		</list:data-column>
	</list:data-columns>
	<list:data-paging page="${queryPage }" >
	</list:data-paging>
</list:data>