<%-- 抄送--%>
<%@page import="com.landray.kmss.sys.xform.base.service.controls.fieldlayout.SysFieldsParamsParse"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/km/imissive/fieldlayout/common/param_parser.jsp"%>
<%
    String fdCopytoIds = parse.getParamValue("fdCopytoIds");
    String fdCopytoNames = parse.getParamValue("fdCopytoNames");
    
    String defaultFdCopytoIds = parse.acquireValue("fdCopytoIds",fdCopytoIds);
    String defaultFdCopytoNames = parse.acquireValue("fdCopytoNames",fdCopytoNames);
    
    String line = parse.getParamValue("line");
    boolean isTextArea = line!=null&&line.equals("multi")?true:false;
	parse.addStyle("width", "control_width", "95%");
%>	
	<input type="hidden" name="fdMissiveCopytoIds" value="${kmImissiveSendMainForm.fdMissiveCopytoIds}">
    <input type="hidden" name="fdMissiveCopytoGroupIds" value="${kmImissiveSendMainForm.fdMissiveCopytoGroupIds}">
	<xform:dialog htmlElementProperties="id='copyUnit'" 
	              propertyId="fdCopytoIds"
	              propertyName="fdCopytoNames"
	              textarea="<%=isTextArea%>"
	              idValue="<%=defaultFdCopytoIds%>"
	              nameValue="<%=defaultFdCopytoNames%>"
		          style="<%=parse.getStyle()%>" 
		          required="<%=required%>"
		          subject="${ lfn:message('km-imissive:kmMissiveReportto.fdUnitId') }">  
	</xform:dialog>
	 <script type="text/javascript">
	 
	 function copySelect(type) {
		// alert("copy---"+type);
		    if(type=="report"){
	    	Dialog_TreeList(
	    	    	false,
	    	        'fdCopytoIds',
	    	        'fdCopytoNames', 
	    	        ';', 
	    	        'kmImissiveUnitCategoryTreeService',
	    	        '<bean:message key="kmImissiveUnit.fdCategoryId" bundle="km-imissive"/>',
	    	        'kmImissiveUnitListWithAuthService&parentId=!{value}&type=report',
	    	        copyCalBackFn);
		    }else if(type=="distribute"){
		    	Dialog_TreeList(
		    	    	true,
		    	        'fdCopytoIds',
		    	        'fdCopytoNames', 
		    	        ';', 
		    	        'kmImissiveUnitAllCategoryTreeService',
		    	        '<bean:message key="kmImissiveUnit.fdCategoryId" bundle="km-imissive"/>',
		    	        'kmImissiveUnitListWithAuthService&parentId=!{value}&type=distribute',
		    	        copyCalBackFn);
			    
			}else{
		    	Dialog_TreeList(
		    	    	true,
		    	        'fdCopytoIds',
		    	        'fdCopytoNames', 
		    	        ';', 
		    	        'kmImissiveUnitAllCategoryTreeService',
		    	        '<bean:message key="kmImissiveUnit.fdCategoryId" bundle="km-imissive"/>',
		    	        'kmImissiveUnitListWithAuthService&parentId=!{value}&type=all',
		    	        copyCalBackFn);
			}
		}

	 
	    function copyCalBackFn(){
			var ids = document.getElementsByName("fdCopytoIds")[0].value;
			var fdMissiveCopytoIds = "";
			var fdMissiveCopytoGroupIds="";
			var idsArray = ids.split(";");
			for(var i=0;i<idsArray.length;i++){
				if(idsArray[i].indexOf("cate")>-1){
					fdMissiveCopytoGroupIds += idsArray[i].substring(0,idsArray[i].indexOf("cate")-1)+";";
				}else{
					fdMissiveCopytoIds += idsArray[i]+";";
				}
			}
			fdMissiveCopytoIds = fdMissiveCopytoIds.substring(0,fdMissiveCopytoIds.length-1);
			fdMissiveCopytoGroupIds = fdMissiveCopytoGroupIds.substring(0,fdMissiveCopytoGroupIds.length-1);
			document.getElementsByName("fdMissiveCopytoIds")[0].value = fdMissiveCopytoIds;
			document.getElementsByName("fdMissiveCopytoGroupIds")[0].value=fdMissiveCopytoGroupIds;
		}
    </script>
