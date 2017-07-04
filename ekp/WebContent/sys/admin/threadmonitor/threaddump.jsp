<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<html>
<head>
<meta name="Author" content="JoBin">
<title>Thread dump tools for jdk 1.5 or above</title>
<style>
a   {text-decoration:none}
a:visited    { color: blue }
a:hover { color: red;text-decoration:underline}
html    { line-height: 120% }
</style>
</head>
<body>
<talbe cellSpacing=10 cellPadding=5 width=753 border=0>
<%
	String url = request.getRequestURI();
	String url1 = url + "?live=false";
	String url2 = url + "?live=true";
	String url5 = url + "?thread=HTTP&live=false";
	String url6 = url + "?thread=HTTP&live=true";
%>
<tr>
<td><a href=<%out.println(url1);%>>All threads</a></td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
<td><a href=<%out.println(url2);%>>Living threads</a></td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
<td><a href=<%out.println(url5);%>>HTTP threads</a></td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
<td><a href=<%out.println(url6);%>>Living HTTP threads</a></td><td>&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
</table>
<table border="1" width="100%" cellspacing="0" cellpadding="2">
<tr>
<td><strong>#</strong></td>
<td><strong>Thread name</strong></td>
<td><strong>Stack trace</strong></td>
</tr>
<%
	String tname = request.getParameter("thread");
	String tlive = request.getParameter("live");
	boolean live = tlive == null || tlive.equals("true") || tlive.equals("on") ? true:false;
	String line = null;
	int lineno = 1;

	//get all stack trace
	java.util.Map  map = Thread.getAllStackTraces();
	java.util.Set set = map.keySet();
	java.util.Iterator items = null;
  
	StackTraceElement[] e = null;
	boolean found = false;
	Thread t = null;
	if (tname != null)
	{
	  //filter by thread name.
  	items = set.iterator();
  	while(items.hasNext())
  	{
  	t= (Thread) items.next();
			if (t.getName().indexOf(tname) >= 0 )
			{
	    		e = (StackTraceElement[])map.get(t);
	    		if (e.length > 0 )
	    		{
	    			//show live thread?
						if (!live || e.length > 20 )
						{
    				  found = true;

		        	out.println("<tr><td valign=top>" + lineno + "<td valign=top><a href=" + request.getRequestURI() + 
		        		"?thread=" + java.net.URLEncoder.encode(t.getName()) +"&live=false>" + t.getName() + "</a></td><td>");
			    		for (int i = 0; i < e.length; i++) 
			    		{
			    			out.println("&nbsp;&nbsp;&nbsp;&nbsp;at " + e[i] + "</br>");
			    		}
			    		out.println("</td></tr>");
			    		lineno += 1;
			    	}
	    		}
			}
		}
		
		if (!found)
		{
			out.println("<tr><td>1</td><td style=\"color:red\">Thread name like \"<strong>" + tname + "</strong>\" not found.</td><td>&nbsp;</td></tr>");
		}
	}
	
	if (tname == null)
	{
	  //show all thread stack trace.
	  items = set.iterator();
  	while(items.hasNext())
  	{
  	t= (Thread) items.next();
  		e =(StackTraceElement[]) map.get(t);
  		if (e.length > 0 )
  		{
  			line = e[0].toString();
  			//show live thread?
  		  if(!live || e.length > 20 )
  		  {
        	out.println("<tr><td valign=top>" + lineno + "<td valign=top><a href=" + request.getRequestURI() + 
        		"?thread=" + java.net.URLEncoder.encode(t.getName()) +"&live=false>" + t.getName() + "</a></td><td>");
	    		for (int i = 0; i < e.length; i++) 
	    		{
	    			out.println("&nbsp;&nbsp;&nbsp;&nbsp;at " + e[i] + "</br>");
	    		}
	    		out.println("</td></tr>");
	    		lineno += 1;
	    	}
  		}
  	}
  }
%>
</table>
</body>
</html>
