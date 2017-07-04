

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<script>
	var obj={
	    "_source":"tib", 
	    "_key": "接口关键字",
	    "_modelname": "外部系统自定义"
	 };

	 function ok(){
		 window.returnValue=obj;
		 window.close();
	 }
	
</script>

<input type='button' value="确定" onclick='ok();'/>  