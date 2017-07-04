<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/list_top.jsp"%>
<html:form action="/sys/property/sys_property_val/sysPropertyVal.do">
	  
<c:if test="${queryPage.totalrows==0}">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</c:if>
<c:if test="${queryPage.totalrows>0}">
	<%@ include file="/resource/jsp/list_pagenav_top.jsp"%>
	<table id="List_ViewTable">
		<tr>
		 
				<td width="10pt">
					<input type="checkbox" name="List_Tongle">
				</td>
				<td width="40pt">
					<bean:message key="page.serial"/>
				</td>
				<td>
					属性模板名称
				</td>
				<td>
					属性名称
				</td>
				<td>
					枚举的属性值
				</td>
				<td>
					是否可编辑
				</td>
				<td>
					操作
				</td>
		 
		</tr>
		<c:forEach items="${queryPage.list}" var="sysPropertyValOnPage" varStatus="vstatus">
			<tr >
				<td>
					<input type="checkbox" name="List_Selected" value="${sysPropertyReference.fdId}">
				</td>
				<td>
					${vstatus.index+1}
				</td>
				<td>
					<c:out value="${sysPropertyValOnPage.fdTemplateName}" />
				</td>
				<td>
					<c:out value="${sysPropertyValOnPage.fdPropertyDefineName}" />
				</td>
				<td>
					 <c:out value="${sysPropertyValOnPage.fdPropertyValue}" />
				</td>
				<td>
				    <sunbor:enumsShow value="${sysPropertyValOnPage.fdEdit}" enumsType="common_yesno" />
				</td>
				<td>
				<kmss:auth requestURL="/sys/property/sys_property_define/sysPropertyDefine.do?method=add">
				    <c:if test="${sysPropertyValOnPage.fdEdit==true}">
						<a href="javascript:void(0)" onclick="editProperty('${sysPropertyValOnPage.fdId}','${templateId}')">编辑</a>
					</c:if>
				</kmss:auth>
				</td>
			</tr>
		</c:forEach>
	</table>
	<%@ include file="/resource/jsp/list_pagenav_down.jsp" %>
</c:if>
</html:form>
<script>
function editProperty(referenceId,templateId){
   Com_OpenWindow('sysPropertyVal.do?method=edit&templateId='+templateId+'&referenceId='+referenceId,'_blank'); 
}

</script>
<%@ include file="/resource/jsp/list_down.jsp"%>