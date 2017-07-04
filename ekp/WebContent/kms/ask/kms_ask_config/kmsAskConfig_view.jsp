<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/view_top.jsp"%> 
<div id="optBarDiv">
	<kmss:auth requestURL="/kms/ask/kms_ask_config/kmsAskConfig.do?method=edit" requestMethod="GET">
		<input type="button"
			value="<bean:message key="button.edit"/>"
			onclick="Com_OpenWindow('kmsAskConfig.do?method=edit','_self');">
	</kmss:auth>
</div>
<p class="txttitle"><bean:message bundle="kms-ask" key="menu.kmsAsk.config"/></p>
<center>
<table class="tb_normal" width=95%> 
	<%--同时可提问题数--%>
	<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="kms-ask" key="kmsAskConfig.fdSamePost"/>
		</td>
		<td colspan=3>
			<bean:write name="kmsAskConfigForm" property="fdSamePost"/>
			<br> 
			<font color="red">
				(注意：本项主要为促进提问人及时结贴所用。为防止提问人只提问，不置最佳答案或不结贴，
				一般建议设置“同时可提问题数”为4-8条，
				<br>当同时提问的问题超过设定的数目时，提问人需结束先前提问的帖子后，方可提交新问题) 
			</font> 
		</td>
	</tr>
	<%--每日最多可推荐问题数--%>
	<%--<tr>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="kms-ask" key="kmsAskConfig.fdIntroduceNum"/>
		</td>
		<td colspan=3>
			<bean:write name="kmsAskConfigForm" property="fdIntroduceNum"/> 
		</td>
	</tr>
	--%>
	<tr><%--问题保留时间（天）--%>
		<td class="td_normal_title" width=15%>
			 问题保留时间(天) 
		</td>
		<td colspan=3>
			${kmsAskConfigForm.fdDayBase}
		</td>
	</tr>  
	<tr><%--每日最多可推荐问题--%>
		<td class="td_normal_title" width=15%>
			问题预警时间(天) 
		</td>
		<td colspan=3>
			${kmsAskConfigForm.fdDayWarn}
		</td>
	</tr> 
	<tr><%--高分问题(分数，此分数以上的为高分问题) --%>
		<td class="td_normal_title" width=15%>
			<bean:message  bundle="kms-ask" key="kmsAskConfig.fdTopScore"/>(分数)
		</td>
		<td colspan=3>
			${kmsAskConfigForm.fdTopScore}
			&nbsp; &nbsp; 
			<font color="red">
				(注意：此分数以上的为高分问题) 
			</font>
		</td>
	</tr>  
</table>
</center> 
<%@ include file="/resource/jsp/view_down.jsp"%>
