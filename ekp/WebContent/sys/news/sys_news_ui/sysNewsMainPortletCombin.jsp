<%@ include file="/sys/ui/jsp/common.jsp"%>
<ui:ajaxtext>
<%String rate=request.getParameter("rate");  
  pageContext.setAttribute("rate",rate+"%");
%>
	<table width="100%" height="100%" data-lui-mark='panel.dataview.height'>
		   <tr>
			    <td width="${rate}" valign="top">
				  <ui:dataview>
					    <ui:source type="AjaxXml">
						     {"url":"/sys/common/dataxml.jsp?s_bean=sysNewsMainPortletService&cateid=${param.cateid}&rowsize=${param.rowsize_image}&type=pic&scope=${param.scope}"}
					    </ui:source>
					    <ui:render ref="sys.ui.slide.default" var-stretch="${param.stretch}">
					    </ui:render>
				 </ui:dataview>
			  </td>
			   <td valign="top">
			     <ui:dataview format="sys.ui.classic">
					  	 <ui:source type="AjaxXml">
						   	 {"url":"/sys/common/dataxml.jsp?s_bean=sysNewsMainPortletService&cateid=${param.cateid}&rowsize=${param.rowsize_text }&type=!{type}&scope=${param.scope}"}
						 </ui:source>
						  <ui:render ref="sys.ui.classic.default" var-showCreator="${param.showCreator}" var-showCreated="${param.showCreated}"
						                                          var-highlight="${param.highlight}"   var-target="${param.target}"
						                                          var-showCate="${param.showCate}" var-cateSize="${param.cateSize}" var-newDay="${param.newDay}">
					     </ui:render>
			    </ui:dataview>
		      </td>
		 </tr>
	  </table>
</ui:ajaxtext>