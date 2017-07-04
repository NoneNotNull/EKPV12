<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<script src='${ KMSS_Parameter_ContextPath }sys/bookmark/import/bookmark.js'></script>
<script type="text/javascript">
		seajs.use(['lui/dialog','lui/jquery'], function(dialog,$) {
			LUI.ready( function() {
			});

           //ajax请求操作
           window.ajaxOperation = function(url,data,newUrl){
        	   LUI.$.ajax({
					url: url,
					type: 'get',
					dataType: 'json',
					async: false,
					data: data,
					success: function(data, textStatus, xhr) {
						if(data==true){
							dialog.success('<bean:message key="return.optSuccess" />');
							setTimeout(function (){
								if(newUrl == null){
						         window.location.reload(true);
						         return;
								}
							    window.location.href=newUrl;
							}, 1500);
						}else{
							dialog.failure('<bean:message key="return.optFailure" />');
						}
					}
				});
				
               };
           //取消置顶操作  置为精华和取消精华操作 结贴
           window.buttonOperation = function(method,idVal,newUrl){
        	    var url = "${LUI_ContextPath}/km/forum/km_forum/kmForumTopic.do?method="+method;
                var data = {fdId:idVal};
	        	   if(method == "conclude"){
	        	    	dialog.confirm("${lfn:message('km-forum:kmForumTopic.button.concludeConfirm')}",function(value){
							if(value== true ){ ajaxOperation(url,data,newUrl);}});
				   }else if(method == "undoStick"){
					   dialog.confirm("${lfn:message('km-forum:kmForumTopic.button.unStickConfirm')}",function(value){
						    if(value== true ){ ajaxOperation(url,data,newUrl);}});
            	   }else if(method == "undoPink"){
            		    dialog.confirm("${lfn:message('km-forum:kmForumTopic.button.unPinkConfirm')}",function(value){
            		        if(value== true ){ ajaxOperation(url,data,newUrl);}});
                   }else{
                	   ajaxOperation(url,data,newUrl);
                      } 
               
               };
           //置顶操作     
           window.stickOperation = function(method,idVal){
        	  dialog.iframe("/km/forum/km_forum_ui/kmForumTopic_topday.jsp","${lfn:message('km-forum:kmForumTopic.button.stickTime')}",
                	  function (fdDays){
		        		 	if(fdDays != null){
		        		 	   var url = "${LUI_ContextPath}/km/forum/km_forum/kmForumTopic.do?method="+method;
		        		 	   var data = {fdId:idVal,fdDays:fdDays};
		 					   ajaxOperation(url,data,null);
		        		 	}
                          },
                          {width:400,height : 200});
               };    

           //主题删除操作     
           window.deleteTopicOperation = function(idVal,replyCount,newUrl){
        	       var url = "${LUI_ContextPath}/km/forum/km_forum/kmForumTopic.do?method=delete";
                   var data = {fdId:idVal};
                   if(replyCount>0){
		                   dialog.confirm("${lfn:message('km-forum:kmForumPost.topicPostDeleteConfirm')}",function(value){
		   					if(value==true){
		   						ajaxOperation(url,data,newUrl);	
		   					   }
		           	        });
                    }else{
                    	dialog.confirm("${lfn:message('km-forum:kmForumPost.topicDeleteConfirm')}",function(value){
    						if(value==true){
    						    ajaxOperation(url,data,newUrl);	
    					   }
            	        });
                    }
               };
                   
           //推荐操作
 	       window.introduceOperation = function(idVal){
        	        var url="/km/forum/km_forum/kmForumTopic.do?method=introduce&fdId="+idVal;
 	        	    dialog.iframe(url,"${lfn:message('km-forum:kmForumTopic.introduce.button')}",
 	    	        	 null,{
 								width : 600,
 								height : 330
 					});
 	              };   
 		   
			//转移
			window.moveOperation = function(idVal,fdForumId){
				    dialog.iframe("/km/forum/km_forum/kmForumTopic.do?method=showMove&fdId="+ idVal+"&fdForumId="+fdForumId,"${lfn:message('km-forum:kmForumCategory.button.changeDirectory')}",
						function(value){
				    	   if(value==null||value==""){
				    		   return;
				    	   }
				    	      window.location.href="${LUI_ContextPath}/km/forum/km_forum/kmForumPost.do?method=view&fdTopicId="+idVal+"&fdForumId="+value;}, {
								width : 600,
								height : 300
					});
			   };   

          //楼层回复按钮
           window.replyOperation = function(fdForumId,fdTopicId,fdParentId){
            	dialog.iframe("/km/forum/km_forum/kmForumPost.do?method=quickReply&fdForumId="+fdForumId+"&fdTopicId="+fdTopicId+"&fdParentId="+fdParentId,"${lfn:message('km-forum:kmForumPost.button.reply')}",
            			function(value){
		     	    	   if(value=="success"){
		     	    		      window.location.href="${LUI_ContextPath}/km/forum/km_forum/kmForumPost.do?method=view&fdForumId="+fdForumId+"&fdTopicId="+fdTopicId;
		     	    		    }
		     	    	   }
		     	     , { width : 988,
    				    height : 520
    				});
                  };   
                  
           //楼层编辑按钮
          window.editOperation = function(fdForumId,fdTopicId,idValue){
                dialog.iframe("/km/forum/km_forum/kmForumPost.do?method=edit&forward=updateReply&fdId="+idValue+"&fdForumId="+fdForumId+"&fdTopicId="+fdTopicId,"${lfn:message('km-forum:kmForumPost.editPost')}",
                		function(value){
			     	    	   if(value==null){
			     	    		   return;
			     	    	   }
     	    	   window.location.href="${LUI_ContextPath}/km/forum/km_forum/kmForumPost.do?method=view&fdForumId="+fdForumId+"&fdTopicId="+fdTopicId;}, {
            				    width : 988,
            				    height : 500
            	  });
               };      

          //楼层删除按钮
         window.deleteOperation = function(idVal){
               //是否被引用
               var isQuote = false;
               LUI.$.ajax({
					url: "${LUI_ContextPath}/km/forum/km_forum/kmForumPost.do?method=deleteIsQuoted",
					type: 'get',
					dataType: 'text',
					async: false,
					data: {fdId:idVal},
					success: function(data, textStatus, xhr) {
						if(data=="yes"){
							isQuote = true;
						}else if(data=="no"){
							isQuote = false;
						}else if(data=="error"){
						    dialog.faiture('<bean:message key="return.optFailure" />');
						}
					}
				});
             
               var url = "${LUI_ContextPath}/km/forum/km_forum/kmForumPost.do?method=delete";
               var data = {fdId:idVal,isQuote:isQuote};
               if(!isQuote){ 
			           	dialog.confirm("${lfn:message('km-forum:kmForumPost.postDeleteConfirm')}",function(value){
							if(value==true){ajaxOperation(url,data,null); }
				        });
               }else if(isQuote){
	            		dialog.confirm("${lfn:message('km-forum:kmForumPost.deleteQuoteConfirm')}",function(value){
							if(value==true){ajaxOperation(url,data,null); }
				        });
                   }
     	     };
     	     
     	//收藏按钮事件
         window.collectOperation = function(idVal){
            var subject  = '${lfn:escapeJs(topic.docSubject)}'
            var context = "<%=request.getContextPath() %>";
     		var url = window.location.href;
     		url = url.substring(url.indexOf('//') + 2, url.length);
    		url = url.substring(url.indexOf('/'), url.length);
    		if (context.length > 1) {
    			url = url.substring(context.length, url.length);
    		}
     		var param={'url':url,'subject':subject,'fdModelId':idVal,'fdModelName':'com.landray.kmss.km.forum.model.KmForumTopic'};
        	var result =  ___BookmarkDialog(param);
            };
            
		  });
		
		
</script>