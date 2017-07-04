<%@ include file="/resource/jsp/common.jsp"%>
<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@page import="com.landray.kmss.util.*"%>
<%@page import="com.landray.kmss.sys.introduce.model.SysIntroduceMain"%>
<%@page import="com.sunbor.web.tag.Page"%>
<%@page import="net.sf.json.*"%>
<%
	Page queryPage= (Page)request.getAttribute("queryPage");
	JSONObject viewObj=new JSONObject();
	int docCount=queryPage.getTotalrows();
	if(docCount==0){
		viewObj.accumulate("errorPage","true");									//错误标识
		viewObj.accumulate("message",ResourceUtil.getString("sysIntroduceMain.showText.noneRecord","sys-introduce"));//错误信息
	}else{
		viewObj.accumulate("pageCount",queryPage.getTotal());//所有页数
		viewObj.accumulate("pageno",queryPage.getPageno());  //当前页码
		viewObj.accumulate("count",docCount);                //文档总数
		if(queryPage.getEnd()<docCount-1)
			viewObj.accumulate("nextPageStart",queryPage.getEnd()+1); //下页开始数
		JSONArray docArr=new JSONArray();
		for(Object intrObj:queryPage.getList()){
			JSONObject intro=new JSONObject();
			SysIntroduceMain introMain=(SysIntroduceMain)intrObj;
			intro.accumulate("subject",introMain.getFdIntroduceReason());
			EnumerationTypeUtil enumUtil = EnumerationTypeUtil.newInstance();
			String toSign="";
			if(introMain.getFdIntroduceToEssence())
				toSign+=" & "+ ResourceUtil.getString("sysIntroduceMain.introduce.show.type.essence","sys-introduce");
			if(introMain.getFdIntroduceToNews())
				toSign+=" & "+ ResourceUtil.getString("sysIntroduceMain.introduce.show.type.news","sys-introduce");
			if(introMain.getFdIntroduceToPerson())
				toSign+=" & "+ ResourceUtil.getString("sysIntroduceMain.introduce.show.type.person","sys-introduce");
			if(StringUtil.isNotNull(toSign))
				toSign=toSign.substring(3);
			intro.accumulate("summary",introMain.getFdIntroducer().getFdName()+" | "
					+ DateUtil.convertDateToString(introMain.getFdIntroduceTime(),DateUtil.PATTERN_DATETIME)+" | "
					+ enumUtil.getColumnEnumsLabel("sysIntroduce_Grade",introMain.getFdIntroduceGrade().toString())+" | "
					+ toSign+"("+introMain.getIntroduceGoalNames()+")");
			intro.accumulate("url","");
			docArr.element(intro);
		}
		viewObj.accumulate("docs",docArr);
	}
	pageContext.setAttribute("viewObj",viewObj.toString());
%>
${viewObj}