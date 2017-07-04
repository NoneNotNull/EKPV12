<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple" sidebar="no">
	<template:replace name="body">
	<%@ include file="/km/imissive/cookieUtil_script.jsp"%>
	<script language="JavaScript">
	seajs.use(['theme!form']);
	seajs.use(['lui/jquery'],function($){
		$(document).ready(function(){
			var docId = "${param.fdId}";
			var tempDocNum = "${param.tempDocNum}";
			  generateNum(docId,tempDocNum);
		});
	});
	function generateNum(docId,tempDocNum){
		 var docNum = document.getElementsByName("fdNum")[0];
		 if(tempDocNum!=""){
			 docNum.value = tempDocNum;
		 }else{
			if("${param.fdNoId}"!=""){
			    var url="${KMSS_Parameter_ContextPath}km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=generateNum"; 
				 $.ajax({   
		    	     type:"post",     
		    	     url:url,     
		    	     data:{fdId:docId}, 
		    	     async:false,    //用同步方式 
		    	     success:function(data){
		    	 	    var results =  eval("("+data+")");
		    		    if(results['docNum']!=null){
		    		   	   docNum.value = results['docNum'];
		    			}
		    		}    
		       });
		   }
	   }
	}
	function optSubmit(){
		//optGetNum();
		var fdNum = document.getElementsByName("fdNum")[0].value;
		$dialog.hide(fdNum);
		return true;	
	}

	function optGetNum(){
		var fdNumberId = document.getElementsByName("fdNumberId")[0].value;
		var docNum = document.getElementsByName("fdNum")[0];
		if(getValueFromCookie(fdNumberId+"${param.fdId}")||getValueFromCookie(fdNumberId)){
			 docNum.value = getValueFromCookie(fdNumberId+"${param.fdId}")?getValueFromCookie(fdNumberId+"${param.fdId}"):getValueFromCookie(fdNumberId);
	    }else{
		 var url="${KMSS_Parameter_ContextPath}km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=generateNumByNumberId"; 
		 $.ajax({     
    	     type:"post",    
    	     url:url,   
    	     data:{fdNumberId:fdNumberId,fdId:"${param.fdId}"},
    	     async:false,    //用同步方式 
    	     success:function(data){
    	 	    var results =  eval("("+data+")");
    		    if(results['docNum']!=null){
    		   	   docNum.value = results['docNum'];
    			}
    		    document.cookie=(fdNumberId+'${param.fdId}='+results['docNum']);
    		    document.cookie=(fdNumberId+'='+results['docNum']);
    		}    
        });
	  }
	}
	</script>
	<center>
		<div>
			<table class="tb_normal" width=95% style="margin-top:25px">
			   <tr>
				    <td>编号规则</td>
					<td>
					<%
						request.setAttribute("fdAllNumberFlag","1");
					    request.setAttribute("modelName","com.landray.kmss.km.imissive.model.KmImissiveSendMain");
					%>
					<xform:select property="fdNumberId" showStatus="edit">
						<xform:customizeDataSource className="com.landray.kmss.sys.number.service.spring.SysNumberMainDataSource"></xform:customizeDataSource>
					</xform:select>&nbsp;&nbsp;
					 <ui:button text="预览" order="2"  onclick="optGetNum();">
				     </ui:button>
					</td>
				</tr>
				<tr>
				    <td><bean:message bundle="km-imissive" key="kmImissiveSendMain.fdDocNum"/></td>
					<td>
					 <xform:text property="fdNum" style="width:97%" showStatus="edit" className="inputsgl"/>
					</td>
				</tr>
			</table>
			<br/>
			<span>
			    <ui:button id="ok_id" text="${lfn:message('button.ok') }" order="2"  onclick="optSubmit();">
				</ui:button>&nbsp;&nbsp;
				<ui:button text="${lfn:message('button.cancel') }" order="2"  onclick="$dialog.hide();">
				</ui:button>
			</span>
		</div>
	</center>
	</template:replace>
</template:include>
