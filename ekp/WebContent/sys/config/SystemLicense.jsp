<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.sys.config.util.LicenseUtil"%>
<%@page import="java.util.Map"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%@page import="com.landray.kmss.sys.organization.interfaces.ISysOrgCoreService"%>
<%@page import="com.landray.kmss.constant.SysOrgConstant"%><br/>
<br/>
<table  align="center" width="500" border="0" cellspacing="0" cellpadding="0" style="margin:0px auto;">
  <tr>
    <td width="104" valign="top"><img src="images/lic/pic1.jpg" width="104" height="38" /></td>
    <td valign="top" background="images/lic/pic_bj1.jpg">&nbsp;</td>
    <td width="73" valign="top"><img src="images/lic/pic2.jpg" width="73" height="38" /></td>
  </tr>
  <tr>
    <td valign="top" background="images/lic/pic_bj3.jpg"><img src="images/lic/pic3.jpg" width="104" height="77" /></td>
    <td rowspan="3" align="center" valign="top" bgcolor="#F7F6F2" style="font-size:12px;">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td height="30" colspan="2" align="center" style="font-size:16px; color:#107bb2; font-weight:bold;"><bean:message key="sysLicense.info" bundle="sys-config" /></td>
      </tr>
      <tr>
        <td height="8" colspan="2"></td>
      </tr>   
      <tr>
        <td height="26" align="right"><bean:message key="sysLicense.licenseTo" bundle="sys-config" />&nbsp;：&nbsp;</td>
        <td align="left"><%=LicenseUtil.get("license-to")%></td>
      </tr>
      <tr>
        <td height="26" align="right"><bean:message key="sysLicense.licenseType" bundle="sys-config" />&nbsp;：&nbsp;</td>
        <td align="left">
        	<%
        		if(LicenseUtil.get("license-type") != null &&LicenseUtil.get("license-type").equalsIgnoreCase("Official")){
        	%>
        		<bean:message key="sysLicense.official" bundle="sys-config" />
        	<%
        		}else{
        	%>
        		<bean:message key="sysLicense.trial" bundle="sys-config" />(<%=LicenseUtil.get("license-expire")%>)
        	<%
        		}
        	%>
        	</td>
      </tr>
      <tr>
        <td height="26" align="right"><bean:message key="sysLicense.licenseCluster" bundle="sys-config" />&nbsp;：&nbsp;</td>
        <td align="left">
        	<%
        		String unlimit = ResourceUtil.getString("sysLicense.licenseType.unlimit", "sys-config");
	    		int licenseCluster = StringUtil.getIntFromString(LicenseUtil.get("license-cluster"), 1);
	    		String licenseClusterString = licenseCluster < 0 ? unlimit : String.valueOf(licenseCluster);
        	%>
        	<%=licenseClusterString%>
        </td>
      </tr>
      <tr>
        <td height="26" align="right"><bean:message key="sysLicense.licenseOrgPerson" bundle="sys-config" />&nbsp;：&nbsp;</td>
        <td align="left">
        	<%
	        	int licenseOrgPerson = StringUtil.getIntFromString(LicenseUtil.get("license-org-person"), 9999999);
	    		String licenseOrgPersonString = licenseOrgPerson == 9999999  ? unlimit : String.valueOf(licenseOrgPerson);
	    		int currentPerson  = ((ISysOrgCoreService)SpringBeanUtil.getBean("sysOrgCoreService")).getAllCount(SysOrgConstant.ORG_TYPE_PERSON);
        	%>
        	<%=licenseOrgPersonString%>&nbsp;&nbsp;&nbsp;&nbsp;(<bean:message key="sysLicense.licenseOrgPerson.registered" bundle="sys-config" />&nbsp;&nbsp;<%=currentPerson%>)
        </td>
      </tr>
      <tr>
        <td height="26" align="right"><bean:message key="sysLicense.licenseService" bundle="sys-config" />&nbsp;：&nbsp;</td>
        <td align="left">
        	<%
	        	String licenseServiceStart = LicenseUtil.get("license-service-start");
	    		String licenseServiceEnd = LicenseUtil.get("license-service-end");
	    		if(StringUtil.isNotNull(licenseServiceStart)){	
        	%>
        	<%=licenseServiceStart%>&nbsp;&nbsp;<bean:message key="sysLicense.licenseService.to" bundle="sys-config" />&nbsp;&nbsp;<%=licenseServiceEnd%>
        	<%
	    		}else {
	    	%>
	    		<%=ResourceUtil.getString("sysLicense.licenseService.none", "sys-config") %>
	    	<%
	    		}
        	%>
        </td>
      </tr>      
     </table>
	 <hr>
     <table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr style="color: blue">
        <td height="26" align="right"><bean:message key="sysLicense.licenseServerIP" bundle="sys-config" />&nbsp;：&nbsp;</td>
        <td align="left">
        	<%
        		Map<String,String> serverHwaddr = LicenseUtil.getServerHwaddr();
        	%>
        	<%=serverHwaddr.get("ip")%>
        </td>
      </tr>
      <tr style="color: blue">
        <td height="26" align="right"><bean:message key="sysLicense.licenseServerMAC" bundle="sys-config" />&nbsp;：&nbsp;</td>
        <td align="left">
        	<%=serverHwaddr.get("mac")%>
        </td>
      </tr>
      <% if(StringUtil.isNotNull(serverHwaddr.get("suggest"))){ %>
      <tr>
        <td height="26" style="color: blue;" colspan="2">
        	<bean:message key="sysLicense.licenseServer.suggest" bundle="sys-config" />&nbsp;：&nbsp;<%=serverHwaddr.get("suggest")%>
        </td>
      </tr>
      <%} 
      if(StringUtil.isNotNull(serverHwaddr.get("error"))){ %>
      <tr>
        <td height="26" style="color: blue;" colspan="2">
        	<bean:message key="sysLicense.licenseServer.error" bundle="sys-config" />&nbsp;：&nbsp;<%=serverHwaddr.get("error")%>
        </td>
      </tr>
      <%} %>                
    </table></td>
    <td valign="top" background="images/lic/pic_bj2.jpg">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top" background="images/lic/pic_bj3.jpg">&nbsp;</td>
    <td valign="top" background="images/lic/pic_bj2.jpg">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top" background="images/lic/pic_bj3.jpg">&nbsp;</td>
    <td valign="bottom" background="images/lic/pic_bj2.jpg"><img src="images/lic/pic4.jpg" width="73" height="49" /></td>
  </tr>
  <tr>
    <td valign="top"><img src="images/lic/pic5.jpg" width="104" height="30" /></td>
    <td valign="top" background="images/lic/pic_bj4.jpg">&nbsp;</td>
    <td valign="top"><img src="images/lic/pic6.jpg" width="73" height="30" /></td>
  </tr>
</table>


<%@ include file="/resource/jsp/view_down.jsp"%>