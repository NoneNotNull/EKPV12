<%@page import="com.landray.kmss.sys.ui.xml.model.*"%>
<%@page import="java.util.*"%>
<%@page import="com.landray.kmss.sys.ui.plugin.SysUiPluginUtil"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%
String fdId = request.getParameter("fdId");
SysUiAssembly assembly = SysUiPluginUtil.getAssemblyById(fdId);
Iterator<SysUiLayout> layouts = SysUiPluginUtil.getLayouts().values().iterator();
List<SysUiLayout> list = new ArrayList<SysUiLayout>();
while(layouts.hasNext()){
	SysUiLayout layout = layouts.next();
	if(layout.getFdKind().equals(fdId)){
		list.add(layout);
	}
}
request.setAttribute("layoutList",list);
request.setAttribute("assembly",assembly);
%>
<!doctype html>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/sys/ui/jsp/jshead.jsp"%>
<script type="text/javascript">
seajs.use(['theme!form']);
</script>
<template:block name="head">
</template:block>
</head>
<body style="background-color: #F9F9F9;">
<template:block name="top">
	<div style="margin:10px 0px 0px 30px;">
	当前路径：部件类型 >> ${assembly.fdName}
	</div>
	<p class="txttitle">${assembly.fdName}（${assembly.fdId}）</p>
</template:block>
<center><div style="width:95%;text-align:left;"><ui:accordionpanel toggle="true">
	<template:block name="elements">
		<ui:content title="布局">
			<table class="tb_normal" width="100%">
				<tr class="tr_normal_title">
					 <td width="5%">序号</td>
					 <td width="30%">ID</td>
					 <td width="30%">名称</td>
					 <td width="35%">缩略图</td>
				</tr>
				<c:forEach items="${layoutList}" var="layout" varStatus="vstatus">
					<tr height="30px"
						onmouseover="this.style.backgroundColor='#F6F6F6';"
						onmouseout="this.style.backgroundColor='#FFFFFF';"
						<c:if test="${not empty layout.fdHelp or not empty defaultLayoutHelp}">
						onclick="location.href='${LUI_ContextPath}${(empty layout.fdHelp) ? defaultLayoutHelp : layout.fdHelp}?fdId=${ layout.fdId }';"
						style="cursor:pointer"
						</c:if>
					>
						<td><center>${vstatus.index+1}</center></td>
						<td>${ layout.fdId }</td>
						<td>${ layout.fdName }</td>
						<td>
							<c:if test="${empty layout.fdThumb}">
								无
							</c:if>
							<c:if test="${not empty layout.fdThumb}">
								<div style="display:inline-block">
									<img src="${LUI_ContextPath}${layout.fdThumb}" style="max-height: 50px;">
									<ui:popup>
										<img src="${LUI_ContextPath}${layout.fdThumb}">
									</ui:popup>
								</div>
							</c:if>
						</td>
					</tr>
				</c:forEach>
			</table>
		</ui:content>
	</template:block>
	<ui:content title="使用说明">
		<template:block name="detail">无</template:block>
	</ui:content>
	<template:block name="more"></template:block>
</ui:accordionpanel></div></center>
<br/>
</body>
</html>
