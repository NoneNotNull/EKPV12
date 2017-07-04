<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.km.forum.model.KmForumConfig"%>
	   <%
	     String isCheckWord = new KmForumConfig().getIsWordCheck();
	     request.setAttribute("isCheckWord",isCheckWord);
	   %>
<script type="text/javascript">
		seajs.use(['lui/dialog','lui/jquery'], function(dialog,$) {
				//判断是否含有敏感词
				window.checkIsHasSenWords= function(content) {
					var result = false;
					var isCheckWord ="${isCheckWord}";
					if(isCheckWord == "false"){
						return result;
				    }
					var url = "${LUI_ContextPath}/km/forum/km_forum/kmForumPost.do?method=getIsHasSensitiveword";
					var data ={content:encodeURIComponent(content)};
					LUI.$.ajax({
						url: url,
						type: 'post',
						dataType: 'json',
						async: false,
						data: data,
						success: function(data, textStatus, xhr) {
						    result = data;
						}
					});
					return result;
			    };

			    
		  });
</script>