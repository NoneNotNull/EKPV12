<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script language="JavaScript">  
Com_SetWindowTitle('<bean:message bundle="sys-tag" key="sysTag.title.help" />');
</script>
<div id="optBarDiv">
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<body>
<%--使用帮助---%>
<p class="txttitle"><bean:message bundle="sys-tag" key="sysTag.help" /> </p>
<DIV  style="font-size: 13px;margin-left: 15%"> 
 
<bean:message bundle="sys-tag" key="sysTag.summary" /><br>
<bean:message bundle="sys-tag" key="sysTag.summary.1" /><br>
<bean:message bundle="sys-tag" key="sysTag.summary.2" /><br>
<bean:message bundle="sys-tag" key="sysTag.summary.3" /><br><br>
 	
<bean:message bundle="sys-tag" key="sysTag.function" /><br>
<bean:message bundle="sys-tag" key="sysTag.icon" />
<img src="${KMSS_Parameter_StylePath}tag/trend_up.jpg" />&nbsp;&nbsp;<bean:message bundle="sys-tag" key="sysTag.up" /><br>
<img src="${KMSS_Parameter_StylePath}tag/trend_down.gif" />&nbsp;&nbsp;
<bean:message bundle="sys-tag" key="sysTag.down" /><br>
<img src="${KMSS_Parameter_StylePath}tag/trend_keep.gif" />&nbsp;&nbsp;
<bean:message bundle="sys-tag" key="sysTag.keep" /><br>
<img src='${KMSS_Parameter_StylePath}tag/title_file.jpg' border="1" style="border-color: #CACCCB"  />
<bean:message bundle="sys-tag" key="sysTag.alias1" /><br>
<img src='${KMSS_Parameter_StylePath}tag/title_file_light.jpg' border="1" style="border-color: #CACCCB"  />
<bean:message bundle="sys-tag" key="sysTag.alias2" /><br><br>
 
<bean:message bundle="sys-tag" key="sysTag.new" /><br>
<bean:message bundle="sys-tag" key="sysTag.new.top" /><br><br>

<bean:message bundle="sys-tag" key="sysTag.yesterday" /><br>
<bean:message bundle="sys-tag" key="sysTag.yesterday.hot.1" /><br>
<bean:message bundle="sys-tag" key="sysTag.yesterday.hot.2" /><br><br>


<bean:message bundle="sys-tag" key="sysTag.week" /><br>
<bean:message bundle="sys-tag" key="sysTag.week.hot" /><br> <br>

<bean:message bundle="sys-tag" key="sysTag.searchHot" /><br>
<bean:message bundle="sys-tag" key="sysTag.searchHot.top" /><br> <br>

<bean:message bundle="sys-tag" key="sysTag.category" /><br>
<bean:message bundle="sys-tag" key="sysTag.category.top" /><br> <br>

<bean:message bundle="sys-tag" key="sysTag.search" /><br>
<bean:message bundle="sys-tag" key="sysTag.search.1" /><br>
<bean:message bundle="sys-tag" key="sysTag.search.2" /><br>
<bean:message bundle="sys-tag" key="sysTag.search.3" /><br>
<bean:message bundle="sys-tag" key="sysTag.search.4" /><br>
<bean:message bundle="sys-tag" key="sysTag.search.5" /><br>
<bean:message bundle="sys-tag" key="sysTag.search.6" /><br>

</DIV> 
 </body> 
 <%@ include file="/resource/jsp/view_down.jsp"%>
