<%@page import="java.util.Map.Entry"%>
<%@page import="java.util.Iterator"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="java.util.Map"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.landray.kmss.framework.hibernate.extend.SqlPartitionConfig"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<list:cri-criterion title="${criterionAttrs['title']}" multi="false" key="partition" expand="true">
	<list:varDef name="title"></list:varDef>
	<list:varDef name="selectBox">
	<list:box-select>
		<list:varDef name="select">
			<%
			Map attrs = (Map)request.getAttribute("criterionAttrs");
			pageContext.setAttribute("defaultValue",SqlPartitionConfig.getInstance().getModel(attrs.get("modelName").toString()).getDefaultValue());
			%>
			<list:item-select cfg-required="true" cfg-defaultValue="${ defaultValue }">
				<ui:source type="Static">
					<% 
					Map map = SqlPartitionConfig.getInstance().getModel(attrs.get("modelName").toString()).getPartitions();
					JSONArray array = new JSONArray();
					Iterator iterator = map.entrySet().iterator();
					while(iterator.hasNext()){
						Entry iem = (Entry)iterator.next();
						JSONObject a = new JSONObject();
						a.put("value",iem.getKey().toString());
						a.put("text",iem.getValue().toString());
						array.add(a);
					}
					out.print(array.toString()); 
					%>
				</ui:source>
			</list:item-select>
		</list:varDef>
	</list:box-select>
	</list:varDef>
</list:cri-criterion>