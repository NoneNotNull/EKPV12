<div>
	<table border=0 cellpadding="0" cellspacing=0 width=100%><tr><td nowrap>
<sunbor:page name="queryPage"  
	rowsizeText="rowsizeText5" pagenoText="pagenoText5" textStyleClass="pagenav_input">

<%-- 
<sunbor:first><bean:message key="page.first"/></sunbor:first> &nbsp;&nbsp;
--%>
<sunbor:prev><bean:message key="page.prev"/></sunbor:prev>  &nbsp;&nbsp; 
<sunbor:next><bean:message key="page.next"/></sunbor:next> &nbsp;&nbsp;
<%-- 
<sunbor:last><bean:message key="page.last"/></sunbor:last> &nbsp;&nbsp;
--%>
</td><td align=right nowrap>
 
<bean:message key="page.the"/>&nbsp;{0}&nbsp;<bean:message key="page.page"/>&nbsp;&nbsp;
<bean:message key="page.total"/>&nbsp;{2}&nbsp;<bean:message key="page.page"/>&nbsp;&nbsp;
<%-- 
<bean:message key="page.rowPerPage"/>&nbsp;{8}&nbsp;<bean:message key="page.row"/>&nbsp;&nbsp;
<bean:message key="page.total"/>&nbsp;{3}&nbsp;<bean:message key="page.row"/>&nbsp;&nbsp;
--%>
<bean:message key="page.to"/><bean:message key="page.the"/>{9}<bean:message key="page.page"/>
<img src="${KMSS_Parameter_StylePath}icons/go.gif" border=0 title="<bean:message key="page.changeTo"/>"
 onclick="{10}" style="cursor:pointer">
</sunbor:page>
</td></tr></table>

</div>