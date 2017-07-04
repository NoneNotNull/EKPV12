<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
{$
<div class="lui_ask_info_right">
		<a class="lui_ask_personimg" href="#" onclick="showUserInfo('{%data.fdPersonId%}');return false;"><img src="{%data.attUrl%}" /></a>
		<ul >
			<li><ui:person personId="{%data.fdPersonId%}" personName="{%data.fdPersonName%}">
			</ui:person></li><!--
			<li>
				等级：{%data.totalGrade%}
			</li>
			<li >
				积分：<span class="lui_ask_score_color">{%data.askScore%}</span>分
			</li>
		--></ul>
		<div class="lui_ask_view_clear"></div>
	</div>
	<div class="lui_ask_view_clear"></div>
$}