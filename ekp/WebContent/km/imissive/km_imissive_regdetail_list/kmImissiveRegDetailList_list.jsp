<%@ page language="java" contentType="text/json; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="kmImissiveRegDetailList" list="${queryPage.list }">
		<%--ID--%> 
		<list:data-column property="fdId"></list:data-column>
		<%--名称--%>
		<list:data-column col="kmImissiveRegDetailList.fdReg.fdName" title="名称" escape="false" style="text-align:left;min-width:150px">
			<span class="com_subject"><c:out value="${kmImissiveRegDetailList.fdReg.fdName}" /></span>
		</list:data-column>
		<list:data-column headerClass="width100" col="kmImissiveRegDetailList.fdReg.fdDeliverType" title="来源">
		    <sunbor:enumsShow value="${kmImissiveRegDetailList.fdReg.fdDeliverType}" enumsType="kmImissiveRegDetailList_type" bundle="km-imissive" />
		    <sunbor:enumsShow value="${kmImissiveRegDetailList.fdType}" enumsType="kmImissiveRegDetailList_unittype" bundle="km-imissive" />
		</list:data-column>
		<list:data-column headerClass="width120"  property="fdUnit.fdName" title="发往单位">
		</list:data-column>
		<list:data-column headerClass="width120"  col="docCreateTime" title="发送日期">
		    <kmss:showDate value="${kmImissiveRegDetailList.docCreateTime}" type="date" />
		</list:data-column>
		<list:data-column headerClass="width80" col="fdOrgNames" title="收件人" escape="false">
		     <c:forEach items="${kmImissiveRegDetailList.fdOrg}" var="fdOrg" varStatus="vstatus">
					<ui:person personId="${fdOrg.fdId}" personName="${fdOrg.fdName}"></ui:person>
			 </c:forEach>
	    </list:data-column>
	    <list:data-column headerClass="width80"  col="fdStatus" title="状态" escape="false">
	         <sunbor:enumsShow value="${kmImissiveRegDetailList.fdStatus}" enumsType="kmImissiveReg_status" bundle="km-imissive" />
		</list:data-column>
		<list:data-column headerClass="width80" col="nodeName" title="当前环节" escape="false">
			<kmss:showWfPropertyValues idValue="${json[kmImissiveRegDetailList.fdId]}" propertyName="nodeName" />
		</list:data-column>
		<list:data-column headerClass="width80" col="handlerName" title="当前处理人" escape="false">
		    <kmss:showWfPropertyValues idValue="${json[kmImissiveRegDetailList.fdId]}" propertyName="handlerName" />
		</list:data-column>
	</list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>