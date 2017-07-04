<%@ page language="java" contentType="text/plain; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ page language="java" import="com.landray.kmss.util.SpringBeanUtil"%>
<%@ page language="java" import="com.landray.kmss.sys.zone.service.ISysZonePersonInfoService"%>
<%@ page language="java" import="com.landray.kmss.sys.zone.model.SysZoneNavigation"%>
<%@ page language="java" import="com.landray.kmss.sys.zone.model.SysZoneNavLink"%>
<%@ page language="java" import="net.sf.json.JSONArray" %>
<%@ page language="java" import="net.sf.json.JSONObject" %>
<%@ page language="java" import="java.util.List"%>
<%@page language="java" import="com.landray.kmss.util.StringUtil" %>
<%	
	String taText = request.getParameter("zone_TA_text");
	ISysZonePersonInfoService service = 
			(ISysZonePersonInfoService)SpringBeanUtil.getBean("sysZonePersonInfoService");
	List<SysZoneNavigation> sysZoneNavigationList = service.getZonePersonNav("mobile");
	JSONArray rtn = new JSONArray();
	rtn = JSONArray.fromObject("[{'id':'home','text':'首页'}]");
	if (sysZoneNavigationList != null && !sysZoneNavigationList.isEmpty()) {
		List<SysZoneNavLink> navList = sysZoneNavigationList.get(0).getFdLinks();
		for(SysZoneNavLink nav : navList) {
			JSONObject obj = new JSONObject();
			obj.put("id", nav.getFdId());
			obj.put("target" , nav.getFdTarget());
			obj.put("url", nav.getFdUrl());
			obj.put("key", nav.getFdServerKey());
			String text = nav.getFdName();
			if(StringUtil.isNotNull(taText)) {
				if(StringUtil.isNotNull(text)&&!"TA".equals(text) && text.indexOf("TA") > -1) {
					text = text.replace("TA",taText );
				}
			}
			obj.put("text",text);
			rtn.add(obj);
		}
		
	}
	out.print(rtn.toString());
%>