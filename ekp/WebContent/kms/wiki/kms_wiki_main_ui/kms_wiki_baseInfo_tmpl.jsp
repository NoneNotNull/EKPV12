<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>

{$
<ul class="lui_wiki_baseInfo_ul">
$}
if(data['_authType']  == '1'){
	{$
		<li>
			${lfn:message('sys-doc:sysDocBaseInfo.docAuthor')} : 
			<ui:person personId="{%data['_authorId']%}" personName="{%data['_authorName']%}"/>
		</li>
	$}
}else {
	{$
	<li>${lfn:message('sys-doc:sysDocBaseInfo.docAuthor')} : 
		<span class="com_author">{% data['_authorName'] %}</span>
	</li>
	$}
}
{$	<li>
		${lfn:message('kms-wiki:kmsWikiMain.docCreator')} : 
		<ui:person personId="{%data['_docCreatorId']%}" personName="{% data['_creatorName'] %}"/>
	</li>
	<li>${lfn:message('kms-wiki:kmsWikiMain.creatDate')} : {% data['_creatTime'] %}</li>
	<li>
		${lfn:message('kms-wiki:kmsWikiMain.docStatus')} :
		${lfn:message('kms-wiki:kmsWikiMain.fdLastEdition_0')}
	</li>
</ul>
<div style='margin-left:-8px;margin-right:-8px;margin-bottom:8px;border-bottom: 1px #bbb dashed;height:8px'></div>
<ul class="lui_wiki_baseInfo_ul">
	<li>${lfn:message('kms-wiki:kmsWiki.fdCategoryHost')} : {% data['_fdCateHost'] %}</li>
$}
if(data['_fdCateHelp']) {
	{$
		<li>${lfn:message('kms-wiki:kmsWiki.fdCategoryHelp')} : {% data['_fdCateHelp'] %}</li>
	$}
}
{$
</ul>
$}
