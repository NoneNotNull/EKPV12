<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ include file="/resource/jsp/list_top.jsp"%>
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
<html:form action="/tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do">	
	<table  id="List_ViewTable">
		<tr align="center"> 
			<c:forEach items="${titleList}" var="item" >
				<td>
				   ${item}
				</td>
			</c:forEach>
		</tr>
	    
	    <c:if test="${!empty resultList}">
			<c:forEach items="${resultList}" var="dataList" >
			 <tr>
			    <c:if test="${!empty dataList}">
				   <c:forEach items="${dataList}" var="dataField" >
						<td >
						   ${dataField}
						</td>
					</c:forEach>
				</c:if>
				 <c:if test="${empty dataList}">
				      <td ></td>
				</c:if>
			 </tr>
			</c:forEach>
		</c:if>
	</table>
</html:form>
