
<%@page import="com.landray.kmss.util.UserUtil"%><%@ include file="/resource/jsp/common.jsp"%>
<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@page import="com.sunbor.web.tag.Page"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.util.ModelUtil"%>
<%@page import="com.landray.kmss.third.pda.util.PdaFlagUtil"%>
<%@page import="org.apache.commons.beanutils.PropertyUtils"%>
<%@page import="com.landray.kmss.sys.organization.model.SysOrgElement"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.landray.kmss.util.DateUtil"%>
<%
	response.setHeader("pragma", "no-cache");
	response.setHeader("cache-control", "no-cache");
	response.setHeader("expires", "0");
	String appFlag="";
	if(PdaFlagUtil.checkClientIsPdaApp(request))
		appFlag="&isAppflag=1";
	Page queryPage= (Page)request.getAttribute("queryPage");
	JSONObject viewObj=new JSONObject();
	int docCount=queryPage.getTotalrows();
	viewObj.accumulate("pageCount",queryPage.getTotal());//所有页数
	viewObj.accumulate("pageno",queryPage.getPageno());  //当前页码
	viewObj.accumulate("count",docCount);                //文档总数
	if(queryPage.getEnd()<docCount-1)
		viewObj.accumulate("nextPageStart",queryPage.getEnd()+1); //下页开始数
	JSONArray docArr=new JSONArray();
	for(Object modelObj:queryPage.getList()){
		JSONObject obj=new JSONObject();
		String fdId="";
		try{
			fdId = (String)PropertyUtils.getProperty(modelObj,"fdId");
		}catch(Exception e){
			fdId = "";
		}
		obj.accumulate("fdId",fdId);
		String fdHasAuth="false";
		try{
			if(UserUtil.checkAuthentication("/sys/task/sys_task_feedback/sysTaskFeedback.do?method=add&fdTaskId="+fdId,"GET")){
				fdHasAuth = "true";
			}
		}catch(Exception e){
			fdHasAuth = "false";
		}
		obj.accumulate("fdHasAuth",fdHasAuth);
		String myPerform="false";
		List performList = new ArrayList();
		String performListIds = "";
		try{
			performList = (List)PropertyUtils.getProperty(modelObj,"toSysOrgPerform");
			if(UserUtil.checkUserModels(performList)||UserUtil.getKMSSUser().isAdmin()){
				myPerform = "true";
			}
		}catch(Exception e){
			myPerform = "false";
		}
		obj.accumulate("myPerform",myPerform);
		String subject="";
		try{
			subject = (String)PropertyUtils.getProperty(modelObj,"docSubject");
		}catch(Exception e){
				subject = "";
		}
		obj.accumulate("subject",subject);
		
		String fdStatus="";
		try{
			fdStatus = (String)PropertyUtils.getProperty(modelObj,"fdStatus");
		}catch(Exception e){
			fdStatus = "";
		}
		obj.accumulate("fdStatus",fdStatus);
		String fdProgress="";
		try{
			fdProgress = (String)PropertyUtils.getProperty(modelObj,"fdProgress");
		}catch(Exception e){
			fdProgress = "";
		}
		obj.accumulate("fdProgress",fdProgress);
		
		
		SysOrgElement fdAppoint = null;
		String fdAppointName="";
		try{
			fdAppoint = (SysOrgElement) PropertyUtils.getProperty( modelObj,"fdAppoint");
			fdAppointName = fdAppoint == null ?"":fdAppoint.getFdName();
		}catch(Exception e){
			fdAppointName = "";
		}
		obj.accumulate("fdAppointName",fdAppointName);
		
		Date fdPlanCompleteDateTime = null;
		try{
			fdPlanCompleteDateTime = (Date) PropertyUtils.getProperty( modelObj,"fdPlanCompleteDateTime");
		}catch(Exception e){
				fdPlanCompleteDateTime = null;
		}
		obj.accumulate("fdPlanCompleteDateTime",DateUtil.convertDateToString(fdPlanCompleteDateTime,DateUtil.PATTERN_DATETIME));
		String fdIsAtt="";
		List<SysOrgElement> toSysOrgAttention = new ArrayList<SysOrgElement>();
		try{
			toSysOrgAttention = (List) PropertyUtils.getProperty( modelObj,"toSysOrgAttention");
			if(toSysOrgAttention.contains(UserUtil.getUser())){
				fdIsAtt = "1";
			}
		}catch(Exception e){
			fdIsAtt = "0";
		}
		obj.accumulate("fdIsAtt",fdIsAtt);
		try{
			fdPlanCompleteDateTime = (Date) PropertyUtils.getProperty( modelObj,"fdPlanCompleteDateTime");
		}catch(Exception e){
				fdPlanCompleteDateTime = null;
		}
		
		obj.accumulate("type","doc");
		obj.accumulate("url", PdaFlagUtil.formatUrl(request, ModelUtil.getModelUrl(modelObj)+(StringUtil.isNull(appFlag)?"":appFlag)));
		docArr.element(obj);
	}
	viewObj.accumulate("docs",docArr);
	pageContext.setAttribute("viewObj",viewObj.toString());
%>
${viewObj}
