<%@ page language="java" contentType="text/json; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.landray.kmss.kms.common.model.KmsCommentMain"%>
<%@page import="com.landray.kmss.util.StringUtil"%>

<list:data>
	<list:data-columns var="item" list="${queryPage.list}" varIndex="status">
		<list:data-column property="fdId"></list:data-column>
		<list:data-column col="index">
		  ${status+1}
		</list:data-column>
		<list:data-column property="docCreateTime"></list:data-column>
		<list:data-column col="fdCommentContent" escape="false">
			<%
				KmsCommentMain commentMain = (KmsCommentMain)pageContext.getAttribute("item");
				if(null != commentMain && StringUtil.isNotNull(commentMain.getFdCommentContent())) {
					String comment = commentMain.getFdCommentContent();
					comment = comment.replaceAll("\\[face","<img src='" + request.getContextPath() 
			                + "/kms/common/resource/img/bq/").replaceAll("]",".gif' type='face'></img>");
					out.print(comment);
				} else {
					out.print("");
				}
			 %>
		</list:data-column>
		<list:data-column property="fdModelId"></list:data-column> 
		<list:data-column property="docCommentator.fdId"></list:data-column>  
		<list:data-column property="docCommentator.fdName"></list:data-column>	
		<list:data-column property="docParentReplyer.fdId"></list:data-column>  
		<list:data-column property="docParentReplyer.fdName"></list:data-column>	
	</list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>	
</list:data>