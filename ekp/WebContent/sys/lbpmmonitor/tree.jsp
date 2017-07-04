<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/resource/jsp/tree_top.jsp" %>
//Com_Parameter.XMLDebug = true;
function generateTree()
{
	LKSTree = new TreeView(
		"LKSTree",
		"<bean:message key="module.sys.lbpmmonitor" bundle="sys-lbpmmonitor"/>",
		document.getElementById("treeDiv")
	);
	var n1, n2, n3;
	n1 = LKSTree.treeRoot;

	//所有流程
	n2 = n1.AppendURLChild(
		"<bean:message bundle="sys-lbpmmonitor" key="sysLbpmMonitor.tree.allFlow"/>",
		"<c:url value="/sys/lbpmmonitor/sys_lbpm_monitor_flow/sysLbpmMonitor_index.jsp" />"
	);
	
	//异常的流程
	n2 = n1.AppendURLChild(
		"<bean:message bundle="sys-lbpmmonitor" key="sysLbpmMonitor.tree.errorFlow"/>",
		"<c:url value="/sys/lbpmmonitor/sys_lbpm_monitor_flow/sysLbpmMonitor_index.jsp?fdStatus=21" />"
	);
	
	//我刚处理过的流程
	n2 = n1.AppendURLChild(
		"<bean:message bundle="sys-lbpmmonitor" key="sysLbpmMonitor.tree.recentHandleFlow"/>",
		"<c:url value="/sys/lbpmmonitor/sys_lbpm_monitor_flow/sysLbpmMonitor_index.jsp?query=recentHandle" />"
	);
	
	//流程版本管理
	n2 = n1.AppendURLChild(
		"<bean:message bundle="sys-lbpmmonitor" key="sysLbpmMonitor.tree.versionMng"/>",
		"<c:url value="/sys/lbpmmonitor/sys_lbpm_monitor_flowVersion/index.jsp" />"
	);
	
	//按模块
	n2 = n1.AppendURLChild(
		"<bean:message bundle="sys-lbpmmonitor" key="sysLbpmMonitor.tree.module"/>"
	);
	
	var parameter=new Array();
	parameter[0]='';
	
	n2.AppendBeanData("sysLbpmMonitorModuleTreeService&current=!{value}",parameter,null,false);
	
	LKSTree.OnNodeQueryClick=function(node){
		if(node.nodeType=="CATEGORY"){
			var mainFrameSrc=parent.frames['viewFrame'].location.href;
			if(mainFrameSrc){
				if(mainFrameSrc.indexOf("#")!=-1){
					mainFrameSrc=mainFrameSrc.substring(0,mainFrameSrc.indexOf("#"));
				}
				var re = new RegExp();
				re.compile("([\\?&]modelName=)[^&]*", "i");
				if(re.test(mainFrameSrc)){
					mainFrameSrc = mainFrameSrc.replace(re, "$1!{value}");
				}else{
					var index=mainFrameSrc.indexOf("?");
					if(index!=-1){
						var url=mainFrameSrc.substring(0,index);
						var queryString=mainFrameSrc.substring(index+1);
						mainFrameSrc=url+"?modelName=!{value}"+"&"+queryString;
					}else{
						mainFrameSrc=mainFrameSrc+"?modelName=!{value}";
					}
				}
				node.parameter[0]=mainFrameSrc;
			}else{
				node.parameter[0]='<c:url value="/sys/lbpmmonitor/sys_lbpm_monitor_flow/sysLbpmMonitor_index.jsp?modelName=!{value}" />';
			}	
		}
	}
	
	LKSTree.EnableRightMenu();
	LKSTree.Show();
}

<%@ include file="/resource/jsp/tree_down.jsp" %>