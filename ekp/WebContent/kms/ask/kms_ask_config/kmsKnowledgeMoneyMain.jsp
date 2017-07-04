<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%--知识货币设置--%>
<%@ include file="/resource/jsp/view_top.jsp"%>
<%---测试提出去掉关闭按钮
<div id="optBarDiv"> 
		<input type="button" value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
 </div>
 ---%>
<p class="txttitle"><bean:message bundle="kms-ask" key="kmsAskPost.knowledgeMoney.manger"/></p>
<center>
<table class="tb_normal" id="Label_Tabel" width=95%>	
	<tr LKS_LabelName="<bean:message key="kmsAskPost.init.knowledgeMoney" bundle="kms-ask"/>">
		<td>
			<iframe marginwidth="0" marginheight="0" width="100%" height="300"  frameborder="0"
				src="<c:url value='/kms/ask/kms_ask_config/kmsKnowledgeMoneyConfig.do?method=view'/>"></iframe>
		</td>
	</tr>
	<tr LKS_LabelName="<bean:message  bundle="kms-ask" key="kmsAskPost.add.knowledgeMoney"/>">
		<td>
			 <iframe marginwidth="0" marginheight="0" width="100%" height="300"  frameborder="0"
				src="<c:url value='/kms/ask/kms_ask_config/kmsAskMoneyAlter.do?method=add&config=true'/>"></iframe>
		</td>		
	</tr>	
</table>
</center>
<%@ include file="/resource/jsp/view_down.jsp"%>
