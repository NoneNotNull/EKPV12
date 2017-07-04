<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<script type="text/javascript">
Com_IncludeFile("document.js", "style/"+Com_Parameter.Style+"/doc/");
Com_IncludeFile("docutil.js|optbar.js");
</script>
<link href="${KMSS_Parameter_StylePath}info_view/doc.css" rel="stylesheet" type="text/css" />
<script>
	if(window.Doc_LabelClass==null){
		Doc_LabelClass = {};
	}
	Doc_LabelClass["info_view"] = {
		imagePath:Com_Parameter.StylePath+"info_view/",
		classPrefix:"info_view_"
	};
</script>
</head>
<body>