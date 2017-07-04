<table id="Label_Tabel" width=95%>
  	<tr LKS_LabelName="<bean:message bundle="kms-expert" key="kmsExpert.personInfo.knowledge.integral"/>">
      <td>
          <TABLE class="tb_normal" width=100%>
            <TR>
              <td width=15% class="td_normal_title"><bean:message bundle="kms-expert" key="kmsExpert.personInfo.sysmodule"/></td>
              <td class="td_normal_title"><bean:message bundle="kms-expert" key="kmsExpert.personInfo.integral"/></td>
            </TR>
            <c:forEach items="${scoreInfo}" var="scoreInfo">
            	<tr>
	            	 <c:forEach items="${scoreInfo}" var="score"  begin="0" step="5">
	            	 	<td width=15%><c:out value='${score}' /></td>
	            	 </c:forEach>
	            	 <c:forEach items="${scoreInfo}" var="score"  begin="1" step="5">
            			 <td>
			              	<table class="tb_noborder" width="98%">
		              			<tr>
		              				<td>
		              					<kmss:showDecimalNumber value="${score}" pattern="#0.00"/>
		              				</td>
	            	 </c:forEach>
	            	 <c:forEach items="${scoreInfo}" var="score"  begin="2" step="5">
			            	 		<td align="right" width="40">
			            	 			<a href="<c:url value="${score}"/>" target="_blank">
											<bean:message bundle="kms-expert" key="kmIntegralPersonInfo.fdintegralparticularinfo"/>
										<a>
									</td> 
						      	</tr>
		              		</table> 
		              	</td>
	            	 </c:forEach>	     
            	 </tr>       
            </c:forEach>	                 
          </TABLE>
      </td>	      
    </tr>
    <kmss:ifModuleExist path="/km/doc/">
	    <tr LKS_LabelName="<bean:message bundle="kms-expert" key="kmsExpert.personInfo.creator.document"/>" style="display:none">
	    	<c:if test="${!empty kmsExpertInfoForm.fdPersonId }">
				<td id="doc"  onresize="Doc_LoadFrame('doc','<c:url value="/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=listOut&ownerId=${kmsExpertInfoForm.fdPersonId}&rowsize=10"/>');">
					<iframe name="" marginwidth=0 marginheight=0 width=100% height="300" src="" frameborder=0></iframe>
				</td>
			</c:if>
	    	<c:if test="${empty kmsExpertInfoForm.fdPersonId }">
				<td id="doc"  onresize="Doc_LoadFrame('doc','<c:url value="/km/doc/km_doc_knowledge/kmDocKnowledge.do?method=listOut&ownerId=${fdId}&rowsize=10"/>');">
					<iframe name="" marginwidth=0 marginheight=0 width=100% height="300" src="" frameborder=0></iframe>
				</td>
			</c:if>
		</tr>
	</kmss:ifModuleExist>
	<kmss:ifModuleExist path="/km/forum/">
		<tr LKS_LabelName="<bean:message bundle="kms-expert" key="kmsExpert.personInfo.with.discuss"/>" style="display:none">
			<c:if test="${!empty kmsExpertInfoForm.fdPersonId }">
				<td id="topic"  onresize="Doc_LoadFrame('topic','<c:url value="/km/forum/km_forum/kmForumTopic.do?method=listOut&fdMyPosterId=${kmsExpertInfoForm.fdPersonId}&rowsize=10"/>');">
					<iframe name="" marginwidth=0 marginheight=0 width=100% height="300" src="" frameborder=0></iframe>
				</td>
			</c:if>
			<c:if test="${empty kmsExpertInfoForm.fdPersonId }">
				<td id="topic"  onresize="Doc_LoadFrame('topic','<c:url value="/km/forum/km_forum/kmForumTopic.do?method=listOut&fdMyPosterId=${fdId}&rowsize=10"/>');">
					<iframe name="" marginwidth=0 marginheight=0 width=100% height="300" src="" frameborder=0></iframe>
				</td>
			</c:if>
		</tr> 
	</kmss:ifModuleExist>
	<kmss:ifModuleExist path="/km/answer/">
		<tr LKS_LabelName="<bean:message bundle="kms-expert" key="kmsExpert.personInfo.with.help"/>" style="display:none">
			<c:if test="${!empty kmsExpertInfoForm.fdPersonId }">
				<td id="help"  onresize="Doc_LoadFrame('help','<c:url value="/kms/ask/kms_ask/kmsAskTopic.do?method=listOut&fdPostPosterId=${kmsExpertInfoForm.fdPersonId}&rowsize=10"/>');">
					<iframe name="" marginwidth=0 marginheight=0 width=100% height="300" src="" frameborder=0></iframe>
				</td>
			</c:if>
			<c:if test="${empty kmsExpertInfoForm.fdPersonId }">
				<td id="help"  onresize="Doc_LoadFrame('help','<c:url value="/kms/ask/kms_ask/kmsAskTopic.do?method=listOut&fdPostPosterId=${fdId}&rowsize=10"/>');">
					<iframe name="" marginwidth=0 marginheight=0 width=100% height="300" src="" frameborder=0></iframe>
				</td>
			</c:if>
		</tr>
	</kmss:ifModuleExist>
</table><br>


