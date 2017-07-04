<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ page import="java.util.Date,com.landray.kmss.km.imeeting.model.KmImeetingMain"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/person/person.tld" prefix="person"%>
<list:data>
	<list:data-columns var="kmImeetingMain" list="${queryPage.list }" varIndex="status" mobile="true">
		<list:data-column property="fdId">
		</list:data-column >
	    <%-- 主题--%>	
		<list:data-column col="label" title="${ lfn:message('km-imeeting:kmImeetingMain.fdName') }">
			<c:out value="${kmImeetingMain.fdName}"/>
		</list:data-column>
		<%-- 召开时间~结束时间 --%>
		<list:data-column col="created" escape="false">
			<c:if test="${not empty kmImeetingMain.fdHoldDate or not empty kmImeetingMain.fdFinishDate }">
				<kmss:showDate value="${kmImeetingMain.fdHoldDate}" type="datetime"></kmss:showDate>
				 ~
				<kmss:showDate value="${kmImeetingMain.fdFinishDate}" type="datetime"></kmss:showDate>
			</c:if>
		</list:data-column>
		 <%-- 主持人头像--%>
		<list:data-column col="icon" escape="false">
			<c:if test="${not empty kmImeetingMain.fdHost }" >
				<person:headimageUrl personId="${kmImeetingMain.fdHost.fdId}" size="90" />
			</c:if>
			<c:if test="${empty kmImeetingMain.fdHost }">
				<person:headimageUrl personId="" size="90" />
			</c:if>
		</list:data-column>
		 <%-- 主持人--%>
		<list:data-column col="host" title="${ lfn:message('km-imeeting:kmImeetingMain.fdHost') }">
			<c:if test="${not empty kmImeetingMain.fdHost or not empty kmImeetingMain.fdOtherHostPerson }">
				<c:if test="${not empty kmImeetingMain.fdHost}">
					<c:out value="${kmImeetingMain.fdHost.fdName}"/>
				</c:if>
			    <c:if test="${not empty kmImeetingMain.fdOtherHostPerson }">
			    	<c:out value="${ kmImeetingMain.fdOtherHostPerson }"></c:out>
			    </c:if>     
	    	</c:if>
		</list:data-column>
		 <%-- 发布时间
	 	<list:data-column col="created" title="${ lfn:message('km-imeeting:kmImeetingMain.fdHoldDate') }">
	        <kmss:showDate value="${kmImeetingMain.fdHoldDate}" type="datetime"></kmss:showDate>
      	</list:data-column>--%>
      	 <%-- 地点--%>
	 	<list:data-column col="place" title="${ lfn:message('km-imeeting:kmImeetingMain.fdPlace') }">
	       <c:if test="${not empty kmImeetingMain.fdPlace }">
	       		<c:out value="${kmImeetingMain.fdPlace.fdName }"></c:out>
	       </c:if>
	       <c:if test="${not empty kmImeetingMain.fdOtherPlace }">
	       		<c:out value="${kmImeetingMain.fdOtherPlace }"></c:out>
	       </c:if>
      	</list:data-column>
      	<%--状态 --%>
      	<list:data-column col="status" title="${ lfn:message('km-imeeting:kmImeetingMain.docStatus') }" escape="false">
	       <%
	       	   Boolean isBegin=false,isEnd=false;
		       if(pageContext.getAttribute("kmImeetingMain")!=null){
		    	   Date now=new Date();
		    	   KmImeetingMain kmImeetingMain=(KmImeetingMain)pageContext.getAttribute("kmImeetingMain");
		    	   if(kmImeetingMain.getFdHoldDate()!=null && kmImeetingMain.getFdFinishDate()!=null){
		    		   //会议已开始
		    		   if(kmImeetingMain.getFdHoldDate().getTime() < now.getTime()){
		    			   isBegin=true;
		    		   }
		    		   if(kmImeetingMain.getFdFinishDate().getTime() < now.getTime()){
		    			   isEnd=true;
		    		   }
		    	   }
		       }
		       request.setAttribute("isBegin", isBegin);
	    	   request.setAttribute("isEnd", isEnd);
			%>
			<%--状态 --%>
			<c:import url="/km/imeeting/mobile/import/status.jsp">
				<c:param name="status" value="${kmImeetingMain.docStatus }"></c:param>
				<c:param name="isBegin" value="${isBegin }"></c:param>
				<c:param name="isEnd" value="${isEnd }"></c:param>
			</c:import>
      	</list:data-column>
		<%--链接--%>
		<list:data-column col="href" escape="false">
			/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=view&fdId=${kmImeetingMain.fdId}
		</list:data-column>
		
	</list:data-columns>
	
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>