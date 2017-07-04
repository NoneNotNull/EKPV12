<%@page import="com.landray.kmss.sys.ui.plugin.SysUiTools"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="title">选择Logo</template:replace>
	<template:replace name="head">
		<template:super/>
		<style type="text/css">
			html,body {
				height: 100%;
			}
			.logo {
				float: left;
				padding: 5px;
				cursor: pointer;
				width:149px;
				height: 100px;
				overflow: hidden;
			}
		</style>
		<script>
			function onLogoClick(title){
				window.$dialog.hide(title);
			}
			LUI.ready(function(){
				 
			});
		</script>
	</template:replace>
	<template:replace name="body">
		<%
		List<String> logos = SysUiTools.scanLogoPath();
		request.setAttribute("logos", logos);
		%>
		<div style="height: 100%;width:100%; overflow: hidden;">		
			<div style="height: 310px;overflow: auto;">
				<div class="logo">
					 <div style="background: #C78700;"><img src="${ LUI_ContextPath }/resource/images/logo.png" title="/resource/images/logo.png"  onclick="onLogoClick(this.title);" width="149" style="vertical-align:top;" /></div>
				</div> 
				<c:forEach items="${logos}" var="logo">
					 <div class="logo">
					 	<div style="background: #C78700;"><img src="${ LUI_ContextPath }${ logo }" title="${ logo }"  onclick="onLogoClick(this.title);" width="149" style="vertical-align:top;" /></div>
					 </div> 
				</c:forEach>
			</div>	
			<div style="color: red;height:20px;">
		 		${ errorMessage }
		 		</div>			
			<html:form enctype="multipart/form-data" style="padding:5px;" action="/sys/ui/sys_ui_logo/sysUiLogo.do" method="post">  
				<input type="file" style="width: 350px;" name="file" />
		 		<input type="submit" value="上传" style="width: 115px;" />
		 		<input type="hidden" name="method" value="upload" />
		 		
			</html:form>
		</div>
	</template:replace>
</template:include>