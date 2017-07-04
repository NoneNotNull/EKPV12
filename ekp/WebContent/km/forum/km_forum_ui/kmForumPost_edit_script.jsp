<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script type="text/javascript">
		seajs.use(['lui/dialog','lui/jquery'], function(dialog,$) {
				//判断是否可以匿名
				window.getIsAnonymous = function(fdForumId) {
					if(fdForumId == null || fdForumId ==""){
                         return;
					 }
					var url = "${LUI_ContextPath}/km/forum/km_forum/kmForumPost.do?method=getIsAnonymous";
					var data ={fdForumId:fdForumId};
					var anonymousDiv = $("#isAnonymous");
					LUI.$.ajax({
						url: url,
						type: 'get',
						dataType: 'json',
						async: false,
						data: data,
						success: function(data, textStatus, xhr) {
							if(data==true){
								//显示
								if( $("#isAnonymous").is(":hidden")){
								   anonymousDiv.show();
								}
							}else{
								//隐藏区域
								if( $("#isAnonymous").is(":visible")){
								   anonymousDiv.hide();
								}
							}
						}
					});
				   
			    };

			//获取富文本框内容
		    window.RTF_GetContent = function(prop){
		    	    var instance=CKEDITOR.instances[prop];
		    	    if(instance){
		    	          return instance.getData();
		    	    }
		    	    return "";
		    };
			
			//弹出框选择后回调
            window.afterSelect = function(rtn){
                 if(rtn == null){
                     return;
                 }
                 //返回列表href变化
                 if($("#returnList").attr("href")!=null){
	                 var newHref = Com_SetUrlParameter($("#returnList").attr("href"),"categoryId",rtn.id);
	                 $("#returnList").attr("href",newHref);
                 }
                 $("input[name='fdForumId']").val(rtn.id);
                 $("input[name='fdForumName']").val(rtn.name);
                 //更换版块显示匿名发帖区域
                 getIsAnonymous(rtn.id);
	               //提交表单校验
	 	    		for(var i=0; i<Com_Parameter.event["submit"].length; i++){
	 	    			if(!Com_Parameter.event["submit"][i]()){
	 	    				return false;
	 	    			}
	 	    		}
                };
			
			//新建
			window.addDoc = function(isForwardQuickEdit) {
			     dialog.simpleCategoryForNewFile({modelName:"com.landray.kmss.km.forum.model.KmForumCategory",
                    									url:"/km/forum/km_forum_cate/simple-category.jsp",
                    									action:afterSelect});
					};
            //提交表单
            var count = 0;
		    window.submitKmForumPostForm=function(method, forumId) {
				    	//提交表单校验
			    		var v=RTF_GetContent("docContent");
			    		if(v==null ||v=="") {
							dialog.alert("<bean:message  bundle='km-forum' key='kmForumPost.topicNotEmpty'/>");
							return;
						}
			    		//检测敏感词
			    		var docSubject = $('input[name="docSubject"]').val();
			    		if(checkIsHasSenWords(docSubject)==true) {
							dialog.alert("<bean:message  bundle='km-forum' key='kmForumConfig.word.warn.topic'/>");
							return;
						}
			    		
						if(checkIsHasSenWords(v)==true) {
							dialog.alert("<bean:message  bundle='km-forum' key='kmForumConfig.word.warn'/>");
							return;
						}
						//为兼容新UED，暂时把帖子内容校验去掉
						//RTF_UpdateLinkedFieldToForm("docContent");
						if(count == 0){
							count ++;
							Com_Submit(document.kmForumPostForm, method, forumId);
						}
					};

		   //通知方式按钮事件
			window.clickCheckBox=function(obj){
				if(obj.checked){	
					    document.getElementById("id_notify_type").style.display="";
					    document.getElementsByName("fdIsNotify")[0].value='1';
					}else{
						document.getElementsByName("fdIsNotify")[0].value='0';
						document.getElementById("id_notify_type").style.display="none";	
					}
				};
		    
		  });
</script>