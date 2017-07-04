<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<link rel="stylesheet" type="text/css" href="${ LUI_ContextPath}/resource/style/default/doc/document.css" />
<center style="margin-top: 30px;">
	<table class="tb_normal" width="520" id="tb1">
		<tr>
			<td valign="center" width="113" class="td_normal_title">
				${ lfn:message('kms-wiki:kmsWiki.setTopLocation')}
			</td>
			<td valign="center" width="227">
				<table width="380" class="tb_noborder">
					<tr>
						<td>
						<kmss:auth
								requestURL="/kms/wiki/kms_wiki_main/kmsWikiMain.do?method=setTop&local=index"
								requestMethod="GET">
							<input type="radio" name="fdSetTopLevel" value="setTop_index" >
							${ lfn:message('kms-wiki:kmsWiki.setTopIndex')}
						</kmss:auth>
							<input type="radio" name="fdSetTopLevel" value="setTop_firstCate" checked>
							${ lfn:message('kms-wiki:kmsWiki.setTopFirst')}
							<input type="radio" name="fdSetTopLevel" value="setTop_currentCate">
							${ lfn:message('kms-wiki:kmsWiki.setTopCurrent')}
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td valign="center" width="113" class="td_normal_title">
				${ lfn:message('kms-wiki:kmsWiki.topReason')}
			</td>
			<td valign="center" colspan="2">
				<table cellspacing="17" cellpadding="0" class="tb_noborder">
					<tr>
						<td valign="center" width="380">
							<textarea name="fdSetTopReason" id="fdSetTopReason" style="width: 100%; height: 150px;"></textarea>
						</td>
						<td><span class="txtstrong" style="margin-top: 135px;">*</span></td>
					</tr>
				</table>
				
			</td>
		</tr>
	</table>
	

</center>
