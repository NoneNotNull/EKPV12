<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.common.model.BaseModel"%>
<%@ page import="com.landray.kmss.sys.relation.interfaces.SearchResultEntry"%>
<%@ page import="com.landray.kmss.sys.config.dict.SysDataDict" %>
<%@ page import="org.apache.commons.beanutils.PropertyUtils" %>
<%@ page import="com.landray.kmss.sys.ftsearch.search.LksHit" %>
<%@ page import="com.landray.kmss.sys.ftsearch.config.LksField" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="/kms/common/resource/ui/kms_list_top.jsp" %>
<style type="text/css">
body {
	background-color: transparent
}
table{
	table-layout:fixed;     /* 只有定义了表格的布局算法为fixed，下面td的定义才能起作用。 */
}
td{
	word-break:keep-all;    /* 不换行 */
	white-space:nowrap;     /* 不换行 */
	overflow:hidden;        /* 内容超出宽度时隐藏超出部分的内容 */
	text-overflow:ellipsis; /* 当对象内文本溢出时显示省略标记(...) ；需与overflow:hidden;一起使用。*/
}
  
</style>
<script type="text/javascript">
Com_IncludeFile("ftsearch_result.css", "style/"+Com_Parameter.Style+"/relation/");
</script>
<div style="margin: 2px 0 0 0;">
<c:choose>
<c:when test="${empty queryPage.list || queryPage.totalrows == 0}">	
	<center><br><bean:message bundle="sys-relation" key="sysRelationMain.showText.noneRecord" /></center>
