<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>
var shortDeptNames = grid.fdDeptName.split("&gt;&gt;");
var shortDeptName = shortDeptNames[shortDeptNames.length-1];
var shortfdPostNames = grid.fdPostNames.split("&gt;&gt;");
var shortfdPostName = shortfdPostNames[shortfdPostNames.length-1];
{$
	<div class="lui_expert_box">
		<a class="lui_expert_img" target="_blank" href="${LUI_ContextPath }/kms/expert/kms_expert_info/kmsExpertInfo.do?method=view&fdExpertId={%grid['fdId']%}"> 
			<img  src="{% grid['imgUrl']%}" onload="javascript:drawImage(this,this.parentNode)">
		</a>
		<ul>
			<li><input type="checkbox" value="{% grid['fdId']%}" name="List_Selected"><span class="com_author"><ui:person personId="{%grid['fdPersonId']%}" personName="{%grid['fdName']%}"></ui:person></span></li>
			<li title="{% grid['fdDeptName']%}">${lfn:message('kms-expert:kmsExpert.department')}{% shortDeptName %}</li>
			<li title="{% grid['fdPostNames']%}">${lfn:message('kms-expert:kmsExpert.position')}{% shortfdPostName %}</li>
			<li title="{% grid['expertAreas']%}">${lfn:message('kms-expert:kmsExpert.areas')}{% grid['expertAreas']%}</li>
$}
		if(grid['askTo']=='true')  {
			{$  
				<li>
					<a href="javascript:void(0)" class="lui_expert_askBtn"  onclick="askToExpert('{%grid['fdId']%}')">
					<span>${lfn:message('kms-expert:table.kmsExpertInfo.askTohim')}</span>
					</a>
				</li>
		 	$}
		}
{$
	    </ul>					
	</div>
$}