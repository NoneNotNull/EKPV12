<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<kmss:windowTitle subjectKey="sys-admin:sys.admin.upgradeWizard" moduleKey="sys-admin:home.nav.sysAdmin" />
<h1>&nbsp;</h1>
<center>
<table width="auto;" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
  	<td valign="middle" width="auto;">
  		<table border="0" cellpadding="0" cellspacing="0">
  			<tr>
	  			<td height="162" align="center" width="auto;">
	  				<span style="font-size: 16px;font-weight: bold;color: #0097E5;">
	  					<bean:message bundle="sys-admin" key="sys.admin.sysupgradeWizard"/>
	  				</span>
	  			</td>
	  			<td width="131" height="162" background="<c:url value="/sys/admin/resource/images/wizard/pic1_1.jpg"/>" nowrap="nowrap">
	  			</td>
	  			<td width="33" height="162" background="<c:url value="/sys/admin/resource/images/wizard/pic2.jpg"/>" nowrap="nowrap">
	  			</td>
  			</tr>
  		</table>
  	</td>
    <td>
    	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	      <tr>
	        <td width="25" align="center">&nbsp;</td>
	        <td height="18" align="left">&nbsp;</td>
	        <td align="left">&nbsp;</td>
	      </tr>
	      <tr>
	      	<td><img src="<c:url value="/sys/admin/resource/images/wizard/1.jpg"/>" width="17" height="17" border="0" /></td>
	        <td><bean:message key="global.init.system"/></td>
	        <td>
	        	<input type="button"
					value="<bean:message key="sys.admin.upgradeWizard.execute" bundle="sys-admin"/>"
					onclick="Com_OpenWindow('<c:url value="/sys/common/config.do?method=systemInitPage" />');"
					style="cursor: pointer;" />
	        </td>
	      </tr>
	      <tr>
	        <td>&nbsp;</td>
	        <td>&nbsp;</td>
	        <td>&nbsp;</td>
	      </tr>
	      <tr>
	        <td><img src="<c:url value="/sys/admin/resource/images/wizard/2.jpg"/>" width="17" height="17" border="0" /></td>
	        <td><bean:message bundle="sys-admin" key="sysAdminDbchecker.dbchecker"/></td>
	        <td>
	        	<input type="button"
					value="<bean:message key="sys.admin.upgradeWizard.execute" bundle="sys-admin"/>"
					onclick="Com_OpenWindow('<c:url value="/sys/admin/sys_admin_dbchecker/sysAdminDbchecker.do?method=select" />');"
					style="cursor: pointer;" />
	        </td>
	      </tr>
	      <tr>
	        <td>&nbsp;</td>
	        <td>&nbsp;</td>
	        <td>&nbsp;</td>
	      </tr>
	      <tr>
	        <td><img src="<c:url value="/sys/admin/resource/images/wizard/3.jpg"/>" width="17" height="17" border="0" /></td>
	        <td><bean:message bundle="sys-admin-transfer" key="module.sys.admin.transfer"/></td>
	        <td>
	        	<input type="button"
					value="<bean:message key="sys.admin.upgradeWizard.execute" bundle="sys-admin"/>"
					onclick="Com_OpenWindow('<c:url value="/sys/admin/transfer/sys_admin_transfer_task/sysAdminTransferTask.do?method=list&status=10" />');"
					style="cursor: pointer;" />
	      </tr>
	      <tr>
	        <td>&nbsp;</td>
	        <td>&nbsp;</td>
	        <td>&nbsp;</td>
	      </tr>
    	</table>
    </td>
  </tr>
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>