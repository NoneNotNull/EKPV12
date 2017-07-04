<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="body">
		<script type="text/javascript">seajs.use(['theme!form']);</script>
		<div style="height:5px;"></div>
		<div style="margin:0px 20px;">
			<template:block name="path">
				<%@ include file="/sys/ui/help/common/path.jsp"%>
			</template:block>
			<template:block name="beforeList" />
			<template:block name="listTable" >			
				<%@ include file="/sys/ui/help/common/table.jsp"%>
			</template:block>
			<template:block name="afterList" />
		</div>
		<div style="height:10px;"></div>
	</template:replace>
</template:include>
