<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:data>
	<list:data-columns var="item" list="${queryPage.list }">
		<list:data-column col="fdId"  escape="false" >
			${item[0].fdId}
		</list:data-column>
		<list:data-column  col="docSubject" title="标题" escape="false" >
			<span class="lui_dataview_classic_cate_nolink">[${fromJson[item[2]]}]</span>
			<a href="${LUI_ContextPath}/sys/follow/sys_follow_doc/sysFollowDoc.do?method=view&fdId=${item[0].fdId}" target="_blank">${item[0].docSubject}</a>
		</list:data-column>
		<list:data-column col="status" escape="false" title="状态" style="width:40px">
			${item[1] == "1"?"已阅":"未阅" }
		</list:data-column>
		<list:data-column col="docCreateTime" escape="false" title="订阅时间" style="width:100px">
			<span class="lui_dataview_classic_created">
			<kmss:showDate value="${item[0].docCreateTime }" type="date"></kmss:showDate>
			</span>
		</list:data-column>
		
	</list:data-columns>
	<list:data-paging page="${queryPage }">
	</list:data-paging>
</list:data>
