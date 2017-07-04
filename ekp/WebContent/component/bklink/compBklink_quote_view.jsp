<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<script>
Com_IncludeFile("docutil.js");
</script>
<div id="optBarDiv">
	<input type="button" value="<bean:message key="button.close"/>"
		onclick="Com_CloseWindow();">
</div>
<center>
<div style="height:480px;width:95%;position:relative;overflow:auto;z-index:10px;">
	<table id = "id_table" class="tb_normal" width="100%">
		<tbody id = "id_table_tbody">
		</tbody>
	
	</table>
</div>	
</center>
<script type="text/javascript">
var quoteModelJosin = window.window.dialogArguments;
var indexValue = ${param.indexValue};
var quoteModelList = quoteModelJosin['index_'+indexValue];
var table,tableHead,tableBody,row,cell,textNode,href;
table = document.getElementById("id_table");
tableHead = document.getElementById("id_table_thead");
tableBody = document.getElementById("id_table_tbody");
row = document.createElement("<tr align=\"center\">");
cell = document.createElement("<td class=\"td_normal_title\">");
textNode = document.createTextNode("<bean:message bundle='component-bklink' key='compBklink.quote.document.list'/>");
cell.appendChild(textNode);
row.appendChild(cell);
cell = document.createElement("<td class=\"td_normal_title\">");
textNode = document.createTextNode("<bean:message bundle='component-bklink' key='compBklink.docCreator'/>");
cell.appendChild(textNode);
row.appendChild(cell);
cell = document.createElement("<td class=\"td_normal_title\">");
textNode = document.createTextNode("<bean:message bundle='component-bklink' key='compBklink.docCreateTime'/>");
cell.appendChild(textNode);
row.appendChild(cell);
tableBody.appendChild(row);
for(var i =0; i < quoteModelList.length; i++){
	var tempObj = quoteModelList[i];
	row = document.createElement("<tr align=\"center\">");
	cell = document.createElement("<td style=\"cursor: pointer;\" width=\"50%\">");
	var fdLinkHref = '${KMSS_Parameter_ContextPath}'+ tempObj['fdLinkHref'].substring(2,tempObj['fdLinkHref'].lastIndexOf('\''));
	href = document.createElement("<a href=\""+fdLinkHref+"\" >");
	textNode = document.createTextNode(tempObj['fdIntroduction']);
	href.appendChild(textNode);
	cell.appendChild(href);
	row.appendChild(cell);
	cell = document.createElement("<td width=\"20%\">");
	textNode = document.createTextNode(tempObj['docCreator']);
	cell.appendChild(textNode);
	row.appendChild(cell);
	cell = document.createElement("<td width=\"30%\>");
	textNode = document.createTextNode(tempObj['docCreateTime']);
	cell.appendChild(textNode);
	row.appendChild(cell);
	tableBody.appendChild(row);
}
</script>
<%@ include file="/resource/jsp/view_down.jsp"%>