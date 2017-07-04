<%@ page language="java" contentType="text/xml; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ page errorPage="/resource/jsp/jsperror.jsp" %>
<%@ page import="org.springframework.context.ApplicationContext,
	org.springframework.web.context.support.WebApplicationContextUtils,
	com.landray.kmss.common.service.IXMLDataBean,
	com.landray.kmss.common.actions.RequestContext,
	com.landray.kmss.util.StringUtil,
	java.util.*
"%>
<dataList>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
	response.setDateHeader("Expires", -1);
	
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
	for(i=0; i<beanList.length; i++){
		treeBean = (IXMLDataBean) ctx.getBean(beanList[i]);
		nodes = treeBean.getDataList(requestInfo);
		if(nodes!=null){
			for(j=0; j<nodes.size(); j++){
				node = nodes.get(j);
				out.print("<data ");
				if(node instanceof HashMap){
					nodeMap = (HashMap)node;
					for(attr=nodeMap.keySet().iterator(); attr.hasNext(); ){
						key = attr.next().toString();
						value = nodeMap.get(key);
						if(value==null)
							continue;
						out.print(key+"=\""+StringUtil.XMLEscape(value.toString())+"\" ");
					}
				}else{
					nodeList = (Object[])node;
					for(k=0; k<nodeList.length && k<keyList.length; k++)
						if(nodeList[k]!=null && !nodeList[k].toString().equals(""))
							out.print(keyList[k]+"=\""+StringUtil.XMLEscape(nodeList[k].toString())+"\" ");
				}
				out.println("/>");
			}
		}
	}
%>
</dataList>
