<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ page import="org.springframework.context.ApplicationContext,
	org.springframework.web.context.support.WebApplicationContextUtils,
	com.landray.kmss.common.service.IXMLDataBean,
	com.landray.kmss.common.actions.RequestContext,
	com.landray.kmss.util.StringUtil,
	java.util.*
"%>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", -1);
	
	List nodes = null;
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(session.getServletContext());
	RequestContext requestInfo = new RequestContext(request);
	String[] beanList = request.getParameter("s_bean").split(";");
	IXMLDataBean treeBean;
	HashMap nodeMap;
	Object node, value;
	Object[] nodeList;
	Iterator attr;
	String key;
	int i, j, k;
	StringBuilder sout = new StringBuilder();
	JSONArray sarray = new JSONArray();
	sout.append("<dataList>");
	for(i=0; i<beanList.length; i++){
		treeBean = (IXMLDataBean) ctx.getBean(beanList[i]);
		nodes = treeBean.getDataList(requestInfo);
		if(nodes!=null){
			for(j=0; j<nodes.size(); j++){
				node = nodes.get(j);
				JSONObject json = new JSONObject();
				sout.append("<data ");
				if(node instanceof HashMap){
					nodeMap = (HashMap)node;
					for(attr=nodeMap.keySet().iterator(); attr.hasNext(); ){
						key = attr.next().toString();
						value = nodeMap.get(key);
						if(value==null)
							continue;
						sout.append(key+"=\""+StringUtil.XMLEscape(value.toString())+"\" ");
						json.put(key,value.toString());
					}
				}else if(node instanceof Object[]){
					nodeList = (Object[])node;
					for(k=0; k<nodeList.length; k++)
						if(nodeList[k]!=null){
							sout.append("key"+k+"=\""+StringUtil.XMLEscape(nodeList[k].toString())+"\" ");
							json.put("key"+k,nodeList[k].toString());
						}
				}else{
					if(node!=null){
						sout.append("key0=\""+StringUtil.XMLEscape(node.toString())+"\" ");
						json.put("key0",node.toString());
					}
				}
				sout.append("/>");
				sarray.add(json);
			}
		}
	}
	sout.append("</dataList>");
	response.addHeader("Access-Control-Allow-Origin","*");
	String jsonpcallback = request.getParameter("jsonpcallback");
	if(StringUtil.isNotNull(jsonpcallback)){
		response.setContentType("text/plain; charset=UTF-8");		
		out.print(jsonpcallback+"("+sarray.toString()+")");
	}else{
		response.setContentType("text/xml; charset=UTF-8");
		out.print(sout.toString());
	}
%>