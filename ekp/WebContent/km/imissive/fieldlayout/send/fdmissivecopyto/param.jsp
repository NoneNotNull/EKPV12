<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<script type="text/javascript">
	Com_IncludeFile("document.js", "style/" + Com_Parameter.Style + "/doc/");
	Com_IncludeFile("jquery.js");
	Com_IncludeFile('json2.js');
	Com_IncludeFile('dialog.js');
</script>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
</head>
<body>
	<form>
	<table class="tb_normal"  width=95%>
	    <%@ include file="/km/imissive/fieldlayout/common/param_top.jsp"%>
	     <c:import url="/km/imissive/fieldlayout/common/param_required.jsp" charEncoding="UTF-8">
				  <c:param name="defaultChecked" value="false" />
		 </c:import>
		 <c:import url="/km/imissive/fieldlayout/common/param_width.jsp" charEncoding="UTF-8">
				  <c:param name="defaultWidth" value="95%" />
		 </c:import>
		 <%@ include file="/km/imissive/fieldlayout/common/param_line.jsp"%>
		<tr>
		<%-- 抄送 --%>
			<td class="td_normal_title" width=40%> <bean:message  bundle="km-imissive" key="kmImissiveMainCopyto"/></td>
			<td> 
			    <xform:dialog propertyId="fdCopytoIds"
			                  propertyName="fdCopytoNames"
			                  textarea="true"
					          style="width:95%" 
					          showStatus="edit"
					          htmlElementProperties="storage=true"
					          subject="${ lfn:message('km-imissive:kmMissiveReportto.fdUnitId') }">  
						      Dialog_TreeList(
						    	    	true,
						    	        'fdCopytoIds',
						    	        'fdCopytoNames', 
						    	        ';', 
						    	        'kmImissiveUnitAllCategoryTreeService',
						    	        '<bean:message key="kmImissiveUnit.fdCategoryId" bundle="km-imissive"/>',
						    	        'kmImissiveUnitListWithAuthService&parentId=!{value}&type=distribute')
				</xform:dialog>
	       </td>
	 </tr>
	 <%@ include file="/km/imissive/fieldlayout/common/param_bottom.jsp"%>
	</table>
	</form>
</body>
</html>
<script>
</script>