</c:when>
<c:otherwise>
<div style="height:auto !important;height:185px;min-height:185px;padding-left: 5px;">
<table class="t_b" border="0" cellspacing="0" cellpadding="0" width="100%">
<tr>
<td width="5%" class="t_b_b">NO.
</td>
<td width="50%">标题
</td>
<td width="20%">创建人
</td>
<td width="20%" class="t_b_c">创建时间
</td>
</tr>
<c:forEach items="${queryPage.list}" varStatus="vstatus" var="resultModel">
 			<c:choose>
                <c:when test="${vstatus.index%2==0}">
   				 <tr >
                </c:when>
                <c:otherwise>
                <tr class='t_b_a' >
                </c:otherwise>
            </c:choose>
	 
	<td> ${vstatus.index+1}
	</td>
	<td nowrap="nowrap" width="50%"  >
	<%
		String docSubject = "";
		String linkUrl = "";
		Date date = null;
		String docCreateTime = "";
		String docCreatorName = "";
		String docCreateInfo = "";
		Object resultModel = pageContext.getAttribute("resultModel");
		if (resultModel instanceof BaseModel) { //精确搜索
			try {
				docSubject = (String) PropertyUtils.getProperty(resultModel, "docSubject");
			} catch (Exception e){
				docSubject = "";
			}
			if (StringUtil.isNotNull(ModelUtil.getModelUrl(resultModel))) {
				linkUrl = ModelUtil.getModelUrl(resultModel);
			}
			try {
				date = (Date) PropertyUtils.getProperty(resultModel, "docCreateTime");
			} catch (Exception e) {
				date = null;
			}
			if (date != null) {
				docCreateTime = DateUtil.convertDateToString(date, ResourceUtil
						.getString("date.format.date"));
			}
			try {
				docCreatorName = (String) PropertyUtils.getProperty(resultModel, "docCreator.fdName");
			} catch (Exception e) {
				docCreatorName = "";
			}
		} else if (resultModel instanceof String[]) { //静态页面
			String[] urlArr = (String[])resultModel;
			if (urlArr.length > 0 && StringUtil.isNotNull(urlArr[0])) {
				docSubject = urlArr[0];
				if (urlArr.length > 1 && StringUtil.isNotNull(urlArr[1])) {
					linkUrl = urlArr[1];
				} else {
					linkUrl = urlArr[0];
				}
			}
		} else if (resultModel instanceof LksHit) { //全文检索
			LksHit lksHit = (LksHit)resultModel;
			if (lksHit != null) {
				Map lksFieldsMap = lksHit.getLksFieldsMap();
				if (lksFieldsMap != null && !lksFieldsMap.isEmpty()) {
					LksField subject = (LksField)lksFieldsMap.get("subject");
					LksField title = (LksField)lksFieldsMap.get("title");
					LksField fileName = (LksField)lksFieldsMap.get("fileName");
					if (subject != null) {
						docSubject = subject.getValue();
					} else if (title != null) {
						docSubject = title.getValue();
					} else if (fileName != null) {
						docSubject = fileName.getValue();
					}
					LksField link = (LksField)lksFieldsMap.get("linkStr");
					if (link != null) {
						linkUrl = link.getValue();
					}
					LksField createTime = (LksField)lksFieldsMap.get("createTime");
					if (createTime != null) {
						docCreateTime = createTime.getValue();
					}
					LksField creator = (LksField)lksFieldsMap.get("creator");
					if (creator != null) {
						docCreatorName = creator.getValue();
					}
					// 去掉样式
					if (StringUtil.	isNotNull(docSubject)) {
						docSubject = docSubject.replaceAll("<strong class=\"lksHit\">","").replaceAll("</strong>","");
					}
					if (StringUtil.isNotNull(docCreateTime)) {
						docCreateTime = docCreateTime.replaceAll("<strong class=\"lksHit\">","").replaceAll("</strong>","");
					}
					if (StringUtil.isNotNull(docCreatorName)) {
						docCreatorName = docCreatorName.replaceAll("<strong class=\"lksHit\">","").replaceAll("</strong>","");
					}
				}
			}
		} else if (resultModel instanceof SearchResultEntry) { //外部扩展
			SearchResultEntry searchModel = (SearchResultEntry)resultModel;
			if (searchModel != null) {
				docSubject = searchModel.getDocSubject();
				linkUrl = searchModel.getLinkUrl();
				if (searchModel.getDocCreateTime() != null) {
					docCreateTime = DateUtil.convertDateToString(searchModel.getDocCreateTime(),ResourceUtil
							.getString("date.format.date"));
				}
				docCreatorName = searchModel.getDocCreatorName();
			}
		}
		pageContext.setAttribute("docSubject", (docSubject != null ? docSubject.trim() : ""));
		pageContext.setAttribute("linkUrl", (linkUrl != null ? linkUrl.trim() : ""));
		if (StringUtil.isNotNull(docCreateTime) || StringUtil.isNotNull(docCreatorName)) {
			docCreateInfo += "(";
			if (StringUtil.isNotNull(docCreateTime)) {
				pageContext.setAttribute("docCreateTime",docCreateTime);
				docCreateInfo += docCreateTime;
			}else{
				pageContext.setAttribute("docCreateTime","");
			}
			if (StringUtil.isNotNull(docCreatorName)) {
				docCreateInfo +=  " " + docCreatorName;
				pageContext.setAttribute("docCreatorName",docCreatorName);
			}else{
				pageContext.setAttribute("docCreatorName"," ");
			}
			docCreateInfo += ")";
		}
		pageContext.setAttribute("docCreateInfo", (docCreateInfo != null ? docCreateInfo.trim() : ""));
	%>
	<c:if test="${linkUrl != ''}">
	<a class="link" href="javascript:void(0);" onclick="Com_OpenWindow('<c:url value="${linkUrl}"/>')" title='<c:out value="${docSubject}" />&nbsp;<c:out value="${docCreateInfo}" />'>
		<span class="f">
			<c:out value="${docSubject}" /><c:if test="${param.showCreateInfo != 'false'}">&nbsp;<c:out value="${docCreateInfo}" /></c:if>
		</span>
	</a>
	</c:if>
	</td>
	<td><c:out value="${docCreatorName}" />
	</td>
	<td><c:out value="${docCreateTime}" />
	</td>
	</tr>
</c:forEach>
</table>
</div>
<%--分页--%>
<c:if test="${not empty queryPage && queryPage.total > 1}">
<div style="border-top: #cae7ad 1px dashed;margin-bottom: 4px"></div>
<div class="postPages" style="margin-bottom: -5px;">
<nobr>
	<sunbor:page name="queryPage" pagenoText="pagenoText2" pageListSize="3" pageListSplit="">
		<sunbor:leftPaging><b>&lt;<bean:message key="page.thePrev"/></b></sunbor:leftPaging>
		{11}
		<sunbor:rightPaging><b><bean:message key="page.theNext"/>&gt;</b></sunbor:rightPaging>
	</sunbor:page>
</nobr>
</div>
</c:if>
</c:otherwise>
</c:choose>
</div>
</td>
</tr>
</table>
</center>
</body>
</html>