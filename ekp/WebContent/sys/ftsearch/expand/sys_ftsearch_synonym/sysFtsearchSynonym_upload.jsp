<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<html>
<head>
	<title><bean:message bundle="sys-ftsearch-expand" key="sysFtsearchSynonym.synonymUpload"/></title>
	<script type="text/javascript">
		window.name="spare" ;
		function haveSelect(){
			var obj = this.event.target|| this.event.srcElement;
			var fileName  = obj.value;
			if(fileName !=null){
				if(obj.value.substring(fileName.length-3) == 'txt'){
					$("#submit1").removeAttr("disabled");
				}else{
					$("#submit1").attr("disabled","disabled");
				}
			}else{
				$("#submit1").attr("disabled","disabled");
			}
		}
		function submitForm(){
			$("#submit1").attr("disabled","disabled");
			$("#loadImag").css("display","block");
			document.getElementById("form1").submit();
		}
	</script>
</head>
<body>
	<div id="loadImag" style="display:none">
		<img alt="上传中" src="${KMSS_Parameter_ResPath}/style/common/images/loading.gif"/>
	</div>
	<div style="padding-left:20px">
		<form id="form1" action="<c:url value="/sys/ftsearch/expand/sys_ftsearch_synonym/sysFtsearchSynonym.do?method=uploadSynonym" />" method="POST" enctype="multipart/form-data" target="spare">  
	        <div>
	        	<input type="file" name="synonymFile" onchange="haveSelect();"/></div>  
	            <div style="font: 12;color:red;"><bean:message bundle="sys-ftsearch-expand" key="sysFtsearchSynonym.promptTitle"/></div>  
	        <div>
	        <input id="submit1" type="button" onclick ="submitForm();"  disabled value="上传"/></div>  
	    </form>
    </div>
</body>
</html>