<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.landray.kmss.km.collaborate.model.KmCollaborateConfig"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="body">	
	   <link href="${LUI_ContextPath}/km/collaborate/resource/css/collaborate_view.css" rel="stylesheet" type="text/css" />
       <style>body{background-color: #fff}</style>
       <script>Com_IncludeFile('ckresize.js', 'ckeditor/');</script>
       <script>
     //自适应高度
     function dyniFrameSize() {
   		 try {
   				// 调整高度
   				var arguObj = document.getElementById("content");
   				if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
   						window.frameElement.style.height = (arguObj.offsetHeight+ 70) + "px";
   				}
   			} catch(e) {
   		  }
   	 };
   	seajs.use(['lui/jquery','lui/dialog'], function(_$, dialog) {
            $=_$;
            //回复操作
            window.replyOperation = function(mainId,fdParentId){
            	   dialog.iframe("/km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do?method=add&mainId="+mainId+"&fdParentId="+fdParentId,"${lfn:message('km-collaborate:kmCollaborateMainReply.replyCollaborate')}",
                 	   function(value){
                 	           if(value==null){  return;}
                 	           //刷新
                 	           forward(mainId);
	       	    	         }, {
             				    width : 950,
             				    height : 470
             	  });
            };
            //编辑操作
            window.editOperation = function(mainId,fdId){
            	  dialog.iframe("/km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do?method=edit&mainId="+mainId+"&fdId="+fdId,"${lfn:message('km-collaborate:kmCollaborateMainReply.replyEdit')}",
                    	   function(value){
                    	           if(value==null){  return;}
                    	           //刷新
                     	           forward(mainId);
                    	      
   	       	    	         }, {
                				    width : 950,
                				    height : 470
                	  });
            };
            //刷新页面
            window.forward = function(mainId){
            	  var pageno = document.getElementById("currPage").value;
            	  var rowsize = document.getElementById("currRowsize").value;
            	  var colla_url="${LUI_ContextPath}/km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do?method=replyList&docCreatorId=${param.docCreatorId}&fdIsOnlyView=${param.fdIsOnlyView}&mainId="+ mainId + "&pageno="+pageno+"&rowsize="+rowsize+"&sortType=asc";
            	  window.location.href=colla_url;
             };

    		 //排序操作
    		 window.sort = function(type) {
    				window.open("${KMSS_Parameter_ContextPath}km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do?method=replyList"+
    	    				"&docCreatorId=${param.docCreatorId}&fdIsOnlyView=${param.fdIsOnlyView}&mainId=${param.mainId}"+
    	    				"&rowsize=${param.rowsize}&pageno=1"+"&sortType="+type,"_self");
    		 };
    		LUI.ready(function(){
    	    	     //回复和编辑按钮中间的 | 控制
    	    	     //两个按钮都显示则显示|
    	    	    var totalRows="${queryPage.totalrows}";
    	    		if(totalRows>0){
    	    				$("div[ref='parentContent']").each(function(){
    	    					var value=$(this).html();
    	    					value=value.replace(/<\/?.+?>/g,"&nbsp;");
    	    					$(this).html(value);
    	    					
    	    				});
    	    		  } 
    	       	 });
            
       	});
</script>
		<% 
		   KmCollaborateConfig kmCollaborateConfig=new KmCollaborateConfig();
		   String fdcontent=kmCollaborateConfig.getDefaultReply();
		   request.setAttribute("fdcontent",fdcontent);	
		   request.setAttribute("fdIsEdit",kmCollaborateConfig.getFdIsEdit());
		%>
<c:if test="${queryPage.totalrows==0}">
<div id="content" style="background: #fff;">
	<%@ include file="/resource/jsp/list_norecord.jsp"%>
