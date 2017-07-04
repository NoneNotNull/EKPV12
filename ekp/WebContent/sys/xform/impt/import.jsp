<%@ page language="java" pageEncoding="UTF-8" contentType="text/javascript; charset=UTF-8"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.framework.service.plugin.Plugin"%>
<%@page import="com.landray.kmss.framework.plugin.core.config.IExtension"%>
<%@page import="com.landray.kmss.sys.xform.impt.SysFormImportPlugin"%>
<%@ taglib uri="/WEB-INF/kmss.tld" prefix="kmss"%>
var __xform_impt_parser = {};
<%
	out.println("Com_IncludeFile('_xform_impt_import.css','" + request.getContextPath() + "/sys/xform/impt/style/', 'css', true);");
	out.println("Com_IncludeFile('_xform_impt_import.js','" + request.getContextPath() + "/sys/xform/impt/js/', 'js', true);");
	IExtension[] exts = SysFormImportPlugin.getParserExtensions();
	for (int i = 0; i < exts.length; i++) {
		IExtension extension = exts[i];
		String extJs = (String)Plugin.getParamValue(extension,SysFormImportPlugin.IMPORT_ITEM_DRAWJS);
		if(StringUtil.isNotNull(extJs)){
			String jsName = extJs.substring(extJs.lastIndexOf("/")+1);
			String jsPath = extJs.substring(0,extJs.lastIndexOf("/")+1);
			out.println("Com_IncludeFile('"+jsName + "','" + request.getContextPath() + jsPath + "', 'js', true);");
		}
	}
%>