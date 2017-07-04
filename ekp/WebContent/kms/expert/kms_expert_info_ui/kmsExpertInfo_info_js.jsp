<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<script>
	seajs.use(['lui/jquery'], function($) {
		$(document).ready(
			function(){
				setTimeout(
					function() {
						var height = $('#expert_content').height();
						var iFrame = window.parent.document.getElementById("___content");
						height += 20;
						iFrame.style.height = height + "px";
					}, 200); 
			}
		);
	});
</script>