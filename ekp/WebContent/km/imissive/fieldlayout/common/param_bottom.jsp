<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<tr>
	<td align="center" colspan="2">
		<%@ include file="/sys/xform/designer/fieldlayout/default_layout/common_param.jsp" %>
    </td>
</tr>
<script>
	function checkOK(){
		var control_width=$("#control_width").val();
		if(control_width&&!/^\d+%$|^\d+px$/g.test(control_width)){
			alert('宽度百分比或像素格式不正确');
			return false;
		}
		var control_height=$("#control_height").val();
		if(control_height&&!/^\d+%$|^\d+px$/g.test(control_height)){
			alert('高度百分比或像素格式不正确');
			return false;
		}
		var control_content=$("#control_content").val();
		if(control_content&&!/^\d+$/g.test(control_content)){
			alert('内容长度限制必须为数字');
			return false;
		}
		return true;
	}
</script>