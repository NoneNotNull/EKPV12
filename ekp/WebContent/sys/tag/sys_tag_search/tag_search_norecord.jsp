<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>  
<%@ include file="/resource/jsp/htmlhead.jsp" %> 
<script type="text/javascript">
Com_IncludeFile("jquery.js");
</script>
 <script>
 window.onload=function(){
	var queryString=parent.parent.document.getElementsByName('queryString')[0].value;
	$(document.getElementById('spanQuery')).text(queryString);//设置搜索信息提示
 }
 </script>
 
<body> 
<DIV style="margin-left: 20%;margin-top: 20px">

	<div style="height: 50px"></div>
	<div style="margin-left: 30px;width: 60%;">
	<div style="width:10%;float: left;"><img alt="" src="${KMSS_Parameter_StylePath}ftsearch/alert.jpg"></div> 
	<div  style="width: 90%;float: left;margin-top: 10px;font-size: 16px">
	<b><bean:message bundle="sys-tag" key="sysTagResult.sorry" />
	<span id='spanQuery' style="color: red;"></span>
	<bean:message bundle="sys-tag" key="sysTagResult.about" /></b></div>
	</div>
	
	 <div style="margin-left: 30px;width: 70%">
	 <div style="width:9%;float: left;"></div>
	 <div  style="width: 91%;float: left;margin-top: 10px;font-size: 16px">
	 <b><bean:message bundle="sys-tag" key="sysTagResult.advice" /></b> 
	 <ul >
	 <li><bean:message bundle="sys-tag" key="sysTagResult.checkWrong" /></li>
	 <li><bean:message bundle="sys-tag" key="sysTagResult.deleteSome" /></li>
	 </ul>
	  
	 </div>
	 
	</div>
	<div style="height: 70px"></div>

</DIV> 
 </body> 
 
