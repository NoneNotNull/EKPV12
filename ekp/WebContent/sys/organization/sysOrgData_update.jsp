<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>


<div class="txttitle"><bean:message bundle="sys-organization" key="sysOrgElement.dataUpdate.title"/></div>
<br>
<center>
<div>

<input type="button"
			value="<bean:message bundle="sys-organization" key="sysOrgElement.dataUpdate.dobutton"/>"
			onclick="Com_OpenWindow('<c:url value="/sys/organization/sys_org_element/sysOrgElement.do?method=updatePinYinField" />')">


<br>
<br>

<bean:message bundle="sys-organization" key="sysOrgElement.dataUpdate.describe"/>
</div>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>