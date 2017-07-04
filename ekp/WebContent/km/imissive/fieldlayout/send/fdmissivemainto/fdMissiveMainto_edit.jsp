<%-- 主送 --%>
<%@page import="com.landray.kmss.sys.xform.base.service.controls.fieldlayout.SysFieldsParamsParse"%>
<%@page import="com.landray.kmss.util.StringUtil"%>
<%@page import="java.util.Map"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<%@ include file="/km/imissive/fieldlayout/common/param_parser.jsp"%>
<%
    String fdMaintoIds = parse.getParamValue("fdMaintoIds");
    String fdMaintoNames = parse.getParamValue("fdMaintoNames");
    
    String defaultFdMaintoIds = parse.acquireValue("fdMaintoIds",fdMaintoIds);
    String defaultFdMaintoNames = parse.acquireValue("fdMaintoNames",fdMaintoNames);
        
    String line = parse.getParamValue("line");
    boolean isTextArea = line!=null&&line.equals("multi")?true:false;
	parse.addStyle("width", "control_width", "95%");
%>	
    <div style="display: inline">
    <input type="hidden" name="fdMissiveMaintoIds" value="${kmImissiveSendMainForm.fdMissiveMaintoIds}">
    <input type="hidden" name="fdMissiveMaintoGroupIds" value="${kmImissiveSendMainForm.fdMissiveMaintoGroupIds}">
    <xform:dialog htmlElementProperties="id='mainUnit'"
                  propertyId="fdMaintoIds"
				  textarea="<%=isTextArea%>"
	              propertyName="fdMaintoNames"
	              idValue="<%=defaultFdMaintoIds%>"
	              nameValue="<%=defaultFdMaintoNames%>"
		          style="<%=parse.getStyle()%>"
		          required="<%=required%>"
		          subject="${ lfn:message('km-imissive:kmMissiveMainMainto.fdUnitId') }">  
	</xform:dialog><input name="fdAutoDeliver" type="hidden" value="0">
	<div id="deliverDiv"></div>
	</div>
    <script type="text/javascript">
    $(document).ready(function(){
	    changeMissiveType("${kmImissiveSendMainForm.fdMissiveType}");
    });
    function changeVal(obj){
        if(obj.checked){
        	document.getElementsByName("fdAutoDeliver")[0].value="1";
        }else{
        	document.getElementsByName("fdAutoDeliver")[0].value="0";
        }
    }
    function changeMissiveType(value){
        //切换类型的时候清空单位，避免权限问题
        //做空判断，避免字段为非必选
        if("${kmImissiveSendMainForm.method_GET}"=="add"){
	    	if(document.getElementsByName("fdMaintoIds").length>0){
		    	document.getElementsByName("fdMissiveMaintoIds")[0].value = "";
		    	document.getElementsByName("fdMissiveMaintoGroupIds")[0].value="";
		    	document.getElementsByName("fdMaintoIds")[0].value = "";
		    	document.getElementsByName("fdMaintoNames")[0].value="";
	    	}
	    	//做空判断，避免字段为非必选
	    	if(document.getElementsByName("fdCopytoIds").length>0){
	    	document.getElementsByName("fdMissiveCopytoIds")[0].value = "";
	    	document.getElementsByName("fdMissiveCopytoGroupIds")[0].value="";
	    	document.getElementsByName("fdCopytoIds")[0].value = "";
	    	document.getElementsByName("fdCopytoNames")[0].value="";
	    	}
	    	//做空判断，避免字段为非必选
	    	if(document.getElementsByName("fdReporttoIds").length>0){
		    	document.getElementsByName("fdMissiveReporttoIds")[0].value = "";
		    	document.getElementsByName("fdMissiveReporttoGroupIds")[0].value="";
		    	document.getElementsByName("fdReporttoIds")[0].value = "";
		    	document.getElementsByName("fdReporttoNames")[0].value="";
	    	}
        }
    	 var fdMissiveType = document.getElementsByName("fdMissiveType");
    	 if(document.getElementsByName("fdMaintoIds").length>0){
    	   $("#mainUnit").parent().parent().unbind("click"); //移除click
    	 }
    	 if(document.getElementsByName("fdCopytoIds").length>0){
    	   $("#copyUnit").parent().parent().unbind("click"); //移除click
    	 }
    	//抄报非必选字典，做空判断
     	if(document.getElementsByName("fdReporttoIds").length>0){
    	  $("#reportUnit").parent().parent().unbind("click"); //移除click
     	}
    	 if(fdMissiveType.length==0){
    		    document.getElementsByName("fdAutoDeliver")[0].value="0";
    		    if(document.getElementsByName("fdMaintoIds").length>0){
	    			$("#mainUnit").parent().parent().click(function(){
	         			mainSelect('all');
	             	});
    		    }
    		    if(document.getElementsByName("fdCopytoIds").length>0){
	         		$("#copyUnit").parent().parent().click(function(){
	         			copySelect('all');
	             	});
    		    }
         		//抄报非必选字典，做空判断
            	if(document.getElementsByName("fdReporttoIds").length>0){
	         		$("#reportUnit").parent().parent().click(function(){
	         			reportSelect('all');
	             	});
            	}
         		$("#deliverDiv").html("");
             	return;
    	 }else{
           	 if(value =="0" || value==""){
           		document.getElementsByName("fdAutoDeliver")[0].value="0";
           		if(document.getElementsByName("fdMaintoIds").length>0){
            		$("#mainUnit").parent().parent().click(function(){
            			mainSelect('all');
                	});
           		}
           		 if(document.getElementsByName("fdCopytoIds").length>0){
            		$("#copyUnit").parent().parent().click(function(){
            			copySelect('all');
                	});
           		 }
           		//抄报非必选字典，做空判断
              	if(document.getElementsByName("fdReporttoIds").length>0){
            		$("#reportUnit").parent().parent().click(function(){
            			reportSelect('all');
                	});
              	}
           		$("#deliverDiv").html("");
             	    return;
                }
               if( value=="1"){
              	 //默认自动分发
              	 document.getElementsByName("fdAutoDeliver")[0].value="1";
                   var html='<input type="checkbox" name="isAuto" onchange="changeVal(this);" checked>自动分发';
                   if(document.getElementsByName("fdMaintoIds").length>0){
               	 $("#mainUnit").parent().parent().click(function(){
            			mainSelect('distribute');
                	 });
                   }
              	 if(document.getElementsByName("fdCopytoIds").length>0){
               	 $("#copyUnit").parent().parent().click(function(){
               		 copySelect('distribute');
                 	 });
              	 }
              	//抄报非必选字典，做空判断
               	if(document.getElementsByName("fdReporttoIds").length>0){
               	 $("#reportUnit").parent().parent().click(function(){
               		 reportSelect('distribute');
                 	 });
               	}
              	 $("#deliverDiv").html(html);
              	 return;
                }
               if( value=="2"){
                   //默认自动上报
              	 document.getElementsByName("fdAutoDeliver")[0].value="1";
              	 var html='<input type="checkbox" name="isAuto" onchange="changeVal(this);" checked>自动上报';
              	 if(document.getElementsByName("fdMaintoIds").length>0){
               	 $("#mainUnit").parent().parent().click(function(){
            			mainSelect('report');
                  	 });
              	 }
              	 if(document.getElementsByName("fdCopytoIds").length>0){
               	 $("#copyUnit").parent().parent().click(function(){
               		 copySelect('report');
                 	 });
              	 }
              	//抄报非必选字典，做空判断
               	if(document.getElementsByName("fdReporttoIds").length>0){
               	$("#reportUnit").parent().parent().click(function(){
               		 reportSelect('report');
                 	});
               	}
              	 $("#deliverDiv").html(html);
              	 return;
               }
          } 
        }
       
	    function mainSelect(type) {
	    	//alert("main---"+type);
		    if(type=="report"){
	    	Dialog_TreeList(
	    	    	false,
	    	        'fdMaintoIds',
	    	        'fdMaintoNames', 
	    	        ';', 
	    	        'kmImissiveUnitCategoryTreeService',
	    	        '<bean:message key="kmImissiveUnit.fdCategoryId" bundle="km-imissive"/>',
	    	        'kmImissiveUnitListWithAuthService&parentId=!{value}&type=report',
	    	        mainCalBackFn);
		    }else if(type=="distribute"){
		    	Dialog_TreeList(
		    	    	true,
		    	        'fdMaintoIds',
		    	        'fdMaintoNames', 
		    	        ';', 
		    	        'kmImissiveUnitAllCategoryTreeService',
		    	        '<bean:message key="kmImissiveUnit.fdCategoryId" bundle="km-imissive"/>',
		    	        'kmImissiveUnitListWithAuthService&parentId=!{value}&type=distribute',
		    	        mainCalBackFn);
			    
			}else{
		    	Dialog_TreeList(
		    	    	true,
		    	        'fdMaintoIds',
		    	        'fdMaintoNames', 
		    	        ';', 
		    	        'kmImissiveUnitAllCategoryTreeService',
		    	        '<bean:message key="kmImissiveUnit.fdCategoryId" bundle="km-imissive"/>',
		    	        'kmImissiveUnitListWithAuthService&parentId=!{value}&type=all',
		    	        mainCalBackFn);
			    
			}
		}

	    function mainCalBackFn(){
	    	var ids = document.getElementsByName("fdMaintoIds")[0].value;
	    	var fdMissiveMaintoIds = "";
	    	var fdMissiveMaintoGroupIds="";
	    	var idsArray = ids.split(";");
	    	for(var i=0;i<idsArray.length;i++){
	    		if(idsArray[i].indexOf("cate")>-1){
	    			fdMissiveMaintoGroupIds += idsArray[i].substring(0,idsArray[i].indexOf("cate")-1)+";";
	    		}else{
	    			fdMissiveMaintoIds += idsArray[i]+";";
	    		}
	    	}
	    	fdMissiveMaintoIds = fdMissiveMaintoIds.substring(0,fdMissiveMaintoIds.length-1);
	    	fdMissiveMaintoGroupIds = fdMissiveMaintoGroupIds.substring(0,fdMissiveMaintoGroupIds.length-1);
	    	document.getElementsByName("fdMissiveMaintoIds")[0].value = fdMissiveMaintoIds;
	    	document.getElementsByName("fdMissiveMaintoGroupIds")[0].value=fdMissiveMaintoGroupIds;
	    }
    </script>
    