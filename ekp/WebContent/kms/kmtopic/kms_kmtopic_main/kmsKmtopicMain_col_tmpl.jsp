<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:col-checkbox name="List_Selected" style="width:5%"></list:col-checkbox>
<list:col-serial title="${ lfn:message('page.serial') }" headerStyle="width:5%"></list:col-serial>
<list:col-html title="${ lfn:message('kms-kmtopic:kmsKmtopicMain.docSubject')}" headerStyle="width:40%" style="text-align:left;padding:0 8px">
	{$
		{%row['icon']%}
		<span class="com_subject">{%row['docSubject']%}</span>
	$}
</list:col-html>
<list:col-html title="${ lfn:message('kms-kmtopic:kmsKmtopic.docAuthor')}" >
	{$
		<span class="com_author">{%row['_docAuthor.fdName']%}</span> 
	$}
</list:col-html> 
<list:col-auto props="docPublishTime;docReadCount;docScore"></list:col-auto>
<list:col-html title="${lfn:message('kms-kmtopic:kmsKmtopic.docCategory')}"
			   style="width:15%" >
   		{$
			<span title="{%row['docCategory.fdName']%}">
				{% strutil.textEllipsis(row['docCategory.fdName'], 15) %}
			</span>
		$}	
 </list:col-html>