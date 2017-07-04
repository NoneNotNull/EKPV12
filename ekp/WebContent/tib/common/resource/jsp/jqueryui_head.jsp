<%
	String Custom_ContextPath = request.getContextPath()+"/";
	request.setAttribute("Custom_ContextPath", Custom_ContextPath);
%>
<link href="${Custom_ContextPath }tib/common/resource/css/cupertino/jquery-ui-1.10.3.custom.css" rel="stylesheet">
<script src="${Custom_ContextPath }tib/common/resource/js/jquery-ui-1.8.11.min.js"></script>
<style>
table tr td{
	text-align: left;
}
</style>
