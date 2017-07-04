<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysEvaluationForm" value="${requestScope[param.formName]}" />
<c:if test="${sysEvaluationForm.evaluationForm.fdIsShow=='true'}">
<script language="JavaScript">
 
	function evaluation_LoadIframe(){
	var iframe = document.getElementById("evaluationContent").getElementsByTagName("IFRAME")[0];
	 	iframe.src = "<c:url value='/kms/common/resource/ui/kmsSysEvaluationMain.do' />?method=list&fdModelId=${sysEvaluationForm.evaluationForm.fdModelId}&fdModelName=${sysEvaluationForm.evaluationForm.fdModelName}";
	var iframe2 = document.getElementById("evaluationEditFrame") ;
		if(iframe2)
	 		iframe2.src = "<c:url value='/kms/common/resource/ui/kmsSysEvaluationMain.do' />?method=add&fdModelName=${sysEvaluationForm.evaluationForm.fdModelName}&fdModelId=${sysEvaluationForm.evaluationForm.fdModelId}&fdIsNewVersion=${sysEvaluationForm.evaluationForm.fdIsNewVersion}&notifyOtherName=${param.notifyOther}&bundel=${param.bundel}&key=${param.key}"; 
	}
	function reloadEvaluationIframe(){//刷新列表
	   var iframe = document.getElementById("evaluationContent").getElementsByTagName("IFRAME")[0];
	 	iframe.src = "<c:url value='/kms/common/resource/ui/kmsSysEvaluationMain.do'/>?method=list&fdModelId=${sysEvaluationForm.evaluationForm.fdModelId}&fdModelName=${sysEvaluationForm.evaluationForm.fdModelName}";
	   // iframe.location.reload() ;//兼容IE6
	}
	
	function refreshEvaluationNum(num){ // 更新点评数量
		var tag='<bean:message bundle="sys-evaluation" key="sysEvaluationMain.tab.evaluation.label" />';
		var a=document.getElementById(tag) ;    
		if(parseInt(num)>0){
		   	tagNum= tag+'('+num+')' ;
		   	a.rev='('+num+')' ;
		}else{
		   	tagNum= tag ;
		   	a.rev='' ;
		}
		var c=a.firstChild ;   
		a.removeChild(c);
		a.appendChild(document.createTextNode(tagNum));
		parent.getEvaluationNum();
	}

	function updatePage(){
		//更新点评数
		//refreshEvaluationNum();

		//更新点评分
		if(isUpdate){
			self.parent.updateScore();
		}
	}

	var isUpdate = null;
	function setUpdateMark(operate){
		isUpdate = operate;
	}
		 
 </script>

<c:if test="${param.isNews ne 'yes'}">
 <tr id="evaluationTr"
	  LKS_LabelName="<bean:message bundle="sys-evaluation" key="sysEvaluationMain.tab.evaluation.label" />" 
	  TAG_NUM="${sysEvaluationForm.evaluationForm.fdEvaluateCount}" SHOW_NUM="true" style="display:none">
	  
		<td><a name="evaluation"></a>
			<table class="tb_normals" width="100%" border=0   >
				<tr>
					<td  height="100%" id="evaluationContent" onresize="evaluation_LoadIframe();" >
						<iframe  name="evaluationListFrame" id="evaluationListFrame" src="" width=100%   height="100%" frameborder=0 scrolling=no>
						</iframe> 
					</td>
				</tr>
				<kmss:auth requestURL="/kms/common/resource/ui/kmsSysEvaluationMain.do?method=add&fdModelName=${sysEvaluationForm.evaluationForm.fdModelName}&fdModelId=${sysEvaluationForm.evaluationForm.fdModelId}&fdIsNewVersion=${sysEvaluationForm.evaluationForm.fdIsNewVersion}" requestMethod="GET">
				<tr>
					<td>
						<iframe name="evaluationEditFrame" id="evaluationEditFrame" src=""   width=100%   height="157"  frameborder=0 scrolling=no >
						</iframe>
					</td>
				</tr>
				</kmss:auth>
			</table>
		</td>
	</tr> 
	</c:if>
	<c:if test="${param.isNews eq 'yes'}">
		<table width="100%">
			<tr>
				<td onresize="evaluation_LoadIframe();">
					<iframe src="<c:url value="/kms/common/resource/ui/kmsSysEvaluationMain.do" />?method=list&rowsize=10&forward=newsList&fdModelId=${sysEvaluationForm.evaluationForm.fdModelId}&fdModelName=${sysEvaluationForm.evaluationForm.fdModelName}" width=100% height=100% frameborder=0 scrolling=no>
					</iframe>
				</td>
			</tr>
			<input type="hidden" name="_disReviewDisFlag" value="false">
		</table>			
	</c:if>
</c:if>

