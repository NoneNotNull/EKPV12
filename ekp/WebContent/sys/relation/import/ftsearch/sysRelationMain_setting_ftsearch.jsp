<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.landray.kmss.sys.ftsearch.db.service.ISysFtsearchConfigService"%>
<%@page import="com.landray.kmss.common.actions.RequestContext"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page import="java.util.List"%>

<template:include ref="default.dialog">
	<template:replace name="content"> 
	<script type="text/javascript" >
		Com_IncludeFile("validator.jsp|validation.jsp|validation.js|plugin.js|jquery.js|dialog.js|calendar.js", null, "js");
		Com_IncludeFile("rela_ftsearch.js","${KMSS_Parameter_ContextPath}sys/relation/import/resource/","js",true);
	</script>
	<script type="text/javascript">
		var rela_tmpId ='<%=com.landray.kmss.util.IDGenerator.generateID()%>';
		var rela_ftsearch_cfg = {
				'varName':'rela_opt',
				'tempId':rela_tmpId,
				'keyword.null':'<bean:message key="errors.required" argKey0="sys-relation:sysRelationEntry.fdKeyword" />',
				'keyword.error':'<bean:message key="errors.maxLength" argKey0="sys-relation:sysRelationEntry.fdKeyword" arg1="200" />',
				'createTime.validate':'<bean:message bundle="sys-relation" key="validate.dateTimeCompare" />',
				'scope.null':'<bean:message key="errors.required" argKey0="sys-relation:sysRelationEntry.fdSearchScope" />',
				'scope.error':'<bean:message bundle="sys-relation" key="sysRelationEntry.ftsearch.searchScope.tooLong" />',
				'fdModuleName.isNull':"<bean:message bundle="sys-relation" key="sysRelationMain.fdModuleName.isNull"/>"
		};
		new RelationFtSearchSetting(rela_ftsearch_cfg);
	</script>
	<div class="rela_config_subset">
		<input type="hidden" name="fdModuleModelName">
		<table class="tb_simple" style="width:100%">
			<tr><td width="20%"><bean:message bundle="sys-relation" key="sysRelationMain.relation.name"/>
			</td><td>
				<xform:text property="fdModuleName" required="true" showStatus="edit" 
								subject="${lfn:message('sys-relation:sysRelationMain.relation.name') }" style="width:80%"></xform:text>
			</td></tr>
			<tr><td><bean:message bundle="sys-ftsearch-db" key="search.search.keyword"/>
			</td><td>
				<xform:text property="fdKeyWord" required="true" showStatus="edit" 
								subject="${lfn:message('sys-ftsearch-db:search.search.keyword') }" style="width:80%"></xform:text>
			</td></tr>
			<tr><td><bean:message bundle="sys-ftsearch-db" key="search.search.creator"/>
			</td><td>
				<xform:address propertyId="docCreatorId" 
					style="width:80%" propertyName="docCreatorName" showStatus="edit" orgType="ORG_TYPE_PERSON">
				</xform:address>
			</td></tr>
			<tr><td>
				<bean:message bundle="sys-ftsearch-db" key="search.search.createDate"/>
			</td><td>
				<bean:message bundle="sys-ftsearch-db" key="search.ftsearch.fromCreateTime"/>
				<xform:datetime property="fdFromCreateTime" dateTimeType="date" showStatus="edit" style="width:160px;"></xform:datetime>
				<bean:message bundle="sys-ftsearch-db" key="search.ftsearch.toCreateTime"/>
				<xform:datetime property="fdToCreateTime" dateTimeType="date" showStatus="edit" style="width:160px;"></xform:datetime>
				<nobr>
				<a href="javascript:void(0);" id="rela_clear">
					<bean:message bundle="sys-ftsearch-db" key="search.ftsearch.clearTime"/></a>
		   		</nobr>
			</td></tr>
		</table>
	</div>
	<div class="rela_config_subset">
		<table class="tb_noborder" style="width:100%">
			<tr><td class="rela_scope">
					<label class="rela_title">
						<bean:message bundle="sys-ftsearch-db" key="search.ftsearch.searchRange"/>
					</label>
					&nbsp;&nbsp;&nbsp;&nbsp;
					<span class="txtstrong">
						<label>
							<input type="checkbox" name="checkAll" >
							<bean:message bundle="sys-ftsearch-db" key="search.moduleSelect.selectAll"/>
						</label>
					</span>
			</td></tr>
			<tr><td>
				<%  
					ISysFtsearchConfigService sysFtsearchConfigService = (ISysFtsearchConfigService)SpringBeanUtil.getBean("sysFtsearchConfigService");
					List<?> entriesDesign = sysFtsearchConfigService.getListSearch(new RequestContext(request));
					pageContext.setAttribute("entriesDesign",entriesDesign);
					pageContext.setAttribute("entriesDesignCount",entriesDesign.size());
				%>
				<table style="width:100%" class="tb_simple">
					<tr>
				  		<c:forEach items="${entriesDesign}" var="element" varStatus="status">
					  		<td style="border: 0" width="25%">
					  			<label>
									<input type="checkbox" name="fdSearchScope" value="${element['modelName']}" /> 
											${element['title']}
								</label> 
							</td>
							<c:if test="${(status.index+1) mod 4 eq 0}">
								</tr>
								<c:if test="${!(status.last)}">
									<tr>
								</c:if>
							</c:if>
						</c:forEach>
						<c:if test="${entriesDesignCount mod 4 ne 0}">
							<c:if test="${entriesDesignCount mod 4 eq 1}">
								<td width="25%"></td>
								<td width="25%"></td>
								<td width="25%"></td>
							</c:if>
							<c:if test="${entriesDesignCount mod 4 eq 2}">
								<td width="25%"></td>
								<td width="25%"></td>
							</c:if>
							<c:if test="${entriesDesignCount mod 4 eq 3}">
								<td width="25%"></td>
							</c:if>
						</c:if>
					</tr>
				</table>
			</td></tr>
			<tr><td colspan="4" align="center" class="rela_scope_button">
				<ui:button text="${lfn:message('button.ok')}" id="rela_config_save"></ui:button>
				&nbsp;&nbsp;&nbsp;
				<ui:button styleClass="lui_toolbar_btn_gray" text="${lfn:message('button.cancel')}" id="rela_config_close"></ui:button>
			</td></tr>
		</table>
	</div>
	</template:replace>
</template:include>