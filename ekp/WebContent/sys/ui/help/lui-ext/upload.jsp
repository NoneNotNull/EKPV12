<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="body">
		<html:form enctype="multipart/form-data" style="padding:5px;" action="/sys/ui/sys_ui_extend/sysUiExtend.do" method="post">  
			<input type="file" style="width: 350px;" name="file" />
	 		<input type="submit" value="上传" style="width: 115px;" />
	 		<input type="hidden" name="method" value="upload" />
	 		<div style="color: red;">
	 		${ errorMessage }
	 		</div>
		</html:form>
	</template:replace>
</template:include>