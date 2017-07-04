<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script src="${kmsResourcePath }/js/kms_tabview.js"></script>
<script src="${kmsResourcePath }/js/lib/jquery.form.js"></script>
<script src="${kmsResourcePath }/js/kms_opera.js"></script>
<script>
	/**
	 * 用于已删除文档代办的检验
	 * @param fdUrl 请求路径 
	 * @param fdId 代办id
	 * @param fdMainId 文档id
	 */
	function readMsg(fdUrl, fdId, fdMainId) {
		jQuery.ajax( {
			url : '${KMSS_Parameter_ContextPath}' + fdUrl,
			data : {
				fdId : fdId,
				fdMainId : fdMainId
			},
			cache : false,
			success : function(data) {
				window.open(data, '_blank');
			},
			error : function() {
				artDialog.alert("该文档已经被删除！");
			}
		});
	}

	function bindButton(){
		$('.help_cko').toggle( function() {
			$('.help_cko').addClass('help_slideDown');
			$(".help_cko_info").slideDown("slow");
		}, function() {
			$('.help_cko').removeClass('help_slideDown');
			$(".help_cko_info").slideUp("slow");
		});
		var options = {
				s_modelName:'com.landray.kmss.sys.notify.model.SysNotifyTodo',
				s_bean : 'sysNotifyTodoService',
				s_method : 'deleteall',
				type : 'all',
				delUrl : '<c:url value="/sys/notify/sys_notify_todo/sysNotifyTodo.do" />?method=deleteall&fdKmsAskCategoryId='
		};
		var delEvent = new KMS.opera(options, $('#setButton'));
		delEvent.bind_del();
	}
</script>