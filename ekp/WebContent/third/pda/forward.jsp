<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/third/pda/htmlhead.jsp"%>
<script type="text/javascript">
	Com_AddEventListener(window,'load',function(){
			var formObj = document.forms['extendform'];
			if(formObj.action!="")
				formObj.submit();
		});
</script>
</head>
<body>
	 <form name="extendform" action="${param['action']}" method="post">
 		<% 
 		Cookie[] cookies = request.getCookies();
		if (cookies != null && cookies.length > 0)
			for (int i = 0; i < cookies.length; i++){
				out.println("<input style='display:none' type='text' name='" +cookies[i].getName() +"' value='"+ cookies[i].getValue()+"'/>");
			}
 		%>
        <input type="submit" style="border:0px;width:0px;height:0px;background: none;">	 
	 </form>
</body>
</html>