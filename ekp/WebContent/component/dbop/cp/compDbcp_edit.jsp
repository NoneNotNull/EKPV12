<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*,
				com.landray.kmss.util.ResourceUtil"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<script>
var dbVO = [
	{fdType:"Oracle",fdDriver:"oracle.jdbc.driver.OracleDriver",fdUrl:"jdbc:oracle:thin:@192.168.0.30:1521:test"},
	{fdType:"MS SQL Server",fdDriver:"net.sourceforge.jtds.jdbc.Driver",fdUrl:"jdbc:jtds:sqlserver://localhost:1433/test"},
	{fdType:"DB2",fdDriver:"com.ibm.db2.jcc.DB2Driver",fdUrl:"jdbc:db2://localhost:50000/test"},
	{fdType:"My SQL",fdDriver:"com.mysql.jdbc.Driver",fdUrl:"jdbc:mysql://localhost:3306/test"},
	{fdType:"Sybase",fdDriver:"com.sybase.jdbc.SybDriver",fdUrl:"jdbc:sybase:Tds:localhost:5007/test"},
	{fdType:"Informix",fdDriver:"com.informix.jdbc.IfxDriver",fdUrl:"jdbc:informix-sqli://localhost:1533/test:INFORMIXSERVER=myserver"},
	{fdType:"PostgreSQL",fdDriver:"org.postgresql.Driver",fdUrl:"jdbc:postgresql://localhost/test"},
	{fdType:"ODBC",fdDriver:"sun.jdbc.odbc.JdbcOdbcDriver",fdUrl:"jdbc:odbc:DatabaseDSN"},
	{fdType:"Other",fdDriver:"",fdUrl:""}
]

function typeChange(el){
	for(var i=0;i<dbVO.length;i++){
		if(dbVO[i]["fdType"]==el.value){
			document.getElementById("fdDriver").value=dbVO[i]["fdDriver"];
			document.getElementById("fdUrl").value=dbVO[i]["fdUrl"];
			break;
		}
		
	}
}
</script>
<%
		List types = new ArrayList();
		String[] values = new String[] {"", "Oracle", "MS SQL Server", "DB2",
				"My SQL","Sybase","Informix","PostgreSQL","ODBC", "Other" };
		String[] texts = new String[] { ResourceUtil.getString(
							"page.firstOption", request
									.getLocale()),"Oracle", "MS SQL Server", "DB2",
				"My SQL", "Sybase","Informix","PostgreSQL","ODBC",ResourceUtil.getString(
							"component-dbop:compDbcp.fdType.other", request
									.getLocale()) };
		for (int i = 0; i < values.length; i++) {
			Map names = new HashMap();
			names.put("value", values[i]);
			names.put("text", texts[i]);
			types.add(names);
		}
		request.setAttribute("types", types);

%>
<html:messages id="messages" message="true">
	<table style="margin:0 auto" align="center">
	<tr>
	   <td>
	       <img src='${KMSS_Parameter_ContextPath}resource/style/default/msg/dot.gif'>&nbsp;&nbsp;<font color='red'>
           <bean:write name="messages" /></font>
	 </td>
	 </tr>
	 </table><hr />
 </html:messages> 

<html:form action="/component/dbop/compDbcp.do" onsubmit="return validateCompDbcpForm(this);">
<div id="optBarDiv">
		<input type=button value="<bean:message  bundle="component-dbop" key="compDbcp.button.test"/>"
			onclick="Com_Submit(document.compDbcpForm, 'test');">
	<c:if test="${compDbcpForm.method_GET=='edit'}">
		<input type=button value="<bean:message key="button.update"/>"
			onclick="Com_Submit(document.compDbcpForm, 'update');">
	</c:if>
	<c:if test="${compDbcpForm.method_GET=='add'}">
		<input type=button value="<bean:message key="button.save"/>"
			onclick="Com_Submit(document.compDbcpForm, 'save');">
		<input type=button value="<bean:message key="button.saveadd"/>"
			onclick="Com_Submit(document.compDbcpForm, 'saveadd');">
	</c:if>
	<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<html:hidden property="fdId"/>
<p class="txttitle"><bean:message  bundle="component-dbop" key="table.compDbcp"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="component-dbop" key="compDbcp.fdName"/>
		</td><td width="85%">
			<html:text property="fdName" style="width:90%;"/><span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="component-dbop" key="compDbcp.fdType"/>
		</td><td width="85%">
			<html:select property="fdType" onchange="typeChange(this);">
				<html:options collection="types" property="value"
					labelProperty="text" />
			</html:select>
			<span class="txtstrong">*</span>
			<bean:message  bundle="component-dbop" key="compDbcp.fdType.note"/>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15% id="fdDriverTitle">
			<bean:message  bundle="component-dbop" key="compDbcp.fdDriver"/>
		</td><td width="85%">
			<html:text property="fdDriver" style="width:90%;"  styleId="fdDriver"/><span class="txtstrong">*</span>
		</td>
	</tr>
	<tr id = "fdUrl_id">
		<td class="td_normal_title" width=15% >
			<bean:message  bundle="component-dbop" key="compDbcp.fdUrl"/>
		</td><td width="85%">
			<html:text property="fdUrl" style="width:90%;" styleId="fdUrl"/><span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="component-dbop" key="compDbcp.fdUsername"/>
		</td><td width="85%">
			<html:text property="fdUsername" style="width:90%;"/><span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="component-dbop" key="compDbcp.fdPassword"/>
		</td><td width="85%">
			<html:password property="fdPassword" style="width:90%;" styleClass="inputsgl"/><span class="txtstrong">*</span>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="component-dbop" key="compDbcp.fdDescription"/>
		</td>
		<td colspan=3 width=85%>
			<html:textarea property="fdDescription" style="width:95%"/><span class="txtstrong">*</span>
		</td>
	</tr>
</table>
</center>
<html:hidden property="method_GET"/>
</html:form>
<html:javascript formName="compDbcpForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
<%@ include file="/resource/jsp/edit_down.jsp"%>