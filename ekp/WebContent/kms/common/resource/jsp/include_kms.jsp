<%@page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8" %>
<%
	String Kms_Theme = request.getSession().getAttribute("kmsTheme") == null
			? "default"
			: (String) request.getSession().getAttribute("kmsTheme");
	String Kms_ContextPath = request.getContextPath() + "/";
	request.setAttribute("kmsContextPath", Kms_ContextPath);
	String Kms_Base_Path = request.getContextPath() + "/kms";
	request.setAttribute("kmsBasePath", Kms_Base_Path);
	String Kms_Resource_Path = request.getContextPath()
			+ "/kms/common/resource";
	request.setAttribute("kmsResourcePath", Kms_Resource_Path);
	String Kms_Theme_Path = request.getContextPath()
			+ "/kms/common/resource/theme" + "/" + Kms_Theme;
	request.setAttribute("kmsThemePath", Kms_Theme_Path);
%>

<script>
	var KMS = {
		version : "v1.0",
		themePath : "${kmsThemePath}",
		basePath : "${kmsBasePath}",
		contextPath : "${kmsContextPath}",
		kmsResourcePath : "${kmsResourcePath}",
		toString : function() {
			return this.version;
		}
	};
</script>