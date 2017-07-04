<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.kms.common.forms.KmsPortalForm"%>
<%
	if (request.getAttribute("model") != null) {
		KmsPortalForm model = (KmsPortalForm) request
				.getAttribute("model");
		request.getSession().setAttribute("kmsTheme", model.getTheme());
	}
	String Kms_Theme = request.getSession().getAttribute("kmsTheme") == null
			? "default"
			: (String) request.getSession().getAttribute("kmsTheme");
	String Kms_ContextPath = request.getContextPath() + "/";
	request.setAttribute("kmsContextPath", Kms_ContextPath);
	String Kms_Base_Path = request.getContextPath() + "/kms";
	request.setAttribute("kmsBasePath", Kms_Base_Path);
	request.setAttribute("resourcePath", request.getContextPath()+"/resource");
	String Kms_Resource_Path = request.getContextPath()
			+ "/kms/common/resource";
	request.setAttribute("kmsResourcePath", Kms_Resource_Path);
	String Kms_Theme_Path = request.getContextPath()
			+ "/kms/common/resource/theme" + "/" + Kms_Theme;
	request.setAttribute("kmsThemePath", Kms_Theme_Path);
%>
<link rel="shortcut icon" href="${kmsResourcePath }/favicon.ico">
<link href="${kmsThemePath }/public.css" rel="stylesheet"
	type="text/css" />
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
<script src="${resourcePath }/js/kms_tmpl.js"></script>

<script src="${kmsResourcePath }/js/lib/json2.js"></script>
<script src="${kmsResourcePath }/js/lib/jquery.js"></script>
<script src="${kmsResourcePath }/js/lib/jquery.form.js"></script>
<script src="${kmsResourcePath }/js/lib/kms.js"></script>
<script src="${kmsResourcePath }/js/artdialog/artdialog.js?skin=blue"></script>
<script src="${kmsResourcePath }/js/artdialog/artdialog.iframe.js"></script>
<script src="${kmsResourcePath }/js/template.js"></script>

<script src="${kmsResourcePath }/js/kms_portlet.js"></script>

<script src="${kmsResourcePath }/js/kms_common.js"></script>
<script src="${kmsResourcePath }/js/kms_utils.js"></script>
