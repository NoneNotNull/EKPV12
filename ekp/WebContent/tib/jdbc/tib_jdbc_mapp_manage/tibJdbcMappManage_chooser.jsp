<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/tib/jdbc/tib_jdbc_mapp_manage/tibJdbcMappManage.do">
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
			<sunbor:columnHead htmlTag="td">
				<td width="30pt">
					<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.select"/>
				</td>
				<td width="30pt">
					<bean:message key="page.serial"/>
				</td>
				<sunbor:column property="tibJdbcMappManage.docSubject">
					<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.docSubject"/>
				</sunbor:column>
				<sunbor:column property="tibJdbcMappManage.fdDataSource">
					<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.fdDataSource"/>
				</sunbor:column>
				<sunbor:column property="tibJdbcMappManage.fdIsEnabled">
					<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.fdIsEnabled"/>
				</sunbor:column>
				<sunbor:column property="tibJdbcMappManage.fdDataSourceSql">
					<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.fdDataSourceSql"/>
				</sunbor:column>
				<sunbor:column property="tibJdbcMappManage.fdTargetSource">
					<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.fdTargetSource"/>
				</sunbor:column>
				<sunbor:column property="tibJdbcMappManage.fdTargetSourceSelectedTable">
					<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.fdTargetSourceSelectedTable"/>
				</sunbor:column>
				<sunbor:column property="tibJdbcMappManage.docCategory.fdName">
					<bean:message bundle="tib-jdbc" key="tibJdbcMappManage.docCategory"/>
				</sunbor:column>
			</sunbor:columnHead>
		</tr>
		<c:forEach items="${queryPage.list}" var="tibJdbcMappManage" varStatus="vstatus">
			<tr >
				<td>
					<input type="radio"" name="List_Selected" value="${tibJdbcMappManage.fdId}">
				</td>
				
				<td>
					${vstatus.index+1}
				</td>
				
				<td>
					${tibJdbcMappManage.docSubject}
				</td>
				
				<td>
				    ${dataSoure[tibJdbcMappManage.fdDataSource]}
				</td>
				
				<td>
					<xform:radio value="${tibJdbcMappManage.fdIsEnabled}" property="fdIsEnabled" showStatus="view">
						<xform:enumsDataSource enumsType="common_yesno" />
					</xform:radio>
				</td>
				
				<td>
					${tibJdbcMappManage.fdDataSourceSql}
				</td>
				
				<td>
					${dataSoure[tibJdbcMappManage.fdTargetSource]}	
				</td>
				
				<td>
					"${tibJdbcMappManage.fdTargetSourceSelectedTable}"
				</td>
				
				<td>
					"${tibJdbcMappManage.docCategory.fdName}"
				</td>
			</tr>
		</c:forEach>
	</table>
	
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
	<!-- 
      <div align="center">
    	  <input type="button" class="btndialog" style="width:50px" value="选择" onclick=""/>
    	  <input type="button" class="btndialog" style="width:50px" value="取消" onclick=""/>
    </div>	
    --> 
</c:if>

<script  type="text/javascript">
Com_IncludeFile("jquery.js");

</script>
</html:form>
<%@ include file="/resource/jsp/list_down.jsp"%>