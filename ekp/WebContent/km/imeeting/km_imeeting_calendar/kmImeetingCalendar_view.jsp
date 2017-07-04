<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%--查看会议安排--%>
<div id="meeting_calendar_mainview" class="meeting_calendar_dialog"  style="position: absolute; display: none">
	<span class="fdId" style="display: none;"></span>
	<span class="type" style="display: none;"></span>
	<%--顶部--%>
	<div class="meeting_calendar_dialog_top">
		<div class="meeting_calendar_dialog_title">${lfn:message('km-imeeting:table.kmImeetingMain')}</div>
		<div class="meeting_calendar_dialog_close" ></div>
	</div>
	<%--内容区--%>
	<div class="meeting_calendar_dialog_content" >
		<div>
			<%--会议名称--%>
			<span class="title" style="display:block;float: left;">
				<bean:message bundle="km-imeeting" key="kmImeetingMain.fdName" />
			</span>
			<span class="fdName" style="display:block;float: left;text-align: justify;width:230px;"></span>
			<div style="clear: both;"></div>
		</div>
		<div>
			<%--召开时间--%>
			<span class="title">
				<bean:message key="time.label" />
			</span>
			<span class="fdHoldDate"></span>
		</div>
		<div>
			<%--召开地点--%>
			<span class="title">
				<bean:message bundle="km-imeeting" key="kmImeetingMain.fdPlace" />
			</span>
			<span class="fdPlace"></span>
		</div>
		<div>
			<%--主持人--%>
			<span class="title">
				<bean:message bundle="km-imeeting" key="kmImeetingMain.fdHost" />
			</span>
			<span class="fdHost"></span>
		</div>
		<div>
			<%--会议发起人--%>
			<span class="title">
				<bean:message bundle="km-imeeting" key="kmImeetingMain.docCreator" />
			</span>
			<span class="docCreator"></span>
		</div>
	</div>
	<%--底部--%>
	<div class="meeting_calendar_dialog_buttom">
		<%-- 查看会议安排 --%>
		<div  style="text-align: center;"><ui:button id="meeting_view_btn" text="查看"  styleClass="lui_toolbar_btn_gray" /></div>
	</div>
</div>

<%--查看会议室预约--%>
<div id="meeting_calendar_bookview" class="meeting_calendar_dialog"  style="position: absolute; display: none">
	<span class="fdId" style="display: none;"></span>
	<span class="type" style="display: none;"></span>
	<%--顶部--%>
	<div class="meeting_calendar_dialog_top">
		<div class="meeting_calendar_dialog_title">${lfn:message('km-imeeting:table.kmImeetingBook')}</div>
		<div class="meeting_calendar_dialog_close" ></div>
	</div>
	<%--内容区--%>
	<div class="meeting_calendar_dialog_content" >
		<div>
			<%--会议名称--%>
			<span class="title" style="display:block;float: left;">
				<bean:message bundle="km-imeeting" key="kmImeetingBook.fdName" />
			</span>
			<span class="fdName" style="display:block;float: left;text-align: justify;width:230px;"></span>
			<div style="clear: both;"></div>
		</div>
		<div>
			<%--召开时间--%>
			<span class="title">
				<bean:message key="time.label" />
			</span>
			<span class="fdHoldDate"></span>
		</div>
		<div>
			<%--会议地点--%>
			<span class="title">
				<bean:message bundle="km-imeeting" key="kmImeetingBook.fdPlace" />
			</span>
			<span class="fdPlace"></span>
		</div>
		<div>
			<%--预约人--%>
			<span class="title">
				<bean:message bundle="km-imeeting" key="kmImeetingBook.docCreator" />
			</span>
			<span class="docCreator"></span>
		</div>
		<div>
			<%--备注--%>
			<span class="title" style="display:block;float: left;">
				<bean:message bundle="km-imeeting" key="kmImeetingBook.fdRemark" />
			</span>
			<span class="fdRemark" style="display:block;float: left;text-align: justify;width:230px;"></span>
			<div style="clear: both;"></div>
		</div>
	</div>
	<%--底部--%>
	<div class="meeting_calendar_dialog_buttom">
		<div  style="text-align: center;">
			<%--删除预约--%>
			<ui:button id="book_delete_btn" text="删除"  styleClass="lui_toolbar_btn_gray"  />
			<%--编辑预约--%>
			<ui:button id="book_edit_btn" text="编辑"  styleClass="lui_toolbar_btn_gray"  />
		</div>
	</div>
</div>
<script>
	seajs.use(['lui/jquery','lui/dialog'], function($,dialog) {
		//查看会议安排
		$('#meeting_view_btn').click(function(){
			$('.meeting_calendar_dialog').hide();
			var fdId=$("#meeting_calendar_mainview").find(".fdId").html();
			window.open('${LUI_ContextPath}/km/imeeting/km_imeeting_main/kmImeetingMain.do?method=view&fdId='+fdId,'_blank');
		});
		//删除会议预约操作
		$('#book_delete_btn').click(function(){
			var fdId=$("#meeting_calendar_bookview").find(".fdId").html();
			var url="${LUI_ContextPath}/km/imeeting/km_imeeting_book/kmImeetingBook.do?method=delete&fdId="+fdId;
			$.get(url,function(data){
				if(data!=null && data.status==true){
					LUI('calendar').refreshSchedules();
				}
				else{
					dialog.failure('<bean:message key="return.optFailure" />');
				}
				$('.meeting_calendar_dialog').hide();//隐藏对话框
			},'json');
		});
		//编辑会议预约操作
		$('#book_edit_btn').click(function(){
			var fdId=$("#meeting_calendar_bookview").find(".fdId").html();
			var url="/km/imeeting/km_imeeting_book/kmImeetingBook.do?method=edit&fdId="+fdId;
			dialog.iframe(url,"${lfn:message('km-imeeting:kmImeetingBook.opt.edit')}",function(result){
				if(result && result=="success"){
					LUI('calendar').refreshSchedules();
				}
			},{width:700,height:500});
			$('.meeting_calendar_dialog').hide();//隐藏对话框
		});
		//关闭
		$('.meeting_calendar_dialog_close').click(function(){
			$('.meeting_calendar_dialog').fadeOut("fast");
		});
	});
</script>