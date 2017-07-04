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
		<%-- 主送 --%>
			<td class="td_normal_title" width=40%> <bean:message  bundle="km-imissive" key="kmImissiveMainMainto"/></td>
			<td>
			    <xform:dialog propertyId="fdMaintoIds"
			                  propertyName="fdMaintoNames"
			                  textarea="true"
					          style="width:95%" 
					          showStatus="edit"
					          htmlElementProperties="storage=true"
					          subject="${ lfn:message('km-imissive:kmMissiveMainMainto.fdUnitId') }">  
						      mainSelect();
				</xform:dialog>
	       </td>
	 </tr>
	 <%@ include file="/km/imissive/fieldlayout/common/param_bottom.jsp"%>
	</table>
	</form>
</body>
</html>
<script>
	function mainSelect() {
		/*var fdIsReportTo = document.getElementsByName("fdIsReportTo");
		if (fdIsReportTo[0].checked == true) {
			Dialog_TreeList(
					false,
					'fdMissiveMaintoIds',
					'fdMissiveMaintoNames',
					';',
					'kmMissiveUnitCategoryTreeService',
					'<bean:message key="kmImissiveUnit.fdCategoryId" bundle="km-imissive"/>',
					'kmMissiveUnitListService&parentId=!{value}');
		}
		if (fdIsReportTo[1].checked == true) {*/
			Dialog_TreeList(
	    	    	true,
	    	        'fdMaintoIds',
	    	        'fdMaintoNames', 
	    	        ';', 
	    	        'kmImissiveUnitAllCategoryTreeService',
	    	        '<bean:message key="kmImissiveUnit.fdCategoryId" bundle="km-imissive"/>',
	    	        'kmImissiveUnitListWithAuthService&parentId=!{value}&type=distribute');
		//}
	}
</script>