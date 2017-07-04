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
			var fdNumberId = "${param.fdNumberId}";
			  generateNum(docId,tempDocNum,fdNumberId);
		});
	});
	function generateNum(docId,tempDocNum,fdNumberId){
		 var docNum = document.getElementsByName("fdNum")[0];
		 if(tempDocNum!=""){
			 docNum.value = tempDocNum;
		 }else{
			 if(getValueFromCookie(fdNumberId)){
					docNum.value = getValueFromCookie(fdNumberId);
			 }else{
				 var url = "${KMSS_Parameter_ContextPath}km/imissive/km_imissive_sign_main/kmImissiveSignMain.do?method=generateNumByNumberId"; 
				 $.ajax({     
		    	     type:"post",     
		    	     url:url,     
		    	     data:{fdNumberId:fdNumberId,fdId:docId},
		    	     async:false,    //用同步方式 
		    	     success:function(data){
		    	 	    var results =  eval("("+data+")");
		    		    if(results['docNum']!=null){
		    		   	   docNum.value = results['docNum'];
		    			}
		    		   document.cookie=(fdNumberId+"="+results['docNum']);
		    		}    
		        });
			}      
		 }
	}
	function optSubmit(){
		var fdNum = document.getElementsByName("fdNum")[0].value;
		$dialog.hide(fdNum);
		return true;	
	}
	</script>
	<center>
		<div>
			<table class="tb_normal" width=95% style="margin-top:25px">
				<tr>
				    <td><bean:message bundle="km-imissive" key="kmImissiveSignMain.fdDocNum"/></td>
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
