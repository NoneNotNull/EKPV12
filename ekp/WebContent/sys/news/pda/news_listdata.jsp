<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.attachment.model.SysAttMain"%>
<%@page import="java.util.List"%>
<%@page
	import="com.landray.kmss.sys.attachment.service.ISysAttMainCoreInnerService"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.util.ModelUtil"%>
<%@page import="com.landray.kmss.third.pda.util.PdaFlagUtil"%>
<%@page import="com.landray.kmss.third.pda.service.IPdaDataShowService"%>
<%@page import="com.landray.kmss.third.pda.model.PdaRowsPerPageConfig"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page import="com.landray.kmss.sys.news.model.SysNewsMain"%>
<%@page import="java.util.Map"%>
<%@ page import="com.sunbor.web.tag.Page"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.landray.kmss.util.DateUtil"%>
<%@page import="net.sf.json.JSONArray"%>

<%
	Map<String,String> map=((IPdaDataShowService)SpringBeanUtil.
			getBean("pdaDataShowService")).getSupportPdaCfgMap();
	ISysAttMainCoreInnerService sysAttMainCoreInnerService=(ISysAttMainCoreInnerService)
			SpringBeanUtil.getBean("sysAttMainService");
	String appFlag="";
	String[] extendArr=(new PdaRowsPerPageConfig()).getFdExtendsUrl();
	if(PdaFlagUtil.checkClientIsPdaApp(request))
		appFlag="&isAppflag=1";
	String prefix = PdaFlagUtil.getUrlPrefix(request);
	
	Page queryPage= (Page)request.getAttribute("queryPage");
	JSONObject viewObj=new JSONObject();
	int docCount=queryPage.getTotalrows();
	if(docCount==0){
		//解决 在iphone客户端中，点击新闻，文档为空时，会弹框提示 “温馨提示 很抱歉，未找到相应的记录”问题
		//viewObj.accumulate("errorPage","true");									//错误标识
		//viewObj.accumulate("message",ResourceUtil.getString("return.noRecord"));  //错误信息
	}else{
		viewObj.accumulate("pageCount",queryPage.getTotal());//所有页数
		viewObj.accumulate("pageno",queryPage.getPageno());  //当前页码
		viewObj.accumulate("count",docCount);                //文档总数
		if(queryPage.getEnd()<docCount-1)
			viewObj.accumulate("nextPageStart",queryPage.getEnd()+1); //下页开始数
		JSONArray docArr=new JSONArray();
		for(Object newsObj:queryPage.getList()){
			JSONObject news=new JSONObject();
			SysNewsMain sysNews=(SysNewsMain)newsObj;
			news.accumulate("subject",sysNews.getDocSubject());				//主题
			news.accumulate("summary",sysNews.getDocCreator().getFdName()+" "+ //概要信息
					DateUtil.convertDateToString(sysNews.getDocCreateTime(),DateUtil.PATTERN_DATETIME));
			List list=sysAttMainCoreInnerService.findByModelKey(sysNews.getClass().getName(),
					sysNews.getFdId(),"Attachment");
			if(list!=null && list.size()>0){
				SysAttMain att=(SysAttMain)list.get(0);
				news.accumulate("picUrl",ModelUtil.getModelUrl(att)+ "&fileName=" +att.getFdFileName());
			}
			if(sysNews.getFdIsLink()!=null && true==sysNews.getFdIsLink()){
				String linkUrl=sysNews.getFdLinkUrl();
				boolean isLink=false;
				if(linkUrl.startsWith("/")){					//系统内链接新闻
					String modelName=sysNews.getFdModelName();
					if(StringUtil.isNotNull(modelName)&& map.get(modelName)!=null)
						isLink=true;
					else
						isLink=false;
				}else{											//系统外新闻
					if(extendArr!=null){
						for(int i=0;i<extendArr.length;i++){
							if(StringUtil.isNotNull(extendArr[i]) && linkUrl.toLowerCase().indexOf(extendArr[i].toLowerCase())>-1){
								isLink=true;
								break;
							}
						}
					}else
						isLink=false;
				}
				if(isLink){
					news.accumulate("url",linkUrl + (StringUtil.isNull(appFlag)?"":appFlag));
					//为兼容功能区配置分类列表接口
					news.accumulate("type","doc");
				}else{
					news.accumulate("url","");
					JSONArray iCons=new JSONArray();
					iCons.element("lock.png");
					news.accumulate("icons",iCons);
					//为兼容功能区配置分类列表接口
					news.accumulate("type","doc");
				}
			}else {
				news.accumulate("url",prefix + ModelUtil.getModelUrl(sysNews).substring(1)+(StringUtil.isNull(appFlag)?"":appFlag));
				//为兼容功能区配置分类列表接口
				news.accumulate("type","doc");
			}
			docArr.element(news);
		}
		viewObj.accumulate("docs",docArr);
	}
	pageContext.setAttribute("viewObj",viewObj.toString());
%>
${viewObj}
