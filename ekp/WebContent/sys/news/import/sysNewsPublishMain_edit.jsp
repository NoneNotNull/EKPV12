<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="sysNewsPublishMainForm" value="${requestScope[param.formName].sysNewsPublishMainForm}" />
<script language="JavaScript">
	//清除分类
	function SNP_clearCategory(){
		document.getElementsByName("sysNewsPublishMainForm.fdCategoryId")[0].value="";
		document.getElementsByName("sysNewsPublishMainForm.fdCategoryName")[0].value="";
  }
</script>
	 <html:hidden property="sysNewsPublishMainForm.fdId"/> 
	 <html:hidden property="sysNewsPublishMainForm.fdModelName"/>
	 <html:hidden property="sysNewsPublishMainForm.fdModelId"/> 
	 <html:hidden property="sysNewsPublishMainForm.fdKey" value="${param.fdKey}"/>	
<c:if test="${not empty param.isShow&&param.isShow}"><%--是否显示自动发布的编辑--%>
<%---有分类的发布--%>
	<c:if test="${sysNewsPublishMainForm.fdIsAutoPublish}">	
		<html:hidden property="sysNewsPublishMainForm.fdIsModifyCate" value="${sysNewsPublishMainForm.fdIsModifyCate}"/> 
		<html:hidden property="sysNewsPublishMainForm.fdIsModifyImpor" value="${sysNewsPublishMainForm.fdIsModifyImpor}"/> 
		<ui:content title="${lfn:message('sys-news:sysNewsPublishMain.tab.publish.label')}">
		<table class="tb_normal" width=100%>
		<tr>
			<td class="td_normal_title" width=15%><%--审批通过自动发布到新闻--%>
				<bean:message  bundle="sys-news" key="sysNewsPublishCategory.fdIsAutoPublish"/>
			</td>
			<td width=85%  >
			 <html:hidden property="sysNewsPublishMainForm.fdIsAutoPublish" value="${sysNewsPublishMainForm.fdIsAutoPublish}"/> 
				<sunbor:enumsShow value="${sysNewsPublishMainForm.fdIsAutoPublish}" enumsType="common_yesno" />	 
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><%--需要经过新闻审批 --%>
				<bean:message  bundle="sys-news" key="sysNewsPublishCategory.fdIsFlow"/>
			</td>
			<td width=35% colspan=3>
			  <html:hidden property="sysNewsPublishMainForm.fdIsFlow" value="${sysNewsPublishMainForm.fdIsFlow}"/> 
				<sunbor:enumsShow value="${sysNewsPublishMainForm.fdIsFlow}" enumsType="common_yesno" />	 
			</td>
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><%--新闻发布类别 --%>
				<bean:message  bundle="sys-news" key="sysNewsPublishCategory.fdCategoryId"/>
			</td>
			<td width=85%>
				<html:hidden property="sysNewsPublishMainForm.fdCategoryId"/> 
				<c:if test="${sysNewsPublishMainForm.fdIsModifyCate}">
						<div class="inputselectsgl"  style="width:40%">
							<div class="input">
								<html:text property="sysNewsPublishMainForm.fdCategoryName" readonly="true" styleClass="" onclick="Dialog_SimpleCategoryForNewFile('com.landray.kmss.sys.news.model.SysNewsTemplate','sysNewsPublishMainForm.fdCategoryId::sysNewsPublishMainForm.fdCategoryName',false,true,null);"/> 		
							</div>
							<div class="selectitem" id="tag_selectItem" onclick="Dialog_SimpleCategoryForNewFile('com.landray.kmss.sys.news.model.SysNewsTemplate','sysNewsPublishMainForm.fdCategoryId::sysNewsPublishMainForm.fdCategoryName',false,true,null);">
							</div>
						</div>
			     	<a href="javascript:void(0)"  onclick="SNP_clearCategory()"/><span style="color: #57c0ef"><bean:message  bundle="sys-news" key="sysNewsPublishCategory.clearCategory"/></span></a>
				</c:if>
				<c:if test="${!sysNewsPublishMainForm.fdIsModifyCate}">
					${sysNewsPublishMainForm.fdCategoryName}
					<html:hidden property="sysNewsPublishMainForm.fdCategoryName"/>
				</c:if> 
				<c:if test="${empty sysNewsPublishMainForm.fdCategoryName}">					 
					<span class="com_help"><bean:message  bundle="sys-news" key="sysNewsPublishMain.fdCategoryNameIsEmpty"/></span>
				</c:if>		
			</td> 
		</tr>
		<tr>
			<td class="td_normal_title" width=15%><%--新闻发布重要度  --%>
				<bean:message  bundle="sys-news" key="sysNewsPublishCategory.fdImportance"/>
			</td>
			<td width=85%>
			<c:if test="${sysNewsPublishMainForm.fdIsModifyImpor}">
				<sunbor:enums  property="sysNewsPublishMainForm.fdImportance" elementType="radio"  enumsType="sysNewsMain_fdImportance" bundle="sys-news"/>
			</c:if>
			<c:if test="${! sysNewsPublishMainForm.fdIsModifyImpor}">
				<html:hidden property="sysNewsPublishMainForm.fdImportance" value="${sysNewsPublishMainForm.fdImportance}"/>
				<sunbor:enumsShow value="${sysNewsPublishMainForm.fdImportance}"  enumsType="sysNewsMain_fdImportance" bundle="sys-news" />
			</c:if>
			</td> 
		</tr> 
	</table>
	</ui:content>
	</c:if>
	<%---没有分类的部署--%>
	<c:if test="${sysNewsPublishMainForm.fdIsAutoPublish==null}">
	<html:hidden property="sysNewsPublishMainForm.fdIsModifyCate" value="false"/> 
	<html:hidden property="sysNewsPublishMainForm.fdIsModifyImpor" value="false"/> 
		<ui:content title="${lfn:message('sys-news:sysNewsPublishMain.tab.publish.label')}">
			<table class="tb_normal" width=100%>
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="sys-news" key="sysNewsPublishCategory.fdIsAutoPublish"/>
				</td>
				<td width=85%  ><%--是否自动发布---%>
				<sunbor:enums  property="sysNewsPublishMainForm.fdIsAutoPublish" elementType="radio"  enumsType="common_yesno" />
				</td>
			</tr>
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="sys-news" key="sysNewsPublishCategory.fdIsFlow"/>
				</td>
				<td width=35% colspan=3><%--是否走流程---%>
					<sunbor:enums  property="sysNewsPublishMainForm.fdIsFlow" elementType="radio"  enumsType="common_yesno" />
				 </td>
			</tr>
			<tr>
				<td class="td_normal_title" width=15%>
					<bean:message  bundle="sys-news" key="sysNewsPublishCategory.fdCategoryId"/>
				</td>
				<td width=85%><%--新闻发布类别 --%>
					<html:hidden property="sysNewsPublishMainForm.fdCategoryId"/>  
				   	<div class="inputselectsgl"  style="width:40%">
							<div class="input">
								<html:text property="sysNewsPublishMainForm.fdCategoryName" readonly="true" styleClass="" onclick="Dialog_SimpleCategoryForNewFile('com.landray.kmss.sys.news.model.SysNewsTemplate','sysNewsPublishMainForm.fdCategoryId::sysNewsPublishMainForm.fdCategoryName',false,true,null);"/> 		
							</div>
							<div class="selectitem" id="tag_selectItem" onclick="Dialog_SimpleCategoryForNewFile('com.landray.kmss.sys.news.model.SysNewsTemplate','sysNewsPublishMainForm.fdCategoryId::sysNewsPublishMainForm.fdCategoryName',false,true,null);">
							</div>
						</div>
			     	<a href="javascript:void(0)"  onclick="SNP_clearCategory()"/><span class="com_btn_link"><bean:message  bundle="sys-news" key="sysNewsPublishCategory.clearCategory"/></span></a>
					<span class="com_help"><bean:message  bundle="sys-news" key="sysNewsPublishMain.fdCategoryNameIsEmpty"/></span>
				</td> 
			</tr>
			<tr>
				<td class="td_normal_title" width=15%><%--新闻发布重要度  --%>
					<bean:message  bundle="sys-news" key="sysNewsPublishCategory.fdImportance"/>
				</td>
				<td width=85%> 		
					<sunbor:enums  property="sysNewsPublishMainForm.fdImportance" elementType="radio"  enumsType="sysNewsMain_fdImportance" bundle="sys-news"/>
				 </td> 
			</tr> 
		</table>
	</ui:content>
	</c:if>
</c:if>
