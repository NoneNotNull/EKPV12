<%@ include file="/resource/jsp/common.jsp"%>
<style>
/*????????*/
.PromptTB{border: 1px solid #000033;}
.barmsg{border-bottom: 1px solid #000033;}
</style>
<%-- ???????? --%>
<link href="${KMSS_Parameter_StylePath}promptBox/prompt.css" rel="stylesheet" type="text/css" />
<br><br><br><br><br>
<center>
<table width=400  border="0" align="center" cellpadding="0" cellspacing="0" class="PromptTB">
	<tr> 
		<td bgcolor="#FFFFFF" height=18 class=barmsg>
			<bean:message key="return.systemInfo"/>
		</td>
	</tr>
	<tr>
		<td>
			<table bgcolor="#FFFFFF" border=0 cellspacing=0 cellpadding=0 width=100%>
				<tr>
					<td width=20 class="PromptTD_Left Prompt_error"></td>
					<td class="PromptTD_Center">
						<br>
						<bean:message key="return.noRecord"/><br><br><span class=txtmsg>
						<bean:message key="return.refresh"/></span>
						<br>
						<br>
					</td>
					<td width=20></td>
				</tr>
				<tr>
					<td colspan="3">
						<div align="center">
							<span class="btn_input m_l20">
								<strong>
								<input type="button" value="<bean:message key="button.back"/>"
									onclick="SapDataByList_HistoryGo();">
								</strong>
							</span>
						</div>
						<br>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</center>
