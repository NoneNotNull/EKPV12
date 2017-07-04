<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/ui.tld" prefix="ui"%>

{$
	<div class="lui_expert_box_2">
		<a class="lui_expert_img" 
		   target="_blank" 
		   href="${LUI_ContextPath }/kms/expert/kms_expert_info/kmsExpertInfo.do?method=view&fdId={%grid['fdId']%}"> 
			<img  src="{% grid['imgUrl']%}" onload="javascript:drawImage(this,this.parentNode)">
		</a>
		<ul>
			<li><input type="checkbox" value="{% grid['fdId']%}" name="List_Selected">
				<a target="_blank" href="${LUI_ContextPath }/kms/expert/kms_expert_info/kmsExpertInfo.do?method=view&fdId={%grid['fdId']%}"> 
					<span class="com_author">{%grid['fdName']%}</span>
				</a>
			</li>
			<li title="{% grid['fdDeptName']%}" >${lfn:message('kms-expert:kmsExpert.department')}{% grid['fdDeptNameShortName'] %}</li>
			<li title="{% grid['fdPostNames']%}">${lfn:message('kms-expert:kmsExpert.position')}{% grid['fdPostNamesShortName'] %}</li>
			<li title="{% grid['fdBackground']%}">${lfn:message('kms-expert:table.kmsExpertInfo.background')}：{% grid['fdBackground']%}</li>
$}
		if(grid['askTo']=='true')  {
			{$  
				<li class="lui_ask_btn">
					<a href="javascript:void(0)" class="lui_expert_askBtn_2"  onclick="askToExpert('{%grid['fdId']%}')">
					<span>${lfn:message('kms-expert:table.kmsExpertInfo.askTohim')}</span>
					</a>
				</li>
		 	$}
		}
{$
	    </ul>					
	</div>
$}