<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="com.landray.kmss.sys.xform.base.service.controls.fieldlayout.SysFieldsParamsParse"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>

<%
	//字段ID
	String fieldIds=request.getParameter("fieldIds");
	String formIds=StringUtil.isNull((String)request.getParameter("formIds"))?fieldIds:(String)request.getParameter("formIds");

	SysFieldsParamsParse parse=new SysFieldsParamsParse(request).parse();
	//默认值
	String defaultValue=parse.getParamValue("defaultValue");
	String value=parse.acquireValue(fieldIds,defaultValue);
	//是否必填,只针对数据字典中非必填的字段生效
	boolean required=Boolean.parseBoolean(parse.getParamValue("control_required","false"));
	
	String dataType=parse.getParamValue("dataType","Double");
	
	String validators="number ";
	String begin = parse.getParamValue("beginNum","");
	String end = parse.getParamValue("endNum","");
	String scale = parse.getParamValue("scale","");
	if (StringUtil.isNotNull(begin) && StringUtil.isNotNull(end)) {
		validators += " range(" + begin + "," + end + ")";
	} else if (StringUtil.isNotNull(begin)) {
		validators +=  " min(" + begin + ")";
	} else if (StringUtil.isNotNull(end)) {
		validators +=  " max(" + end + ")";
	}
	if (StringUtil.isNotNull(scale)) {
		validators +=  " scaleLength(" + scale + ")";
	}
	//样式字符串
	parse.addStyle("width", "control_width", "auto");
%>
<xform:xtext property="<%=formIds%>" required="<%=required%>" dataType="<%=dataType%>" style="<%=parse.getStyle()%>" value="<%=value%>" validators="<%=validators%>"/>	