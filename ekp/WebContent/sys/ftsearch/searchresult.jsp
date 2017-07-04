<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <%@ taglib uri="/WEB-INF/sunbor.tld" prefix="sunbor"%>
<%@ page import="java.util.*, javax.servlet.http.HttpServletRequest ,javax.servlet.http.HttpServletResponse, 
com.landray.kmss.common.actions.RequestContext,
com.landray.kmss.sys.ftsearch.db.forms.SysFtearchBuilderForm,
com.landray.kmss.sys.ftsearch.db.service.ISysFtsearchConfigService,
com.landray.kmss.sys.ftsearch.db.service.SearchBuilder,com.landray.kmss.sys.ftsearch.util.SysFtsearchUtil,
com.landray.kmss.util.*,com.landray.kmss.util.StringUtil,com.sunbor.web.tag.Page" %>
<%@ page import="com.landray.kmss.sys.ftsearch.config.LksField,
	com.landray.kmss.sys.ftsearch.search.LksHit,
	com.landray.kmss.sys.config.dict.SysDataDict,
	com.landray.kmss.sys.ftsearch.util.ResultModelName" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link type="text/css" href="<c:url value="/resource/style/default/ftsearch/ftsearch_result.css"/>" rel="stylesheet" media="all" />

<title>Insert title here</title>
</head>
<body>
<%
com.sunbor.web.tag.Page queryPage = new com.sunbor.web.tag.Page();

	String s_pageno = request.getParameter("pageno");
	String s_rowsize = request.getParameter("rowsize");
	int pageno = 0;
	int rowsize = 10;
	if (s_pageno != null && s_pageno.length() > 0) {
		pageno = Integer.parseInt(s_pageno);
	}
	if (s_rowsize != null && s_rowsize.length() > 0) {
		rowsize = Integer.parseInt(s_rowsize);
	}
	
	String q = request.getParameter("q");
	Map parameters = new HashMap();
	String dateFormat = ResourceUtil.getString("search.format",
			"sys-ftsearch-db");
	SysFtsearchUtil.setParameters(parameters, new RequestContext(
				request), dateFormat);
	String entriesConfigName = ((ISysFtsearchConfigService) SpringBeanUtil.getBean("sysFtsearchConfigService"))
			.getListSearchConfigNull();
	String modelName="com.landray.kmss.km.doc.model.KmDocKnowledge";
	request.setAttribute("entriesConfigName", entriesConfigName);
	parameters.put("pageno", "" + pageno);
	parameters.put("rowsize", "" + rowsize);
	parameters.put("queryString", q);
	parameters.put("modelName", modelName);
	queryPage =( (SearchBuilder) SpringBeanUtil.getBean("searchBuilder")).search(parameters);
	List titleList = ( (SearchBuilder) SpringBeanUtil.getBean("searchBuilder")).searchTitleList(modelName,
			null, new RequestContext(request));// 搜索范围的模块名称
	request.setAttribute("titleList", titleList);
	String titleListSize = "0";
	if (titleList != null) {
		titleListSize = titleList.size() + "";
	}
	request.setAttribute("titleListSize", titleListSize);
	Map mapSet = new HashMap();
	mapSet.put("queryString", q);// 查询的字符串
	mapSet.put("format", dateFormat);// 时间格式
	mapSet.put("host", request.getHeader("host"));// 服务器根目录
	request.setAttribute("mapSet", mapSet);
	request.setAttribute("searchInfo", ResourceUtil.getString(
			"search.search.info", "sys-ftsearch-db", request
					.getLocale(), new Object[] {
					"" + queryPage.getTotalrows(), "" + queryPage.getPageno(),
					"" + queryPage.getTotal() }));// 搜索结果
	request.setAttribute("queryPage", queryPage);

%>
<DIV class='bt' > 
		<c:if test="${not empty queryPage}">
			 <table   width="100%">
			  <tr>
			  <td width="3%">
			  <div class='ml10'>
			  <IMG  src="<c:url value="/resource/style/default/ftsearch/dot_orange.jpg"/>"/></div>
			  </td> 
			  <td width="28%" style="">
			  <span style="color: blue">结果共</span>
			  <span style="color: red"><b><%=queryPage.getTotalrows()%></b></span>
			  <span style="color: blue">个项目文件</span> </td> 
			  <td width="70%" style="text-align: right">	
			  <% if (queryPage.getTotalrows()>1){ %>
			  <%--分页---%> 		
			  <div class="pages page_margin" >
				<span class="postPages">
					<sunbor:page name="queryPage" pagenoText="pagenoText1" pageListSize="10" pageListSplit="">
						<sunbor:leftPaging><b>&lt;<bean:message key="page.thePrev"/></b></sunbor:leftPaging>
						{11}
						<sunbor:rightPaging><b><bean:message key="page.theNext"/>&gt;</b></sunbor:rightPaging>
						<% if (((Page)request.getAttribute("queryPage")).getTotal() > 1){ %>
							<span style="margin-top:-1px;height: 20px;">{9}</span>
							<img src="${KMSS_Parameter_StylePath}icons/go.gif" border=0 title="<bean:message key="page.changeTo"/>"
							 	onclick="{10}" style="cursor:pointer">
						<% } %>
					</sunbor:page>
				</span> 
			</div> 
			<% }%>
			</td>
			</tr>
			</table>
			<%--如果查询无数据--%>
