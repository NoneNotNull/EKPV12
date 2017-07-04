<%@ page language="java" contentType="application/x-javascript; charset=UTF-8"	pageEncoding="UTF-8"%>
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
	
	out.print(request.getParameter("jsoncallback")+"(");
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(session.getServletContext());
	RequestContext requestInfo = new RequestContext(request);
	String[] beanList = request.getParameter("s_bean").split(";");
	IXMLDataBean treeBean;
	List nodes;
	HashMap nodeMap;
	Object node, value;
	Object[] nodeList;
	String[] keyList = new String[]{"text", "value", "title", "nodeType", "beanName", "isAutoFetch", "href", "target", "winStyle"};
	Iterator attr;
	String key;
	int i, j, k;
	out.print("[");
	for(i=0; i<beanList.length; i++){
		treeBean = (IXMLDataBean) ctx.getBean(beanList[i]);
		nodes = treeBean.getDataList(requestInfo);
		if(nodes!=null){
			for(j=0; j<nodes.size(); j++){
				node = nodes.get(j);
				out.println("{");
				if(node instanceof HashMap){
					nodeMap = (HashMap)node;
					for(attr=nodeMap.keySet().iterator(); attr.hasNext(); ){
						key = attr.next().toString();
						value = nodeMap.get(key);
						if(value==null)
							continue;
						out.print("\""+key+"\":\""+value.toString()+"\"");
						if(attr.hasNext())out.print(",");
					}
				}else{
					nodeList = (Object[])node;
					for(k=0; k<nodeList.length && k<keyList.length; k++)
						if(nodeList[k]!=null && !nodeList[k].toString().equals("")){
							out.print("\""+keyList[k]+"\":\""+nodeList[k].toString()+"\"");
							if(k<nodeList.length-1)out.print(",");
						}
				}
				out.print("}");
				if(j<nodes.size()-1)out.print(",");
			}
		}
	}
	out.print("])");
%>