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
				  <c:param name="defaultWidth" value="45%" />
		   </c:import>
			<tr>
			<%-- 默认核稿人--%>
				<td class="td_normal_title" width=40%>${lfn:message('km-imissive:kmImissiveSignMain.fdCheckId')}</td>
				<td>
				   <xform:address 
				            isLoadDataDict="false"
				            htmlElementProperties="storage=true"
				            showStatus="edit"
							style="width:85%"
							subject="${lfn:message('km-imissive:kmImissiveSignMain.fdCheckId')}"
							propertyId="fdCheckerId" propertyName="fdCheckerName"
							orgType='ORG_TYPE_PERSON' className="input">
				   </xform:address>
		       </td>
		 </tr>
		 <%@ include file="/km/imissive/fieldlayout/common/param_bottom.jsp"%>
		</table>
	</form>
</body>
</html>
