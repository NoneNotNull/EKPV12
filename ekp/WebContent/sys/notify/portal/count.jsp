<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/ui/lfn.tld" prefix="lfn"%>
<div class="lui_portal_header_text">
	<div title="${ lfn:message('sys-notify:header.type.todo') }" onclick="window.open('${LUI_ContextPath}/sys/person/home.do?link=sys_notify_home_nav#cri.status1.q=fdType:13','_blank')" class="lui_portal_header_daiban_div">
		<div class="lui_icon_s lui_icon_s_daiban" style="vertical-align: text-top;"></div>
		<div id="__notify_daiban__" class='lui_portal_header_daiban'></div>
	</div>
	<div title="${ lfn:message('sys-notify:header.type.view') }" onclick="window.open('${LUI_ContextPath}/sys/person/home.do?link=sys_notify_home_nav#cri.status1.q=fdType:2','_blank')" class="lui_portal_header_daiyue_div">
		<div class="lui_icon_s lui_icon_s_daiyue" style="vertical-align: text-top;"></div>
		<div id="__notify_daiyue__" class='lui_portal_header_daiyue'></div>
	</div>
</div>
<script>
LUI.ready(function(){
	var refreshTime = parseInt(${ param['refreshTime'] });
	if(isNaN(refreshTime) || refreshTime<1){
		refreshTime = 0;
	}
	var refreshNotify = function(){
		LUI.$.getJSON(Com_Parameter.ContextPath + "sys/notify/sys_notify_todo/sysNotifyTodo.do?method=sumTodoCount",function(json){
			if(json!=null){
				LUI.$("#__notify_daiban__").html(json.type_1==null?0:json.type_1);
				LUI.$("#__notify_daiyue__").html(json.type_2==null?0:json.type_2);				
			}
		});
		if(refreshTime>0)
			window.setTimeout(refreshNotify,refreshTime*1000*60);
	};
	refreshNotify();
});
</script>