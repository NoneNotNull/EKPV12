<%@page import="com.landray.kmss.sys.attachment.actions.SysAttMainAction"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//注释掉修改前的代码
	//new SysAttMainAction().download(null,null,request,response); 

    //修复移动端附件下载不了的问题 可重现环境（Linux+weblogic+oracle）
    //request.getRequestDispatcher(url).forward(request,response)是直接将请求转发到指定URL，所以该请求 
    //能够直接获得上一个请求的数据，也就是说采用请求转发，request对象始终存在，不会重新创建。
    //而sendRedirect()会新建request对象，所以上一个request中的数据会丢失。 

    request.getRequestDispatcher("/sys/attachment/sys_att_main/sysAttMain.do?method=download").forward(request,response);

%>