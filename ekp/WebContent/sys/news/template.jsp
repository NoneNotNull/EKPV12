<%@page import="org.apache.commons.beanutils.PropertyUtils"%>
<%@page import="com.landray.kmss.common.model.IBaseTreeModel"%>
<%@page import="java.util.*"%>
<%@page import="com.landray.kmss.common.dao.HQLInfo"%>
<%@page import="net.sf.json.*"%>
<%@page import="com.landray.kmss.util.SpringBeanUtil"%>
<%@page import="com.landray.kmss.common.dao.IBaseDao"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%! 

public  JSONArray getTreeChildren(String modelName, String modelId) {
	IBaseDao baseDao = (IBaseDao) SpringBeanUtil.getBean("KmssBaseDao");
	JSONArray array = new JSONArray();
	HQLInfo hqlInfo = new HQLInfo();
	hqlInfo.setModelName(modelName);
	if(modelId == null){
		hqlInfo.setWhereBlock("fd_parent_id = null");
	}else{
		hqlInfo.setWhereBlock("fd_parent_id = :fdId");
		hqlInfo.setParameter("fdId", modelId);
	}
	try {
		List list = baseDao.findList(hqlInfo);
		if(list.size() > 0){
			for (int i = 0; i < list.size(); i++) {
				JSONObject json = new JSONObject();
				String value = PropertyUtils.getProperty(list.get(i), "fdId").toString();
				String text = PropertyUtils.getProperty(list.get(i), "fdName").toString();
				json.put("text", text);
				json.put("value", value);
				JSONArray children = getTreeChildren(modelName, value);
				if(children!=null)
					json.put("children",children);
				array.add(json);
			}
		}else{
			return null;
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
	return array;
}
%>
<%
	out.print(getTreeChildren("com.landray.kmss.sys.news.model.SysNewsTemplate",null).toString(4));
%>