</div>
</c:if>
<c:if test="${queryPage.totalrows>0}">
         <div class="work_comm_tabs_1_contentL"  id="content" style="height:auto;margin-top: -17;">
			      <div class="work_comm_tabs_1_contentR">
			           <div class="work_comm_tabs_1_contentM">
			                <div class="discuss" id="con_one_1">
			                    <div class="sort">
			                         <!--排序-->
			                         <select style="right:15px;position:absolute;" name="type" class="dropdown"  onchange="sort(value)" >
					                         <c:if test="${param.sortType eq 'asc'}">
					                              <option value="asc"  selected="selected">${lfn:message('km-collaborate:kmCollaborate.jsp.zhengxu')}</option>
					                              <option value="desc">${lfn:message('km-collaborate:kmCollaborate.jsp.nixu')}</option>
					                         </c:if>
					                          <c:if test="${param.sortType eq 'desc'}">
					                              <option value="asc">${lfn:message('km-collaborate:kmCollaborate.jsp.zhengxu')}</option>
					                              <option value="desc"  selected="selected">${lfn:message('km-collaborate:kmCollaborate.jsp.nixu')}</option>
					                         </c:if>
			                           </select>
			                    </div>
			                      <dl class="discuss_dl">
			                         <c:forEach items="${queryPage.list}" var="reply" varStatus="varS">
										   <dd class="clrfix">
												       <!-- 头像 -->
								                       <div class="left"><img src="${ LUI_ContextPath }/sys/person/sys_person_zone/sysPersonZone.do?method=img&fdId=${reply.docCreator.fdId}" width="60" height="60" /></div>
								                       <div class="right">
								                             <!--显示楼层发表于-->
								                                 <div class="p1">
								                                      <span class="floor">${reply.docReplyFloor }${lfn:message('km-collaborate:kmCollaborate.jsp.lou')}</span><span class="author"> ${reply.docCreator.fdName }</span><span class="date">
								                                      ${lfn:message('km-collaborate:kmCollaborate.jsp.at')}
								                                      <kmss:showDate value="${reply.docCreateTime }" showTitle="true" isInterval="true" type="datetime"></kmss:showDate>
								                                 <!-- 被修改时间 -->
								                                 <c:if test="${reply.docAlterTime!=null}">
								                                      <span class="work_comm_Content">
									                                      <p class="last_eidt" style="margin-top: -12px"> ${lfn:message('km-collaborate:kmCollaborate.jsp.reply.str')}&nbsp;<ui:person personId="${reply.docAlteror.fdId}" personName="${reply.docAlteror.fdName}"></ui:person>
									                                      &nbsp;${lfn:message('km-collaborate:kmCollaborate.jsp.yu')}&nbsp;
									                                      <kmss:showDate value="${reply.docAlterTime}" showTitle="true" isInterval="true" type="datetime"></kmss:showDate>
									                                      &nbsp;${lfn:message('km-collaborate:kmCollaborate.jsp.bianji')}</p>
									                                  </span>
									                             </c:if>
								                                 </div>
						 		                                  <!--显示回复楼层内容-->
						                    		       <c:if test="${reply.fdParent != null }">	                                  
								                                    <div class="quoteL">
								                                            <div class="quoteR">
								                                                <div class="quoteC">
								                                                    <div class="quote_content">
								                                                        <div class="p1">
								                                                             <span class="floor">${reply.fdParent.docReplyFloor}${lfn:message('km-collaborate:kmCollaborate.jsp.lou')}</span>
								                                                             <span class="author">${reply.fdParent.docCreator.fdName }</span>
								                                                             <span class="date">
								                                                                  ${lfn:message('km-collaborate:kmCollaborate.jsp.at')}
								                                                                 <kmss:showDate value="${reply.fdParent.docCreateTime}" showTitle="true" isInterval="true" type="datetime"></kmss:showDate>
								                                                             </span>
								                                                        </div>
								                                                        <div class="p2" id="rfc${reply.fdId}" ref="fdContent" style=" border:0px solid #ccc; width:100%;min-height:20px;">
								                                                             <div id="_____rtf_____reply${reply.fdId}${reply.fdParent.fdId}">
														                                              ${reply.fdParent.fdContent }
														                                     </div>
													                                    	 <div id='_____rtf__temp_____reply${reply.fdId}${reply.fdParent.fdId}' style="width:75%"></div>
														                                     <script type="text/javascript">
																		                          var property = 'reply'+'${reply.fdId}${reply.fdParent.fdId}';
																							      CKResize.addPropertyName(property);
																					         </script>
                                                                                       </div>
								                                                    </div>
								                                                </div>
								                                            </div>
								 									 </div>
								                             </c:if>  
                                      							 <div class="p2" ref="fdContent">
								                                    &nbsp;
									                                     <div id="_____rtf_____reply${reply.fdId}">
									                                          ${contentMap[reply.fdId] }
									                                     </div>
								                                    	 <div id='_____rtf__temp_____reply${reply.fdId}' style="width:75%"></div>
									                                     <script type="text/javascript">
													                          var property1 = 'reply'+'${reply.fdId}';
																		      CKResize.addPropertyName(property1);
																         </script>
								                                  </div>
                                      							  
								                                  <!--显示附件-->
								                                   <p class="attach">
								                                          <c:set var="replyForm" value="${reply}" scope="request"/>     
																	          <c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
																					<c:param name="fdKey" value="replyAttachment"/>
																					<c:param name="fdAttType" value="byte"/>
																					<c:param name="fdModelId" value="${reply.fdId }"/>
																					<c:param name="formBeanName" value="replyForm"/>
																					<c:param name="fdModelName" value="com.landray.kmss.km.collaborate.model.KmCollaborateMainReply"/>
																			  </c:import>
																			  <script type="text/javascript">
																			   	  attachmentObject_replyAttachment_${reply.fdId}.showAfterCustom=function(){
																			    	  	 dyniFrameSize();
																				     };
																			 </script>	
																			<c:if test="${fdIsEdit=='1'}"> 
																			  <script type="text/javascript">
																			     attachmentObject_replyAttachment_${reply.fdId}.canEdit=false;
																			  </script>	
																            </c:if>
																	 </p>
								                                  <!--操作-->
								                                  <div class="operate">
										                                <!--回复-->
										                                <kmss:auth requestURL="/km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do?method=saveReply&fdId=${reply.fdId }&fdCommunicationMainId=${reply.fdCommunicationMain.fdId}">
																	    	<c:if test="${ reply.fdCommunicationMain.docStatus== '30' }">
		                                                                                <a id="reply" name="reply" class="a_operate" href="javascript:replyOperation('${reply.fdCommunicationMain.fdId}','${reply.fdId}');">
		                                                                                                              	${lfn:message('km-collaborate:kmCollaborateMain.docReply')}</a>
							  												            <c:if test="${fdIsEdit=='0'}">
														                                    <kmss:auth requestURL="/km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do?method=updateReply&fdId=${reply.fdId }&fdCommunicationMainId=${reply.fdCommunicationMain.fdId}">		    
																			     			   <span class="split" id="split">|</span>
																			     			 </kmss:auth>
																			  		    </c:if>
																	  		 </c:if>    
																	    </kmss:auth>
										                                    
																	     <!--编辑-->
										                                 <c:if test="${ reply.fdCommunicationMain.docStatus== '30' }">
					  												          <c:if test="${fdIsEdit=='0'}">
												                                    <kmss:auth requestURL="/km/collaborate/km_collaborate_main_reply/kmCollaborateMainReply.do?method=updateReply&fdId=${reply.fdId }&fdCommunicationMainId=${reply.fdCommunicationMain.fdId}">		    
																				         <input type="hidden" id="fdParentId_${reply.fdId}" value="${reply.fdParent.fdId}" />
																				         <a class="a_operate"  name="edit" href="javascript:editOperation('${reply.fdCommunicationMain.fdId}','${reply.fdId }')" id="edit">
																				         	${lfn:message('km-collaborate:kmCollaborate.jsp.bianji')}</a>
																			       </kmss:auth>
																	  		   </c:if>
																	      </c:if>
								                                  </div>
								                           </div>
								                     </dd>
								                </c:forEach>
			                           </dl>
					        </div>
					 </div>
			  </div>
	 </div>
	 <list:paging></list:paging>	 
