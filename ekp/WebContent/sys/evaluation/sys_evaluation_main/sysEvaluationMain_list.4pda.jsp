<%@ include file="/resource/jsp/common.jsp"%>
<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@page import="com.landray.kmss.util.*"%>
<%@page import="com.landray.kmss.sys.evaluation.model.SysEvaluationMain"%>
<%@page import="com.sunbor.web.tag.Page"%>
<%@page import="net.sf.json.*"%>
<%
	Page queryPage= (Page)request.getAttribute("queryPage");
	JSONObject viewObj=new JSONObject();
	int docCount=queryPage.getTotalrows();
	if(docCount==0){
		viewObj.accumulate("errorPage","true");									//错误标识
		viewObj.accumulate("message",ResourceUtil.getString("sysEvaluation.noData","sys-evaluation"));//错误信息
	}else{
		viewObj.accumulate("pageCount",queryPage.getTotal());//所有页数
		viewObj.accumulate("pageno",queryPage.getPageno());  //当前页码
		viewObj.accumulate("count",docCount);                //文档总数
		if(queryPage.getEnd()<docCount-1)
			viewObj.accumulate("nextPageStart",queryPage.getEnd()+1); //下页开始数
		JSONArray docArr=new JSONArray();
		for(Object evalObj:queryPage.getList()){
			JSONObject eval=new JSONObject();
			SysEvaluationMain evaluationMain=(SysEvaluationMain)evalObj;
			eval.accumulate("subject",evaluationMain.getFdEvaluationContent());
			eval.accumulate("summary",evaluationMain.getFdEvaluator().getFdName()+" | "+DateUtil.convertDateToString(evaluationMain.getFdEvaluationTime(),DateUtil.PATTERN_DATETIME));
			eval.accumulate("url",evaluationMain.getFdEvaluationScore());
			docArr.element(eval);
		}
		viewObj.accumulate("docs",docArr);
	}
	pageContext.setAttribute("viewObj",viewObj.toString());
%>
${viewObj}