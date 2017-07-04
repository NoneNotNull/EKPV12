<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.landray.kmss.sys.lbpmservice.constant.LbpmConstants" %>
<%@ include file="/resource/jsp/common.jsp"%>
<script language="JavaScript">
<%--流程审批界面的语言包、常量表--%>
var lbpm = new Object();
lbpm.globals = new Object(); //所有函数集合
lbpm.operations = new Object(); //所有操作集合
lbpm.nodes = new Object(); //所有节点集合
lbpm.lines = new Object(); //所有连线集合
lbpm.modifys = null; //所有修改的数据集合
lbpm.events={}; //所有事件集合
lbpm.flowcharts={};//流程图所要的属性集合

lbpm.nodeDescMap = {};
lbpm.nodedescs = {}; //所有节点描述集合
lbpm.jsfilelists = new Array(); //所有include的的JS文件路径集合

lbpm.modelName = "${sysWfBusinessForm.modelClass.name}";
lbpm.modelId = "${sysWfBusinessForm.fdId}";
( function(lbpm) {
	var constant=lbpm.constant={};
	//工作项常量
	lbpm.workitem={};
	lbpm.workitem.constant={};
	//节点常量
	lbpm.node={};	
	lbpm.node.constant={};
	//操作常量
	lbpm.operation={};
	lbpm.operation.constant={};
	constant.wt={};//工作项常量
	constant.opt={};//操作常量
	constant.evt={};//事件常量
	//址本本选择
	constant.ADDRESS_SELECT_FORMULA="<%=LbpmConstants.HANDLER_SELECT_TYPE_FORMULA%>";
	constant.ADDRESS_SELECT_ORG="<%=LbpmConstants.HANDLER_SELECT_TYPE_ORG%>";
	constant.ADDRESS_SELECT_POSTPERSONROLE="ORG_TYPE_POSTORPERSON | ORG_TYPE_ROLE";
	constant.ADDRESS_SELECT_ALLROLE="ORG_TYPE_ALL | ORG_TYPE_ROLE";
	constant.SELECTORG="<bean:message key='dialog.selectOrg' />"; //选择
	constant.PROCESSTYPE_SERIAL="<%=LbpmConstants.PROCESS_TYPE_SERIAL%>";  //串行
	constant.PROCESSTYPE_ALL="<%=LbpmConstants.PROCESS_TYPE_ALL%>";     //会审/会签
	constant.PROCESSTYPE_SINGLE="<%=LbpmConstants.PROCESS_TYPE_SINGLE%>";  //并行
	constant.REVIEWPOINT="<bean:message bundle='sys-lbpmservice' key='lbpmProcessTable.reviewPoint' />" ;//审批
	constant.SIGNPOINT="<bean:message bundle='sys-lbpmservice' key='lbpmProcessTable.signPoint' />"; //签字
	
	constant.METHOD="${param.method}";
	constant.METHODEDIT="edit";
	constant.METHODVIEW="view";
	constant.IDENTITY_PROCESSOR = "processor";
	
	constant.DOCSTATUS = '${sysWfBusinessForm.docStatus}'; //文档状态
	constant.STATE_COMPLETED='30';//流程结束
	constant.STATE_ACTIVATED='20'; //流程中
	constant.STATE_CREATED='10'; //流程创建
	
	constant.STATUS_UNINIT=0; //状态：未初始化
	constant.STATUS_NORMAL=1;//状态：普通
	constant.STATUS_PASSED=2; //状态：曾经流过
	constant.STATUS_RUNNING=3; //状态：当前
	constant.STATUS_NORMAL_MSG="<bean:message bundle='sys-lbpmservice' key='lbpmSupport.STATUS_NORMAL'/>"; //未执行
	constant.STATUS_PASSED_MSG="<bean:message bundle='sys-lbpmservice' key='lbpmSupport.STATUS_PASSED'/>" ;//已执行
	constant.STATUS_RUNNING_MSG="<bean:message bundle='sys-lbpmservice' key='lbpmSupport.STATUS_RUNNING'/>";//当前节点
	
	constant.ROLETYPE="${param.roleType}"; //角色类型
	constant.FDKEY="${param.fdKey}";
	
	//处理人身份标识，起草人
	constant.DRAFTERROLETYPE="drafter";
	constant.HANDLER_IDENTITY_DRAFT=1;
	//处理人身份标识，处理人
	constant.PROCESSORROLETYPE = "processor";
	constant.HANDLER_IDENTITY_HANDLER=2;
	//处理人身份标识，特权人
	constant.AUTHORITYROLETYPE="authority";
	constant.HANDLER_IDENTITY_SPECIAL=3;
	//处理人身份标识，已处理人
	constant.HISTORYHANDLERROLETYPE="historyhandler";
	constant.HANDLER_IDENTITY_HISTORYHANDLER=4;
	
	constant.SUCCESS="success";
	constant.FAILURE="failure";
	constant.VALIDATEISNULL="<bean:message bundle='sys-lbpmservice' key='validate.isNull' />";
	constant.VALIDATEISNAN="<bean:message bundle='sys-lbpmservice' key='validate.isNaN' />";

	constant.PRIVILEGERFLAG='${sysWfBusinessForm.sysWfBusinessForm.fdIsAdmin}';
	constant.SHOWHISTORYOPERS='${param.showHistoryOpers}';
	constant.PROCESSTYPE="<bean:message bundle='sys-lbpmservice' key='lbpmSupport.processType'/>";
	constant.PROCESSTYPE_0="<bean:message bundle='sys-lbpmservice' key='lbpmSupport.processType_0'/>";
	constant.PROCESSTYPE_1="<bean:message bundle='sys-lbpmservice' key='lbpmSupport.processType_1'/>";
	constant.PROCESSTYPE_20="<bean:message bundle='sys-lbpmservice' key='lbpmSupport.processType_20'/>";
	constant.PROCESSTYPE_21="<bean:message bundle='sys-lbpmservice' key='lbpmSupport.processType_21'/>";

    //节点类型
    constant.NODETYPE_START="startNodeDesc"; //开始节点类型
    constant.NODETYPE_END="endNodeDesc"; //结束节点类型
   	constant.NODETYPE_STARTSUBPROCESS = "startSubProcessNodeDesc";//开始启动子流程节点类型
	constant.NODETYPE_DRAFT="draftNodeDesc";//起草节点类型
   	constant.NODETYPE_JOIN="joinNodeDesc";//并发分支结束节点类型
   	constant.NODETYPE_SIGN="signNodeDesc";//签字节点类型
   	constant.NODETYPE_SPLIT = "isSplitNode";//并发分支开始节点类型 	
   	constant.NODETYPE_REVIEW="isReviewNode";//审批节点类型 	
   	constant.NODETYPE_HANDLER="isHandler";//带处理人的节点类型
   	constant.NODETYPE_SEND="isSendNode";//抄送节点类型
   	constant.NODETYPE_CANREFUSE="canRefuse";//可以被驳回节点类型
   	constant.NODETYPE_AUTOBRANCH="isAutoBranch";//自动分支节点类型
   	constant.NODETYPE_MANUALBRANCH="isManualBranch";//人工分支节点类型
   	constant.NODETYPE_RECOVERSUBPROCESS="isRecoverSubProcess";//结束子流程节点类型
   	constant.NODETYPE_ROBOT="isRobot";//机器人节点类型
 	//事件常量定义
 	constant.EVENT_MODIFYNODEATTRIBUTE="modifyNodeAttribute"; //修改节点属性
 	constant.EVENT_MODIFYPROCESS="modifyProcess"; //修改流程图
 	constant.EVENT_SELECTEDMANUAL="selectedManual"; //选择了人工分支(起草人选择后续分支)
 	constant.EVENT_SELECTEDFUTURENODE="selectedFutureNode"; //选择即将流向分支
 	constant.EVENT_FILLLBPMOBJATTU="fillLbpmObjAttu"; //允许项目定制修改节点属性（像美的代理节点）
 	constant.EVENT_CHANGEWORKITEM="changeWorkitem"; //当用户有多个工作项时切换工作项
	constant.EVENT_validateMustSignYourSuggestion = "validateMustSignYourSuggestion"; // 校验是否填写审批意见
 	//流程图常量
	constant.COMMONNODEHANDLERPARSEERROR='<kmss:message bundle="sys-lbpmservice" key="lbpmNode.nodeHandler.parseError"/>';
	constant.COMMONNODEHANDLERPROCESSTYPESERIAL='<kmss:message bundle="sys-lbpmservice" key="lbpmNode.nodeHandler.processtypeSerial"/>';
	constant.COMMONNODEHANDLERPROCESSTYPEALL='<kmss:message bundle="sys-lbpmservice" key="lbpmNode.nodeHandler.processtypeAll"/>';
	constant.COMMONNODEHANDLERPROCESSTYPESINGLE='<kmss:message bundle="sys-lbpmservice" key="lbpmNode.nodeHandler.processtypeSingle"/>';
	constant.COMMONNODENAME='<kmss:message bundle="sys-lbpmservice" key="lbpmNode.nodeHandler.nodeName"/>';
	constant.COMMONNODEHANDLER='<kmss:message bundle="sys-lbpmservice" key="lbpmNode.nodeHandler.nodeHandler"/>';
	constant.COMMONNODEHANDLERHINT='<kmss:message bundle="sys-lbpmservice" key="lbpmNode.nodeHandler.hint"/>';
    //JS提示
    constant.CHKNEXTNODENOTNULL="<bean:message bundle='sys-lbpmservice' key='lbpmNode.validate.nextNode.isNull' />";
    constant.LOADINGMSG="<bean:message bundle='sys-lbpmservice' key='WorkFlow.Loading.Msg' />";
	constant.CONCURRENCYBRANCHSELECT="<bean:message bundle='sys-lbpmservice' key='lbpmSupport.concurrencyBranchSelect'/>";
	constant.CONCURRENCYBRANCHTITLE="<bean:message bundle='sys-lbpmservice' key='lbpmSupport.concurrencyBranchTitle'/>";
	constant.VALIDATENOTIFYTYPEISNULL="<bean:message bundle='sys-lbpmservice' key='lbpmNode.validate.notifyType.isNull'/>";
	constant.VALIDATEOPERATIONTYPEISNULL="<bean:message bundle='sys-lbpmservice' key='lbpmNode.validate.operationType.isNull' />";
	constant.ERRORMAXLENGTH="<bean:message key='errors.maxLength' />";
	constant.CREATEDRAFTCOMMONUSAGES="<bean:message bundle='sys-lbpmservice' key='lbpmNode.createDraft.commonUsages' />";
	constant.MUSTMODIFYHANDLERNODEIDSISNULL="<bean:message bundle='sys-lbpmservice' key='lbpmNode.flowContent.mustModifyHandlerNodeIds.isNull' />";
	constant.VALIDATENEXTNODEHANDLERISNULL="<bean:message bundle='sys-lbpmservice' key='lbpmNode.validate.nextNodeHandler.isNull' />";
	constant.FLOWCONTENTMUSTMODIFYNODENEXTHANDLER="<bean:message bundle='sys-lbpmservice' key='lbpmNode.flowContent.mustModifyNodeNextHandlerNodeIds.isNull' />";
	constant.COMMONNODEHANDLERORGEMPTY='<kmss:message bundle="sys-lbpmservice" key="lbpmNode.nodeHandler.orgEmpty"/>';

	constant.opt.EnvironmentUnsupportOperation='<bean:message bundle="sys-lbpmservice" key="lbpmSupport.environmentUnsupportOperation" />';
	constant.opt.MustSignYourSuggestion='<bean:message bundle="sys-lbpmservice" key="lbpmNode.mustSignYourSuggestion" />';
})(lbpm);

lbpm.constant.GetMessage = function(msg, param1, param2, param3){
	var re;
	if(param1!=null){
		re = /\{0\}/gi;
		msg = msg.replace(re, param1);
	}
	if(param2!=null){
		re = /\{1\}/gi;
		msg = msg.replace(re, param2);
	}
	if(param3!=null){
		re = /\{2\}/gi;
		msg = msg.replace(re, param3);
	}
	return msg;
}; 
</script>