<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<title>
	<bean:message key="global.init.system"/>
</title>
<style>
.init_btn_bg{
	cursor: pointer;
	text-align: center;
}
.init_btn_font{
	font-size: 16px;
	color: white;
	font-weight:bold;
}
ul{
	margin-bottom: 5px;
	padding: 0 20px 0 30px;
}
li{
	list-style: none;
	padding: 2px 0;
}
</style>
<br>
<br>
<table width="320px" border="0" align="center" cellpadding="0" cellspacing="0" style="margin:0px auto;font-size:12px; line-height:150%">
  <tr>
    <td width="45"><img src="<c:url value="/sys/config/images/init/pic.jpg"/>" width="45" height="85" /></td>
    <td align="center" valign="top" background="<c:url value="/sys/config/images/init/pic1.jpg"/>" style="font-size:21px; color:#ffffff; padding-top:36px; font-weight:bold;"><bean:message key="global.init.system"/></td>
    <td width="45"><img src="<c:url value="/sys/config/images/init/pic2.jpg"/>" width="45" height="85" /></td>
  </tr>
  <tr>
    <td background="<c:url value="/sys/config/images/init/pic3.jpg"/>">&nbsp;</td>
    <td>
    	<ul>
    		<li><strong><bean:message key="global.init.system.message"/></strong></li>
			<c:forEach items="${initNames}" var="initName" varStatus="vstatus">
				<li>${vstatus.index+1}、${initName}</li>
			</c:forEach>
    	</ul>
    </td>
    <td background="<c:url value="/sys/config/images/init/pic4.jpg"/>">&nbsp;</td>
  </tr>
  <tr>
    <td><img src="<c:url value="/sys/config/images/init/pic5.jpg"/>" width="45" height="41" /></td>
    <td valign="top"  background="<c:url value="/sys/config/images/init/pic9.jpg"/>"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td>&nbsp;</td>
        <td width="121" height="41" background="<c:url value="/sys/config/images/init/pic6.jpg"/>" class="init_btn_bg" onclick="Com_OpenWindow('<c:url value="/sys/common/config.do?method=systemInit"/>', '_self')">
      		<span class="init_btn_font"><bean:message key="global.init.system.button"/></span>
        </td>
        <td>&nbsp;</td>
        <td width="121" height="41" background="<c:url value="/sys/config/images/init/pic7.jpg"/>" class="init_btn_bg" onclick="Com_CloseWindow();">
      		<span class="init_btn_font"><bean:message key="button.close"/></span>
        </td>
        <td>&nbsp;</td>
      </tr>
    </table></td>
    <td><img src="<c:url value="/sys/config/images/init/pic8.jpg"/>" width="45" height="41" /></td>
  </tr>
</table>
<%@ include file="/resource/jsp/view_down.jsp"%>