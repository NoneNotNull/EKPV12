<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.landray.kmss.common.actions.RequestContext"%>
<%@page import="com.landray.kmss.sys.evaluation.service.ISysEvaluationMainService"%>
<template:include ref="default.simple" sidebar="no">
	<template:replace name="head">
		<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/sys/evaluation/import/resource/overView.css" />
		<%@ include file="/sys/evaluation/import/sysEvaluationMain_over_view_js.jsp"%>
		<template:super/>
		<script >
			seajs.use(['theme!form' ]);
		</script>
	</template:replace>
	<template:replace name="title">
		${lfn:message('sys-evaluation:sysEvaluationMain.overView') }
	</template:replace>
		<div>
			<table class="over_view_table">
				<tr>
					<td><span class="over_view_words">${lfn:message('sys-evaluation:sysEvaluation.search.range')}</span>
						<select name="modelName" class="over_view_select" onchange="searchByModel()" >
							<option value="">${lfn:message('sys-evaluation:sysEvaluation.all.system')}</option>
							<%
								ISysEvaluationMainService evalService = 
									(ISysEvaluationMainService)SpringBeanUtil.getBean("sysEvaluationMainService");
								JSONArray modelNameList = evalService.listEvalModels(new RequestContext(request));
								for(int i=0;i<modelNameList.size();i++){
									JSONObject jObject = (JSONObject)modelNameList.get(i);
									String modelName = jObject.getString("modelName");
									String text = jObject.getString("text");
							%>
									<option value="<%=modelName%>"><%=text%></option>
							<%	}
							%>
						</select>
					</td>
				</tr>
				<tr>
					<td>
						<span class="over_view_words">${lfn:message('sys-evaluation:sysEvaluationNotes.docSubject')}</span>
						<xform:radio property="fdEvaluationType" value="0" onValueChange="changeEvalType" showStatus="edit">
	        				<xform:enumsDataSource enumsType="sysEvaluationType"></xform:enumsDataSource>		        			
	        			</xform:radio>
	        			
					</td>
				</tr>
			</table>
		</div>
		<div style="margin:20px;">
			<%@ include file="/sys/evaluation/import/sysEvaluationMain_col_view.jsp"  %>
		</div>
</template:include>