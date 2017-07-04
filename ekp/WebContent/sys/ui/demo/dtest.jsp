<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
 <head>
  <title> New Document </title>
  <meta name="Generator" content="EditPlus">
  <meta name="Author" content="">
  <meta name="Keywords" content="">
  <meta name="Description" content="">
  <script src="http://localhost:8080/ekp/resource/js/domain.js"></script>
 </head>

 <body> 
	<script type="text/javascript">
 		function callFunc(){
			domain.call(parent, "hello", ["a","b"],function(val){
				alert(val);
			});
 		}
		
		function fireEvent(){
			//控件事件
			domain.call(parent, "fireEvent", [{
				type:"event", 
				target:"p_aacfc21686291a3aa836",
				name:"selectChange",
				data:{"index":1}
				}]);
			/*
			//广播消息
			domain.call(parent, "fireEvent", [{
				type:"topic", 
				target:"p_aacfc21686291a3aa836",
				name:"selectChanged",
				data:{}
				}]);
			*/
		}
	</script>
	
	<input type="button" value="跨域调用函数" onclick="callFunc()" />
	<input type="button" value="跨域触发事件" onclick="fireEvent()" />
 </body>
</html>
