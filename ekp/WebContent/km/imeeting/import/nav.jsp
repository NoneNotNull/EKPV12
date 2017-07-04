<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<c:set var="key" value="${param.key}"/>
<c:set var="criteria" value="${param.criteria}"/>
<%--会议日历--%>
<ui:content title="${ lfn:message('km-imeeting:kmImeeting.tree.calender') }" expand="${param.key != 'calendar'?'false':'true' }" >
	<ul class='lui_list_nav_list'>
		<%--会议资源日历--%>
		 <li><a href="javascript:void(0)" onclick="window.open('${LUI_ContextPath }/km/imeeting/km_imeeting_calendar/rescalendar.jsp','_self');" title="${lfn:message('km-imeeting:kmImeeting.tree.calender.rescalendar') }">${lfn:message('km-imeeting:kmImeeting.tree.calender.rescalendar') }</a></li>
		 <%--我的会议日历--%>
		<li><a href="javascript:void(0)" onclick="window.open('${LUI_ContextPath }/km/imeeting/km_imeeting_calendar/mycalendar.jsp','_self');" title="${lfn:message('km-imeeting:kmImeeting.tree.calender.mycalendar') }">${lfn:message('km-imeeting:kmImeeting.tree.calender.mycalendar') }</a></li>
	</ul>
</ui:content>
<%--会议统计--%>
<ui:content title="${ lfn:message('km-imeeting:kmImeeting.tree.stat') }" expand="${param.key != 'stat'?'false':'true' }" >
	<ui:menu layout="sys.ui.menu.ver.default">
		<%--部门会议统计--%>
		<ui:menu-popup text="${ lfn:message('km-imeeting:kmImeeting.tree.stat.dept')}" style="margin-bottom:3px;" align="right-top" borderWidth="2" icon="lui_icon_s_icon_1">
			<div style="width: 500px;">
				<ui:dataview>
					<ui:source type="Static">
						[{
							"text":"${lfn:message('km-imeeting:kmImeetingStat.stat.thrught')}",
							"children":[{	
									"text":"${lfn:message('km-imeeting:kmImeetingStat.dept.stat')}",		
									"href":"/km/imeeting/km_imeeting_stat/index.jsp?stat_key=dept.stat",
									"target":"_self"
								},{
									"text":"${lfn:message('km-imeeting:kmImeetingStat.dept.statMon')}",		
									"href":"/km/imeeting/km_imeeting_stat/index.jsp?stat_key=dept.statMon",
									"target":"_self"
							}]
						}]
					</ui:source>
					<ui:render ref="sys.ui.treeMenu2.cate"></ui:render>
				</ui:dataview>
			</div>
		</ui:menu-popup>
		<%--个人会议统计--%>
		<ui:menu-popup text="${ lfn:message('km-imeeting:kmImeeting.tree.stat.person')}" style="margin-bottom:3px;" align="right-top" borderWidth="2" icon="lui_icon_s_icon_1">
			<div style="width: 500px;">
				<ui:dataview>
					<ui:source type="Static">
						[{
							"text":"${lfn:message('km-imeeting:kmImeetingStat.stat.thrught')}",
							"children":[{	
									"text":"${lfn:message('km-imeeting:kmImeetingStat.person.stat')}",		
									"href":"/km/imeeting/km_imeeting_stat/index.jsp?stat_key=person.stat",
									"target":"_self"
								},{
									"text":"${lfn:message('km-imeeting:kmImeetingStat.person.statMon')}",		
									"href":"/km/imeeting/km_imeeting_stat/index.jsp?stat_key=person.statMon",
									"target":"_self"
							}]
						}]
					</ui:source>
					<ui:render ref="sys.ui.treeMenu2.cate" ></ui:render>
				</ui:dataview>
			</div>
		</ui:menu-popup>
		<%--会议室资源统计--%>
		<ui:menu-popup text="${ lfn:message('km-imeeting:kmImeeting.tree.stat.res')}" align="right-top" borderWidth="2" icon="lui_icon_s_icon_1">
			<div style="width: 500px;">
				<ui:dataview>
					<ui:source type="Static">
						[{
							"text":"${lfn:message('km-imeeting:kmImeetingStat.stat.thrught')}",
							"children":[{	
									"text":"${lfn:message('km-imeeting:kmImeetingStat.resource.stat')}",		
									"href":"/km/imeeting/km_imeeting_stat/index.jsp?stat_key=resource.stat",
									"target":"_self"
								},{
									"text":"${lfn:message('km-imeeting:kmImeetingStat.resource.statMon')}",		
									"href":"/km/imeeting/km_imeeting_stat/index.jsp?stat_key=resource.statMon",
									"target":"_self"
							}]
						}]
					</ui:source>
					<ui:render ref="sys.ui.treeMenu2.cate"></ui:render>
				</ui:dataview>
			</div>
		</ui:menu-popup>
	</ui:menu>
