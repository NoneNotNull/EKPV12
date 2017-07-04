<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script type="text/javascript">
Com_IncludeFile("optbar.js|list.js");
</script>
<script>
 function expandMethod(imgSrc,divSrc) {
	var imgSrcObj = document.getElementById(imgSrc);
	var divSrcObj = document.getElementById(divSrc);
	if(divSrcObj.style.display!=null && divSrcObj.style.display!="") {
		divSrcObj.style.display = "";
		imgSrcObj.src = "${KMSS_Parameter_StylePath}icons/collapse.gif";
	}else{
		divSrcObj.style.display = "none";
		imgSrcObj.src = "${KMSS_Parameter_StylePath}icons/expand.gif";		
	}
 }

 List_TBInfo = new Array(
			{TBID:"List_ViewTable1"},{TBID:"List_ViewTable2"},{TBID:"List_ViewTable3"}
		);
</script>

<div id="optBarDiv"><input type="button"
	value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>

<p class="txttitle">${param.name}<bean:message bundle="tib-sys-sap-connector" key="tibSysSapWebservice.serverInterfaceExplain"/></p>
<center>
<table class="tb_normal" width=95%>
	<tr>
		<td class="td_normal_title" width=15%><bean:message bundle="tib-sys-sap-connector" key="tibSysSapWebservice.serverInterface"/></td>
		<td width="85%">
		<pre class="prettyprint java">
	    Object SapJsonWebservice(String RFCName, String jsonParams) throws Exception
		</pre>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%><bean:message bundle="tib-sys-sap-connector" key="tibSysSapWebservice.functionDesc"/></td>
		<td width="85%"><bean:message bundle="tib-sys-sap-connector" key="tibSysSapWebservice.jsonFormatParam"/></td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%><bean:message bundle="tib-sys-sap-connector" key="tibSysSapWebservice.returnValue"/></td>
		<td width="85%"><bean:message bundle="tib-sys-sap-connector" key="tibSysSapWebservice.returnSapJson"/></td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%><bean:message bundle="tib-sys-sap-connector" key="tibSysSapWebservice.interfaceParam"/></td>
		<td width="85%"><img id="viewSrc1"
			src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
			onclick="expandMethod('viewSrc1','paramDiv1')" style="cursor: hand"><br>
		<div id="paramDiv1" style="display:none">
		<table id="List_ViewTable1" class="tb_noborder">
			<tr>
				<sunbor:columnHead htmlTag="td">
					<td width="40pt"><bean:message bundle="tib-sys-sap-connector" key="tibSysSapWebservice.serialNumber"/></td>
				    <td width="20%"><bean:message bundle="tib-sys-sap-connector" key="tibSysSapWebservice.attributeName"/></td>
				    <td width="20%"><bean:message bundle="tib-sys-sap-connector" key="tibSysSapWebservice.type"/></td>
				    <td width="10%"><bean:message bundle="tib-sys-sap-connector" key="tibSysSapWebservice.defaultValue"/></td>
				    <td width="50%"><bean:message bundle="tib-sys-sap-connector" key="tibSysSapWebservice.desc"/></td>
				</sunbor:columnHead>
			</tr>
			<tr>
				<td align="center">1</td>
				<td>RFCName</td>
				<td><bean:message bundle="tib-sys-sap-connector" key="tibSysSapWebservice.string"/></td>
				<td><bean:message bundle="tib-sys-sap-connector" key="tibSysSapWebservice.not"/></td>
				<td><bean:message bundle="tib-sys-sap-connector" key="tibSysSapWebservice.moduleConfigFuncName"/> </td>
			</tr>
			<tr>
				<td align="center">2</td>
				<td>jsonParams</td>
				<td><bean:message bundle="tib-sys-sap-connector" key="tibSysSapWebservice.string"/></td>
				<td><bean:message bundle="tib-sys-sap-connector" key="tibSysSapWebservice.not"/></td>
				<td><bean:message bundle="tib-sys-sap-connector" key="tibSysSapWebservice.jsonFormatString"/></td>
			</tr>
		</table></div>
		</td>
	</tr>
	<tr>
		<td class="td_normal_title" width=15%><bean:message bundle="tib-sys-sap-connector" key="tibSysSapWebservice.inputParamExplain"/></td>
		<td width="35%">
		<img id="importjson"
			src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
			onclick="expandMethod('importjson','importjsonDiv')" style="cursor: hand"><br>
		<div id="importjsonDiv" style="display:none">
		<pre class="prettyprint js">
	var data ={
	//传入参数
	importParams : {
		//字段名
		field1 : 'aa',
		field2 : 2,
		//结构体
		structure : {
			field1 : 1,
			field2 : 'BB'
		}
	},
	//传入内表参数
	importTables : {
		//内表名1
		tableName1 : [{
					field1 : 1,
					field2 : 2
				}],
		//内表名	2	
		tableName2 : [{
					field1 : 1,
					field2 : 2
				}, {
					field1 : 1,
					field2 : 2
				}]
	}
}
		 </pre>
		 </div>
		</td>
	</tr>	
	<tr>
		<td class="td_normal_title" width=15%><bean:message bundle="tib-sys-sap-connector" key="tibSysSapWebservice.returnParamJsonExplain"/></td>
		<td width="85%">
		<img id="viewSrc2"
			src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
			onclick="expandMethod('viewSrc2','paramDiv2')" style="cursor: hand"><br>
		<div id="paramDiv2" style="display:none">
		<pre class="prettyprint js">
     var data = {
	RFC_ISSUCCESS : 1,
	RFC_RETURN :'<bean:message bundle="tib-sys-sap-connector" key="tibSysSapWebservice.bapiFuncXmlData"/>'}//不同的bapi返回数据不一样
   </pre>
		</div>
		</td>
	</tr>
		<td class="td_normal_title" width=15%><bean:message bundle="tib-sys-sap-connector" key="tibSysSapWebservice.referenceCode"/></td>
		<td width="35%">
		<img id="viewcode"
			src="${KMSS_Parameter_StylePath}icons/expand.gif" border="0"
			onclick="expandMethod('viewcode','codediv')" style="cursor: hand"><br>
			
             <div id="codediv" width="100%" height="100%">
             <pre class="prettyprint java">
        public static void main(String args[]) throws java.lang.Exception {
		//URL wsdlURL = ISapWebServiceService.WSDL_LOCATION;
		//webservice url
		URL wsdlURL = new URL("http://127.0.0.1:8080/SAP2/sys/webservice/sapWebService?wsdl");
		if (args.length > 0 && args[0] != null && !"".equals(args[0])) {
			File wsdlFile = new File(args[0]);
			try {
				if (wsdlFile.exists()) {
					wsdlURL = wsdlFile.toURI().toURL();
				} else {
					wsdlURL = new URL(args[0]);
				}
			} catch (MalformedURLException e) {
				e.printStackTrace();
			}
		}
		ISapWebServiceService ss = new ISapWebServiceService(wsdlURL,
				SERVICE_NAME);
		ISapWebService port = ss.getISapWebServicePort();
		{
			System.out.println("Invoking sapJsonWebservice...");
			//RFCName
			java.lang.String _sapJsonWebservice_arg0 = "<bean:message bundle="tib-sys-sap-connector" key="tibSysSapWebservice.empExamineFlowInterface"/>";
			//jsonParams拼装传入参数
			java.lang.Object _sapJsonWebservice_arg1 = "{'importParams':{},'importTables':{'TB_VACATION_APPLY':[{'OAACT':'liangjz','PERNR':'','AWART':'e002','BEGDA':'20121212','ENDDA':'20121213','STDAZ':'5'}]}}";

			try {
				java.lang.Object _sapJsonWebservice__return = port
						.sapJsonWebservice(_sapJsonWebservice_arg0,
								_sapJsonWebservice_arg1);
				System.out.println("sapJsonWebservice.result="
						+ _sapJsonWebservice__return);

			} catch (Exception_Exception e) {
				System.out
						.println("Expected exception: Exception has occurred.");
				System.out.println(e.toString());
			}
		}
		System.exit(0);
	}
             </pre>
             </div>
        </td>
	</tr>	
</table>
</center>


<%@ include file="/resource/jsp/view_down.jsp"%>