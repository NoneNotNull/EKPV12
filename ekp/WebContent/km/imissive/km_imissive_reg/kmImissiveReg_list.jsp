<%@ page language="java" contentType="text/json; charset=UTF-8"
   import="com.landray.kmss.km.imissive.model.KmImissiveReg,com.landray.kmss.km.imissive.model.KmImissiveRegDetailList,com.landray.kmss.sys.organization.model.SysOrgElement,java.util.*,com.landray.kmss.util.*"
   pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<%@page import="com.landray.kmss.km.imissive.model.KmImissiveUnit"%><list:data>
	<list:data-columns var="kmImissiveReg" list="${queryPage.list }">
		<%--ID--%> 
		<list:data-column property="fdId"></list:data-column>
		<list:data-column headerClass="width120"  col="docCreateTime" title="发送时间">
		    <kmss:showDate value="${kmImissiveReg.docCreateTime}" type="datetime" />
		</list:data-column>
		<%--名称--%>
		<list:data-column  headerClass="width200" col="fdName" title="名称" style="text-align:left" escape="false">
			<span class="com_subject"><c:out value="${kmImissiveReg.fdName}" /></span>
		</list:data-column>
		<%--发往单位 --%>
		<list:data-column  col="fdDetailList" escape="false" title="发往单位">
			<%
			if(pageContext.getAttribute("kmImissiveReg")!=null){
		    List fdDetailList=((KmImissiveReg)pageContext.getAttribute("kmImissiveReg")).getFdDetailList();
			String unitNames="";
				for(int i=0;i<fdDetailList.size();i++){
					if(i==fdDetailList.size()-1){
						unitNames+=((KmImissiveRegDetailList)fdDetailList.get(i)).getFdUnit().getFdName();	
					}else{
						unitNames+=((KmImissiveRegDetailList)fdDetailList.get(i)).getFdUnit().getFdName()+";";
					}
				 }
			request.setAttribute("unitNames",unitNames);
			}
			%>
			<p title="${unitNames}">
				<c:forEach items="${kmImissiveReg.fdDetailList}" var="fdDetail" varStatus="vstatus">
					${fdDetail.fdUnit.fdName}
				</c:forEach>
			</p>
		</list:data-column>
		<list:data-column headerClass="width100" col="kmImissiveReg.fdDeliverType" title="来源">
		    <sunbor:enumsShow value="${kmImissiveReg.fdDeliverType}" enumsType="kmImissiveRegDetailList_type" bundle="km-imissive" />
		</list:data-column>
	</list:data-columns>

	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>