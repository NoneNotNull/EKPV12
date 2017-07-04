<%@page import="com.landray.kmss.sys.xform.base.service.controls.fieldlayout.SysFieldsParamsParse"%>
<%@page import="com.landray.kmss.util.ResourceUtil"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/htmlhead.jsp" %>
<script type="text/javascript">
	Com_IncludeFile("document.js", "style/" + Com_Parameter.Style + "/doc/");
	Com_IncludeFile("jquery.js");
	Com_IncludeFile('json2.js');
	Com_IncludeFile('dialog.js');
	Com_IncludeFile("validator.jsp|validation.js|validation.jsp|xform.js");
</script>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
</head>
<body>
<form>
	<table class="tb_normal"  width=95%>
	  <%@ include file="/km/imissive/fieldlayout/common/param_top.jsp"%>
	  <tr>
			<td class="td_normal_title" width=25%>${lfn:message('km-imissive:kmMissiveSendTemplate.fdTableHead')}</td>
			<td>
			    <xform:textarea property="fdTableHead" 
			                    showStatus="edit"
			                    style="width:95%" 
			                    required="true" 
			                    validators="maxLength(200)" 
			                    htmlElementProperties="storage=true"
			                    subject="${lfn:message('km-imissive:kmMissiveSendTemplate.fdTableHead')}">
			    </xform:textarea>
			</td>
	  </tr>
	  <%@ include file="/km/imissive/fieldlayout/common/param_bottom.jsp"%>
	  <script>
			  $KMSSValidation();
			  function checkOK(){
				//提交表单校验
					for(var i=0; i<Com_Parameter.event["submit"].length; i++){
						if(!Com_Parameter.event["submit"][i]()){
							return false;
						}
					}
				//提交表单消息确认
					for(var i=0; i<Com_Parameter.event["confirm"].length; i++){
						if(!Com_Parameter.event["confirm"][i]()){
							return false;
						}
					}
					return true;
			  }
      </script>
	</table>
	</form>
</body>
</html>
