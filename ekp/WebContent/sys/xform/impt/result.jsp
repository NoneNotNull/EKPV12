<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.dialog">
	<template:replace name="head">
		<style type="text/css">
			body{margin:20px 0px 20px 0px; height: 150px;background-color: white;}
		</style>
		<script type="text/javascript">
		Com_IncludeFile("jquery.js");
		Com_AddEventListener(window,'load',function(){
				var result  = $("#result").val();
				var callbackFun = '${callback}';
				if(callbackFun=='')
					callbackFun = 'form_impt_callback';
				if(result!=null){
					parent[callbackFun]($.parseJSON(result),'${impt_opt}');
				}else{
					parent[callbackFun](null,'${impt_opt}');
				}
			});
		</script>
	</template:replace>
	<template:replace name="content"> 
		<textarea id="result" style="display:none"> ${result}</textarea>
	</template:replace>
</template:include>
