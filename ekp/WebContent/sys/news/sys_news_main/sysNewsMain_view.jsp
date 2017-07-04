<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%--bookmark--%>
<c:import url="/sys/bookmark/include/bookmark_bar.jsp"
	charEncoding="UTF-8">
	<c:param name="fdSubject" value="${sysNewsMainForm.docSubject}" />
	<c:param name="fdModelId" value="${sysNewsMainForm.fdId}" />
	<c:param name="fdModelName"
		value="com.landray.kmss.sys.news.model.SysNewsMain" />
</c:import>
<script>
	function confirmDelete(msg){
		var del = confirm('<bean:message key="page.comfirmDelete"/>');
		return del;
	}
	Com_AddEventListener(window,'load',function(){  
		if(window.resizeContentFrame){
			setTimeout("window.resizeContentFrame();",200);
		}
	});
</script>
<kmss:windowTitle
	subject="${sysNewsMainForm.docSubject}"
	moduleKey="sys-news:news.moduleName" />
<div id="optBarDiv">
	
	<c:if test="${sysNewsMainForm.docStatus=='30' }">
		<input type="button"
			value="<bean:message key="news.button.back" bundle="sys-news"/>"
			onclick="Com_OpenWindow('sysNewsMain.do?method=view&fdId=${param.fdId}','_self');" />
	</c:if>
	<c:if test="${sysNewsMainForm.docStatus!='00' }">
		<kmss:auth
			requestURL="/sys/news/sys_news_main/sysNewsMain.do?method=edit&fdId=${param.fdId}"
			requestMethod="GET">
			<input type="button" value="<bean:message key="button.edit"/>"
				onclick="Com_OpenWindow('sysNewsMain.do?method=edit&fdId=${param.fdId}','_self');">
		</kmss:auth>
	</c:if>
	<kmss:auth
		requestURL="/sys/news/sys_news_main/sysNewsMain.do?method=delete&fdId=${param.fdId}"
		requestMethod="GET">
		<input type="button" value="<bean:message key="button.delete"/>"
			onclick="if(!confirmDelete())return;Com_OpenWindow('sysNewsMain.do?method=delete&fdId=${param.fdId}','_self');">
	</kmss:auth>
	<input type="button" value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<p class="txttitle"><bean:message bundle="sys-news"
	key="table.sysNewsMain" /></p>
