<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@page import="com.landray.kmss.sys.evaluation.model.SysEvaluationMain"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<list:data>
	<list:data-columns var="item" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column>
		<list:data-column col="fdEvaluationContent" title="${lfn:message('sys-evaluation:sysEvaluationMain.fdEvaluationContent')}" escape="false">
			<%
				SysEvaluationMain evalMain = (SysEvaluationMain)pageContext.getAttribute("item");
				if(evalMain!=null && 
						StringUtil.isNotNull(evalMain.getFdEvaluationContent())){
					String evalCont = evalMain.getFdEvaluationContent();
					evalCont = evalCont.replaceAll("\\[face","<img src='" + request.getContextPath() 
			                + "/sys/evaluation/import/resource/images/bq/").replaceAll("]",".gif' type='face'></img>");
					out.print(evalCont);
				}else{
					out.print("");
				}
			%>
		</list:data-column>
		<list:data-column property="fdEvaluationScore" title="${lfn:message('sysEvaluationMain.fdEvaluationScore')}">
		</list:data-column>
		<list:data-column property="fdEvaluator.fdName" title="${lfn:message('sysEvaluationMain.sysEvaluator')}">
		</list:data-column>
		<list:data-column property="fdEvaluator.fdId">
		</list:data-column>
		<list:data-column property="fdEvaluationTime" title="${lfn:message('sysEvaluationMain.fdEvaluationTime')}">
		</list:data-column>
		<list:data-column col="fdReplyCount" title="${lfn:message('sys-evaluation:sysEvaluationMain.fdReplyCount')}">
			${not empty item.fdReplyCount? item.fdReplyCount: 0}
		</list:data-column>
		<list:data-column col="docPraiseCount">
			${not empty item.docPraiseCount? item.docPraiseCount: 0}
		</list:data-column>
	</list:data-columns>
	<list:data-paging currentPage="${queryPage.pageno }"
		pageSize="${queryPage.rowsize }" totalSize="${queryPage.totalrows }">
	</list:data-paging>
</list:data>
