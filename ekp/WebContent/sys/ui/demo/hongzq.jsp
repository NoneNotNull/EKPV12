<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/resource/jsp/htmlhead.jsp"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/list.tld" prefix="list"%>
<head>

<template:include ref="default.simple">
	<template:replace name="body">
		<list:paging layout="sys.ui.paging.default" channel="11" currentPage="20" pageSize="100" totalSize="5">
		</list:paging>
	</template:replace>
</template:include>
