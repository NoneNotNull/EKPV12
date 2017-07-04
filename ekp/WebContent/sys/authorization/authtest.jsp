<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.util.UserUtil" %>
当前用户：<%= UserUtil.getUserName(request) %>
<br><br>
用户角色：<%= UserUtil.getKMSSUser(request).getUserAuthInfo().getAuthRoleAliases() %>
<br><br>
用户ID：<%= UserUtil.getKMSSUser(request).getUserAuthInfo().getAuthOrgIds() %>