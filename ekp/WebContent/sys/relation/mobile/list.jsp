<%@page import="java.util.Date"%>
<%@page import="org.apache.commons.beanutils.PropertyUtils"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@page import="com.landray.kmss.util.DateUtil"%>
<%@page import="com.landray.kmss.sys.relation.util.SysRelationUtil"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.sys.ftsearch.config.LksField"%>
<%@page import="java.util.Map"%>
<%@page import="com.landray.kmss.sys.ftsearch.search.LksHit"%>
<%@page import="com.landray.kmss.common.model.BaseModel"%>
<%@page import="com.landray.kmss.util.ModelUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/person/person.tld"
	prefix="person"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%!public int rtnType(Object obj) {
		// 高级搜索
		if (obj instanceof BaseModel)
			return 0;
		// 静态链接
		if (obj instanceof String[])
			return 1;
		// 全文搜索
		if (obj instanceof LksHit)
			return 2;
		return 0;
	}%>
<list:data>
	<list:data-columns var="item" list="${queryPage.list }" mobile="true">

		<%
			Object obj = pageContext.getAttribute("item");
					int i = rtnType(obj);
					if (i == 0) {
		%>
		<list:data-column title="" col="label">
			<c:out value="${item.docSubject}"></c:out>
		</list:data-column>
		<list:data-column title="" col="href" escape="false">
			<c:if test="${not empty item }">
				<%=ModelUtil.getModelUrl(obj)%>
			</c:if>
		</list:data-column>

		<list:data-column title="" col="creator">
			<c:out value="${item.docCreator.fdName}"></c:out>
		</list:data-column>

		<list:data-column title="" col="created">
			<c:if test="${not empty item }">
				<%=DateUtil.convertDateToString(
										(Date) PropertyUtils.getProperty(obj,
												"docCreateTime"), ResourceUtil
												.getString("date.format.date"))%>
			</c:if>
		</list:data-column>

		<%
			} else if (i == 1) {
						String docSubject = "";
						String docLink = "";
						String[] urlArr = (String[]) obj;
						if (urlArr.length > 0
								&& StringUtil.isNotNull(urlArr[0])) {
							docSubject = urlArr[0];
							docSubject = SysRelationUtil
									.replaceStrongStyle(docSubject);
							if (urlArr.length > 1
									&& StringUtil.isNotNull(urlArr[1])) {
								docLink = urlArr[1];
							} else {
								docLink = urlArr[0];
							}
						}
		%>
		<list:data-column title="" col="label">
			<%=docSubject%>
		</list:data-column>
		<list:data-column title="" col="href" escape="false">
			<%=docLink%>
		</list:data-column>
		<%
			} else if (i == 2) {

						LksHit lksHit = (LksHit) obj;
						Map lksFieldsMap = lksHit.getLksFieldsMap();
						if (lksFieldsMap != null && !lksFieldsMap.isEmpty()) {
		%>
		<list:data-column title="" col="label">
			<%
				String docSubject = "";
									LksField subject = (LksField) lksFieldsMap
											.get("subject");
									LksField title = (LksField) lksFieldsMap
											.get("title");
									LksField fileName = (LksField) lksFieldsMap
											.get("fileName");
									if (subject != null) {
										docSubject = subject.getValue();
									} else if (title != null) {
										docSubject = title.getValue();
									} else if (fileName != null) {
										docSubject = fileName.getValue();
									}
									if (StringUtil.isNotNull(docSubject)) {
										docSubject = SysRelationUtil
												.replaceStrongStyle(docSubject);
									}
			%>
			<%=docSubject%>
		</list:data-column>
		<list:data-column title="" col="href" escape="false">
			<%
				String docLink = "";
									LksField link = (LksField) lksFieldsMap
											.get("linkStr");
									if (link != null) {
										docLink = link.getValue();
									}
			%>
			<%=docLink%>

		</list:data-column>

		<list:data-column title="" col="creator">
			<%
				String docCreatorName = "";

									LksField creator = (LksField) lksFieldsMap
											.get("creator");
									if (creator != null) {
										docCreatorName = SysRelationUtil
												.replaceStrongStyle(creator
														.getValue());
									}
			%>
			<%=docCreatorName%>
		</list:data-column>

		<list:data-column title="" col="created">
			<%
				String docCreateTime = "";

									LksField createTime = (LksField) lksFieldsMap
											.get("createTime");
									if (createTime != null) {
										docCreateTime = SysRelationUtil
												.replaceStrongStyle(createTime
														.getValue());
									}
			%>
			<%=docCreateTime%>
		</list:data-column>
		<%
			}
					}
		%>
	</list:data-columns>
</list:data>
