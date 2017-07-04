<%-- 抄报 --%>
<%@page import="com.landray.kmss.sys.xform.base.service.controls.fieldlayout.SysFieldsParamsParse"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/km/imissive/fieldlayout/common/param_parser.jsp"%>
<%
    String fdReporttoIds = parse.getParamValue("fdReporttoIds");
    String fdReporttoNames = parse.getParamValue("fdReporttoNames");
    
    String defaultFdReporttoIds = parse.acquireValue("fdReporttoIds",fdReporttoIds);
    String defaultFdReporttoNames = parse.acquireValue("fdReporttoNames",fdReporttoNames);
    
    String line = parse.getParamValue("line");
    boolean isTextArea = line!=null&&line.equals("multi")?true:false;
	parse.addStyle("width", "control_width", "95%");
%>	
	<input type="hidden" name="fdMissiveReporttoIds" value="${kmImissiveSendMainForm.fdMissiveReporttoIds}">
    <input type="hidden" name="fdMissiveReporttoGroupIds" value="${kmImissiveSendMainForm.fdMissiveReporttoGroupIds}">
	<xform:dialog htmlElementProperties="id='reportUnit'" 
	              propertyId="fdReporttoIds"
	              propertyName="fdReporttoNames"
	              idValue="<%=defaultFdReporttoIds%>"
	              textarea="<%=isTextArea%>"
	              nameValue="<%=defaultFdReporttoNames%>"
		          style="<%=parse.getStyle()%>" 
		          required="<%=required%>"
		          subject="${ lfn:message('km-imissive:kmMissiveMainReportto.fdUnitId') }">  
	</xform:dialog>
	<script type="text/javascript">
	 function reportSelect(type) {
		 //alert("report---"+type);
		    if(type=="report"){
	    	Dialog_TreeList(
	    	    	false,
	    	        'fdReporttoIds',
	    	        'fdReporttoNames', 
	    	        ';', 
	    	        'kmImissiveUnitCategoryTreeService',
	    	        '<bean:message key="kmImissiveUnit.fdCategoryId" bundle="km-imissive"/>',
	    	        'kmImissiveUnitListWithAuthService&parentId=!{value}&type=report',
	    	        reportCalBackFn);
		    }else if(type=="distribute"){
		    	Dialog_TreeList(
		    	    	true,
		    	        'fdReporttoIds',
		    	        'fdReporttoNames', 
		    	        ';', 
		    	        'kmImissiveUnitAllCategoryTreeService',
		    	        '<bean:message key="kmImissiveUnit.fdCategoryId" bundle="km-imissive"/>',
		    	        'kmImissiveUnitListWithAuthService&parentId=!{value}&type=distribute',
		    	        reportCalBackFn);
			    
			}else{
		    	Dialog_TreeList(
		    	    	true,
		    	        'fdReporttoIds',
		    	        'fdReporttoNames',
		    	        ';', 
		    	        'kmImissiveUnitAllCategoryTreeService',
		    	        '<bean:message key="kmImissiveUnit.fdCategoryId" bundle="km-imissive"/>',
		    	        'kmImissiveUnitListWithAuthService&parentId=!{value}&type=all',
		    	        reportCalBackFn);
			    
			}
		}
		function reportCalBackFn(){
			var ids = document.getElementsByName("fdReporttoIds")[0].value;
			var fdMissiveReporttoIds = "";
			var fdMissiveReporttoGroupIds="";
			var idsArray = ids.split(";");
			for(var i=0;i<idsArray.length;i++){
				if(idsArray[i].indexOf("cate")>-1){
					fdMissiveReporttoGroupIds += idsArray[i].substring(0,idsArray[i].indexOf("cate")-1)+";";
				}else{
					fdMissiveReporttoIds += idsArray[i]+";";
				}
			}
			fdMissiveReporttoIds = fdMissiveReporttoIds.substring(0,fdMissiveReporttoIds.length-1);
			fdMissiveReporttoGroupIds = fdMissiveReporttoGroupIds.substring(0,fdMissiveReporttoGroupIds.length-1);
			document.getElementsByName("fdMissiveReporttoIds")[0].value = fdMissiveReporttoIds;
			document.getElementsByName("fdMissiveReporttoGroupIds")[0].value=fdMissiveReporttoGroupIds;
		}
	</script>
	
	