</ui:content>
<%--会议安排--%>
<ui:content title="${ lfn:message('km-imeeting:kmImeeting.tree.meeting') }" expand="${param.key != 'imeeting'?'false':'true' }" >
	<ul class='lui_list_nav_list'>
	    <li><a href="javascript:void(0)" onclick="setUrl('imeeting','mymeeting','');" title="${ lfn:message('km-imeeting:kmImeeting.tree.meeting.allMeeting') }">${ lfn:message('km-imeeting:kmImeeting.tree.meeting.allMeeting') }</a></li>
	    <li><a href="javascript:void(0)" onclick="setUrl('imeeting','mymeeting','myAttend');" title="${ lfn:message('km-imeeting:kmImeeting.myAttend') }">${ lfn:message('km-imeeting:kmImeeting.myAttend') }</a></li>
	    <li><a href="javascript:void(0)" onclick="setUrl('imeeting','mymeeting','myHaveAttend');" title="${ lfn:message('km-imeeting:kmImeeting.myHaveAttend') }">${ lfn:message('km-imeeting:kmImeeting.myHaveAttend') }</a></li>
		<li><a href="javascript:void(0)" onclick="setUrl('imeeting','mymeeting','myCreate');" title="${ lfn:message('km-imeeting:kmImeeting.tree.meeting.myCreate') }">${ lfn:message('km-imeeting:kmImeeting.tree.meeting.myCreate') }</a></li>
		<li><a href="javascript:void(0)" onclick="setUrl('imeeting','mymeeting','myApproval');" title="${ lfn:message('km-imeeting:kmImeeting.tree.meeting.myApproval') }">${ lfn:message('km-imeeting:kmImeeting.tree.meeting.myApproval') }</a></li>
		<li><a href="javascript:void(0)" onclick="setUrl('imeeting','mymeeting','myApproved');" title="${ lfn:message('km-imeeting:kmImeeting.tree.meeting.myApproved') }">${ lfn:message('km-imeeting:kmImeeting.tree.meeting.myApproved') }</a></li>
	</ul> 
</ui:content>
<%--纪要与反馈--%>
<ui:content title="${ lfn:message('km-imeeting:kmImeeting.tree.summary') }" expand="${param.key != 'summary' ?'false':'true'}">
           <ul class='lui_list_nav_list'>
		    <li><a href="javascript:void(0)" onclick="setUrl('summary','mysummary','');" title="${ lfn:message('km-imeeting:kmImeeting.tree.summary.allSummary') }">${ lfn:message('km-imeeting:kmImeeting.tree.summary.allSummary') }</a></li>
			<li><a href="javascript:void(0)" onclick="setUrl('summary','mysummary','myCreate');" title="${ lfn:message('km-imeeting:kmImeeting.tree.summary.myCreate') }">${ lfn:message('km-imeeting:kmImeeting.tree.summary.myCreate') }</a></li>
			<li><a href="javascript:void(0)" onclick="setUrl('summary','mysummary','myApproval');" title="${ lfn:message('km-imeeting:kmImeeting.tree.summary.myApproval') }">${ lfn:message('km-imeeting:kmImeeting.tree.summary.myApproval') }</a></li>
			<li><a href="javascript:void(0)" onclick="setUrl('summary','mysummary','myApproved');" title="${ lfn:message('km-imeeting:kmImeeting.tree.summary.myApproved') }">${ lfn:message('km-imeeting:kmImeeting.tree.summary.myApproved') }</a></li>
		</ul>
</ui:content>
<%-- 后台配置 --%>
<ui:content title="${ lfn:message('list.otherOpt') }" expand="${param.key == 'uploadAtt' ?'true':'false'}">
	<ul class='lui_list_nav_list'>
		<li><a href="javascript:void(0)" onclick="window.open('${LUI_ContextPath }/km/imeeting/km_imeeting_uploadAtt/index.jsp','_self');">${ lfn:message('km-imeeting:kmImeeting.tree.uploadAtt') }</a></li>
		<li><a href="${LUI_ContextPath }/sys/?module=km/imeeting" target="_blank">${ lfn:message('list.manager') }</a></li>
	</ul>
</ui:content>
<script>
	seajs.use([
	   	'lui/jquery', 
	   	'lui/util/str', 
	   	'lui/dialog'
	   	], function($, strutil, dialog){
	   	
		window.setUrl=function(key,mykey,type){
			//重刷页面
			if(key!="${key}"){
				//会议安排
				if(key == 'imeeting'){
					if(type ==''){
			        	openUrl('km_imeeting_main','');
				    }else{
		    			openUrl('km_imeeting_main','cri.q='+mykey+':'+type);
				    }
			     }
			     //会议纪要
			     if(key == 'summary'){
			    	 if(type ==''){
			    		openUrl('km_imeeting_summary','');
				    }else{
			    	 	openUrl('km_imeeting_summary','cri.q='+mykey+':'+type);
				    }
			     }
			}else{
				//不需要冲刷页面
				openQuery();
				if(type==''){
					LUI('${criteria}').clearValue();
				}else{
					 LUI('${criteria}').setValue(mykey, type);
				}
			}
		};
		window.openUrl = function(prefix,hash){
		    var srcUrl = "${LUI_ContextPath}/km/imeeting/";
			srcUrl = srcUrl+ prefix+"/index.jsp";
			if(hash!=""){
				srcUrl+="#"+hash;
		    }
			window.open(srcUrl,"_self"); 
		};
	});
</script>