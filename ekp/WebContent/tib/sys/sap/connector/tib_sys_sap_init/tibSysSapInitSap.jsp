<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<table class="tb_normal" width="100%" style="display:none;" id="sap">
	<!-- SAP -->
	<tr>
	    <td class="td_normal_title" width=15%>
	       <bean:message bundle="tib-sys-sap-connector" key="init.fdPool"/>
	    </td>
		<td width="35%">
			<xform:select property="fdPoolId" style="float: left;" showStatus="edit" value="${fdPoolId }">
				<xform:beanDataSource serviceBean="tibSysSapJcoSettingService"
									selectBlock="fdId,fdPoolName" orderBy="" />
			</xform:select>
	    </td>
	    <td  width="50%">
		  	<input type="button" title="<bean:message bundle='tib-sys-sap-connector' key='init.configServer'/>" 
				value="<bean:message bundle='tib-sys-sap-connector' key='init.configServer'/>"
			    onclick="tibSapInitFunction(1);" class="btnopt"/>&nbsp;
	        <input type="button" title="<bean:message bundle="tib-sys-sap-connector" key="init.configJCOPools"/>" 
				value="<bean:message bundle="tib-sys-sap-connector" key="init.configJCOPools"/>"
	         	onclick="tibSapInitFunction(2);" class="btnopt"/> 
	   </td>
	</tr>
	
</table>
<iframe id='iframeResult' style="display:none;"  name="iframeName" width=100% 
  	height="380px" src="" frameborder=0  marginheight="0"> </iframe>
<script language="JavaScript">
$(document).ready(function(){
	$("input:radio[name=moduleType]").click(function(){
		 var selectValue= $("input:radio[name='moduleType']:checked").val();
	     if(selectValue!="sap"){
		 	 $("#iframeResult").hide();
		 }
	});
});


function  tibSapInitFunction(type){
    if(type=='1'){
	   url="<c:url value='/tib/sys/sap/connector/tib_sys_sap_server_setting/tibSysSapServerSetting.do'/>?method=add";
	}else if(type=='2'){
	   url="<c:url value='/tib/sys/sap/connector/tib_sys_sap_jco_setting/tibSysSapJcoSetting.do' />?method=add";
    }
    $("#iframeResult").attr("src",url);
    $("#iframeResult").show();
    //$(window.frames["iframeName"].document).find("#_save").css("display","");
 }
</script>