<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.util.*"%>
<%@page import="com.landray.kmss.sys.relation.util.SysRelationUtil"%>
<%@page import="org.apache.commons.beanutils.PropertyUtils"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="com.landray.kmss.sys.relation.interfaces.SearchResultEntry"%>
<%@page import="com.landray.kmss.sys.ftsearch.search.LksHit"%>
<%@page import="java.util.*"%>
<%@page import="com.landray.kmss.sys.ftsearch.config.LksField"%>
<%@page import="com.sunbor.web.tag.Page"%>
<%@page import="com.landray.kmss.common.model.BaseModel"%>
<%
	List queryList= ((Page) request.getAttribute("queryPage")).getList();
	JSONArray rtnJsonArr = new JSONArray();
	for(int i=0; i<queryList.size(); i++){
		Object resultModel = queryList.get(i);
		String docSubject = "";
		String linkUrl = "";
		Date date = null;
		String docCreateTime = "";
		String docCreatorName = "";
		String docCreateInfo = "";
		if (resultModel instanceof BaseModel) {		//精确搜索
			try {
				try {
					docSubject = (String) PropertyUtils.getProperty(resultModel, "docSubject");
				} catch (Exception e){
					docSubject = "";
				}
				if (StringUtil.isNotNull(ModelUtil.getModelUrl(resultModel))) {
					linkUrl = ModelUtil.getModelUrl(resultModel);
				}
				try {
					date = (Date) PropertyUtils.getProperty(resultModel, "docCreateTime");
				} catch (Exception e) {
					date = null;
				}
				if (date != null) {
					docCreateTime = DateUtil.convertDateToString(date, ResourceUtil
							.getString("date.format.date"));
				}
				try {
					docCreatorName = (String) PropertyUtils.getProperty(resultModel, "docCreator.fdName");
				} catch (Exception e) {
					docCreatorName = "";
				}
			} catch (Exception e){
			}
		}else if (resultModel instanceof String[]) { //静态页面
			String[] urlArr = (String[])resultModel;
			if (urlArr.length > 0 && StringUtil.isNotNull(urlArr[0])) {
				docSubject = urlArr[0];
				if (urlArr.length > 1 && StringUtil.isNotNull(urlArr[1])) {
					linkUrl = urlArr[1];
				} else {
					linkUrl = urlArr[0];
				}
			}
		}else if (resultModel instanceof LksHit) { //全文检索
			LksHit lksHit = (LksHit)resultModel;
			if (lksHit != null) {
				Map lksFieldsMap = lksHit.getLksFieldsMap();
				if (lksFieldsMap != null && !lksFieldsMap.isEmpty()) {
					LksField subject = (LksField)lksFieldsMap.get("subject");
					LksField title = (LksField)lksFieldsMap.get("title");
					LksField fileName = (LksField)lksFieldsMap.get("fileName");
					if (subject != null) {
						docSubject = subject.getValue();
					} else if (title != null) {
						docSubject = title.getValue();
					} else if (fileName != null) {
						docSubject = fileName.getValue();
					}
					LksField link = (LksField)lksFieldsMap.get("linkStr");
					if (link != null) {
						linkUrl = link.getValue();
					}
					LksField createTime = (LksField)lksFieldsMap.get("createTime");
					if (createTime != null) {
						docCreateTime = createTime.getValue();
					}
					LksField creator = (LksField)lksFieldsMap.get("creator");
					if (creator != null) {
						docCreatorName = creator.getValue();
					}
					
					// 去掉样式
					if (StringUtil.	isNotNull(docSubject)) {
						docSubject = SysRelationUtil.replaceStrongStyle(docSubject);
					}
					if (StringUtil.isNotNull(docCreateTime)) {
						docCreateTime = SysRelationUtil.replaceStrongStyle(docCreateTime);
					}
					if (StringUtil.isNotNull(docCreatorName)) {
						docCreatorName = SysRelationUtil.replaceStrongStyle(docCreatorName);
					}
				}
			}
		} else if (resultModel instanceof SearchResultEntry) { //外部扩展
			SearchResultEntry searchModel = (SearchResultEntry)resultModel;
			if (searchModel != null) {
				docSubject = searchModel.getDocSubject();
				linkUrl = searchModel.getLinkUrl();
				if (searchModel.getDocCreateTime() != null) {
					docCreateTime = DateUtil.convertDateToString(searchModel.getDocCreateTime(),ResourceUtil
							.getString("date.format.date"));
				}
				docCreatorName = searchModel.getDocCreatorName();
			}
		}
		JSONObject tmpObject = new JSONObject();
		if(docSubject != null){
			tmpObject.accumulate("text",docSubject.trim());
		}else{
			tmpObject.accumulate("text","");
		}
		if(linkUrl != null){
			tmpObject.accumulate("href",linkUrl.trim());
		}else{
			tmpObject.accumulate("href","");
		}
		if (StringUtil.isNotNull(docCreateTime)){
			tmpObject.accumulate("created",docCreateTime);
		}
		if (StringUtil.isNotNull(docCreatorName)){
			tmpObject.accumulate("creator",docCreatorName);
		}
		rtnJsonArr.element(tmpObject);
	}
	out.print(rtnJsonArr.toString());
%>
