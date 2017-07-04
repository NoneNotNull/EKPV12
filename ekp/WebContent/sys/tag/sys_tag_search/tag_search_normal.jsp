<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>  
<%@ page import="java.util.List,
	com.landray.kmss.util.ResourceUtil,
	com.landray.kmss.sys.config.dict.SysDataDict,
	com.landray.kmss.sys.config.dict.SysDictModel" %>
<%@page import="com.sunbor.web.tag.Page"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<script language="JavaScript">
Com_IncludeFile("list.js");
Com_IncludeFile("tag_search_normal.css", "style/"+Com_Parameter.Style+"/tag/");
</script> 
<body style="margin:0;padding:0;">  
<DIV class='bt' > 
<DIV class='btw'>
<IMG  src="${KMSS_Parameter_StylePath}tag/dot_orange.jpg"/>
<span class='fz_15'><bean:message bundle="sys-tag" key="sysTagResult.total" />
</span><span class='cl_orange bol fz_15'>${queryPage.totalrows}</span>
<span class='fz_15'><bean:message bundle="sys-tag" key="sysTagResult.total.file" /> </span>
</DIV>
<%--分页---%>
<c:if test="${queryPage.totalrows>10}">
 	<DIV class="pages" style="float: right;margin-top:9px"> 
		<span class="postPages" >
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
	</DIV> 
 
</c:if>  

</DIV>
<%--分割条---%>
<DIV class='vline' style="margin-top:13px"> 
<DIV class='w95' style="margin-top: -13px;height:100%"> 
<%--查询无数据--%>
<c:if test="${queryPage.totalrows==0}">
<iframe  id='iframe${topic.fdId}' src="<c:url value='/sys/tag/sys_tag_search/tag_search_norecord.jsp'/>" width=100% height=100%  frameborder=0 scrolling=no marginheight="0"    onload="Javascript:parent.SetWinHeight(this)"  >
</iframe>
</c:if>

<%--查询有数据--%>
<c:if test="${queryPage.totalrows>0}">
	<c:forEach items="${queryPage.list}" var="sysTagMain" varStatus="vstatus">
	 <div  style="text-align: left;margin-top: 30px"> 
	 <c:set var="fdModelId" value="${sysTagMain.fdModelId }"/>
	 <c:set var="fdModelName" value="${sysTagMain.fdModelName }"/>
	 <%
	    SysDictModel sysDictModel = SysDataDict.getInstance().getModel((String)pageContext.getAttribute("fdModelName"));
	 	String url = "";
	 	if(sysDictModel != null && sysDictModel.getUrl()!=null){
		 	url = sysDictModel.getUrl();
		 	url=StringUtil.replace(url,"${fdId}",(String)pageContext.getAttribute("fdModelId"));
		 //	url=url.substring(0,url.length()-7)+(String)pageContext.getAttribute("fdModelId");
	 	}
	 %>
	 	<%--主题--%>
		<a target='_blank' class="fz16"  href='${path}<%=url %>'>
		<span class="lksHit">${sysTagMain.docSubject}</span></a>
		&nbsp;&nbsp; 
		<span  class='font_blue fz13' >
		<%---创建者--%>
		<bean:message bundle="sys-tag" key="sysTagResult.creators" />
		 ${sysTagMain.docCreator.fdName} 
		</span>
		 &nbsp;&nbsp;
		 <%---创建时间--%> 
		<span  class='font_blue fz13'>
		<bean:message bundle="sys-tag" key="sysTagResult.createDates" /> 
		 <kmss:showDate
				value="${sysTagMain.docCreateTime}"
				type="datetime" /> 
		</span>
		 &nbsp;&nbsp;
		<%---所属模块--%>
		<span class='font_blue fz13' >
		<bean:message bundle="sys-tag" key="sysTagResult.modelNames" /> 
	  	<%  
	  		if(sysDictModel != null && sysDictModel.getMessageKey() !=null)
	  	  		out.println(ResourceUtil.getString(sysDictModel.getMessageKey())); 
	  	%>
		</span> 
		<%--链接--%>
		<div class='link' >
		<span class='linkUrl'  style="font-size: 16px">
		http://${host}${path} 
		<%=url%>&nbsp;</span>
		<%--全文--%>
		<a  target="_blank" href='${path}<%=url %>'>
		<span style="font-size: 12px"><bean:message bundle="sys-tag" key="sysTagResult.whole" /></span></a>
		</div> 
	</div>
	
	</c:forEach> 
	 
	<%--分页--%>  
	<c:if test="${queryPage.totalrows>10}">
			<div class="pages" style="float: left;margin-top:30px">
				<span class="postPages" >
					<sunbor:page name="queryPage" pagenoText="pagenoText2" pageListSize="10" pageListSplit="">
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
		</c:if>
	</c:if> 
</DIV>


</DIV>
 </body>  
 
