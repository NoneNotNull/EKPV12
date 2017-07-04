<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
{$
	<p class="lui_category_location">
		${lfn:message('sys-ui:ui.category.current.select')}$}
			var data = layout.parent.data;
            for(var i=0;i<data.length;i++){
            	var len = data[i].length;
            	if(data[i][0] && data[i][0].nodeType!='category'&& data[i][0].nodeType!=true){
	            	for(var j=len-1;j>=0;j--){
	            		{$
		      		          {%data[i][j].text%}
		            	$}
			            	if(j>0){
		         				{$ &gt;$}
		           			}
	            	}
            	}
            	if(i < data.length-1){
            		{$ ;&nbsp;$}
            	}
            }                    
{$                                
	</p>
$}
