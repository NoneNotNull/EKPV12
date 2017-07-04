<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="java.util.Date"%>
<%@page import="com.landray.kmss.util.DateUtil"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/person/person.tld" prefix="person"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/mobile/mui.tld" prefix="mui"%>
<template:include ref="mobile.view" compatibleMode="true">
	<template:replace name="head">
		<link rel="Stylesheet" href="${LUI_ContextPath}/sys/mobile/css/themes/default/header.css" />
		<link rel="Stylesheet" href="${LUI_ContextPath}/sys/mobile/css/themes/default/nav.css" />
		<link rel="Stylesheet" href="${LUI_ContextPath}/sys/mobile/css/themes/default/listview.css" />
		<link rel="Stylesheet" href="${LUI_ContextPath}/sys/mobile/css/themes/default/person.css" />
		<link rel="Stylesheet" href="${LUI_ContextPath}/sys/task/mobile/resource/css/view.css" />
		<mui:min-file name="mui-task.js"/>
	</template:replace>
	<template:replace name="title">
		<c:if test="${not empty sysTaskMainForm.docSubject}">
			<c:out value="${ sysTaskMainForm.docSubject}"></c:out>
		</c:if>
		<c:if test="${empty sysTaskMainForm.docSubject}">
			<c:out value="${lfn:message('sys-task:module.sys.task') }"></c:out>
		</c:if>
	</template:replace>
	<template:replace name="content">
		<div id="scrollView"  class="gray"
			data-dojo-type="mui/view/DocScrollableView"
			data-dojo-mixins="mui/list/_ViewPushAppendMixin">
			<xform:text property="docCreateTime" showStatus="noShow"></xform:text>
			<div class="muiTaskInfoBanner">
				<dl class="txtInfoBar">
					<dt>
						<%--任务名称--%>
						<xform:text property="docSubject"></xform:text>
					</dt>
					<dd>
						<i class="mui mui-meeting_date"></i>
						<%--截止时间--%>
						截止时间:
						<xform:datetime property="fdPlanCompleteDate" dateTimeType="date"></xform:datetime>&nbsp;
						<xform:datetime property="fdPlanCompleteTime" dateTimeType="time"></xform:datetime>
					</dd>
				</dl>
				<%-- 状态 --%>
				<span class="leftTag">
					<c:import url="/sys/task/mobile/import/status.jsp">
						<c:param name="status" value="${ sysTaskMainForm.fdStatus}"></c:param>
					</c:import>
				</span>
				<%-- 进度 --%>
				<div class="progressBar">
					<span class="progress">
						<div class="progresstxt">
							<span>进度</span><br/>
							<c:out value=" ${sysTaskMainForm.fdProgress}"></c:out>
							<span class="percentage">%</span>
						</div>
					</span> 
				</div>
				<%-- 截止日期 --%>
				<div class="deadLinedayBar rightTag">
					<span class="deadLineday"></span><br/>
					<span class="deadLineunit"></span>
				</div>
			</div>
			
			<div data-dojo-type="mui/fixed/Fixed" id="fixed">
				<div data-dojo-type="mui/fixed/FixedItem">
					<%--切换页签--%>
					<div class="muiHeader">
						<div
							data-dojo-type="mui/nav/MobileCfgNavBar" 
							data-dojo-props="scrollDir:'',defaultUrl:'/sys/task/mobile/view_nav.jsp' ">
						</div>
					</div>
				</div>
			</div>
			
			<%--任务内容页签--%>
			<div id="contentView" data-dojo-type="dojox/mobile/View">
				
				<ul data-dojo-type="sys/task/mobile/resource/js/OverflowTabBar">
					<%--未结项的任务才可以进行执行反馈、任务评价、更新进度、终止任务/取消终止、分解子任务、编辑、驳回任务等操作--%>	
					<c:if test="${sysTaskMainForm.fdStatus != '6' }">
						<%-- 执行反馈 --%>
						<kmss:auth
							requestURL="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=add&flag=${param.flag}&fdTaskId=${param.fdId}"
							requestMethod="GET">
							<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtn muiBtnFeedback" 
			  					data-dojo-props="icon:'mui mui-task-icon',colSize:2,href:'/sys/task/sys_task_feedback/sysTaskFeedback.do?method=add&fdTaskId=${param.fdId}'">执行反馈</li>
		  				</kmss:auth>
		  				<%-- 标记完成(条件:1.未完成 2.不存在子任务) --%>
		  				<c:if test="${sysTaskMainForm.fdStatus != '3' && childSize == 0  }">	
		  					<kmss:auth
							requestURL="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=add&flag=${param.flag}&fdTaskId=${param.fdId}"
							requestMethod="GET">
			  					<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtn muiBtnComplete" 
			  						data-dojo-props="icon:'mui mui-task-icon',colSize:2,href:'javascript:window.complete();'">标记完成</li>
		  					</kmss:auth>
		  				</c:if>
		  				
		  				<%-- 分解子任务 --%>
		  				<c:if test="${sysTaskMainForm.fdStatus != '4' && sysTaskMainForm.fdStatus != '3' }">
							<c:if test="${sysTaskMainForm.fdResolveFlag != 'true' }">
								<kmss:auth
									requestURL="/sys/task/sys_task_main/sysTaskMain.do?method=addChildTask&fdTaskId=${param.fdId}&flag=${param.flag}"
									requestMethod="GET">
			  							<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtn muiBtnFeedback" 
		  									data-dojo-props="icon:'mui mui-task-icon',colSize:2,href:'javascript:addChild();'">分解子任务</li>
				  				</kmss:auth>	
				  			</c:if>
				  		</c:if>
				  		<%-- 任务评价 --%>
				  		<kmss:auth
							requestURL="/sys/task/sys_task_evaluate/sysTaskEvaluate.do?method=add&flag=${param.flag}&fdTaskId=${param.fdId}"
							requestMethod="GET">
			  				<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtn muiBtnComplete" 
			  					data-dojo-props="icon:'mui mui-task-icon',colSize:2,href:'/sys/task/sys_task_evaluate/sysTaskEvaluate.do?method=add&fdTaskId=${param.fdId}'">任务评价</li>
			  			</kmss:auth>	
	  				</c:if>
				</ul>
				
				<div class="sysTaskPanel" data-dojo-type="mui/panel/AccordionPanel" data-dojo-props="fixed:false">
					<div data-dojo-type="mui/panel/Content"  data-dojo-props="title:'${lfn:message('sys-task:sysTaskMain.docContent') }',icon:''">
						<div class="txtContent">
							<%--任务内容--%>
							<div class="muiTaskContentDiv">
								<xform:rtf property="docContent" mobile="true"></xform:rtf>
							</div>
							<%-- 上级任务 --%>
							<c:if test="${sysTaskMainForm.fdParentName != null}">
								<div class="muiTaskLink">
									<a href='../sys_task_main/sysTaskMain.do?method=view&fdId=${sysTaskMainForm.fdParentId}' target="_self">
										<div class="muiTaskLinkTitle">
											<bean:message bundle="sys-task" key="sysTaskMain.fdParentId" />
										</div>
										<div class="muiTaskLinkSubject">
											<c:out value="${sysTaskMainForm.fdParentName}" />
										</div>
										<div class="muiTaskLinkR">
											<i class="muiAttachmentItemExpand mui mui-forward"></i>
										</div>
									</a>
								</div>
							</c:if>
							<%-- 任务来源 --%>
							<c:if test="${not empty sysTaskMainForm.fdSourceSubject && not empty sysTaskMainForm.fdSourceUrl}">
								<div class="muiTaskLink">
									<a href='<c:url value="${sysTaskMainForm.fdSourceUrl}"/>' target="_self">
										<div class="muiTaskLinkTitle">
											<bean:message bundle="sys-task" key="sysTaskMain.fdSourceSubject" />
										</div>
										<div class="muiTaskLinkSubject">
											<c:out value="${sysTaskMainForm.fdSourceSubject}" />
										</div>
										<div class="muiTaskLinkR">
											<i class="muiAttachmentItemExpand mui mui-forward"></i>
										</div>
									</a>
								</div>
							</c:if>
							<c:if test="${not empty sysTaskMainForm.fdSourceSubject && empty sysTaskMainForm.fdSourceUrl}">
								<div class="muiTaskLink">
									<div class="muiTaskLinkTitle">
										<bean:message bundle="sys-task" key="sysTaskMain.fdSourceSubject" />
									</div>
									<div class="muiTaskLinkSubject">
										<c:out value="${sysTaskMainForm.fdSourceSubject}" />
									</div>
								</div>
							</c:if>
							
							
							
						</div>
					</div>
					
					<c:import url="/sys/attachment/mobile/import/view.jsp" charEncoding="UTF-8">
		            	<c:param name="fdKey" value="attachment"/>
		            	<c:param name="formName" value="sysTaskMainForm"/>
		            </c:import>
		            
		            <div data-dojo-type="mui/panel/Content" data-dojo-props="title:'相关人员',icon:''">
						<div class="txtContent">
							<ul class="muiTaskList performPersonContainer">
								<%--指派人--%>
								<li>
									<div data-dojo-type="mui/person/PersonList"
										data-dojo-props="title:'指派人',detailTitle:'指派人',personId:'${sysTaskMainForm.fdAppointId }'">
									</div>
								</li>
								<%--负责人--%>
								<li>
									<div data-dojo-type="mui/person/PersonList"
										data-dojo-props="title:'负责人',detailTitle:'负责人',personId:'${sysTaskMainForm.fdPerformId }'">
									</div>
								</li>
								<c:if test="${not empty sysTaskMainForm.fdCcIds }">
								<%--抄送人--%>
								<li>
									<div data-dojo-type="mui/person/PersonList"
										data-dojo-props="title:'抄送人',detailTitle:'抄送人',personId:'${sysTaskMainForm.fdCcIds }'">
									</div>
								</li>
								</c:if>
							</ul>
						</div>
					</div>
					
					
				</div>
			
			</div>
			
			<%--子任务页签--%>
			<div id="childTaskView" data-dojo-type="dojox/mobile/View">
					
				<ul data-dojo-type="sys/task/mobile/resource/js/OverflowTabBar">
	  				<%-- 分解子任务 --%>
	  				<c:if test="${sysTaskMainForm.fdStatus != '4' && sysTaskMainForm.fdStatus != '3' && sysTaskMainForm.fdStatus != '6' }">
						<c:if test="${sysTaskMainForm.fdResolveFlag != 'true' }">
							<kmss:auth
								requestURL="/sys/task/sys_task_main/sysTaskMain.do?method=addChildTask&fdTaskId=${param.fdId}&flag=${param.flag}"
								requestMethod="GET">
		  							<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtn muiBtnFeedback" 
	  									data-dojo-props="icon:'mui mui-task-icon',colSize:2,href:'javascript:addChild();'">分解子任务</li>
			  				</kmss:auth>	
			  			</c:if>
			  		</c:if>
				</ul>
					
			    <ul data-dojo-type="sys/task/mobile/resource/js/list/SysTaskJsonStoreList" 
			    	data-dojo-mixins="sys/task/mobile/resource/js/list/CalendarItemListMixin"
			    	data-dojo-props="url:'/sys/task/sys_task_main/sysTaskIndex.do?method=list&orderby=docCreateTime&ordertype=down&parentTaskId=${sysTaskMainForm.fdId }',lazy:false">
				</ul>
			</div>
			
			<%--反馈页签--%>
			<div id="feedbackView"  data-dojo-type="dojox/mobile/View">
				<ul data-dojo-type="sys/task/mobile/resource/js/OverflowTabBar">
	  				<%--未结项的任务才可以进行执行反馈、任务评价、更新进度、终止任务/取消终止、分解子任务、编辑、驳回任务等操作--%>	
					<c:if test="${sysTaskMainForm.fdStatus != '6' }">
						<%-- 执行反馈 --%>
						<kmss:auth
							requestURL="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=add&flag=${param.flag}&fdTaskId=${param.fdId}"
							requestMethod="GET">
							<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtn muiBtnFeedback" 
			  					data-dojo-props="icon:'mui mui-task-icon',colSize:2,href:'/sys/task/sys_task_feedback/sysTaskFeedback.do?method=add&fdTaskId=${param.fdId}'">执行反馈</li>
		  				</kmss:auth>
		  				<%-- 标记完成(条件:1.未完成 2.不存在子任务) --%>
	  					<c:if test="${sysTaskMainForm.fdStatus != '3' && childSize == 0  }">	
		  					<kmss:auth
							requestURL="/sys/task/sys_task_feedback/sysTaskFeedback.do?method=add&flag=${param.flag}&fdTaskId=${param.fdId}"
							requestMethod="GET">
			  					<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtn muiBtnComplete" 
			  						data-dojo-props="icon:'mui mui-task-icon',colSize:2,href:'javascript:window.complete();'">标记完成</li>
		  					</kmss:auth>
		  				</c:if>
				  		<%-- 任务评价 --%>
				  		<kmss:auth
							requestURL="/sys/task/sys_task_evaluate/sysTaskEvaluate.do?method=add&flag=${param.flag}&fdTaskId=${param.fdId}"
							requestMethod="GET">
			  				<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtn muiBtnComplete" 
			  					data-dojo-props="icon:'mui mui-task-icon',colSize:2,href:'/sys/task/sys_task_evaluate/sysTaskEvaluate.do?method=add&fdTaskId=${param.fdId}'">任务评价</li>
			  			</kmss:auth>	
	  				</c:if>
				</ul>
				
				<div class="sysTaskPanel" data-dojo-type="mui/panel/AccordionPanel" data-dojo-props="fixed:false">
					<div data-dojo-type="mui/panel/Content"  data-dojo-props="title:'任务反馈',icon:''">
						<ul data-dojo-type="sys/task/mobile/resource/js/list/SysTaskJsonStoreList" 
					    	data-dojo-mixins="sys/task/mobile/resource/js/list/FeedbackItemListMixin"
					    	data-dojo-props="url:'/sys/task/sys_task_feedback/sysTaskFeedback.do?method=list&fdTaskId=${sysTaskMainForm.fdId}',lazy:false">
						</ul>
					</div>
					<div data-dojo-type="mui/panel/Content"  data-dojo-props="title:'任务评价',icon:''">
						<ul data-dojo-type="sys/task/mobile/resource/js/list/SysTaskJsonStoreList" 
					    	data-dojo-mixins="sys/task/mobile/resource/js/list/EvaluateItemListMixin"
					    	data-dojo-props="url:'/sys/task/sys_task_evaluate/sysTaskEvaluate.do?method=list&fdTaskId=${sysTaskMainForm.fdId}',lazy:false">
						</ul>
					</div>
				</div>
				
				
			</div>
			
			<%--分解图页签--%>
			<div id="picView" data-dojo-type="dojox/mobile/View">
				<%--任务分解图/责任分解图选项--%>
				<div 	data-dojo-type="dojox/mobile/ScrollableView"
	       				data-dojo-props="scrollDir:'h',scrollBar:false,threshold:20,height:'400px'">
	       			<div>
					<div class="picStatus">
						<img src="../images/STATUS_INACTIVE.gif" title="<bean:message bundle="sys-task" key = "sysTaskMain.status.inactive"/>"/><bean:message bundle="sys-task" key = "sysTaskMain.status.inactive"/>
						<img src="../images/STATUS_PROGRESS.gif" title="<bean:message bundle="sys-task" key = "sysTaskMain.status.progress"/>"/><bean:message bundle="sys-task" key = "sysTaskMain.status.progress"/>
						<img src="../images/STATUS_COMPLETE.gif" title="<bean:message bundle="sys-task" key = "sysTaskMain.status.complete"/>"/><bean:message bundle="sys-task" key = "sysTaskMain.status.complete"/>
						<img src="../images/STATUS_OVERRULE.gif" title="<bean:message bundle="sys-task" key = "sysTaskMain.status.overrule"/>"/><bean:message bundle="sys-task" key = "sysTaskMain.status.overrule"/>
						<img src="../images/STATUS_TERMINATE.gif" title="<bean:message bundle="sys-task" key = "sysTaskMain.status.terminate"/>"/><bean:message bundle="sys-task" key = "sysTaskMain.status.terminate"/>
						<img src="../images/STATUS_CLOSE.gif" title="<bean:message bundle="sys-task" key = "sysTaskMain.status.close"/>"/><bean:message bundle="sys-task" key = "sysTaskMain.status.close"/>
					</div>
					<div class="picSelect">
						<select onchange="swapProcess(this)">
							<option value="task" selected><bean:message bundle="sys-task" key = "sysTaskMain.processIco.task"/></option>
							<option value="person"><bean:message bundle="sys-task" key = "sysTaskMain.processIco.person"/></option>
						</select>
					</div>
					<%--任务分解图/责任分解图--%>
					<div style="clear: both;">
						<script>${jsonString}</script>
						<script type="text/javascript"src="${LUI_ContextPath}/sys/task/js/wz_jsgraphics.js"></script>
						<script>
							var _rurl = "${LUI_ContextPath}/sys/task/";
							var _url = "<%=request.getContextPath()%>";
							if(_url.length==1){
								_url = _url.substring(1,_url.lenght);
							}
							function swapProcess(el){
								for(var i=0;i<el.length;i++){
									if(i==el.selectedIndex){
										document.getElementById(el.options[i].value+"Canvas").style.display="";
									}else{
										document.getElementById(el.options[i].value+"Canvas").style.display="none";
									}
								}
							}
						</script>
						<div id="taskCanvas" style="position: relative;height: ${level*100-20}px;width: 100%;"></div>
						<div id="personCanvas" style="position: relative;height: ${level*100-20}px; width: 100%;display:none;"></div>
						<%@ include file="../js/task.jsp"%>
					</div>
					</div>
				</div>
			</div>
			
			<ul data-dojo-type="mui/tabbar/TabBar" fixed="bottom" >
			  	<li data-dojo-type="mui/back/BackButton"
			  		data-dojo-props="doBack:window.doBack"></li>
			  	<%--未结项的任务才可以进行执行反馈、任务评价、更新进度、终止任务/取消终止、分解子任务、编辑、驳回任务等操作
				<c:if test="${sysTaskMainForm.fdStatus != '6' }">
					<kmss:auth
						requestURL="/sys/task/sys_task_main/sysTaskMain.do?method=edit&flag=${param.flag}&fdId=${param.fdId}"
						requestMethod="GET">
						<li data-dojo-type="mui/tabbar/TabBarButton" class="muiBtnSubmit " 
						 	 data-dojo-props='colSize:2,href:"/sys/task/sys_task_main/sysTaskMain.do?method=edit&flag=${param.flag}&fdId=${param.fdId}",transition:"slide"'>编辑</li>
					</kmss:auth>
				</c:if>--%>	
				<%-- 任务关注 --%>
				<c:if test="${sysTaskMainForm.fdStatus != '6' }">
					<li data-dojo-type="mui/tabbar/TabBarButton" 
						data-dojo-mixins="sys/task/mobile/resource/js/_AttentionTabBarButtonMixin"
						data-dojo-props='icon1:"mui mui-focus-on",fdId:"${param.fdId}",hasAttention:${isAttention}'></li>
				</c:if>
				
		    	<li data-dojo-type="mui/tabbar/TabBarButtonGroup" style="float: right;" data-dojo-props="icon1:'mui mui-more'">
		    		<div data-dojo-type="mui/back/HomeButton"></div>
		    	</li>
			</ul>
			
		</div>
		
		
		
		
		
	</template:replace>
