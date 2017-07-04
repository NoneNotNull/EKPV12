<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<list:col-checkbox name="List_Selected" style="width:5%"></list:col-checkbox>
<list:col-serial title="${ lfn:message('page.serial') }" headerStyle="width:3%"></list:col-serial>	 
<list:col-html title="${ lfn:message('kms-wiki:kmsWiki.list.subject')}" headerStyle="width:35%" style="text-align:left;padding:0 8px">
	{$
		{%row['icon']%}
		<span class="com_subject">{%row['docSubject']%}</span>
	$}
</list:col-html>
<list:col-auto props="docAuthor.fdName"></list:col-auto>
<list:col-html title="${lfn:message('kms-wiki:kmsWiki.list.fdLastModifiedTime') }">
	{$	 
		{% row['fdLastModifiedTime']%}
	 $}
</list:col-html>
<%--{$ {%env.fn.parseDate(row['fdLastModifiedTime'], 'yyyy MM dd')%}  $}
<list:col-html title="${lfn:message('kms-wiki:kmsWiki.list.lastEditor') }">
	{$
		<span style="color: #E79005">{%row['fdLastCreator']%}</span>
	$}
  </list:col-html> --%>
  <list:col-auto props="editTimes;docReadCount;docScore"></list:col-auto>
  <list:col-html title="${lfn:message('kms-wiki:kmsWiki.list.category') }" >
  		{$
		<span>{% strutil.textEllipsis(row['docCategory.fdName'], 20) %}</span>
	$}	
  </list:col-html>