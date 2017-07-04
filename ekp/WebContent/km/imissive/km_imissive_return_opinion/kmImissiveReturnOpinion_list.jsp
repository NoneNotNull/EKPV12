<%@ page language="java" contentType="text/json; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="kmImissiveReturnOpinion" list="${queryPage.list }">
		<list:data-column headerClass="width160"  property="fdUnit.fdName" title="退回单位">
		</list:data-column>
		<list:data-column style="text-align:left;min-width:200px"  property="docContent" title="退回意见">
		</list:data-column>
		<list:data-column headerClass="width160"  col="docCreateTime" title="退回时间">
		    <kmss:showDate value="${kmImissiveReturnOpinion.docCreateTime}" type="date" />
		</list:data-column>
		<list:data-column headerClass="width160" col="docCreator.fdName" title="退回人" escape="false">
			    <ui:person personId="${kmImissiveReturnOpinion.docCreator.fdId}" personName="${kmImissiveReturnOpinion.docCreator.fdName}"></ui:person> 
	    </list:data-column>
	</list:data-columns>
		<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>