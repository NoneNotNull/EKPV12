<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<section data-lui-role="panel" id="personal-panel">
	<script type="text/config">
		{
			url : '${LUI_ContextPath}${param.url}',
			width : 0.6,
			mask : true
		}
	</script>
</section>

<script>
	function personal_click(){
		Pda.Element('personal-panel').selected();
		Pda.Topic.emit('head_btnClick');
	}
</script>