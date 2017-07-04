<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.config.xml.DesignConfigLoader"%>
<%
	DesignConfigLoader.getXmlReaderContext().refresh(
			"http://www.landray.com.cn/schema/lui");


	DesignConfigLoader.getXmlReaderContext().refresh(
		"http://www.landray.com.cn/schema/portal");
%>
成功重新加载XML
