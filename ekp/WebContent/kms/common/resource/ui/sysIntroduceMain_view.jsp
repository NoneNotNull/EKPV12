<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/common.jsp"%>
<c:set var="sysIntroduceForm" value="${requestScope[param.formName]}"/>
<c:if test="${sysIntroduceForm.introduceForm.fdIsShow=='true'}">
	<script language="JavaScript">
				function openIntroduceWindows(){
					var url = encodeURIComponent("<c:url value='/kms/common/resource/ui/kmsSysIntroduceMain.do?method=add'/>&fdModelName=${sysIntroduceForm.introduceForm.fdModelName}&fdModelId=${sysIntroduceForm.introduceForm.fdModelId}&fdIsNewVersion=${sysIntroduceForm.introduceForm.fdIsNewVersion}&toEssence=${param.toEssence}&toNews=${param.toNews}&docCreatorName=${param.docCreatorName}");
					var width = 640;
					var height = 500;
					var winStyle = "resizable:1;dialogwidth:"+width+"px;dialogheight:"+height+"px;";
					url = '<c:url value="/resource/jsp/frame.jsp?url=" />' + url;
					return showModalDialog(url, null, winStyle);
				}
				 
				function introduce_LoadIframe(){
					 var iframe1 = document.getElementById("introduceContent").getElementsByTagName("IFRAME")[0];
					  iframe1.src = "<c:url value='/kms/common/resource/ui/kmsSysIntroduceMain.do' />?method=viewAll&fdModelId=${sysIntroduceForm.introduceForm.fdModelId}&fdModelName=${sysIntroduceForm.introduceForm.fdModelName}";
					 var iframe2 = document.getElementById("introduceEditFarme") ;
					 	if(iframe2)
				     		iframe2.src = "<c:url value='/kms/common/resource/ui/kmsSysIntroduceMain.do' />?method=add&fdModelId=${sysIntroduceForm.introduceForm.fdModelId}&fdModelName=${sysIntroduceForm.introduceForm.fdModelName}&fdIsNewVersion=${sysIntroduceForm.introduceForm.fdIsNewVersion}&toEssence=${param.toEssence}&toNews=${param.toNews} ";
					 }
				function reloadIntroduceIframe(){
				  var iframe1 = document.getElementById("introduceContent").getElementsByTagName("IFRAME")[0];
			 	  iframe1.src = "<c:url value='/kms/common/resource/ui/kmsSysIntroduceMain.do' />?method=viewAll&fdModelId=${sysIntroduceForm.introduceForm.fdModelId}&fdModelName=${sysIntroduceForm.introduceForm.fdModelName}";
				}
				function refreshIntroduceNum(num){
				 	var tag='<bean:message bundle="sys-introduce" key="sysIntroduceMain.tab.introduce.label" />';
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
				    parent.getIntroduceNum();
				}
 	</script>
 <tr id="introduceTr" LKS_LabelName="<bean:message bundle="sys-introduce" key="sysIntroduceMain.tab.introduce.label" />" 
	TAG_NUM="${sysIntroduceForm.introduceForm.fdIntroduceCount}" SHOW_NUM="true" style="display:none"  >
	
		<td><a name="introduce"></a>
		
			<table class="tb_normals" border=0 width="100%" onresize="introduce_LoadIframe()">
				<tr>
					<td id="introduceContent" >
						<iframe name="introduceListFarme" id="introduceListFarme" src="" width=100%   height="100%" frameborder=0 scrolling=no>
						</iframe>
					</td>
				</tr>
				<kmss:auth requestURL="/kms/common/resource/ui/kmsSysIntroduceMain.do?method=add&fdModelId=${sysIntroduceForm.introduceForm.fdModelId}&fdModelName=${sysIntroduceForm.introduceForm.fdModelName}" requestMethod="GET">
				<tr>
					<td>
						<iframe name="introduceEditFarme" id="introduceEditFarme" src=""   width=100%   height="255"  frameborder=0 scrolling=no >
						</iframe>
					</td>
				</tr>
				</kmss:auth>
			</table>
		</td>
	</tr>
</c:if>

