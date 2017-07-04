<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.sys.attachment.model.SysAttMain"%>
<%@page import="com.landray.kmss.sys.attachment.util.SysAttViewerUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<c:set var="_fdKey" value="${param.fdKey}" />

<c:if test="${param.formName!=null && param.formName!=''}">
	<c:set var="_formBean" value="${requestScope[param.formName]}" />
	<c:set var="attForms" value="${_formBean.attachmentForms[_fdKey]}" />
</c:if>

<c:set var="_fdModelName" value="${param.fdModelName}" />
<c:if test="${_fdModelName==null || _fdModelName == ''}">
	<c:if test="${_formBean!=null}">
		<c:set var="_fdModelName" value="${_formBean.modelClass.name}" />
	</c:if>
</c:if>

<c:set var="_fdModelId" value="${param.fdModelId}" />
<c:if test="${_fdModelId==null || _fdModelId == ''}">
	<c:if test="${_formBean!=null}">
		<c:set var="_fdModelId" value="${_formBean.fdId}" />
	</c:if>
</c:if>

<c:set var="_fdMulti" value="false" />
<c:if test="${param.fdMulti!=null}">
	<c:set var="_fdMulti" value="${param.fdMulti}" />
</c:if>

<%-- fdAttType: byte/pic--%>
<c:set var="_fdAttType" value="byte" />
<c:if test="${param.fdAttType!=null}">
	<c:set var="_fdAttType" value="${param.fdAttType}" />
</c:if>

<%-- fdViewType: normal/simple--%>
<c:set var="_fdViewType" value="normal"></c:set>
<c:if test="${param.fdViewType!=null}">
	<c:set var="_fdViewType" value="${param.fdViewType}" />
</c:if>

<c:if test="${attForms!=null && fn:length(attForms.attachments)>0}">
	<div class="muiAttachments muiAttachments${_fdViewType}">
		<c:if test="${_fdViewType=='normal' }">
			<div data-dojo-type="sys/attachment/mobile/js/AttachmentViewListItem"
				data-dojo-props="name:'附件：共${fn:length(attForms.attachments)}个',viewType:'${_fdViewType}',icon:'mui mui-attach'"
				class="muiAttTitle"></div>
		</c:if>
		<div data-dojo-type="sys/attachment/mobile/js/AttachmentList"
			data-dojo-props="fdKey:'${_fdKey}',fdModelName:'${_fdModelName}',fdModelId:'${_fdModelId}',viewType:'${_fdViewType}',editMode:'view'">
			<c:forEach var="sysAttMain" items="${attForms.attachments}"
				varStatus="vsStatus">
				<c:if test="${sysAttMain.fdAttType=='pic'}">
					<div
						data-dojo-type="sys/attachment/mobile/js/AttachmentViewPicItem"
						data-dojo-props="name:'${sysAttMain.fdFileName}',
							size:'${sysAttMain.fdSize}',
							icon:'/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${sysAttMain.fdId}'">
					</div>
				</c:if>

				<c:set value="false" var="canDownload"></c:set>
				<!-- 下载权限 -->
				<kmss:auth
					requestURL="/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${sysAttMain.fdId}"
					requestMethod="GET">
					<c:set value="true" var="canDownload"></c:set>
				</kmss:auth>

				<c:set value="true" var="canRead"></c:set>
				<!-- 下载权限 -->
				<kmss:auth
					requestURL="/sys/attachment/sys_att_main/sysAttMain.do?method=read&fdId=${sysAttMain.fdId}"
					requestMethod="GET">
					<c:set value="true" var="canRead"></c:set>
				</kmss:auth>


				<c:if test="${sysAttMain.fdAttType!='pic'}">
					<c:set var="downLoadUrl"
						value="/sys/attachment/sys_att_main/sysAttMain.do?method=download&fdId=${sysAttMain.fdId}" />
					<c:if test="${_downLoadNoRight==true || _downLoadNoRight=='true'}">
						<c:set var="downLoadUrl"
							value="/third/pda/attdownload.jsp?fdId=${sysAttMain.fdId}" />
					</c:if>
					<%
						SysAttMain sysAttMain = (SysAttMain) pageContext
											.getAttribute("sysAttMain");
									String path = SysAttViewerUtil.getViewerPath(
											sysAttMain, request);
									Boolean hasViewer = Boolean.FALSE;
									if (StringUtil.isNotNull(path))
										hasViewer = Boolean.TRUE;
									pageContext.setAttribute("hasViewer", hasViewer);
					%>

					<div
						data-dojo-type="sys/attachment/mobile/js/AttachmentViewListItem"
						data-dojo-props="name:'${sysAttMain.fdFileName}',
							size:'${sysAttMain.fdSize}',
							href:'${downLoadUrl}',
							fdId:'${sysAttMain.fdId}',
							type:'${sysAttMain.fdContentType}',
							hasViewer:${hasViewer },
							canDownload:${canDownload},
							canRead:${canRead}">
					</div>
				</c:if>
			</c:forEach>
		</div>
	</div>
</c:if>