</template:include>
<script>
	require(['dojo/_base/array',
	         'dojo/query',
	         'dojo/date/locale',
	         'dojo/date',
	         'dojo/ready',
	         'dojo/topic',
	         'dijit/registry',
	         'dojo/dom-geometry',
	         'dojo/request',
	         'mui/dialog/Tip',
	         'dojox/mobile/TransitionEvent',
	         'mui/rtf/RtfResizeUtil'
	         ],function(array,query,locale,date,ready,topic,registry,domGeometry,request,Tip,TransitionEvent,RtfResizeUtil){
		
		//切换标签重新计算高度
		var _position=domGeometry.position(query('#fixed')[0]),
		_scrollTop=0;
		topic.subscribe("/mui/list/_runSlideAnimation",function(srcObj, evt) {
			_scrollTop= Math.abs(evt.to.y);
		});
		topic.subscribe("/mui/navitem/_selected",function(){
			var view=registry.byId("scrollView");
			if(_scrollTop > _position.y){
				view.handleToTopTopic(null,{
					y: 0 - (_position.y)
				});
			}
		});
		
		//切换标签时resize rtf中的表格
		var hasResize=false;
		topic.subscribe("/mui/navitem/_selected",function(widget,args){
			var feedbackView=registry.byId("feedbackView");
			if(!hasResize  && widget.moveTo=='feedbackView'  ){
				hasResize=true;
				setTimeout(function(){
					var arr=query('#feedbackView .content');
					array.forEach(arr,function(item){
						new RtfResizeUtil({
							channel:item.id,
							containerNode:item
						});
					});
				},1);
			}
		});
		
		var docCreateTime='${sysTaskMainForm.docCreateTime}',//创建时间
			fdPlanComplete='${sysTaskMainForm.fdPlanCompleteDate}'+' '+'${sysTaskMainForm.fdPlanCompleteTime}';//截止时间
		docCreateTime=parseDate(docCreateTime);
		fdPlanComplete=parseDate(fdPlanComplete);
		
		
		//截止日期倒计时
		var Timer=setInterval(_setInterval,1000*60);
		function _setInterval(){
			//已完成不显示
			if('${sysTaskMainForm.fdStatus}'== '3' || '${sysTaskMainForm.fdStatus}'== '6'){
				query('.deadLineday')[0].innerHTML='';
				query('.deadLineunit')[0].innerHTML='';
				Timer=null;
			}else{
				var now=new Date(),
				duration=date.difference(now,fdPlanComplete,'millisecond'),
				description='剩余';
				
				if(duration < 0){
					description='超期'
					duration= 0 - duration;
				}
				//X天(大于1天)
				if(duration >= 1000*60*60*24){
					var day=parseInt( duration/(24*60*60*1000) );
					query('.deadLineday')[0].innerHTML=day;
					query('.deadLineunit')[0].innerHTML=description+'天';
				}
				//X小时(不足一天)
				if(duration<1000*60*60*24 && duration>=1000*60*60){
					var hour=parseInt( duration % (24*60*60*1000) /(60*60*1000) );
					if(hour<1){
						hout=1;
					}
					query('.deadLineday')[0].innerHTML=hour;
					query('.deadLineunit')[0].innerHTML=description+'小时';
				}
				//X分钟(不足一小时)
				if(duration <1000*60*60 && duration>=0 ){ 
					var minute=parseInt(duration/(60*1000)) ;
					if(minute<1){
						minute=1;
					}
					query('.deadLineday')[0].innerHTML=minute;
					query('.deadLineunit')[0].innerHTML=description+'分钟';
				}
				
			}
		}
		_setInterval();
		
		//分解子任务
		window.addChild=function(){
			var lever = ${currentLevel};
			if(lever >= 3){
				Tip.tip({
					text:"${ lfn:message('sys-task:sysTaskMain.lever.number.message')}"
				});
			}else{
				window.open('${LUI_ContextPath}/sys/task/sys_task_main/sysTaskMain.do?method=addChildTask&fdTaskId=${param.fdId}&flag=${param.flag}','_self');
			}
		};
		
		//标记完成
		window.complete=function(){
			
			var processing=Tip.processing();//加载中...
			
			processing.show();
			
			var url='${LUI_ContextPath}/sys/task/sys_task_main/sysTaskMain.do?method=updateFinish&fdTaskId=${param.fdId}';
			var promise = request.post(url, {
                timeout: 5000
            }).then(function(result) {
            	//success	
            	processing.hide(false);
            	Tip.success({text: "操作成功", callback:function(){
            		location.reload();
            	} });
            	
            }, function(result) {
            	//fail
            });
			
		};
		
		//返回
		window.doBack=function(){
			window.open('${LUI_ContextPath}/sys/task/mobile/index.jsp','_self');
		};
		
		
		//String类型转化为Date类型
		function parseDate(/*String*/ date){
			return locale.parse(date,{
				selector : 'time',
				timePattern : 'yyyy-MM-dd HH:mm'//先写死,不考虑国际化
			});
		}
		
	});

</script>
