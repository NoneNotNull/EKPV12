<%@ include file="/sys/ui/jsp/common.jsp"%>
<ui:ajaxtext>
<%String width=request.getParameter("width");
  String height=request.getParameter("height");
  request.setAttribute("height",height+"px");
  request.setAttribute("width",width+"px");
%>
    <ui:dataview>
		<ui:source type="AjaxXml">
			  {"url":"/sys/common/dataxml.jsp?s_bean=sysNewsMainPortletService&type=pic&cateid=${param.cateid}&rowsize=${param.rowsize}&scope=${param.scope}"}
		</ui:source>
	    <ui:render type="Template">
	    {$<ul>$}
		     for(var i=0;i<data.length;i++){
			    {$<li style="display:table;margin-bottom: 12px;"><div> $}
			       {$
				       <div style="font-weight: bold;cursor:pointer">
				         <a href="{%env.fn.formatUrl(data[i].href)%}" target="_blank"><p style="font-size:14px;">{%env.fn.formatText(data[i].text)%}</p></a>
				       </div>
			          <div style="line-height: 1.5;padding-top:5px">
					     <a href="{%env.fn.formatUrl(data[i].href)%}" target="_blank"> <image src="{%env.fn.formatUrl(data[i].image)%}" 
					       style="float:left;padding-right:6px" height="${height}" width="${width}"/></a>
						 <span style="padding-left: 5px" >{%env.fn.formatText(data[i].description)%}</span>
				      </div>
				      <div style="text-align: right">
				         <span>{%env.fn.formatText(data[i].creator)%} | {%data[i].created%}</span>
				       </div>
				    $}
			  {$</div></li>$}
			 }
		 {$</ul>$}
	   </ui:render>
   </ui:dataview>
</ui:ajaxtext>