</c:if>
	<input type="hidden" id="currPage" name="currPage" value="${queryPage.pageno}">
	<input type="hidden" id="currRowsize" name="currRowsize" value="${queryPage.rowsize}">
	<input type="hidden" id="currMainId" name="currMainId" value="${param.mainId}">
	<script>
    LUI.ready(function(){
        	dyniFrameSize();
        	CKResize.____ckresize____(true);
			seajs.use('lui/topic',function(topic){
				var evt = {
					    	page: {currentPage:"${queryPage.pageno}", pageSize:"${queryPage.rowsize}", totalSize:"${queryPage.totalrows}"}
			            	   }
					    topic.publish('list.changed',evt);
				        topic.subscribe('paging.changed',function(evt){
					    var  arr = evt.page;
					    var pageno=arr[0].value;
					    var rowsize=arr[1].value;
						var iframe = parent.document.getElementById("win");
					    var url="../km_collaborate_main_reply/kmCollaborateMainReply.do?method=replyList&docCreatorId=${param.docCreatorId}&fdIsOnlyView=${param.fdIsOnlyView}&mainId=${param.mainId}&pageno="+pageno+"&rowsize="+rowsize+"&sortType=asc";
						iframe.src =url;
			         	 });
				});
		});
		</script>
	</template:replace>
</template:include>