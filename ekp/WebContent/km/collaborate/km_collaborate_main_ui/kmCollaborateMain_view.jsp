<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="com.landray.kmss.km.collaborate.model.KmCollaborateConfig"%>
<template:include ref="default.view" sidebar="no" width="980px">
	 <!-- 导航区域 -->
	<template:replace name="title">
		<c:out value="${kmCollaborateMainForm.docSubject} - ${ lfn:message('km-collaborate:table.kmCollaborateMainTitle') }"></c:out>
	</template:replace>
	<template:replace name="head">
		 <link href="${LUI_ContextPath}/km/collaborate/resource/css/collaborate_view.css" rel="stylesheet" type="text/css" />
		 <script type="text/javascript">
			seajs.use(['lui/jquery','lui/dialog'], function(_$, _dialog) {
					  $=_$;
					  dialog=_dialog;
					
					//结束沟通
					window.delDoc = function(){
				         dialog.confirm("<bean:message key='kmCollaborate.jsp.jsgt' bundle='km-collaborate'/>",function(value){
							if(value==true){
								window.del_load = dialog.loading();
								$.post('<c:url value="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=conclude&fdId=${param.fdId }"/>',
									"",delCallback,'json');
							}
						});
					};		
		
		/**************************结束沟通回调函数*********************************/	
			window.delCallback = function(data){
				if(window.del_load!=null)
					window.del_load.hide();
				if(data!=null && data.status==true){
					dialog.success('<bean:message key="return.optSuccess" />');
					setTimeout(function (){
						location.reload(true);
					}, 1500)
					
				}else{
					dialog.failure('<bean:message key="return.optFailure" />');
				}
			};
		});
				/**************************回复按钮事件*********************************/
				function focuOnTarget(){
					 var editor=CKEDITOR.instances.fdContent;
					 editor.setData($("#fdContent___Config").val());
					 editor.focus();
					 $('input[name=fdReplyType]')[0].checked='true';
					 window.location.href='#replyContent';
				} 
		
		/**************************加载完成事件*********************************/
			LUI.ready(function(){
			     //初始化显示回复列表
				var iframe = document.getElementById("win");
				 iframe.src = "../km_collaborate_main_reply/kmCollaborateMainReply.do?method=replyList&mainId=${param.fdId}&pageno=1&rowsize=10&sortType=asc";
			
			    //悬浮事件		 
				$("#signTo").hover(function(){
					$("#zone-bar-main").css("top",($(this).offset().top-$("#zone-bar-main").height()/2+$(this).height()/2)+"px");
					$("#zone-bar-main").css("left",($(this).offset().left-112)+"px");
					$("#zone-bar-main").show();
					$("#signTo").css("background-image","url(${LUI_ContextPath}/km/collaborate/resource/images/15-1.png)");
					canHide=false;
				},function(){
					canHide=true;
		            window.clearTimeout(t); //将上次的定时器清除,重新设置
			    	var t = window.setTimeout(doHide,300); //在间隔1000毫秒后执行是否隐藏处理
					});
				$("#zone-bar-main").hover(function(){
					  $("#signTo").css("background-image","url(${LUI_ContextPath}/km/collaborate/resource/images/15.png)");
					  canHide=false;
					},function(){
					  canHide=true;
					  window.clearTimeout(t); //将上次的定时器清除,重新设置
				      var t = window.setTimeout(doHide,300); //在间隔1000毫秒后执行是否隐藏处理
						});
		
			    //隐藏
				function doHide(){
					if(canHide){
				    $("#signTo").css("background-image","url(${LUI_ContextPath}/km/collaborate/resource/images/15.png)");
					$("#zone-bar-main").hide();
				 	}
				}
				//初始化按钮
				var isFollow = "${isfollow}";
				if(isFollow == "1"){
		  			 $("#attention").hide();
			    }else{
			    	 $("#cancleAttention").hide();
				}

				//关注等按钮事件
				$("#zone-bar-main > ul a").click(function(){
					var name=$(this).attr("name");
			  		var message="";
			  		var message_false="";
			  		if(name=="readed"){
			  			 message="<bean:message bundle='km-collaborate' key='kmCollaborate.jsp.readed.success' />";
			  			 message_false="<bean:message bundle='km-collaborate' key='kmCollaborate.jsp.readed.failure' />";
			  		}else if(name=="notRead"){
			  			 message="<bean:message bundle='km-collaborate' key='kmCollaborate.jsp.unRead.success' />";
			  			 message_false="<bean:message bundle='km-collaborate' key='kmCollaborate.jsp.unRead.failure' />";
			  			
			  		}else if(name=="attention"){
			  			 message="<bean:message bundle='km-collaborate' key='kmCollaborate.jsp.attention.success' />";
			  			 message_false="<bean:message bundle='km-collaborate' key='kmCollaborate.jsp.attention.failure' />";
			  			 $("#cancleAttention").show();
			  			 $("#attention").hide();
			  		}else if(name=="cancleAttention"){
			  			 message="<bean:message bundle='km-collaborate' key='kmCollaborate.jsp.calcelAtt.success' />";
			  			 message_false="<bean:message bundle='km-collaborate' key='kmCollaborate.jsp.calcelAtt.failure' />";
			  			 $("#cancleAttention").hide();
			  			 $("#attention").show();
			  			
			  		}
					$.get("<c:url value='/km/collaborate/km_collaborate_partner_info/kmCollaboratePartnerInfo.do'/>?method=isRead&"+"flag="+$(this).attr("name")+"&docid=${kmCollaborateMainForm.fdId}",function(json){
						if(json['value']==true){
							  dialog.success(message);
					       }else{
							  dialog.failure(message_false);
					       }
					},"json");
				});
				$("input[type='checkbox']").focus(function(){
					$("#fdNotifyType").hide();
				}); 
		
				//窗口滑动显示
				window['$FIRST_LOAD']=false;
				window['$Click']="";
				$("#win").load(function(){
					if(!$FIRST_LOAD){
		              window.scroll(0, 0);
				 	  window['$FIRST_LOAD']=true;
					}else{
						window.scroll(0, $("#win").offset().top-40);
					}
				}); 
		
				//设置默认回复语
				 var status="${kmCollaborateMainForm.docStatus}";
				 if(status=="30"){
					 CKEDITOR.on('instanceReady', function (e) { 
						 var editor=CKEDITOR.instances.fdContent;
					 	 editor.setData($("#fdContent___Config").val());
						 editor.focus();
						 });
			   	}
		         //默认加载相关交流
				 setTab('one', 1, 2);
			});
		
			
			// 编辑按钮
			function edit(){
				Com_OpenWindow('kmCollaborateMain.do?method=editContent&fdId=${param.fdId}','_self');
			}
		   //获取富文本框内容
		   function RTF_GetContent(prop){
		    var instance=CKEDITOR.instances[prop];
		    if(instance){
		          return instance.getData();
		    }
		    return "";
		}
		
		    //提交按钮事件
			function formSubmit() {
				var v=RTF_GetContent("fdContent");
				if(v==null ||v=="") {
					dialog.alert('<bean:message  bundle="km-collaborate" key="kmCollaborate.fdContent.notNull"/>');
					return;
				}
				document.getElementsByName("fdContent")[0].value=v;
				if($("input[name='fdNotifyType']").val()=="" || $("input[name='fdNotifyType']").val()==null)
				{
					 $("#fdNotifyType").show();
					 return;
				}
				for(var i=0; i<Com_Parameter.event["confirm"].length; i++){
					if(!Com_Parameter.event["confirm"][i]()){
						return false;
					}
				}
					$.ajax({
						url: '${LUI_ContextPath}/km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do?method=saveReply',
						type: 'POST',
						dataType: 'json',
						async: false,
						data: $("#kmCollaborateMainReply").serialize(),
						success: function(data, textStatus, xhr) {
							if(data==true){
								dialog.success('<bean:message  bundle="km-collaborate" key="kmCollaborateMain.submitSuccess"/>');
								setTimeout(function (){
									  document.getElementById('win').contentWindow.location.reload(true);
									  //重置内容
								      var editor=CKEDITOR.instances.fdContent;
									  editor.setData($("#fdContent___Config").val());
									  //清除附件区域
									  document.getElementById("att_xtable_replyAttachment").innerHTML="";
									  attachmentObject_replyAttachment.fileList=[];
									  //回复数+1
									  var readCount=document.getElementById("replyCount").innerHTML;
									  document.getElementById("replyCount").innerHTML=parseInt(readCount)+1;
								}, 1500);
								
								 //刷新事件
								  if(window.opener!=null) {
									var hrefUrl= window.opener.location.href;
									var localUrl = location.href;
									if(hrefUrl.indexOf("/sys/notify/")>-1 && localUrl.indexOf("/sys/notify/")==-1)
										window.opener.location.reload();
									try {
										if (window.opener.LUI) {
											window.opener.LUI.fire({ type: "topic", name: "successReloadPage" });
											return;
										}
									} catch(e) {}
									if (window.LUI) {
										LUI.fire({ type: "topic", name: "successReloadPage" }, window.opener);
									}
								}
								
								
							}else{
								dialog.faiture('<bean:message  bundle="km-collaborate" key="kmCollaborateMain.submitFaiture"/>!');
							}
						}
					});
			    //5秒后才能再次使用
				var submitVar=document.getElementById("btn_submit_com");
				submitVar.disabled=true;
				setTimeout("document.getElementById('btn_submit_com').disabled=false;", 5000);	
				
			}
			
			/** 选项卡切换 ***********************************************************************************************/
			function setTab(name, cursel, n) {
			    for (var i = 1; i <= n; i++) {
			        var menu = document.getElementsByName(name + i);
			        for(var j=0;j<menu.length;j++){
		               menu[j].className = i == cursel ? "current" : "";
			        }
			       
			    }
				var iframe = document.getElementById("win");
				var fdIsOnlyView = '${kmCollaborateMainForm.fdIsOnlyView}';
			    if(cursel=="1"){
				 iframe.src = "../km_collaborate_main_reply/kmCollaborateMainReply.do?method=replyList&mainId=${param.fdId}&docCreatorId=${kmCollaborateMainForm.docCreatorId}&pageno=1&rowsize=10&sortType=asc&fdIsOnlyView="+fdIsOnlyView;
			    }else{
			     iframe.src = "../km_collaborate_partner_info/kmCollaboratePartnerInfo.do?method=condition&fdId=${kmCollaborateMainForm.fdId}&docCreatorId=${kmCollaborateMainForm.docCreatorId}&type=name&rowsize=10&fdIsOnlyView="+fdIsOnlyView;
			    }
			};
		    </script>
			<style>
			 .notNull{display:none;padding-left:10px;border:solid #DFA387 1px;padding-top:8px;padding-bottom:8px;background:#FFF6D9;color:#C30409;margin-top:3px;}
			</style>
	</template:replace>
	<!-- 导航区域 -->
	<template:replace name="path">
			<ui:menu layout="sys.ui.menu.nav">
				<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home" href="/" target="_self">
				</ui:menu-item>
				<ui:menu-item text="${lfn:message('km-collaborate:table.kmCollaborateMainTitle')}" href="/km/collaborate/" target="_self">
				</ui:menu-item>
				<ui:menu-source autoFetch="false" target="_self" href="/km/collaborate/#cri.q=fdCategory:!{value}">
					 <ui:source type="AjaxJson">
						{"url":"/km/collaborate/km_collaborate_category/kmCollaborateCategory.do?method=getCategoryNavPath&cateId=${kmCollaborateMainForm.fdCategoryId}"} 
					</ui:source>
			    </ui:menu-source>
		</ui:menu>
	</template:replace>	
	<!-- 内容区域 -->
<template:replace name="content"> 
     	<% 
		   KmCollaborateConfig kmCollaborateConfig=new KmCollaborateConfig();
		   String fdcontent=kmCollaborateConfig.getDefaultReply();
		   request.setAttribute("fdConfigContent",fdcontent);	
		   request.setAttribute("fdIsEdit",kmCollaborateConfig.getFdIsEdit());
		   request.setAttribute("userId",UserUtil.getUser().getFdId());
		   request.setAttribute("replyNotifyType", kmCollaborateConfig.getDefaultNotifyType());
		%>
    <!-- 快捷菜单 -->
        <div class="work_comm_menu">
            <ul>
            <!-- 回复按钮 -->
            <kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=partners&fdId=${param.fdId }">
				   <c:if test="${kmCollaborateMainForm.docStatus eq '30' }">	
		                <li class="item_1" title="${lfn:message('km-collaborate:kmCollaborateMain.docReplyCount')}" onclick="focuOnTarget();"></li>
		           </c:if>   
		    </kmss:auth>
		    <!-- 转发按钮 -->
		    <kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=add&showForward=true&showid=${param.fdId }">
		                <li class="item_2" title="${lfn:message('km-collaborate:button.showForward')}" onclick="Com_OpenWindow('kmCollaborateMain.do?method=add&showForward=true&showid=${param.fdId}','_self'); "></li>
		    </kmss:auth>    
		     <!-- 标记按钮 --> 
		     <kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=mark&fdId=${param.fdId }">
				  <c:if test="${ !isAdminOnly}" >          
		                <li class="item_3" title="${lfn:message('km-collaborate:kmCollaborate.jsp.signTo')}" id="signTo"> </li>
		          </c:if>    
		     </kmss:auth>   
		     <!-- 结束按钮 -->
		     <kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=conclude&fdId=${param.fdId }">
				 	<c:if test="${kmCollaborateMainForm.docStatus eq '30' }">
		                <li class="item_4" title="${lfn:message('km-collaborate:kmCollaborate.jsp.endMain')}" onclick="delDoc();"></li>
		             </c:if>
		     </kmss:auth>          
            </ul>
       </div>		
<!-- 点击【标记】按钮出现选项区域 -->	
<div id="zone-bar-main" style=" z-index:1;display: none">
<ul id="zone-bar">
    <c:if test="${kmCollaborateMainForm.docCreatorId ne current_user_id}">
		<li><a ref="sign" href="#" name="readed" id="readed"><bean:message key='kmCollaborate.jsp.yudu' bundle='km-collaborate' /></a></li>
		<li><a ref="sign" href="#" name="notRead" id="notRead"><bean:message key='kmCollaborate.jsp.weidu' bundle='km-collaborate' /></a></li>
	</c:if>
	<li><a ref="sign" href="#" name="attention" id="attention"><bean:message key='kmCollaborate.jsp.attention' bundle='km-collaborate' /></a></li>
	<li><a ref="sign" href="#" name="cancleAttention" id="cancleAttention"><bean:message key='kmCollaborate.jsp.calcelAtt' bundle='km-collaborate' /></a></li>
</ul> 
<img src="${LUI_ContextPath}/km/collaborate/resource/images/from_right.png"/>
</div>


  <div class="work_comm_ViewContentL">
        <div class="work_comm_ViewContentR">
              <div class="work_comm_ViewContentC">
                  <!-- 标题 Begin -->
                       <div class="work_comm_Title clrfix">
                            <!-- 作者头像 -->
	                            <div class="left"><img src="${ LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId=${kmCollaborateMainForm.docCreatorId}" alt="${lfn:message('km-collaborate:kmCollaborateLogs.docAuthor')}" /></div>
	                            <div class="right">
	                                <h1 class="title">
	                                   <!-- 标题 -->
	                                   <c:if test="${kmCollaborateMainForm.docStatus==40 }">
											   <img src="../img/end.gif" style="vertical-align: middle;">
										</c:if>
	                                    <c:if test="${kmCollaborateMainForm.fdIsPriority }">
											   <img  src="${KMSS_Parameter_ContextPath}km/collaborate/img/gt_zy.png" title="${ lfn:message('km-collaborate:kmCollaborateMain.highPriority') }">
										 </c:if> 
										 <c:out value="${kmCollaborateMainForm.docSubject}"/>
	                                </h1>
	                                    <!-- 基本信息 -->
	                                <div class="baseInfo">
	                                     <!-- 创建者 -->
	                                    <span><ui:person personId="${kmCollaborateMainForm.docCreatorId}" personName="${kmCollaborateMainForm.docCreatorName}"></ui:person></span>
	                                     <!-- 时间 -->
	                                    <span>${lfn:message('km-collaborate:kmCollaborate.jsp.at')}<bean:write name="kmCollaborateMainForm" property="docCreateTime" /></span>
	                                   	<!--阅读数-->
						            	<bean:message key="kmCollaborate.jsp.yuedu" bundle="km-collaborate"/>
						            		 <c:if test="${not empty kmCollaborateMainForm.docReadCount}">
						            	        <span>(<font class="com_number">${kmCollaborateMainForm.docReadCount}</font>)
						            	        </span>
						            	     </c:if>
						            	      <c:if test="${empty kmCollaborateMainForm.docReadCount}">
						            	        <span>(<font class="com_number">0</font>)
						            	        </span>
						            	     </c:if>
	                                    <!--回复数--> 
						             	<bean:message key="kmCollaborate.jsp.reply" bundle="km-collaborate"/><span>(<font class="com_number" id="replyCount">${ kmCollaborateMainForm.docReplyCount}</font>)</span>
	                                 </div>
	                            </div>
			                      <c:if test="${kmCollaborateMainForm.docStatus eq '30' }">
								  <!-- 参数设置中，false为允许编辑，true为不允许编辑 -->
									  <c:if test="${fdIsEdit=='0'}">
										  <kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=editContent&fdId=${param.fdId}" requestMethod="GET">	
                                               <a class="a_edit" title="${lfn:message('km-collaborate:kmCollaborate.jsp.bianji')}"  onclick="edit();">${lfn:message('km-collaborate:kmCollaborate.jsp.bianji')}</a>
									      </kmss:auth>
								       </c:if>
							       </c:if>
                     </div>
                    <!-- 标题 End -->
                    <!--内容区域  -->
                    <div class="work_comm_Content">
                            <!-- 最后修改者信息 -->
                            <c:if test="${not empty kmCollaborateMainForm.docAlterorId}">
                               <p class="last_eidt"> ${lfn:message('km-collaborate:kmCollaborate.jsp.mainView.str')}&nbsp;
                                  <ui:person personId="${kmCollaborateMainForm.docAlterorId}" personName="${kmCollaborateMainForm.docAlterorName}"></ui:person> 
                                   ${lfn:message('km-collaborate:kmCollaborate.jsp.yu')}
                                   <c:out value="${kmCollaborateMainForm.docAlterTime}"/> 
                                   ${lfn:message('km-collaborate:kmCollaborate.jsp.bianji')}
                               </p>
                             </c:if>
                             <!-- 文件来源,办理依据-->
							 <c:if test="${not empty kmCollaborateMainForm.fdSourceUrl}">
								<bean:message bundle="km-collaborate" key="kmCollaborateMain.fdSource"/>：
							        <a href="<c:url value="${kmCollaborateMainForm.fdSourceUrl}"/>" target="_blank"><span class="com_subject">${kmCollaborateMainForm.fdSourceSubject}</span></a>
							        <br>
							</c:if>
                            <!-- 主要内容显示信息 -->
                              <c:if test="${not empty kmCollaborateMainForm.fdContent}">
                                   <p id="kcContent_p" style="overflow:hidden;">
                                       <xform:rtf property="fdContent"></xform:rtf>
                                   </p>
                              </c:if>
                             <!--附件-->
							<c:if test="${not empty kmCollaborateMainForm.attachmentForms['attachment'].attachments}">    
							  	<div class="lui_form_spacing"> </div>
							    <div>
									<div class="lui_form_subhead"><img src="${KMSS_Parameter_ContextPath}sys/attachment/view/img/attachment.png"> ${ lfn:message('km-collaborate:kmCollaborate.jsp.attachment') }(${fn:length(kmCollaborateMainForm.attachmentForms['attachment'].attachments)})</div>
									<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
										<c:param name="fdKey" value="attachment" />
										<c:param name="fdModelId" value="${param.fdId}" />
										<c:param name="formBeanName" value="kmCollaborateMainForm" />
									</c:import>
									<!-- 附件权限设置开始 -->
									  <c:if test="${kmCollaborateMainForm.fdEditAtt=='false'&&userId != kmCollaborateMainForm.docCreatorId}">
										   <script>
										      attachmentObject_attachment_${param.fdId}.canEdit=false;
										   </script>
									 </c:if>
										  
									 <c:if test="${fdIsEdit=='1'&& userId == kmCollaborateMainForm.docCreatorId}">
										  <script>
										      attachmentObject_attachment_${param.fdId}.canEdit=false;
										   </script>
										    <!-- 附件权限设置结束-->
									  </c:if>
						    	</div>
							</c:if> 
        			    </div>  
        			    <!-- 附件结束 -->
                </div>
         </div>
 </div>               
 
 
 <c:if test="${kmCollaborateMainForm.docStatus eq '30' }">
   <!-- 回复 Begin -->
        <div id="replyContent" class="lui_common_tabs_3_content_c comment" >
            <div class="lui_common_tabs_3_contentTopL" style="padding-left: 8px">
                <div class="lui_common_tabs_3_contentTopR">
                    <div class="lui_common_tabs_3_contentTopM clrfix">
	                        <div class="lui_common_tabs_3_title">
	                            ${lfn:message('km-collaborate:kmCollaborateMain.docReply')}
	                         </div>
                        <div class="clr">
                        </div>
                    </div>
                </div>
            </div>
            <div class="lui_common_tabs_3_contentMiddleL" style="padding-left: 8px;padding-right: 7px">
                <div class="lui_common_tabs_3_contentMiddleR">
                    <div class="lui_common_tabs_3_contentMiddleM" >
                          <html:form action="/km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do?method=saveReply" styleId="kmCollaborateMainReply">
								<input type="hidden" name="fdCommunicationMainId"  value="${param.fdId }" />
								<input type="hidden" id="fdParentId"  name="fdParentId"  value="" />
								<input type="hidden" id="fdId"  name="fdId"  value="" />
									 <table class="tb_normal" width=100% style="margin: 10px 0 0 0" >
									   <c:if test="${kmCollaborateMainForm.fdIsOnlyView!=true}">	
												<tr>
													    <!-- 回复方式 -->
														<td class="td_normal_title" width="100px" align="left"><bean:message bundle="km-collaborate" key="kmCollaborateMainReply.fdReplyType" /></td>
														<td>
															<input type="radio" name="fdReplyType" value="1" checked><bean:message key='kmCollaborate.jsp.creator' bundle='km-collaborate' />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
														 	<input type="radio" name="fdReplyType" value="2"><bean:message key='kmCollaborate.jsp.allPerson' bundle='km-collaborate' />
														</td>
												</tr>
								        </c:if>
								        <c:if test="${kmCollaborateMainForm.fdIsOnlyView==true}">	
												<tr>
													<!-- 回复方式 -->
												    <input type="hidden" name="fdReplyType" value="1"/>
												</tr>
								        </c:if>
											<tr>
												    <!-- 回复内容 -->
													<td class="td_normal_title" width="100px" align="left"><bean:message bundle="km-collaborate" key="kmCollaborateMainReply.fdContent" /></td>
													<td>
														<div>
														    <kmss:editor property="fdContent" height="160px" toolbarCanCollapse="all"></kmss:editor>
															<input type="hidden" id="fdContent___Config" value="${fdConfigContent}">
														</div> 
														<div class="tips">
															<img src="${LUI_ContextPath}/km/collaborate/resource/images/tip_bulb.png"/>
															<c:if test="${kmCollaborateMainForm.fdIsOnlyView!=true}">	
																	<bean:message bundle="km-collaborate" key="kmCollaboratePartnerInfo.fdIsOnlyView.tipsPublic" />
															</c:if>
															<c:if test="${kmCollaborateMainForm.fdIsOnlyView==true}">	
																	<bean:message bundle="km-collaborate" key="kmCollaboratePartnerInfo.fdIsOnlyView.tipsSecre" />
															</c:if>
														</div>
													</td>
										  </tr>
										  <tr>
												    <!-- 文档附件 -->
													<td class="td_normal_title" width="100px" align="left"><bean:message key='kmCollaborate.jsp.attachment' bundle='km-collaborate' /></td>
													<td>
													    <c:import url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp" charEncoding="UTF-8">
															<c:param name="fdKey" value="replyAttachment" />
															<c:param name="fdModelName" value="com.landray.kmss.km.collaborate.model.KmCollaborateMainReply" />
														</c:import>
												   </td>
										</tr>
										 <tr>
												    <!-- 通知方式 -->
													<td class="td_normal_title" width="100px" align="left"><bean:message bundle="km-collaborate" key="kmCollaborateMain.fdNotifyType" /></td>
													<td><kmss:editNotifyType property="fdNotifyType" value="${replyNotifyType}"/>
													    <div class="notNull" id="fdNotifyType">×&nbsp;&nbsp;&nbsp;<bean:message bundle="km-collaborate" key="kmCollaborateMain.choose.notifytype"/></div>
													</td>
										</tr>
								</table> 
						</html:form>
                        <!--按钮 Begin-->
                        <div class="lui_common_shade_btnGroup clrfix" title="${lfn:message('km-collaborate:kmCollaborateMain.pda.submit')}">
                            <ul class="shade_btn_box clrfix">
                                <li>
                                    <div class="shade_btnL">
                                        <div class="shade_btnR">
                                            <div class="shade_btnC">
                                            	 <ui:button id="btn_submit_com" style="width:65px" text="${lfn:message('button.submit')}" onclick="formSubmit();"/>
                                             </div>
                                        </div>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <!--按钮 End-->
                    </div>
                </div>
            </div>
            <div class="lui_common_tabs_3_contentBottomL">
                <div class="lui_common_tabs_3_contentBottomR">
                    <div class="lui_common_tabs_3_contentBottomM">
                    </div>
                </div>
            </div>
        </div>
        <!-- 回复 End -->
 </c:if> 
	       <!-- 参与情况和相关交流 -->
	         <!--头部 begin-->
	   <ui:fixed elem=".work_comm_tabs_1_titleL"></ui:fixed>
	   <div style="height: 12px;background-color: #f3f3f3;margin-bottom: -10px;" >
	   </div>      
       <div class="work_comm_tabs_1">	         
            <div class="work_comm_tabs_1_titleL">
                <div class="work_comm_tabs_1_titleR">
                    <div class="work_comm_tabs_1_titleM">
                        <ul>
                            <li id="one1" name="one1" class="current" onclick="setTab('one', 1, 2)"><span><a>${lfn:message('km-collaborate:kmCollaborate.jsp.xgjl')}</a></span>
                            </li>
                            <li id="one2" name="one2" onclick="setTab('one', 2, 2)"><span><a>${lfn:message('km-collaborate:kmCollaborate.jsp.cyqk')}</a></span> </li>
                        </ul>
                    </div>
                </div>
            </div>
			<div id="common" >
			   	<iframe  name="win" id="win" width="100%"  style="height: auto;" frameborder=0 scrolling=no>
				</iframe>
			</div> 
      </div>			
	</template:replace> 
</template:include>