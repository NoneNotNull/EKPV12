<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@ include file="/sys/praise/sysPraiseMain_view_js.jsp"%>
<script type="text/javascript">
	seajs.use(['${KMSS_Parameter_ContextPath}sys/praise/style/view.css']);
	seajs.use(['lui/topic', 'lui/jquery'], function(topic, $){
		var listChannel = "${param.listChannel}";
		var praiseAreaName = "${param.praiseAreaName}";
		topic.channel(listChannel).subscribe("list.loaded",function(evt) {
			var praiseModelIds = [];
			var fdModelName = $("#"+praiseAreaName+" .eval_praise_reply").attr("eval-view-modelname");
			$("#"+praiseAreaName+" .eval_reply_infos").each(function(){
				praiseModelIds.push($(this).attr("id"));
			});
			if(praiseModelIds.length>0){
				//调用点赞中方法，对已赞过的换用“已赞”图标
				updatePraiseStatus(praiseModelIds,fdModelName);
			}
		});
	});
</script>