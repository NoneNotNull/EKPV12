<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.km.collaborate.model.KmCollaborateConfig" %>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.simple">
	<template:replace name="body">
		<%
			KmCollaborateConfig kmCollaborateConfig = new KmCollaborateConfig();
			String Num = kmCollaborateConfig.getDefaultComNums();
			int comNum = Integer.parseInt(Num);
			request.setAttribute("comNum",comNum);
		%>
		<link href="${LUI_ContextPath}/km/collaborate/resource/css/collaborate_view.css" rel="stylesheet" type="text/css" />
       <style>
           body{background-color: #fff}
       </style>
        <script>Com_IncludeFile('ckresize.js', 'ckeditor/');</script>
        <script type="text/javascript">
		    Com_IncludeFile("jquery.js|dialog.js");
	   </script>
       <link type="text/css" rel="stylesheet" href="${LUI_ContextPath}/km/collaborate/js/jquery.qtip.css" />
       <script type="text/javascript" src="${LUI_ContextPath}/km/collaborate/js/jquery.qtip.js" charset="UTF-8"></script>
       <script type="text/javascript">
			seajs.use(['lui/jquery','lui/dialog'], function(_$, dialog) {
				//$=_$;
				//删除参与人员
				window.isDelete = function(mainId,personId){
				      	dialog.confirm("<bean:message key='kmCollaborate.jsp.confirm' bundle='km-collaborate'/>",function(value){
					      	if(value==true){
				      		$.getJSON('<c:url value="/km/collaborate/km_collaborate_partner_info/kmCollaboratePartnerInfo.do?method=delete"/>',{'fdParentId':mainId,'fdId':personId},function(data){
					      		if(data.success==true){
						      		dialog.success('<bean:message key="return.optSuccess" />');
					      		}else{
					      			dialog.failure('<bean:message key="return.optFailure" />');
						      		}
								var pageNo="${queryPage.pageno}";
								var id = '${kmCollaborateMain.fdId}';
								var type="${param.type}";
								var rowsize="${param.rowsize}";
								window.open('<c:url value="/km/collaborate/km_collaborate_partner_info/kmCollaboratePartnerInfo.do?method=condition&docCreatorId=${param.docCreatorId}&fdIsOnlyView=${param.fdIsOnlyView}&fdId='+ id +'&pageno='+pageNo+'&rowsize='+rowsize+'&type='+ type +'" />','_self');
						          });
					      	}
				      	});
				     }


				/********新增人员函数*******/
				window.submitValue=function() {
					// 判断参与人员是否改变，若没有改变，则不触发事件，若改变了则触发事件并且判断是否人员已经重复， 重复则去掉
					// 新添加的参与者Ids和Names
					var fdPersonIds = document.getElementById("fdPersonId").value;
					var fdPersonNames = document.getElementById("fdPersonName").value
					var personIds = new Array();
					var PersonNames = new Array();
					personIds=fdPersonIds.split(";");
					PersonNames=fdPersonNames.split(";");
					// 实际已经存在的参与者arrayObj为实际参与者数组
					var attendIds ="${attendIds}";
					// 若存在，则删除
					for ( var i=0 ; i < personIds.length ; ++i ) {
						if(IsInArray(attendIds,personIds[i])){
							delete personIds[i];
							delete PersonNames[i];
						}
					}
					// 判断是否存在
					function IsInArray(arr,val){    
						return arr.indexOf(val)!=-1;
					}
				      if(fdPersonIds!=""){
							if(personIds.join(";").replace(/;/g,"")!=""){
								//实际增加人数
								var num = 0;
								for(var id in personIds){
									if(id!="" && id!=null){
										num++;
								    }
							    }
							    var pageCount = "${pageCount}";
							    var comNum = "${comNum}";
								if(parseInt(pageCount) + parseInt(num) > parseInt(comNum) +1){
									dialog.alert("<bean:message key='kmCollaborate.jsp.morethan.comNum' bundle='km-collaborate' />");
									return;
								}
								
								var fdId=document.getElementsByName("fdCommunicationMainId")[0].value;
								$.ajaxSetup({ 
								    async : false
								}); 
								$.get('<c:url value="/km/collaborate/km_collaborate_partner_info/kmCollaboratePartnerInfo.do?method=saveCondition"/>',{'fdPersonId': personIds.join(";"),'fdCommunicationMainId':fdId},function(data){
						      		if(data=="succcess"){
							      		dialog.success('<bean:message key="return.optSuccess" />');
							      		setTimeout(function(){
							      			var pageNo="${queryPage.pageno}";
											var id = '${kmCollaborateMain.fdId}';
											var type="${param.type}";
											var rowsize="${param.rowsize}";
							      			window.open('<c:url value="/km/collaborate/km_collaborate_partner_info/kmCollaboratePartnerInfo.do?method=condition&docCreatorId=${param.docCreatorId}&fdIsOnlyView=${param.fdIsOnlyView}&fdId='+ id +'&pageno='+pageNo+'&rowsize='+rowsize+'&type='+ type +'" />','_self');
								      		},1000);
						      		}else{
						      			dialog.failure('<bean:message key="return.optFailure" />');
							      		}
								},'text');
		
							}else{
		                        dialog.alert("${lfn:message('km-collaborate:kmCollaborate.jsp.isExist')}");
							}
				      }
				}
				});
		LUI.ready(function(){
			CKResize.____ckresize____(true);
			//过滤标签
			$("div[name='lastReplyContent']").each(function(){
				var value=$(this).html();
				value = value.replace(/<\/?[^>]*>/g,''); //去除HTML tag
				value = value.replace(/[ | ]*\n/g,'\n'); //去除行尾空白
				$(this).html(value);
			});
			$("img[name='operate']").each(function(){
				$(this).qtip({
					content: {
					 attr: 'data-value'	
				   },	
				    position: {
						my: 'right center',
						at: 'top center',
					    effect: false
					}
					});
				});
			//排序样式
			initOrderCss();
			dyniFrameSize();
		});

/**
 * 初始化排序按钮的样式
 */
function initOrderCss(){
	var type="${param.type}";
	if(type=="name"){
         $("#name").attr("class","current");
         return;
	}
	if(type=="depart"){
		$("#depart").attr("class","current");
		return;
	}
	if(type=="condition"){
		$("#condition").attr("class","current");
		return;
	}
}

/**
 * 自适应高度
 */
function dyniFrameSize() {
	try {
		// 调整高度
		var arguObj = document.getElementById("content");
		
		if(window.frameElement!=null && window.frameElement.tagName=="IFRAME"){
			window.frameElement.style.height = (arguObj.offsetHeight + 70) + "px";
		}
	} catch(e) {
  }
}
/**
 * 排序
 */
	function changeSort(typek){
		var id = '${kmCollaborateMain.fdId}';
		var pageno="${queryPage.pageno}";
		var rowsize="${queryPage.rowsize}";
		window.open('<c:url value="/km/collaborate/km_collaborate_partner_info/kmCollaboratePartnerInfo.do?method=condition&docCreatorId=${param.docCreatorId}&fdIsOnlyView=${param.fdIsOnlyView}&fdId='+ id +'&pageno='+pageno+'&rowsize='+rowsize+'&type='+ typek +'" />','_self');
	}


	//增加人员操作
	function hello() {
		Dialog_Address(true,'fdPersonId','fdPersonName',';',ORG_TYPE_PERSON,submitValue);
	}

	/*格式化时间*/
	function fdTime(fdTime){
		var value = fdTime.substring(0, fdTime.length-5);
		return value;
	}
</script>
<html:form action="/km/collaborate/km_collaborate_partner_info/kmCollaboratePartnerInfo.do" styleId="km_collaborate_partner_info">
	<input type="hidden"  name="fdCommunicationMainId" value="${kmCollaborateMain.fdId }"/>
	<input type="hidden" id="fdPersonId" name="fdPersonId" />
	<input type="hidden" id="fdPersonName" name="fdPersonName" />
	<div id="content" class="discuss" >
		<div class="sort">
		     <!-- 排序 -->  
              <ul>
                <li id="name"><a href="javaScript:void(0)" name="name"  onclick="changeSort(name);"><bean:message key="kmCollaborate.jsp.fullName" bundle="km-collaborate"/></a></li>
	    		<li id="depart"><a href="javaScript:void(0)" name="depart" onclick="changeSort(name);"><bean:message key="kmCollaborate.jsp.department" bundle="km-collaborate"/></a></li>
	    		<li id="condition"><a href="javaScript:void(0)" name="condition" onclick="changeSort(name);"><bean:message key="kmCollaborate.jsp.status" bundle="km-collaborate"/></a></li>
            </ul>
       </div>
        <div class="info">
             <!-- 参与人数 -->${lfn:message('km-collaborate:kmCollaborateMain.participantTotal')}<span class="summary_tips"><c:out value="${pageCount}"/></span>${lfn:message('km-collaborate:kmCollaborateMain.participantPeoplr')}
            
            <!-- 新增人员按钮 -->
            <kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=saveCondition&fdId=${kmCollaborateMain.fdId}">
		            <c:if test="${kmCollaborateMain.docStatus== '30' }">
		    	          <input type="button" value="${lfn:message('km-collaborate:kmCollaborate.jsp.zjry')}" class="btn_add_staff" onclick="hello()"/>
		    	    </c:if>
		    	</kmss:auth> 
          </div>
  		<div ref="fdContent">     
   			<table class="comm_table">
                                <tr>
                                    <th class="th1"> ${lfn:message('km-collaborate:kmCollaborate.jsp.latestReply')}  </th>
                                    <th class="th2">${lfn:message('km-collaborate:kmCollaborate.jsp.fullName')}/${lfn:message('km-collaborate:kmCollaborate.jsp.department')}</th>
                                    <th class="th3"> ${lfn:message('km-collaborate:kmCollaborate.jsp.status')} </th>
                                    <th class="th4"> ${lfn:message('km-collaborate:kmCollaborateLogs.operate')}</th>
                                </tr>
 			  <c:forEach items="${queryPage.list}" var="kmCollaboratePartnerInfo" varStatus="vstatus">                                
                                <tr>
                                    <td style="text-align: left">
                                        <c:if test="${showPartner==true || param.fdIsOnlyView != true || userId == kmCollaboratePartnerInfo.fdPerson.fdId}">
	                                        <div class="p1">
	                                             <div id="_____rtf_____reply${kmCollaboratePartnerInfo.fdPerson.fdId}">
														${kmCollaboratePartnerInfo.fdLatestReply}
											     </div>
												 <div id='_____rtf__temp_____reply${kmCollaboratePartnerInfo.fdPerson.fdId}' style="width:400px"></div>
												 <script type="text/javascript">
													 var property = 'reply'+'${kmCollaboratePartnerInfo.fdPerson.fdId}';
													 CKResize.addPropertyName(property);
												 </script>
	                                         </div>
	                                        <span class="date">
	                                               <kmss:showDate value="${kmCollaboratePartnerInfo.fdLatestRTime}" type="datetime" />
	                                        </span>
	                                    </c:if>
                                    </td>
                                    <td>
                                        <input type="hidden" name="span" value="${kmCollaboratePartnerInfo.fdPerson.fdId }"/> 
                                        <p style="text-align: center;padding: 0px">${kmCollaboratePartnerInfo.fdPerson.fdName }</p>
                                        <!-- 部门 -->
                                        <p style="text-align: center;padding: 0px"><c:if test="${kmCollaboratePartnerInfo.fdPerson.fdParent!=null }">${kmCollaboratePartnerInfo.fdPerson.fdParent.fdName }</c:if></p>
                                    </td>
                                    <td>
                                         <span  class="status_replied">
									        <!-- 已回复-->
									        <c:if test="${kmCollaboratePartnerInfo.fdIsReply == true }"><img src="${LUI_ContextPath}/km/collaborate/resource/images/work_comm_status_1.png"  align="absmiddle" title="${lfn:message('km-collaborate:kmCollaborate.jsp.replied')}"/>&nbsp;<bean:message key="kmCollaborate.jsp.replied" bundle="km-collaborate"/></c:if>
									    	<c:if test="${kmCollaboratePartnerInfo.fdIsReply == false }">
									    	    <!-- 开封 -->
									    		<c:if test="${kmCollaboratePartnerInfo.fdIsRead == true }"><img src="${LUI_ContextPath}/km/collaborate/resource/images/work_comm_status_3.png"  align="absmiddle" title="${lfn:message('km-collaborate:kmCollaborate.jsp.readed')}"/>&nbsp;<bean:message key="kmCollaborate.jsp.readed" bundle="km-collaborate"/></c:if>
									    		<!-- 未开封 -->
									    		<c:if test="${kmCollaboratePartnerInfo.fdIsRead == false }"><img src="${LUI_ContextPath}/km/collaborate/resource/images/work_comm_status_2.png"  align="absmiddle" title="${lfn:message('km-collaborate:kmCollaborate.jsp.unRead')}"/>&nbsp;<bean:message key="kmCollaborate.jsp.unRead" bundle="km-collaborate"/></c:if>
									    	</c:if>
									    </span>
                                    </td>
                                    <td>
                                         <!-- 删除按钮 -->
                                	 <kmss:auth requestURL="/km/collaborate/km_collaborate_main/kmCollaborateMain.do?method=deletePartner&fdPartnerInfoId=${kmCollaboratePartnerInfo.fdId}&fdId=${kmCollaboratePartnerInfo.fdCommunicationMain.fdId }">
								    	<c:if test="${kmCollaboratePartnerInfo.fdIsRead == false &&kmCollaboratePartnerInfo.fdCommunicationMain.docStatus=='30'}">
								    	    <span><img src="${LUI_ContextPath}/km/collaborate/resource/images/work_comm_operate_1.png" onClick="isDelete('${kmCollaboratePartnerInfo.fdCommunicationMain.fdId }','${kmCollaboratePartnerInfo.fdId }')" title="${lfn:message('km-collaborate:kmCollaborateMain.delete')}" style="cursor:pointer"></span>
								    	</c:if>
									</kmss:auth>
							      <!-- 提示信息 -->
									 <c:if test="${kmCollaboratePartnerInfo.fdOperator != null }">
											<span> <img name="operate"  src="${LUI_ContextPath}/km/collaborate/resource/images/work_comm_operate_2.png" data-value='${kmCollaboratePartnerInfo.fdOperator.fdName}<bean:message bundle="km-collaborate" key="kmCollaborate.jsp.yu" /><kmss:showDate value="${kmCollaboratePartnerInfo.fdCreateTime}" type="datetime" /> <bean:message key="kmCollaborate.jsp.addPerson" bundle="km-collaborate"/>：${kmCollaboratePartnerInfo.fdPerson.fdName }'>	</span>			
								     </c:if>
                                    </td>
                                </tr>
   					</c:forEach>
   		 </table>
   		 <div class="info" style="border-bottom: 1px solid #e3e3e3;">
   ${lfn:message('km-collaborate:kmCollaborate.jsp.followers')}： <c:forEach items="${queryTotal}" var="kmCollaboratePartnerInfo" varStatus="vstatus">
					 <c:if test="${kmCollaboratePartnerInfo.fdIsFollow == true }">
						 ${kmCollaboratePartnerInfo.fdPerson.fdName};
					 </c:if>
			     </c:forEach>
         </div>
     </div>  
   </div>  
	    <list:paging></list:paging>	 
</html:form>
  <script>
    LUI.ready(function(){
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
						var fdId="${kmCollaborateMain.fdId}";
						var type="${param.type}";
						var url="../km_collaborate_partner_info/kmCollaboratePartnerInfo.do?method=condition&docCreatorId=${param.docCreatorId}&fdIsOnlyView=${param.fdIsOnlyView}&fdId="+fdId+"&pageno="+pageno+"&rowsize="+rowsize+"&type="+type;
						iframe.src =url;
			         	 });
				});
		})
    </script>
	</template:replace>
</template:include>