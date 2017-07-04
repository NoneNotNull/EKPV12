<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page import="com.landray.kmss.sys.evaluation.service.ISysEvaluationNotesService"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.landray.kmss.common.actions.RequestContext"%>

[
<%
ISysEvaluationNotesService notesService = 
		(ISysEvaluationNotesService)SpringBeanUtil.getBean("sysEvaluationNotesService");
	JSONArray modelNameList = notesService.listEvalNotesModels(new RequestContext(request));
	for(int i=0;i<modelNameList.size();i++){
		JSONObject jObject = (JSONObject)modelNameList.get(i);
		String modelName = jObject.getString("modelName");
		String mName = jObject.getString("text");
%>
		{"text":"<%=mName%>", "value":"<%=modelName%>"}
		<%	if(i<modelNameList.size()-1){
		%>	,
		<%}%>
<%	}
%>
]