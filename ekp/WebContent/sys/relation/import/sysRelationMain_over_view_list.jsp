<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.landray.kmss.sys.config.dict.SysDictModel"%>
<%@page import="com.landray.kmss.sys.config.dict.SysDataDict"%>
<%@page import="com.landray.kmss.common.service.IBaseService"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page import="org.apache.commons.beanutils.PropertyUtils"%>
<%@page import="com.landray.kmss.common.model.IBaseModel"%>
<%@page import="com.landray.kmss.sys.relation.model.SysRelationStaticNew"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>

<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>
<list:data>
	<list:data-columns var="item" list="${queryPage.list }">
		<list:data-column property="fdId">
		</list:data-column>
		
		<list:data-column col="fdSourceDocSubject" title="${lfn:message('sys-relation:relationOverView.source.doc2')}" escape="false">
			<%
				SysRelationStaticNew item = (SysRelationStaticNew)pageContext.getAttribute("item");
				if(item != null){
					String fdSourceId = item.getFdSourceId();
					String fdSourceModelName = item.getFdSourceModelName();
					String fdSourceDocSubject = item.getFdSourceDocSubject();
					
					String url = "";
					String showDocSubject = "";
					if(StringUtil.isNotNull(fdSourceId) && StringUtil.isNotNull(fdSourceModelName)){
						SysDataDict sysDataDict = SysDataDict.getInstance();
						String sourceUrl = sysDataDict.getModel(fdSourceModelName).getUrl();
						url = request.getContextPath() + 
										sourceUrl.substring(0,sourceUrl.indexOf("?")+1) + 
											StringUtil.setQueryParameter(sourceUrl.substring(
													sourceUrl.indexOf("?")+1),"fdId",fdSourceId);
						showDocSubject = "<a class='com_subject' href='" + 
													url + "' target='_blank'>" + 
													fdSourceDocSubject + "</a>";
					}else{
						showDocSubject = fdSourceDocSubject;
					}
					out.print(showDocSubject);
				}
			%>
		</list:data-column>
		
		<list:data-column col="fdRelatedDocSubject" title="${lfn:message('sys-relation:relationOverView.related.doc')}" escape="false">
			<%
				SysRelationStaticNew item = (SysRelationStaticNew)pageContext.getAttribute("item");
				if(item != null){
					String fdRelatedId = item.getFdRelatedId();
					String fdRelatedModelName = item.getFdRelatedModelName();
					String docSubject = "";
					String fdRelatedUrl = item.getFdRelatedUrl();
					String docPublishing = ResourceUtil.getString("relationOverView.doc.publishing","sys-relation");
					String recycle = ResourceUtil.getString("relationOverView.doc.recycle","sys-relation");
					String hasDeleted = ResourceUtil.getString("relationOverView.doc.deleted","sys-relation");
					String showStatus = docPublishing;
					
					Boolean isDeleted = false;
					docSubject = item.getFdRelatedName();
					if(StringUtil.isNull(fdRelatedId) || StringUtil.isNull(fdRelatedModelName)){
						showStatus = "";
					}else{
						SysDictModel docModel = SysDataDict.getInstance().getModel(fdRelatedModelName);
						IBaseService docService = (IBaseService) SpringBeanUtil.getBean(docModel.getServiceBean());
						IBaseModel baseModel = (IBaseModel)docService.findByPrimaryKey(fdRelatedId,null, true);
						if(baseModel != null){
							if(PropertyUtils.isReadable(baseModel, "docStatus")){
								String docStatus = (String)PropertyUtils
														.getProperty(baseModel,"docStatus");
								if("50".equals(docStatus)){
									showStatus = recycle;
								}else{
									showStatus = docPublishing;
								}
							}
						}else{
							fdRelatedUrl = "";
							showStatus = hasDeleted;
							isDeleted = true;
						}
					}
					String showDocSubject = "";
					if(isDeleted){
						showDocSubject = "<span>" + showStatus + 
												"<span class='com_subject'>" + 
													docSubject + "</span></span>";
					}else{
						if(StringUtil.isNotNull(fdRelatedUrl) 
								&& "/".equals(fdRelatedUrl.substring(0,1))){
							fdRelatedUrl = request.getContextPath() + fdRelatedUrl;
						}
						showDocSubject = "<a class='com_subject' href='" + fdRelatedUrl + 
											"' target='_blank'>" + 
												showStatus + docSubject + "</a>";
					}
					out.print(showDocSubject);
				}
			%>
		</list:data-column>
		
		<list:data-column col="fdRelatedType" title="${lfn:message('sys-relation:relationOverView.relationship')}" escape="false">
			${item.fdRelatedType == 0?"单向":"双向" }
		</list:data-column>
	</list:data-columns>

	<list:data-paging page="${queryPage }">
	</list:data-paging>
</list:data>