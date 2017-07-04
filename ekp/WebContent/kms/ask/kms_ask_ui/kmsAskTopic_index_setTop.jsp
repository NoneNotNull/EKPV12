<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/resource/style/default/doc/document.css" />
<center style="margin-top: 30px;">
	<table class="tb_normal" width="635" id="tb1">
		<tr>
			<td valign="center" width="180" class="td_normal_title">
				${ lfn:message('kms-ask:kmsAskTopic.setTopLocation')}
			</td>
			<td valign="center" width="227">
				<table width="415" class="tb_noborder">
					<tr>
						<td>
						<kmss:auth
								requestURL="/kms/ask/kms_ask_topic/kmsAskTopic.do?method=setTop&local=index"
								requestMethod="GET">
							<input type="radio" name="fdSetTopLevel" value="setTop_index" >
							${ lfn:message('kms-ask:kmsAskTopic.setTopIndex')}
						</kmss:auth>
							<input type="radio" name="fdSetTopLevel" value="setTop_firstCate" checked>
							${ lfn:message('kms-ask:kmsAskTopic.setTopFirst')}
							<input type="radio" name="fdSetTopLevel" value="setTop_currentCate">
							${ lfn:message('kms-ask:kmsAskTopic.setTopCurrent')}
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td valign="center" width="180" class="td_normal_title">
				${ lfn:message('kms-ask:kmsAskTopic.topReason')}
			</td>
			<td valign="center" colspan="2">
				<table cellspacing="17" cellpadding="0" class="tb_noborder">
					<tr>
						<td valign="center" width="415">
							<textarea name="fdSetTopReason" id="fdSetTopReason" style="width: 100%; height: 150px;"></textarea>
						</td>
						<td><span class="txtstrong" style="margin-top: 135px;">*</span></td>
					</tr>
				</table>
				
			</td>
		</tr>
	</table>
	

</center>
