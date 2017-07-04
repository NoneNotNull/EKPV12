<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/kms/common/resource/jsp/include_kms_top.jsp" %>
 
 
<script src="ratingsys.js" type="text/javascript"></script> 
<style type="text/css">
    #rateStatus{   }
    #rateMe{ clear:both;  padding:0px; margin:0px;  }
    #rateMe li{float:left;list-style:none;}
    #rateMe li a:hover,
      /*兼容多浏览器*/
    #rateMe .on{background:url("<c:url value='/kms/multidoc/resource/img/star_on_16.png'/>") no-repeat ;
    		 cursor:pointer; cursor:hand; background-position:center center; width:16px;height:16px; position: relative;}
    #rateMe a{float:left;background:url("<c:url value='/kms/multidoc/resource/img/star_off_16.png'/>") no-repeat ;
             cursor:pointer; cursor:hand; background-position:center center; width:16px; height:16px;position: relative;}
    #ratingSaved{display:none;}
    .saved{color:red; }
</style> 
<script type="text/javascript">
	window.onload=function(){
	 	document.getElementById("fdEvaluationContent").value="";
	 	//document.getElementById("fdEvaluationContent").focus();
	 	document.getElementById("fdEvaluationScore").value="";
	}
	var options={
		url: "${KMSS_Parameter_ContextPath}kms/common/resource/ui/kmsSysEvaluationMain.do?method=save",
		type: "post", 
		beforeSubmit:beforeSubmit, 
		success:submitSuccess 
	};
	  
	function beforeSubmit(){
		v=document.getElementById("fdEvaluationScore").value ;
	   	if(v=='') {
	        showAlert('请把鼠标放在星星上评分');
	        return false ;
	    }else{
			document.getElementById("submintEvaluationButton").disabled='true';   
			return true ;
	    }
	}
	function editSubmit(){
	    $("form[name='sysEvaluationMainForm']").ajaxSubmit(options);  
	    self.parent.setUpdateMark(true) ;//更新评分
	  	return false; 
	}
	function submitSuccess(){
		document.getElementById("fdEvaluationContent").value='';
		reSetRate();// 重设星星 
		showSuccess();
		setTimeout(function(){
			self.parent.reloadEvaluationIframe();
		},100);
	}
	
	function showSuccess(){
		var success = document.getElementById("success");
		success.style.display = "block";	
	    setTimeout(function(){
	         success.style.display = "none";
	         document.getElementById("submintEvaluationButton").disabled='';
	   	},500);
	}
	function showSuccess2(){
		artDialog.dialog.tips('提交成功！', 1.5);
	}
</script>

<html:form action="/kms/common/resource/ui/kmsSysEvaluationMain.do"  >
	<center> 
		<table   border=0 width=100%  class='t_d'>
			<html:hidden property="fdId" />
		    <html:hidden property="fdEvaluationTime"  /> 
		    <html:hidden property="fdEvaluatorName"  />
			<tr class='t_d_a'>
				<td> 
					<bean:message bundle="sys-evaluation" key="sysEvaluationMain.fdEvaluationScore" />
				</td>  
				<td colspan=3   style="vertical-align:middle; text-align:left;">
				 
				  <div   id="rateMe"   title="请评分...">
				      <a onclick="rateIt(this)" rev="4" id="_1" title="差" onmouseover="rating(this)" onmouseout="off(this)"></a>
				      <a onclick="rateIt(this)" rev="3" id="_2" title="一般" onmouseover="rating(this)" onmouseout="off(this)"></a>
				      <a onclick="rateIt(this)" rev="2" id="_3" title="好" onmouseover="rating(this)" onmouseout="off(this)"></a>
				      <a onclick="rateIt(this)" rev="1" id="_4" title="很好" onmouseover="rating(this)" onmouseout="off(this)"></a>
				      <a onclick="rateIt(this)" rev="0" id="_5" title="非常好" onmouseover="rating(this)" onmouseout="off(this)"></a>
				       
				  </div>&nbsp;&nbsp; <span id="rateStatus">请评分...</span>
								
				</td>
			</tr>
			<tr  class='t_d_b'>
				<td  >
					<bean:message bundle="sys-evaluation" key="sysEvaluationMain.fdEvaluationContent" />
				</td>
				  <td colspan=3> 
					<html:textarea property="fdEvaluationContent" styleId="fdEvaluationContent" style="width:100%;height:80px" />
				</td>
			</tr>
			<tr  class='t_d_a'>
				<td  >
					<bean:message key="sysEvaluationMain.notifyOption" bundle="sys-evaluation" />
				</td>
				<td>
					<input name="isNotify" type="checkbox" value="yes"><bean:message key="sysEvaluationMain.isNotify" bundle="sys-evaluation" />
					<c:if test="${param.notifyOtherName!='' && param.notifyOtherName!= null}">
					<input name="notifyOther" type="checkbox" value="${param.notifyOtherName}" checked="checked"><bean:message key="${param.key}" bundle="${param.bundel}" />
					</c:if>
				</td>
			 
				<td  >
					<bean:message key="sysNotifySetting.fdNotifyType" bundle="sys-notify" />
				</td>
				<td>
					<kmss:editNotifyType property="fdNotifyType" />
				</td>
			</tr>
		</table>
	</center>
	<html:hidden property="method_GET" />
	<html:hidden property="fdKey" />
	<html:hidden property="fdModelId"  value='${param.fdModelId}'/>
	<html:hidden property="fdModelName" value='${param.fdModelName}'/>
	<html:hidden property="fdEvaluationScore"  styleId='fdEvaluationScore' />
	
</html:form>

 <div align='right'>
 <input id='submintEvaluationButton' type=button value="提 交" onclick="editSubmit(); "  >
 </div>	
<html:javascript formName="sysEvaluationMainForm"  cdata="false"
      dynamicJavascript="true" staticJavascript="false"/>
      
<div id="success" style="border-width:1px;border-style:solid;position:absolute;display:none;top:30%;left:40%;background:#f8f8f8;width:200px;height:50px;" align="center"> 
<br><font size="4"><bean:message bundle="" key="return.optSuccess" /></font> 
</div>
