<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%--日历中空白日期选择--%>
<div id="meeting_calendar_add" class="meeting_calendar_dialog"  style="position: absolute; display: none">
	<%--顶部--%>
	<div class="meeting_calendar_dialog_top">
		<div class="meeting_calendar_dialog_title"></div>
		<div class="meeting_calendar_dialog_close" ></div>
	</div>
	<%--内容区--%>
	<div class="meeting_calendar_dialog_content" >
		<div>
			<%--召开日期--%>
			<span class="title">
				<c:out value="${lfn:message('km-imeeting:kmImeetingBook.fdHoldDate') }"></c:out>
			</span>
			<span class="date"></span>
			<span class="fdHoldDate" style="display: none;"></span>
			<span class="fdFinishDate" style="display: none;"></span>
		</div>
		<div>
			<%--会议地点--%>
			<span class="title">
				<c:out value="${lfn:message('km-imeeting:kmImeetingBook.fdPlace') }"></c:out>
			</span>
			<span class="resName"></span>
			<span class="resId" style="display: none;"></span>
		</div>
	</div>
	<%--底部--%>
	<div class="meeting_calendar_dialog_buttom">
		<kmss:authShow roles="ROLE_KMIMEETING_BOOKCREATE">
			<!-- 预约会议室 -->
			<ui:button id="book_add_btn" text="${lfn:message('km-imeeting:table.kmImeetingBook')}"  styleClass="lui_toolbar_btn_gray"  />
		</kmss:authShow>
		<kmss:authShow roles="ROLE_KMIMEETING_CREATE">
			<!-- 会议安排 -->
			<ui:button id="meeting_add_btn" text="${lfn:message('km-imeeting:table.kmImeetingMain')}"  styleClass="lui_toolbar_btn_gray"  />
		</kmss:authShow>
	</div>
</div>
<script>
	seajs.use([
		'lui/jquery',
		'lui/dialog'
		], function($,dialog) {
		//预约会议
		$('#book_add_btn').click(function(){
			$('.meeting_calendar_dialog').hide();
			var resId=$("#meeting_calendar_add").find(".resId").html();
			var fdHoldDate=$("#meeting_calendar_add").find(".fdHoldDate").html();
			var fdFinishDate=$("#meeting_calendar_add").find(".fdFinishDate").html();
			var url="/km/imeeting/km_imeeting_book/kmImeetingBook.do?method=add&resId="+resId+"&startDate="+fdHoldDate+"&endDate="+fdFinishDate;
			dialog.iframe(url,"${lfn:message('km-imeeting:kmImeetingBook.opt.create')}",function(result){
				if(result && result=="success"){
					LUI('calendar').refreshSchedules();
				}
			},{width:700,height:500});
		});
		//新建会议安排
		$('#meeting_add_btn').click(function(){
			$('.meeting_calendar_dialog').hide();
			var resId=$("#meeting_calendar_add").find(".resId").html();
			var fdHoldDate=$("#meeting_calendar_add").find(".fdHoldDate").html();
			var fdFinishDate=$("#meeting_calendar_add").find(".fdFinishDate").html();
			dialog.categoryForNewFile(
					'com.landray.kmss.km.imeeting.model.KmImeetingTemplate',
					'/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=add&fdTemplateId=!{id}'+'&startDate='+fdHoldDate+'&endDate='+fdFinishDate+"&resId="+resId,
					false,null,null,'${param.categoryId}');
		});
		
	});
</script>