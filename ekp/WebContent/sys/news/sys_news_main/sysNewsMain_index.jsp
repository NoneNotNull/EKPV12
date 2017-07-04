<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/list.tld" prefix="list" %>
<list:data>
	
	<list:data-columns var="item" list="${queryPage.list }" varIndex="varIndex">
		<list:data-column property="docSubject" title="文档标题">
		</list:data-column>
		<list:data-column property="docCreator.fdName" title="作者">
		</list:data-column>
		<list:data-column property="docPublishTime" title="发布时间">
		</list:data-column>
		<list:data-column property="docCreateTime" title="创建时间">
		</list:data-column>
		<list:data-column property="docReadCount" title="阅读次数">
		</list:data-column>
	</list:data-columns>
	
	<list:data-paging currentPage="${queryPage.pageno }" pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }"></list:data-paging>

</list:data>
