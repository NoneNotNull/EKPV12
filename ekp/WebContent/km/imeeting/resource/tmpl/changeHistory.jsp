<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
{$<br/>$}

if(data.length > 0){
	
	{$
		<p class="txttitle">
			<bean:message bundle="km-imeeting" key="kmImeetingMainHistory.fdChangeOpt" />
		</p>
		<table class="tab_listData">
			<tr class="tab_title">
				<th style="width:55px;"><bean:message key="page.serial"/></th>
				<th style="width:120px;"><bean:message bundle="km-imeeting" key="kmImeetingMainHistory.fdOptPerson"/></th>
				<th style="width:180px;"><bean:message bundle="km-imeeting" key="kmImeetingMainHistory.fdOptDate"/></th>
				<th style="width:120px;"><bean:message bundle="km-imeeting" key="kmImeetingMainHistory.fdChangeOptType"/></th>
				<th><bean:message bundle="km-imeeting" key="kmImeetingMainHistory.fdChangeOptContent"/></th>
			</tr>
	$}
	for(var i=0; i < data.length; i++){
		{$
			<tr class="tab_data">
				<td>{% i+1 %}</td>
				<td>{% data[i].optPersonName %}</td>
				<td>{% data[i].date %}</td>
		$}
		var content=LUI.toJSON(data[i].content);
		if(data[i].opt=='05'){
			{$		
				<td><bean:message bundle="km-imeeting"  key="enumeration_km_imeeting_main_history_fd_opt_type_change"/></td>
				<td style="text-align: left;">{% content.changeReason %}</td>
			$}			
		}
		if(data[i].opt=='04'){
			{$		
				<td><bean:message bundle="km-imeeting"  key="enumeration_km_imeeting_main_history_fd_opt_type_cancel"/></td>
				<td style="text-align: left;">{% content.cancelReason %}</td>
			$}	
		}
		{$
			</tr>
		$}
	}
	{$
		</table>
	$}
	
}
