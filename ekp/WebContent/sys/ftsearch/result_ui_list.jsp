<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>



<%@page import="com.landray.kmss.sys.ftsearch.search.LksHit"%>
<%@page import="java.util.Map"%>
<%@page import="com.landray.kmss.sys.ftsearch.config.LksField"%>

<%@page import="java.util.regex.Pattern"%>
<%@page import="java.util.regex.Matcher"%><list:data>
	<list:data-columns var="item" list="${queryPage.list }">
		<%
			Object basedocObj = pageContext.getAttribute("item");
					if (basedocObj != null) {
						LksHit lks = (LksHit) basedocObj;
						Map lksFieldsMap = lks.getLksFieldsMap();
						LksField link = (LksField) lksFieldsMap.get("linkStr");
						LksField title = (LksField) lksFieldsMap.get("title");
						LksField subject = (LksField) lksFieldsMap
								.get("subject");
						LksField content = (LksField) lksFieldsMap
								.get("content");
						LksField fileName = (LksField) lksFieldsMap
								.get("fileName");
						LksField creator = (LksField) lksFieldsMap
								.get("creator");
						LksField createTime = (LksField) lksFieldsMap
								.get("createTime");
						String fdDocSubject = "";
						String linkUrl = "";
						String docCreator = "";
						String docCreateTime = "";

						if (subject != null) {
							fdDocSubject = subject.getValue();
						} else if (title != null) {
							fdDocSubject = title.getValue();
						} else if (fileName != null) {
							fdDocSubject = fileName.getValue();
						}

						if (creator != null)
							docCreator = creator.getValue();
						if (createTime != null)
							docCreateTime = createTime.getValue();
						String regEx_html = "<[^>]+>"; //定义HTML标签的正则表达式
						Pattern p_html = Pattern.compile(regEx_html,
								Pattern.CASE_INSENSITIVE);
						Matcher m_html = p_html.matcher(fdDocSubject);
						fdDocSubject = m_html.replaceAll(""); //过滤html标签 

						Matcher _m_html = p_html.matcher(docCreator);
						docCreator = _m_html.replaceAll("");
						
						if (link != null) {
							linkUrl = link.getValue();
						}
						pageContext.setAttribute("fdDocSubject", fdDocSubject);
						pageContext.setAttribute("linkUrl", linkUrl);
						pageContext.setAttribute("docCreator", docCreator);
						pageContext.setAttribute("docCreateTime", docCreateTime);
					}
		%>
		<list:data-column col="fdUrl">
			${linkUrl}
		</list:data-column>
		<list:data-column col="docSubject">
			${fdDocSubject}
		</list:data-column>
		<list:data-column col="docCreator">
			${docCreator}
		</list:data-column>
		<list:data-column col="docCreateTime">
			${docCreateTime}
		</list:data-column>
	</list:data-columns>

	<list:data-paging page="${queryPage }">
	</list:data-paging>
</list:data>