<center>
<table id="Label_Tabel" width=95%>
	<!--  主要内容 -->
	<tr
		LKS_LabelName="<bean:message bundle='sys-news' key='news.document.content'/>">
		<td>
			<table class="tb_normal" width=100%>
				<!-- 新闻主题 -->
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="sys-news" key="sysNewsMain.docSubject" /></td>
					<td colspan=3><bean:write name="sysNewsMainForm"
						property="docSubject" /></td>
				</tr>
			
				<!-- 关 键 字 -->
				<tr>
					<td class="td_normal_title" width=15%>
					<bean:message
						bundle="sys-news" key="sysNewsMain.fdNewsSource" />
					</td>
					<td width=35%>
						<bean:write name="sysNewsMainForm"
						property="fdNewsSource" />
					</td>
					<td class="td_normal_title" width=15% rowspan="2"><bean:message
						bundle="sys-news" key="sysNewsMain.fdMainPicture" /></td>
					<td width=35% rowspan="2">
						<c:import
							url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
							charEncoding="UTF-8">
							<c:param name="fdKey" value="Attachment" />
							<c:param name="fdMulti" value="false" />
							<c:param name="fdAttType" value="pic" />
							<c:param name="fdShowMsg" value="false" />
							<c:param name="fdImgHtmlProperty" value="width=120" />
							<c:param name="formBeanName" value="sysNewsMainForm" />
							<c:param name="fdModelName"
								value="com.landray.kmss.sys.news.model.SysNewsMain" />
						</c:import>
					</td>
				</tr>
				<%--关键字去掉
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="sys-news" key="sysNews.docKeyword" /></td>
					<td width=35%><bean:write name="sysNewsMainForm"
						property="docKeywordNames" /></td>
				</tr>
				--%>
				
				<tr>
					<!-- 新闻重要度 -->
					<td class="td_normal_title" width=15%><bean:message
						bundle="sys-news" key="sysNewsTemplate.fdImportance" /></td>
					<td width=35%><sunbor:enumsShow value="${sysNewsMainForm.fdImportance}"
						enumsType="sysNewsMain_fdImportance" />
					</td>
				</tr>
				<!-- 标签机制 -->
			<c:import url="/sys/tag/include/sysTagMain_view.jsp"
				charEncoding="UTF-8">
				<c:param name="formName" value="sysNewsMainForm" />
				<c:param name="fdKey" value="newsMainDoc" /> 
			</c:import>
			<!-- 标签机制 -->
				<tr>
					<!-- 新闻模板 -->
					<td class="td_normal_title" width=15%><bean:message
						bundle="sys-news" key="sysNewsMain.fdTemplateId" /></td>
					<td width=35%>
						<c:out value="${sysNewsMainForm.fdTemplateName }" />
					</td>
					<td class="td_normal_title" width=15%><bean:message
						bundle="sys-news" key="sysNewsMain.docPublishTime" /></td>
					<td width=35%>
						<c:out value="${sysNewsMainForm.docPublishTime }" />
					</td>
				</tr>
				<!-- 录 入 者 -->
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="sys-news" key="sysNewsTemplate.docCreatorId" />
					</td>
					<td width=35%>
						<c:out value="${sysNewsMainForm.fdCreatorName }" />
					</td>
					<td class="td_normal_title" width=15%><bean:message
						bundle="sys-news" key="sysNewsMain.docCreateTime" /></td>
					<td width=35%>
						<c:out value="${sysNewsMainForm.docCreateTime }" />
					</td>
				</tr>
				<!-- 所属部门 -->
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="sys-news" key="sysNewsMain.fdAuthorId" /></td>
					<td width=35%>
						<c:out value="${sysNewsMainForm.fdAuthorName}" />
					</td>
					<td class="td_normal_title" width=15%><bean:message
						bundle="sys-news" key="sysNewsMain.fdDepartmentId" /></td>
					<td width=35%>
						<c:out value="${sysNewsMainForm.fdDepartmentName}" />
					</td>
				</tr>
				<tr>
					<td width="15" class="td_normal_title">
						<bean:message bundle="sys-news" key="sysNewsMain.fdDescription" />
					</td>
					<td width="85%" colspan="3">
						<kmss:showText value="${sysNewsMainForm.fdDescription}" />
					</td>
				</tr>
				<!-- 新闻内容 -->
				<tr>
					<td class="td_normal_title" width=15%><bean:message
						bundle="sys-news" key="sysNewsMain.docContent" /></td>
					<td colspan=3 valign="top" id="contentDiv">
						<c:choose>
						<c:when test="${not empty sysNewsMainForm.fdIsLink}">
							<bean:message bundle="sys-news" key="SysNewsMain.linkNews" />
							<a href='<c:url value="${sysNewsMainForm.fdLinkUrl}"/>'/>
								${sysNewsMainForm.docContent}
							</a>
						</c:when>
						<c:otherwise>
							<c:if test="${sysNewsMainForm.fdContentType=='rtf'}">
								${sysNewsMainForm.docContent}
							</c:if>
							<c:if test="${sysNewsMainForm.fdContentType=='word'}">
							<%if(com.landray.kmss.sys.attachment.util.JgWebOffice.isJGEnabled()){
								if (com.landray.kmss.sys.attachment.util.JgWebOffice.isExistFile(request)){%>
								<iframe id="IFrame_Content" src="<c:url value="/sys/attachment/sys_att_main/jg/sysAttMain_html_forward.jsp?fdId=${param.fdId}" />" width=100% height=100% frameborder=0 scrolling=no>
								</iframe>
								<script>
								  $(document).ready(function (){
									var frame = document.getElementById("IFrame_Content");
									//获取所有a元素
									var elems = frame.contentWindow.document.getElementsByTagName("a");
									for(var i = 0;i<elems.length;i++){
										elems[i].setAttribute("target","_top");
									}
								  });
									function resizeContentFrame(){
										try{
											var IFrame_Content = document.getElementById("IFrame_Content");
											var tmpHeight = (IFrame_Content.contentWindow.document.body.scrollHeight + 10 )+"px";
											document.getElementById("contentDiv").style.height = tmpHeight;
										}catch(e){}
									}
								</script>
							<%  }
								else{%>
									${sysNewsMainForm.fdHtmlContent}
								<% }
							  } else { %>
									${sysNewsMainForm.fdHtmlContent}
							<%} %>
							</c:if>
						</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<!-- 附件 -->
				<tr KMSS_RowType="documentNews">
					<td class="td_normal_title" width=15%><bean:message
						bundle="sys-news" key="sysNewsMain.attachment" /></td>
					<td colspan=3><c:import
						url="/sys/attachment/sys_att_main/sysAttMain_view.jsp"
						charEncoding="UTF-8">
						<c:param name="fdMulti" value="true" />
						<c:param name="formBeanName" value="sysNewsMainForm" />
						<c:param name="fdKey" value="fdAttachment" />
						<c:param name="fdModelName"
								value="com.landray.kmss.sys.news.model.SysNewsMain" />
					</c:import></td>
				</tr>
				<c:if test="${sysNewsMainForm.fdTopTime!=null}">
					<tr>
						<td class="td_normal_title" width=15%><bean:message
							bundle="sys-news" key="sysNewsMain.fdTopTime" /></td>
						<td colspan=3>
							<bean:message bundle="sys-news" key="sysNewsMain.fdTopTime.period"
								arg0="${sysNewsMainForm.fdTopTime}" arg1="${sysNewsMainForm.fdTopEndTime}"/>
						</td>
					</tr>
				</c:if>
			</table>
		</td>
	</tr>
	<!-- 权限 -->
	<tr LKS_LabelName="<bean:message bundle="sys-right" key="right.moduleName" />">
		<td>
		<table
			class="tb_normal"
			width=100%>
			<c:import
				url="/sys/right/right_view.jsp"
				charEncoding="UTF-8">
				<c:param
					name="formName"
					value="sysNewsMainForm" />
				<c:param
					name="moduleModelName"
					value="com.landray.kmss.sys.news.model.SysNewsMain" />
			</c:import>
		</table>
		</td>
	</tr>
	<!-- 相关新闻 -->
	<tr
		LKS_LabelName="<bean:message bundle='sys-news' key='news.document.relation'/>">
		<c:set var="mainModelForm" value="${sysNewsMainForm}" scope="request" />
		<c:set var="currModelName"
			value="com.landray.kmss.sys.news.model.SysNewsMain" scope="request" />
		<c:set var="moduleModelName"
			value="com.landray.kmss.sys.news.model.SysNewsMain" scope="request" />
		<td><%@ include
			file="/sys/relation/include/sysRelationMain_view.jsp"%></td>
	</tr>
	<!-- 流程 -->
	<%
		if (!UserUtil.getUser().isAnonymous()) {
	%>
	<!-- 以下代码为嵌入流程模板标签的代码 -->
	<c:import url="/sys/workflow/include/sysWfProcess_view.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="sysNewsMainForm" />
		<c:param name="fdKey" value="newsMainDoc" />
	</c:import>
	<!-- 以上代码为嵌入流程模板标签的代码 -->
	
	<%
		}
	%>
	<c:import url="/sys/evaluation/include/sysEvaluationMain_view.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="sysNewsMainForm" />
	</c:import>
	<!-- 阅读 -->
	<c:import
		url="/sys/readlog/include/sysReadLog_view.jsp"
		charEncoding="UTF-8">
		<c:param name="formName" value="sysNewsMainForm" />
	</c:import>
	<kmss:ifModuleExist path="/tools/datatransfer/">
		<c:import
			url="/tools/datatransfer/include/toolsDatatransfer_old_data.jsp"
			charEncoding="UTF-8">
			<c:param
				name="fdModelId"
				value="${sysNewsMainForm.fdId}" />
			<c:param
				name="fdModelName"
				value="com.landray.kmss.sys.news.model.SysNewsMain" />
		</c:import>
	</kmss:ifModuleExist>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
