<%@ include file="/resource/jsp/common.jsp"%>
<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@page import="com.landray.kmss.third.pda.service.IPdaDataShowService"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@page import="com.landray.kmss.util.*"%>
<%@page import="java.util.Map"%>
<%@page import="com.sunbor.web.tag.Page"%>
<%@page import="com.landray.kmss.third.pda.model.PdaRowsPerPageConfig"%>
<%@page import="net.sf.json.*"%>
<%
	Map<String,String> map=((IPdaDataShowService)SpringBeanUtil.getBean("pdaDataShowService")).getSupportPdaCfgMap();
	String appFlag="";
	String[] extendArr=(new PdaRowsPerPageConfig()).getFdExtendsUrl();
	Page queryPage= (Page)request.getAttribute("queryPage");
	JSONObject viewObj=new JSONObject();
	int docCount=queryPage.getTotalrows();
	if(docCount==0){
		viewObj.accumulate("errorPage","true");	//错误标识
		viewObj.accumulate("message",ResourceUtil.getString("sysRelationMain.noData","sys-relation"));//错误信息
	}else{
		viewObj.accumulate("pageCount",queryPage.getTotal());//所有页数
		viewObj.accumulate("pageno",queryPage.getPageno());  //当前页码
		viewObj.accumulate("count",docCount);                //文档总数
		if(queryPage.getEnd()<docCount-1)
			viewObj.accumulate("nextPageStart",queryPage.getEnd()+1); //下页开始数
		JSONArray docArr=new JSONArray();
		for(Object relaObj:queryPage.getList()){
			JSONObject relation=new JSONObject();
			Map rstMain=(Map)relaObj;
			relation.accumulate("subject",rstMain.get("docSubject"));
			relation.accumulate("summary",rstMain.get("docCreateInfo"));
			String modelName=(String)rstMain.get("modelName");
			boolean needUrl=false;
			String linkStr=(String)rstMain.get("linkUrl");
			if(map.get(modelName)!=null)
				needUrl=true;
			if(needUrl==false){
				if(StringUtil.isNotNull(linkStr) && extendArr!=null){
					for(int i=0;i<extendArr.length;i++){
						if(StringUtil.isNotNull(extendArr[i]) && linkStr.toLowerCase().indexOf(extendArr[i].toLowerCase())>-1){
							needUrl=true;
							break;
						}
					}
				}
				
				if(StringUtil.isNotNull(linkStr)){
				    for (Map.Entry<String, String> entry : map.entrySet()) {
				    	if(linkStr.toLowerCase().indexOf(entry.getKey())>-1){
							needUrl=true;
							break;
						}
					}
				}
			}
			if(needUrl)
				relation.accumulate("url",rstMain.get("linkUrl"));
			docArr.element(relation);
		}
		viewObj.accumulate("docs",docArr);
	}
	pageContext.setAttribute("viewObj",viewObj.toString());
%>
${viewObj}
