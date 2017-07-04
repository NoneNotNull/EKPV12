<%@ page language="java" contentType="text/json; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.sunbor.web.tag.Page"%>
<%@page import="java.util.List"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.landray.kmss.sys.organization.service.ISysOrgElementService"%>
<%@page import="com.landray.kmss.kms.multidoc.service.IKmsMultidocKnowledgeService"%>
<%@page import="com.landray.kmss.sys.organization.model.SysOrgElement"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page import="com.landray.kmss.kms.knowledge.util.KmsKnowledgeUtil"%>
<%@page import="com.landray.kmss.util.StringUtil"%>

<%
	Page attPage = (Page) request.getAttribute("attPage");
	JSONObject attCreatorJson = new JSONObject();
	JSONObject attFileSize = new JSONObject();
	ISysOrgElementService sysOrgElementService = (ISysOrgElementService) SpringBeanUtil
			.getBean("sysOrgElementService");
	SysOrgElement deptOrg = null;
	IKmsMultidocKnowledgeService kmsMultidocKnowledgeService = (IKmsMultidocKnowledgeService) SpringBeanUtil
			.getBean("kmsMultidocKnowledgeService");

	String attCreator = "";
	String fileSize = "";
	if (attPage != null) {
		List<Object[]> obj = attPage.getList();
		for (Object[] attList : obj) {
			if (StringUtil.isNotNull((String) attList[1])) {
				deptOrg = (SysOrgElement) sysOrgElementService
						.findByPrimaryKey((String) attList[1]);
				attCreator = deptOrg.getFdName();
			}

			attCreatorJson.element((String) attList[0], attCreator);
			fileSize = KmsKnowledgeUtil.format(attList[2].toString());
			attFileSize.element((String) attList[0], fileSize);
		}
	}
	request.setAttribute("attCreatorJson", attCreatorJson);
	request.setAttribute("attFileSize", attFileSize);
%>

<list:data>
	<list:data-columns var="item" list="${attPage.list }">
		<list:data-column col="fdId">
			${item[5]}
		</list:data-column>
		<list:data-column col="attName" title="${lfn:message('kms-multidoc:kmsMultidoc.attName')}">
			${item[4]}
		</list:data-column>
		<list:data-column col="attCreator" title="${lfn:message('kms-multidoc:kmsMultidoc.uploader')}" escape="false">
			<ui:person personId="${item[1]}" personName="${attCreatorJson[item[0]]}"></ui:person>
		</list:data-column>
		<list:data-column col="attSize" title="${lfn:message('kms-multidoc:kmsMultidoc.attSize')}">
			${attFileSize[item[0]]}
		</list:data-column>
		<list:data-column col="uploadTime" title="${lfn:message('kms-multidoc:kmsMultidoc.uploadTime')}">
			<kmss:showDate value="${item[3]}" type="date" />
		</list:data-column>
		<list:data-column col="docSubject" title="${lfn:message('kms-multidoc:kmsMultidoc.docSubject')}">
			${item[6]}
		</list:data-column>
	</list:data-columns>

	<list:data-paging page="${attPage }">
	</list:data-paging>
</list:data>
