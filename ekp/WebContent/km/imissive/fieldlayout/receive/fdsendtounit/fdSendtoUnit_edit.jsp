<%-- 发文单位 --%>
<%@page import="com.landray.kmss.sys.xform.base.service.controls.fieldlayout.SysFieldsParamsParse"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/km/imissive/fieldlayout/common/param_parser.jsp"%>
<%parse.addStyle("width", "control_width", "45%");
  required = Boolean.parseBoolean(parse.getParamValue("control_required", "true"));%>
<div id="inner" style="display: inline">
	<xform:dialog 
	       propertyId="fdSendtoUnitId" 
	       propertyName="fdSendtoUnitName"
	       style="<%=parse.getStyle()%>" 
	       className="inputsgl"
	       required="<%=required%>" 
	       subject="${ lfn:message('km-imissive:kmImissiveReceiveMain.fdSendtoDept') }">
		   Dialog_TreeList(false, 'fdSendtoUnitId', 'fdSendtoUnitName', ';', 'kmImissiveUnitCategoryTreeService',
		                          '<bean:message key="kmImissiveUnit.fdCategoryId" bundle="km-imissive"/>', 
		                          'kmImissiveUnitListService&parentId=!{value}');
	</xform:dialog>
</div>
<div id="outer" style="display:none">
	<xform:text property="fdOutSendto" 
	            style="<%=parse.getStyle()%>" 
	            className="inputsgl"
	            required="<%=required%>" 
	            subject="${ lfn:message('km-imissive:kmImissiveReceiveMain.fdSendtoDept') }"/>			 
</div>
<input type="checkbox" id="outerUnit" onclick="SetIfRequired();"/><bean:message  bundle="km-imissive" key="kmImissiveReceiveMain.fdOutSendtoDept"/>
<script>
	function SetIfRequired(){
		var outerUnit=document.getElementById("outerUnit");
		var outer = document.getElementById("outer");
		var inner = document.getElementById("inner");
		var fdSendtoUnitId = document.getElementsByName("fdSendtoUnitId")[0];
		var fdSendtoUnitName = document.getElementsByName("fdSendtoUnitName")[0];
		var fdOutSendto = document.getElementsByName("fdOutSendto")[0];
		if(outerUnit.checked){
			 outer.style.display="inline";
			 inner.style.display="none";	
	         fdSendtoUnitId.value="";
	         fdSendtoUnitName.value="";	
	         //fdOutSendto.value="";
			document.getElementsByName("fdOutSendto")[0].setAttribute("validate","required maxLength(100)");
			document.getElementsByName("fdSendtoUnitName")[0].setAttribute("validate","");
			if(document.getElementById("advice-fdSendtoUnitName")){		
				document.getElementById("advice-fdSendtoUnitName").style.display="none";	
		    }
			var _validate_serial=fdSendtoUnitName.getAttribute("__validate_serial");
			if(document.getElementById('advice-'+_validate_serial)){		
				document.getElementById('advice-'+_validate_serial).style.display="none";	
			}
			
		}else{
			outer.style.display="none";
			inner.style.display="inline";
			//fdSendtoUnitId.value="";
			//fdSendtoUnitName.value="";	
			fdOutSendto.value="";
			document.getElementsByName("fdOutSendto")[0].setAttribute("validate","");
			document.getElementsByName("fdSendtoUnitName")[0].setAttribute("validate","required");
			if(document.getElementById("advice-fdOutSendto")){		
				document.getElementById("advice-fdOutSendto").style.display="none";	
		    }

			var _validate_serial=fdOutSendto.getAttribute("__validate_serial");
			if(document.getElementById('advice-'+_validate_serial)){		
				document.getElementById('advice-'+_validate_serial).style.display="none";	
			}
		}
	}
	Com_AddEventListener(window, "load", function() {
		var fdOutSendto = document.getElementsByName("fdOutSendto")[0];
		if(fdOutSendto.value!=null&&fdOutSendto.value!=""){
			document.getElementById("outerUnit").checked="true";
		}
		SetIfRequired();
		});
</script>