<% if (queryPage.getTotalrows()==0){ %>	
	
	
<% }

else  
{ %>

<%--如果查询有数据--%>
	<div style="" class='content_margin'>
	<%--<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>--%><%--分页--%>
	
	<br> 
	
	<%--标题 时间 创建者 所属模块--%>
	<%for(int i=0;i<queryPage.getList().size();i++){
		LksHit lksHit = (LksHit)queryPage.getList().get(i);
		Map lksFieldsMap = lksHit.getLksFieldsMap();
		LksField link = (LksField)lksFieldsMap.get("linkStr");
		LksField title = (LksField)lksFieldsMap.get("title");
		LksField subject = (LksField)lksFieldsMap.get("subject");
		LksField content = (LksField)lksFieldsMap.get("content");
		LksField fileName = (LksField)lksFieldsMap.get("fileName");
		LksField middleFileName = (LksField)lksFieldsMap.get("middleFileName");
		LksField highFileName = (LksField)lksFieldsMap.get("highFileName");
		LksField fullText = (LksField)lksFieldsMap.get("fullText");
		LksField juniorSummary = (LksField)lksFieldsMap.get("juniorSummary");

		LksField keyword = (LksField)lksFieldsMap.get("keyword");
		LksField fmodelName = (LksField)lksFieldsMap.get("modelName");
		LksField category= (LksField)lksFieldsMap.get("category");
		LksField creator = (LksField)lksFieldsMap.get("creator");
		LksField createTime = (LksField)lksFieldsMap.get("createTime");  
		String linkValue = link.getValue().substring(1,link.getValue().length());
		request.setAttribute("linkValue",linkValue);
		request.setAttribute("linkUrl",link.getValue()); 
		request.setAttribute("ResultModelName",ResultModelName.getModelName(fmodelName.getValue()));  
	%> 
	 <div > 
		<a target='_blank' href='<c:url value="${linkUrl}"/>'>
		<span class="postdesc fz16"><%=subject==null?"":subject.getValue()%><%=title==null?"":title.getValue()%><%=fileName==null?"":fileName.getValue()%><%=middleFileName==null?"":middleFileName.getValue()%><%=highFileName==null?"":highFileName.getValue()%></span></a>
		&nbsp;&nbsp; 
		<span  class='font_blue fz13' ><%---创建者--%>
		<bean:message bundle="sys-ftsearch-db" key="search.search.creators" />
		<%if(creator!=null){
			out.println(creator.getValue());
		}%> 
		</span>
		 &nbsp;<%---时间格式--%>
		<%if(createTime!=null){
		%>			
		<span  class='font_blue fz13'><bean:message bundle="sys-ftsearch-db" key="search.search.createDates" />	
		<% 	
			out.println(createTime.getValue());
		%>
		</span>
		 &nbsp; &nbsp;
		<%} 
		%> 
		<span class='font_blue fz13' >
		<bean:message bundle="sys-ftsearch-db" key="search.search.modelNames" />
		  ${ResultModelName}
		</span> 
	</div>

	<%
	String desc ="";
	List fields = com.landray.kmss.sys.ftsearch.config.LksConfigBuilder.getSingletonInstance().getLksConfig(
			com.landray.kmss.sys.ftsearch.config.LksConfigBuilder.getLksConfigPath()).getDisplayFields();
	for(Iterator it = fields.iterator();it.hasNext();){
		LksField field = (LksField)it.next();
		if(field.getType() != null && field.getType().equalsIgnoreCase("text")){
			LksField valueField = (LksField)lksFieldsMap.get(field.getName());
			if(valueField != null 
					&& !valueField.getName().equals("linkStr")
					&& !valueField.getName().equals("title")
					&& !valueField.getName().equals("subject")
					&& !valueField.getName().equals("fileName")
					&& !valueField.getName().equals("middleFileName")
					&& !valueField.getName().equals("highFileName")
					&& !valueField.getName().equals("modelName")
					&& !valueField.getName().equals("createTime")
					){
				desc += valueField.getValue();
				
			}
		}
	}
	
	
	%>

	<div class='font_blue fz13' style="height:30px;overflow:hidden" >
		<%=desc%>
	</div>




	<p></p>
	<%}
	}%>
		</c:if> 
 </DIV>
</body>
</html>