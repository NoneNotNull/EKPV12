<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List,
	org.springframework.context.ApplicationContext,
	org.springframework.web.context.support.WebApplicationContextUtils,
	com.landray.kmss.sys.oms.in.interfaces.IOMSSynchroInProvider,
	com.landray.kmss.third.ldap.oms.in.*
	" %>
<%
	String type = request.getParameter("type");
	if(type==null || type.length()==0){
		type = "dept";
	}
	ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(session.getServletContext());
	IOMSSynchroInProvider tookitLdapSynchroInProvider = (IOMSSynchroInProvider)ctx.getBean("tookitLdapSynchroInProvider");
	tookitLdapSynchroInProvider.init();
	List results = tookitLdapSynchroInProvider.getRecordsForUpdate();
	for(int i=0;i<results.size();i++){
		Object o = results.get(i);
		if((type.equals("dept") || type.equals("all"))
			&& o instanceof LdapDept){
			LdapDept dept = (LdapDept)o;
			out.print(dept.toString("<br>"));
		}
		if((type.equals("person") || type.equals("all"))
			&& o instanceof LdapPerson){
			LdapPerson person = (LdapPerson)o;
			out.print(person.toString("<br>"));
		}
		if((type.equals("post") || type.equals("all"))
			&& o instanceof LdapPost){
			LdapPost post = (LdapPost)o;
			out.print(post.toString("<br>"));
		}
		if((type.equals("group") || type.equals("all"))
			&& o instanceof LdapGroup){
			LdapGroup group = (LdapGroup)o;
			out.print(group.toString("<br>"));
		}
	}
%>
