<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
{$   
		<div class="com_subhead">
			${lfn:message('km-imeeting:kmImeetingMainFeedback.title.stat')}
		</div>		
		<div style="padding: 5px;margin-bottom: 10px;">
			<%-- 通知数--%>
			<span>${lfn:message('km-imeeting:kmImeetingMainFeedback.notifyCount')}:{%data.notifyCount%}</span>
			<%-- 回执数--%>
			<span>${lfn:message('km-imeeting:kmImeetingMainFeedback.feedbackCount')}:{%data.feedbackCount%}</span>
			<%-- 参加人数--%>
			<span>${lfn:message('km-imeeting:kmImeetingMainFeedback.attendCount')}:{%data.attendCount%}</span>
			<%-- 不参加人数--%>
			<span>${lfn:message('km-imeeting:kmImeetingMainFeedback.unAttendCount')}:{%data.unAttendCount%}</span>
		</div>
$}

{$
	<div class="com_subhead">
			${lfn:message('km-imeeting:kmImeetingMainFeedback.title.detail')}
	</div>
	<div class="lui_listview_main">
		<div class="lui_listview_header_l">
			<div class="lui_listview_header_r">
				<div class="lui_listview_header_c">
				</div>
			</div>
		</div>
		
		<div class="lui_listview_center_l">
			<div class="lui_listview_center_r">
				<div class="lui_listview_center_c">
					<table width="100%" class="lui_listview_columntable_listtable">
						<thead class="lui_listview_listtable_thead" >
							<tr>
								<th class="lui_listview_listtable_th">${lfn:message('km-imeeting:kmImeetingMainFeedback.docCreator')}</th>
								<th class="lui_listview_listtable_th">${lfn:message('km-imeeting:kmImeetingMainFeedback.dept') }</th>
								<th class="lui_listview_listtable_th">${lfn:message('km-imeeting:kmImeetingMainFeedback.fdOperateType')}</th>
								<th class="lui_listview_listtable_th">${lfn:message('km-imeeting:kmImeetingMainFeedback.docAttendId')}</th>
								<th class="lui_listview_listtable_th">${lfn:message('km-imeeting:kmImeetingMainFeedback.fdReason')}</th>
							</tr>			
						</thead>
						<tbody>
$}							
							for( var i=0 ; i < data.list.length; i++){
								{$
									<tr>
										<td style="text-align: center;">{%data.list[i].creator%}</td>
										<td  style="text-align: center;">{%data.list[i].dept%}</td>
								$}
								if( data.list[i].opttype == '01' ){
									{$ <td  style="text-align: center;">
											<bean:message bundle="km-imeeting" key="enumeration_km_imeeting_main_feedback_fd_operate_type_attend"/>
										</td>  
									$}
								}
								if( data.list[i].opttype == '02' ){
									{$ <td  style="text-align: center;">
											<bean:message bundle="km-imeeting" key="enumeration_km_imeeting_main_feedback_fd_operate_type_unattend"/>
										</td>  
									$}
								}
								if( data.list[i].opttype == '03' ){
									{$ <td style="text-align: center;">
											<bean:message bundle="km-imeeting" key="enumeration_km_imeeting_main_feedback_fd_operate_type_proxy"/>
										</td>  
									$}
								}
								{$		
										<td  style="text-align: center;">{%data.list[i].attend%}</td>
										<td  style="text-align: center;">{%data.list[i].reason%}</td>
									</tr>
								$}
							}
{$						
						</tbody>
					</table>
				</div>
			</div>
		</div>
		
		<div class="lui_listview_footer_l">
			<div class="lui_listview_footer_r">
				<div class="lui_listview_foot_c">
				</div>
			</div>
		</div>
		
	</div>

$}