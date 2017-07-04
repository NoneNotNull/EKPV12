<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.landray.kmss.web.taglib.editor.CKEditorConfig"%>
<%@page import="com.landray.kmss.util.UserUtil"%>
<template:include ref="default.edit" sidebar="no" width="100%">
    <template:replace name="head">
          <%   CKEditorConfig __config = new CKEditorConfig();
			   __config.addConfigValue("smiley_height",300);
		  %>
		<link href="${LUI_ContextPath}/km/forum/resource/css/forum_edit.css" rel="stylesheet" type="text/css" />
	    <%@ include file="/km/forum/km_forum_ui/kmForumPost_checkWork_script.jsp"%>
		<style>
			.lui_form_content {border: 0}
		</style>
        <script type="text/javascript">
		seajs.use(['lui/dialog','lui/jquery'], function(dialog,$) {
	    	LUI.ready( function() {
		    	var fdParentId ="${param.fdParentId}";
	    		dyniFrameSize();
	    		//楼层回复防止附件上传自适应,回复和点击
	    	    var method="${kmForumPostForm.method_GET}";
	    	    //回复主题
	    		if(fdParentId ==""&&method!="edit"){
		    		 //附件添加后高度自适应
				    attachmentObject_attachment.on("uploadSuccess", function() {
				    	dyniFrameSize();
				    });
		    		
				    //附件删除后高度自适应
				    attachmentObject_attachment.on("editDelete", function() {
				    	dyniFrameSize();
				    });
				    ___ckeReady();
				//iframe回复楼层
	    		}else{
	    			window.frameElement.style.height = "500px";
			    }
			    

			    //是否显示匿名回复选择框
			    var fdForumId = '${param.fdForumId}';
			    getIsAnonymous(fdForumId);
			    
	    	});
	   
            //自适应高度
	    	window.dyniFrameSize = function() {
	    		try {
	    			// 调整高度
	    			var arguObj = document.getElementById("quickReply_div");
	    			if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
	    				window.frameElement.style.height = (arguObj.offsetHeight)+45+ "px";
	    				window.frameElement.style.width = (arguObj.offsetWidth) + "px";
	    			}
	    		} catch(e) {
	    		}
	    	};
	    	//获取富文本框内容
	    	window.RTF_GetContent = function(prop){
	    	    var instance=CKEDITOR.instances[prop];
	    	    if(instance){
	    	          return instance.getData();
	    	    }
	    	    return "";
	    	};

	    	//快速新建采用无刷新提交
	    	window.submitForm=function(method){
	    		for(var i=0; i<Com_Parameter.event["confirm"].length; i++){
					if(!Com_Parameter.event["confirm"][i]()){
						return false;
					}
				}    
	    		//提交表单校验
	    		var v=RTF_GetContent("docContent");
	    		if(v==null ||v=="") {
					dialog.alert("<bean:message  bundle='km-forum' key='kmForumPost.notEmpty'/>");
					return;
				}
	    		//检测敏感词
				if(checkIsHasSenWords(v)==true) {
					dialog.alert("<bean:message  bundle='km-forum' key='kmForumConfig.word.warn'/>");
					return;
				}
				CKEDITOR.instances['docContent'].element.fire('updateEditorElement');
				var v1=RTF_GetContent("docContent");
	    		document.getElementsByName("docContent")[0].value=v1;
				$.ajax({
					url: '${LUI_ContextPath}/km/forum/km_forum/kmForumPost.do?method='+method,
					type: 'POST',
					dataType: 'json',
					async: false,
					data: $("#kmForumPost").serialize(),
					success: function(data, textStatus, xhr) {
						if(data==true){
							dialog.success('<bean:message key="return.optSuccess" />');
							setTimeout(function (){
								var pageno = window.parent.document.getElementById("currPage").value;
								var rowsize = window.parent.document.getElementById("currRowsize").value;
								var totalrows = window.parent.document.getElementById("totalrows").value;
							    if ($("#toLastPage").is(":checked")) {//跳转到最后一页
									pageno = parseInt((totalrows+1)/rowsize);
								}
								//跳转到阅读页面定位锚点
								var fdPostId = "";
								if(method == "updateReply"){
									fdPostId = '${param.fdId}';
								}else if(method == "saveQuick"){
									fdPostId = '${param.fdParentId}';
								}
								window.parent.location.href="${LUI_ContextPath}/km/forum/km_forum/kmForumPost.do?method=view&fdForumId=${param.fdForumId}&fdTopicId=${param.fdTopicId}&pageno="+pageno+"&rowsize="+rowsize+"&sortType=asc"+"&fdPostId="+fdPostId;
							}, 1500);
						}else{
							dialog.faiture('<bean:message key="return.optFailure" />');
						}
					}
				});
		    };

		    window.___ckeReady = function(){
		    	if (CKEDITOR.instances['docContent'] && CKEDITOR.instances['docContent'].instanceReady) {
		    	    CKEDITOR.instances['docContent'].on('resize',function(){
		    	    	dyniFrameSize();
		    		    });
		    		 dyniFrameSize();
		    	} else
		    		setTimeout(function() {
		    			___ckeReady();
		    		}, 200);
		    };

		  //判断是否可以匿名
			window.getIsAnonymous = function(fdForumId) {
				if(fdForumId == null){
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

		    
		  });
	   </script>
	   <script type="text/javascript">
	   function submitKmForumPostForm() {
			Com_Submit(document.kmForumPostForm, 'saveQuick');
		}
	   </script>
	</template:replace>
	<template:replace name="content"> 
		    <%--新建帖子表格开始--%>  
             <html:form action="/km/forum/km_forum/kmForumPost.do" styleId="kmForumPost">
               <div id="quickReply_div" class="forum_quickPost_read">
                 <html:hidden property="fdId"/>
				 <html:hidden property="fdTopicId"/>
				 <html:hidden property="fdParentId"/>
				 <html:hidden property="fdQuoteMsg"/>
				 <html:hidden property="quoteMsg"/>
				 <html:hidden property="fdForumId"/>
				 <html:hidden property="fdForumName"/>
		    <c:if test="${ kmForumPostForm.method_GET == 'edit' }">		 
		         <html:hidden property="fdIsAnonymous"/>
		    </c:if>
				 <html:hidden property="docSubject"/>
				 <html:hidden property="fdSupportCount"/>
                 <table class="lui_sheet_c_table">
                    <tr>
                        <td class="td_user_img">
                            <%String fdId = UserUtil.getUser().getFdId();
                              request.setAttribute("imageUserId",fdId);%>
                             <img src="${ LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId=${imageUserId}" style="width: 60px;height: 60px" alt=""/>
                        </td>
                        <td>
				            <%
								CKEditorConfig __config = new CKEditorConfig();
								__config.addConfigValue("smiley_height","350");
							%>
                            <kmss:editor property="docContent" height="220px" width="100%" config="<%=__config %>"/>
                            <div style="height: 8px"></div>
                            <%--附件--%>
					        <c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
							     <c:param name="fdKey" value="attachment"/>
							     <c:param name="fdModelName" value="com.landray.kmss.km.forum.model.KmForumPost" />
						    </c:import>
						    <p class="p_upload"> </p>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                        <td>
                            <c:choose>
		                         <c:when test="${ kmForumPostForm.method_GET == 'edit' }">
		                            <ui:button styleClass="com_bgcolor_d com_fontcolor_d com_bordercolor_d forum_button" text="${lfn:message('km-forum:KmForumPost.notify.title.quickUpdate') }" onclick="submitForm('updateReply');"/>
		                         </c:when>
		                         <c:otherwise>
		                          	<ui:button styleClass="com_bgcolor_d com_fontcolor_d com_bordercolor_d forum_button" text="${lfn:message('km-forum:KmForumPost.notify.title.quickReply') }" onclick="submitForm('saveQuick');"/>
		                         </c:otherwise>
		                    </c:choose>
                            <span class="qucikPost_w"><span class="item">
                                <%--回帖后回到最后一页--%>
                                 <c:if test="${ kmForumPostForm.method_GET != 'edit' }"> 
                                        <input type="checkbox" name="toLastPage" id="toLastPage"><label for="toLastPage">${lfn:message("km-forum:KmForumPost.notify.title.replyTips") }</label>
                                        <%--匿名回复--%>
		                                <span class="item" id="isAnonymous">     
				                            <xform:checkbox property="fdIsAnonymous" htmlElementProperties="disabled:true">
						                        <xform:simpleDataSource value="1">${lfn:message("km-forum:KmForumPost.notify.title.anonReply") }</xform:simpleDataSource>
						                    </xform:checkbox> 
		                                </span>
	                              </c:if>
                               </span> 
                           </span>
                        </td>
                    </tr>
                </table>
               </div>
             </html:form>
            <!-- 新建帖子表格 结束 -->
		<script>
			var _validation=$KMSSValidation();
		</script>
	</template:replace>
</template:include>
