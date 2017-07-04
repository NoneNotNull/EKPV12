<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script language="JavaScript">  
Com_SetWindowTitle('<bean:message bundle="sys-tag" key="sysTag.title.help" />');
</script>
<div id="optBarDiv"><input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();"></div> 
<body> 
<%--使用帮助--%>
<p class="txttitle"><bean:message bundle="sys-tag" key="sysTag.help" /> </p>
<DIV  style="font-size: 13px;margin-left: 15%">  
<bean:message bundle="sys-tag" key="sysTag.search.function" /><br><br>

<bean:message bundle="sys-tag" key="sysTag.search.way.1" /><br>
<bean:message bundle="sys-tag" key="sysTag.search.way.2" /><br>
<bean:message bundle="sys-tag" key="sysTag.search.way.3" /><br><br>

<img src="${KMSS_Parameter_StylePath}tag/tree.jpg"  /><br>
<bean:message bundle="sys-tag" key="sysTag.search.result" /><br>
<bean:message bundle="sys-tag" key="sysTag.search.result.byTime" /><br>
<bean:message bundle="sys-tag" key="sysTag.search.result.day" /><br>
<bean:message bundle="sys-tag" key="sysTag.search.result.week" /><br>
<bean:message bundle="sys-tag" key="sysTag.search.result.year" /><br>

<br>

<bean:message bundle="sys-tag" key="sysTag.search.result.byView" /><br>
<bean:message bundle="sys-tag" key="sysTag.normal" /><br>
<bean:message bundle="sys-tag" key="sysTag.search.result.1" />
<br><br>

<bean:message bundle="sys-tag" key="sysTag.search.result.cube" /><br>
<bean:message bundle="sys-tag" key="sysTag.search.result.cube.1" /><br><br>

<bean:message bundle="sys-tag" key="sysTag.search.result.cube.2" /><br>
<bean:message bundle="sys-tag" key="sysTag.search.result.cube.3" /><br>
<bean:message bundle="sys-tag" key="sysTag.search.result.cube.4" />
<bean:message bundle="sys-tag" key="sysTag.search.result.cube.5" /><br>
<bean:message bundle="sys-tag" key="sysTag.search.result.cube.6" /><br>
<bean:message bundle="sys-tag" key="sysTag.search.result.cube.7" />
<bean:message bundle="sys-tag" key="sysTag.search.result.cube.8" /><br><br>

<IMG  src=' ${KMSS_Parameter_StylePath}tag/cube_openTag.gif ' >
&nbsp;&nbsp;<bean:message bundle="sys-tag" key="sysTag.search.result.relation" /><br>
<bean:message bundle="sys-tag" key="sysTag.search.result.relation.1" /><br>
<bean:message bundle="sys-tag" key="sysTag.search.result.relation.2" />
<bean:message bundle="sys-tag" key="sysTag.search.result.relation.3" /><br>
<bean:message bundle="sys-tag" key="sysTag.search.result.relation.4" /><br>
<bean:message bundle="sys-tag" key="sysTag.search.result.relation.5" /><br>
<bean:message bundle="sys-tag" key="sysTag.search.result.relation.6" /><br>
<bean:message bundle="sys-tag" key="sysTag.search.result.relation.7" /><br>
</DIV> 
</body> 
<%@ include file="/resource/jsp/view_down.jsp"%>