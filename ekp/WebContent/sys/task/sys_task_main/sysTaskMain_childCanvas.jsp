<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/third/pda/htmlhead.jsp"%>
   <div style="padding-top:10px">
		<img src="../images/STATUS_INACTIVE.gif" title="<bean:message bundle="sys-task" key = "sysTaskMain.status.inactive"/>"/><bean:message bundle="sys-task" key = "sysTaskMain.status.inactive"/>
		<img src="../images/STATUS_PROGRESS.gif" title="<bean:message bundle="sys-task" key = "sysTaskMain.status.progress"/>"/><bean:message bundle="sys-task" key = "sysTaskMain.status.progress"/>
		<img src="../images/STATUS_COMPLETE.gif" title="<bean:message bundle="sys-task" key = "sysTaskMain.status.complete"/>"/><bean:message bundle="sys-task" key = "sysTaskMain.status.complete"/>
		<img src="../images/STATUS_OVERRULE.gif" title="<bean:message bundle="sys-task" key = "sysTaskMain.status.overrule"/>"/><bean:message bundle="sys-task" key = "sysTaskMain.status.overrule"/>
		<img src="../images/STATUS_TERMINATE.gif" title="<bean:message bundle="sys-task" key = "sysTaskMain.status.terminate"/>"/><bean:message bundle="sys-task" key = "sysTaskMain.status.terminate"/>
		<select onchange="swapProcess(this)">
		<option value="task" selected><bean:message bundle="sys-task" key = "sysTaskMain.processIco.task"/></option>
		<option value="person"><bean:message bundle="sys-task" key = "sysTaskMain.processIco.person"/></option>
		</select>
	</div>
    <div style="padding-top: 30px;margin-left:60px">
		<script>
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
		<script>
			${jsonString}	
		</script>
		<style>
		.noteDiv {
			position: absolute;
			white-space: nowrap;
			height: 100px;
			width: 250px;
		}
		
		.ttb_noborder, .ttd_noborder, .ttb_noborder td{
			border: 0px;
			padding:0px;
			border-collapse:collapse;
		}
		.back {
			position: fixed;
			bottom: 50px;
			left: 4%;
			z-index: 999;
			background: url(../images/back.png) no-repeat;
			width: 25px;
			height: 25px;
		}
		</style>
		<script type="text/javascript"
			src="${KMSS_Parameter_ContextPath}sys/task/js/wz_jsgraphics.js"></script>
		<script>
			var _rurl = "${KMSS_Parameter_ContextPath}sys/task/";
			var _url = "<%=request.getContextPath()%>";
			if(_url.length==1){
				_url = _url.substring(1,_url.lenght);
			}
		</script>
		<div id="taskCanvas"
			style="position: relative; height: ${level*100-20}px; width: 100%;"></div>
		<div id="personCanvas"
			style="position: relative; height: ${level*100-20}px; width: 100%;display:none;"></div>
		<%@ include file="../js/task.jsp"%>
		 <div class="back" onclick="Com_OpenWindow('${KMSS_Parameter_ContextPath}sys/task/sys_task_main/sysTaskMain.do?method=view&fdId=${taskId}','_self');"></div>
</div>