<%@page import="com.landray.kmss.sys.ui.xml.model.*"%>
<%@page import="java.util.*"%>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
String formatId = request.getParameter("fdId");
SysUiFormat format = SysUiPluginUtil.getFormatById(formatId);
List<SysUiSource> sourceList = SysUiPluginUtil.getSourceByFormat(null,formatId);
List<SysUiRender> renderList = SysUiPluginUtil.getRenderByFormat(null,formatId);
request.setAttribute("sourceList",sourceList);
request.setAttribute("renderList",renderList);
request.setAttribute("format",format);
%>
<template:include ref="default.simple">
	<template:replace name="head">
		<template:super />
		<link href="${LUI_ContextPath}/resource/style/default/doc/document.css" rel="stylesheet" type="text/css" />
		<title>数据格式：${format.fdName}</title>
		<style>
			body{background-color: #F9F9F9;}
		</style>
	</template:replace>
	<template:replace name="body">
		<div style="margin:10px 0px 0px 30px;">
			当前路径：部件类型 >>
			<a href="${LUI_ContextPath}/sys/ui/help/dataview/index.jsp?fdId=dataview" target="_self">数据视图</a> >>
			${ format.fdName }
		</div>
		<p class="txttitle">${ format.fdName }（${ format.fdId }）</p>
		<center><div style="width:95%;text-align:left;">
		<ui:accordionpanel toggle="true">
			<ui:content title="数据呈现">
				<table class="tb_normal" width="100%">
					<tr class="tr_normal_title" height="30px">
						 <td width="5%">序号</td>
						 <td width="20%">ID</td>
						 <td width="20%">名称</td>
						 <td width="5%">场景</td>
						 <td width="30%">代码路径</td>
						 <td width="20%">缩略图</td>
					</tr>
					<c:forEach items="${renderList}" var="render" varStatus="vstatus">
						<tr style="cursor:pointer" height="30px"
							onclick="window.open('${LUI_ContextPath}${(empty render.fdHelp) ? "/sys/ui/help/dataview/render-help.jsp" : render.fdHelp}?fdId=${ render.fdId }&formatName='+encodeURIComponent('${format.fdName}'),'_self');"
							onmouseover="this.style.backgroundColor='#F6F6F6';"
							onmouseout="this.style.backgroundColor='#FFFFFF';">
							<td><center>${vstatus.index+1}</center></td>
							<td>${ render.fdId }</td>
							<td>${ render.fdName }</td>
							<td>${ render.fdFor }</td>
						 	<td>${ render.fdBody.src }</td>
							<td>
								<c:if test="${empty render.fdThumb}">
									无
								</c:if>
								<c:if test="${not empty render.fdThumb}">
									<div style="display:inline-block">
										<img src="${LUI_ContextPath}${render.fdThumb}" style="max-height: 50px;">
										<ui:popup>
											<img src="${LUI_ContextPath}${render.fdThumb}">
										</ui:popup>
									</div>
								</c:if>
							</td>
						</tr>
					</c:forEach>
				</table>
			</ui:content>
			<ui:content title="数据格式">
				<table width="100%" class="tb_normal">
					<tr>
						<td class="td_normal_title" width="15%">描述</td>
						<td>
							<c:out value="${ format.fdDescription }" />
						</td>
					</tr>
					<tr>
						<td class="td_normal_title">使用说明</td>
						<td>
							<c:if test="${ not empty format.fdHelp }">
								<c:import url="${ format.fdHelp }"/>
							</c:if>
						</td>
					</tr>
					<tr>
						<td class="td_normal_title">数据样例</td>
						<td>
							<c:if test="${ not empty format.fdExample }">
								<a href="${LUI_ContextPath}${format.fdExample}" target="_blank">
									${format.fdExample}
								</a>
							</c:if>
						</td>
					</tr>
				</table>
			</ui:content>
			<ui:content title="数据抓取" expand="false">
				<table class="tb_normal" width="100%">
					<tr class="tr_normal_title" height="30px">
						<td width="5%">序号</td>
						<td width="20%">ID</td>
						<td width="20%">名称</td>
						<td width="5%">场景</td>
						<td width="20%">类型</td>
						<td width="25%">内容</td>
					</tr>
					<c:forEach items="${sourceList}" var="source" varStatus="vstatus">
					<!-- onclick="window.open('${LUI_ContextPath}${source.fdHelp}?fdId=${ source.fdId }','_blank');" -->
						<tr height="30px"
							onmouseover="this.style.backgroundColor='#F6F6F6';"
							onmouseout="this.style.backgroundColor='#FFFFFF';">
							<td><center>${vstatus.index+1}</center></td>
							<td>${ source.fdId }</td>
							<td>${ source.fdName }</td> 
							<td>${ source.fdFor }</td> 
							<td>${ source.fdType }</td> 
							<td>
								<div style="padding:5px; display:inline-block;">
									鼠标放这里显示参数
									<ui:popup>
										<c:out value="${ empty source.fdBody.body ? source.fdBody.src : source.fdBody.body }" />
									</ui:popup>
								</div>
							</td>
						</tr>
					</c:forEach>
				</table> 
			</ui:content>
		</ui:accordionpanel>
		</div></center>
	</template:replace>
</template:include>