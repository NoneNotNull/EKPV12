<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.tib.soap.sync.model.ClocalVo"%>
<%@page import="java.util.Set"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/view_top.jsp"%>

<div id="optBarDiv">
	<input type="button" value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>

<p class="txttitle">
	<bean:message bundle="tib-soap-sync" key="table.tibSoapSyncJob" />
</p>
<script type="text/javascript">
Com_IncludeFile("jquery.js|list.js");
</script>

<script type="text/javascript">
function edition_LoadIframe(index,tableName,dbID,tempId){
	var iframe = document.getElementById("editionContent"+index).getElementsByTagName("IFRAME")[0];

	if($(iframe).attr("src").length<1){
	    var src=Com_Parameter.ContextPath+"tib/soap/sync/tib_soap_sync_temp_func/tibSoapSyncTempFunc.do?method=listDStable&tableName="+tableName+"&dbID="+dbID+"&tempId="+tempId;
		$(iframe).attr("src",src);
	}
}

</script>
<center>
	<%
		Set<ClocalVo> list = (Set<ClocalVo>) request.getAttribute("result");
		int size = list.size();
	%>
	<c:if test="<%=size==0%>">
		<%@ include file="/resource/jsp/list_norecord.jsp"%>
	</c:if>
	<c:if test="<%=size>0%>">
		<table id="Label_Tabel" width=100%>
		   
		   	<logic:iterate id="clocal" name="result"  indexId="index">
		
			<tr LKS_LabelName="<bean:write name="clocal" property="tableName" />" style="display:none">
				<td>
					<table class="tb_normal" width=100%>
						<tr>
							<td  id="editionContent${index}"  onresize="edition_LoadIframe('${index}',' ${clocal.tableName}','${clocal.dsID }','${clocal.tempfuncId }');">
							
					<iframe src="" width=100% height="400" frameborder=0 scrolling="auto">
					</iframe>
				</td>
						</tr>
					</table></td>
			</tr>
			
			</logic:iterate>
			
			
		</table>
	</c:if>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
