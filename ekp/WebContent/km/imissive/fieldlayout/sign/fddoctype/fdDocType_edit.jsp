<%-- 发文文种 --%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="java.util.Map"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/km/imissive/fieldlayout/common/param_parser.jsp"%>
<%parse.addStyle("width", "control_width", "95%"); %>
<select name="fdDocTypeId" style="<%=parse.getStyle()%>">
<% 
    String selectedId = parse.acquireValue("fdDocTypeId");

    String ids = parse.getParamValue("fdMissiveTypesIds");
    String names = parse.getParamValue("fdMissiveTypesNames");
	if(StringUtil.isNotNull(ids)){
		String[] idArr = ids.split(";");
		String[] nameArr = names.split(";");
		for(int i=0; i<idArr.length; i++){
			if(StringUtil.isNotNull(idArr[i])){
				out.print("<option value='"+idArr[i]+"'");
				if(selectedId.equals(idArr[i])){
					out.print("selected='selected'");
				}
				out.println(">"+nameArr[i]+"</option>");
			}
		}
	}
								
%>	
</select>
