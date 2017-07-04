<%@page import="com.landray.kmss.km.imeeting.model.KmImeetingMain"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="kmImeetingMain" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column property="fdName" title="${ lfn:message('km-imeeting:kmImeetingMain.fdName') }" style="text-align:left;min-width:150px;">
		</list:data-column>
		<list:data-column headerClass="width60" col="fdHost" title="${ lfn:message('km-imeeting:kmImeetingMain.fdHost') }" escape="false">
		   <ui:person personId="${kmImeetingMain.fdHost.fdId}" personName="${kmImeetingMain.fdHost.fdName}"></ui:person>
		   <c:out value="${kmImeetingMain.fdOtherHostPerson}"/>
		</list:data-column> 
		<list:data-column headerClass="width100" col="fdPlace" title="${ lfn:message('km-imeeting:kmImeetingMain.fdPlace') }" escape="false">
		  <c:out value="${kmImeetingMain.fdPlace.fdName}"/> <c:out value="${kmImeetingMain.fdOtherPlace}"/>
		</list:data-column>
		<list:data-column headerClass="width120" col="fdDate" title="${lfn:message('km-imeeting:kmImeetingMain.fdDate') }" escape="false">
			<kmss:showDate value="${kmImeetingMain.fdHoldDate}" type="datetime" /> 
			<br/>
			~ <kmss:showDate value="${kmImeetingMain.fdFinishDate}" type="datetime" /> 
		</list:data-column>
		<list:data-column headerClass="width120" col="fdHoldDate" title="${ lfn:message('km-imeeting:kmImeetingMain.fdHoldDate') }">
		   <kmss:showDate value="${kmImeetingMain.fdHoldDate}" type="datetime" />
		</list:data-column>
		<list:data-column headerClass="width120" col="fdFinishDate" title="${ lfn:message('km-imeeting:kmImeetingMain.fdFinishDate') }">
		   <kmss:showDate value="${kmImeetingMain.fdFinishDate}" type="datetime" /> 
		</list:data-column>
		<list:data-column headerClass="width80" property="docCreator.fdName" title="${ lfn:message('km-imeeting:kmImeetingMain.docCreator') }" escape="false">
		</list:data-column>
		<list:data-column headerClass="width100" property="docDept.fdName" title="${ lfn:message('km-imeeting:kmImeetingMain.docDept') }">
		</list:data-column>
		<%--会议状态：发布状态下显示未召开、进行中、已召开....其他情况显示会议状态 #9104--%>
		<list:data-column headerClass="width60" col="docStatus" title="${ lfn:message('km-imeeting:kmImeetingMain.docStatus') }">
			<c:if test="${kmImeetingMain.docStatus=='30' }">
				<%
					if(pageContext.getAttribute("kmImeetingMain")!=null){
						KmImeetingMain kmImeetingMain = (KmImeetingMain)pageContext.getAttribute("kmImeetingMain");
						Date now=new Date(),
						 	holdDate=kmImeetingMain.getFdHoldDate(),
						 	finishDate=kmImeetingMain.getFdFinishDate();
						Boolean isBegin=false,isEnd=false;
						String docStatus=ResourceUtil.getString("kmImeeting.status.publish.unHold", "km-imeeting");
						// 会议已开始
						if (holdDate.getTime() < now.getTime()) {
							isBegin = true;
						}
						// 会议已结束
						if (finishDate.getTime() < now.getTime()) {
							isEnd = true;
						}
						if(isBegin==true && isEnd==false){
							docStatus=ResourceUtil.getString("kmImeeting.status.publish.holding", "km-imeeting");
						}
						if(isEnd==true){
							docStatus=ResourceUtil.getString("kmImeeting.status.publish.hold", "km-imeeting");
						}
						request.setAttribute("docStatus", docStatus);
					}
				%>
				<c:out value="${docStatus}"></c:out>
			</c:if>
			<c:if test="${kmImeetingMain.docStatus!='30' }">
				<sunbor:enumsShow value="${kmImeetingMain.docStatus}" bundle="km-imeeting" enumsType="km_imeeting_main_doc_status" />
			</c:if>
		</list:data-column>
	</list:data-columns>

	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>