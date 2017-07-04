<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="
	java.util.*,
	org.springframework.context.ApplicationContext,
	org.springframework.web.context.support.WebApplicationContextUtils,
	com.landray.kmss.util.*,
	com.landray.kmss.sys.authentication.background.*,
	com.landray.kmss.sys.lbpm.engine.support.pvm.*,
	com.landray.kmss.sys.lbpm.engine.service.*,
	com.landray.kmss.sys.lbpm.engine.persistence.model.*,
	com.landray.kmss.sys.lbpm.engine.manager.operation.*,
	com.landray.kmss.sys.lbpm.engine.support.execute.*,
	com.landray.kmss.sys.organization.model.*
	"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>流程实例信息</title>
</head>
<body>
<kmss:authShow roles="SYSROLE_ADMIN">
<%!
public void logInfo (JspWriter out, String processId, ApplicationContext ctx) {
	try {
		// TODO
		ProcessExecuteService processExecuteService = (ProcessExecuteService)ctx.getBean("lbpmProcessExecuteService");
		ProcessInstanceInfoLoader processInstanceInfoLoader = (ProcessInstanceInfoLoader)ctx.getBean("lbpmProcessInstanceInfoLoader");
		ProcessInstanceInfo processInstanceInfo = processExecuteService.load(processId);
		if(processInstanceInfo==null){
			out.println("没有找到流程实例："+processId);
		} else {
			out.println("流程信息：");
			out.println("<br>");
			out.println("流程详细定义：");
			out.println("<br>");
			out.println(StringUtil.XMLEscape(processInstanceInfo.getProcessDefinitionInfo().getDetailDefinitionXml()));
			out.println("<br>");
			out.println("流程简版定义：");
			out.println("<br>");
			out.println(StringUtil.XMLEscape(processInstanceInfo.getProcessDefinitionInfo().getSimpleDefinitionXml()));
			out.println("<br>");
			out.println("是否当前处理人：" + (processInstanceInfo.isHandler() ? "是" : "否"));
			out.println("<br>");
			out.println("是否特权人：" + (processInstanceInfo.isAdmin() ? "是" : "否"));
			out.println("<br>");
			out.println("是否起草人：" + (processInstanceInfo.isDrafter() ? "是" : "否"));
			out.println("<br>");
			out.println("流程是否异常：" + (processInstanceInfo.isError() ? "是" : "否"));
			out.println("<br>");
			out.println("流程是否暂停：" + (processInstanceInfo.isSuspended() ? "是" : "否"));
			out.println("<br>");
			out.print("历史处理人：");
			List<?> historyHandlers = processInstanceInfo.getHistoryHandlers();
			for (int i = 0; i < historyHandlers.size(); i++) {
				String[] historyHandler = (String[]) historyHandlers.get(i);
				out.print(historyHandler[1]+"; ");
			}
			out.println("<br>");
			out.println("<br>");
			out.println("节点信息：");
			out.println("<br>");
			List<?> currentNodeInfos =  processInstanceInfo.getCurrentNodeInfos();
			for (int i = 0; i < currentNodeInfos.size(); i++) {
				NodeInstanceInfo nodeInstanceInfo = (NodeInstanceInfo) currentNodeInfos.get(i);
				out.println("当前节点：" + ((LbpmNode)nodeInstanceInfo.getNodeInstance()).getFdFactNodeName() + " 编号Id：" + nodeInstanceInfo.getNodeInstance().getFdFactNodeId() + " 节点实例Id：" + nodeInstanceInfo.getNodeInstance().getFdId());
				out.println("<br>");
				out.println("节点定义：");
				out.println("<br>");
				out.println(StringUtil.XMLEscape(nodeInstanceInfo.getNodeDefinitionInfo().getDetailXml()));
				out.println("<br>");
				out.println("节点是否锁定：" + (ExecutionLocker.getInstance().isLocked(nodeInstanceInfo.getNodeInstance()) ? "是" : "否"));
				out.println("<br>");
				out.println("节点是否暂停：" + (nodeInstanceInfo.isSuspended() ? "是" : "否"));
				out.println("<br>");
				out.println("审批界面JS：" + nodeInstanceInfo.getReviewJs());
				out.println("<br>");
				out.println("起草人操作：");
				out.println("<br>");
				List<?> drafterOperationInfos = nodeInstanceInfo.getDrafterOperationInfos();
				for (int j = 0; j < drafterOperationInfos.size(); j++) {
					OperationInfo operationInfo = (OperationInfo) drafterOperationInfos.get(j);
					out.println("操作：" + operationInfo.getName() + " 操作js：" + operationInfo.getReviewJs() + " 类型：" + operationInfo.getType() + " 处理人类型：" + operationInfo.getHandlerType());
					out.println("<br>");
				}
				out.println("特权人操作：");
				out.println("<br>");
				List<?> adminOperationInfos = nodeInstanceInfo.getAdminOperationInfos();
				for (int j = 0; j < adminOperationInfos.size(); j++) {
					OperationInfo operationInfo = (OperationInfo) adminOperationInfos.get(j);
					out.println("操作：" + operationInfo.getName() + " 操作js：" + operationInfo.getReviewJs() + " 类型：" + operationInfo.getType() + " 处理人类型：" + operationInfo.getHandlerType());
					out.println("<br>");
				}
				
				out.println("当前处理人工作项信息：");
				out.println("<br>");
				List<?> handlerWrokitemInfos = nodeInstanceInfo.getHandlerWrokitemInfos();
				for (int j = 0; j < handlerWrokitemInfos.size(); j++) {
					WorkitemInstanceInfo handlerWrokitemInfo = (WorkitemInstanceInfo) handlerWrokitemInfos.get(j);
					out.println("当前工作项：" + handlerWrokitemInfo.getWorkitem().getFdId());
					out.println("<br>");
					out.println("工作项是否锁定：" + (ExecutionLocker.getInstance().isLocked(handlerWrokitemInfo.getWorkitem()) ? "是" : "否"));
					out.println("<br>");
					out.println("工作项是否暂停：" + (handlerWrokitemInfo.isSuspended() ? "是" : "否"));
					out.println("<br>");
					out.println("审批界面JS：" + handlerWrokitemInfo.getReviewJs());
					out.println("<br>");
					out.println("暂存意见：" + handlerWrokitemInfo.getSavedNote());
					out.println("<br>");
					out.println("处理人操作：");
					out.println("<br>");
					List<?> operationInfos = handlerWrokitemInfo.getOperationInfos();
					for (int k = 0; k < operationInfos.size(); k++) {
						OperationInfo operationInfo = (OperationInfo) operationInfos.get(k);
						out.println("操作：" + operationInfo.getName() + " 操作js：" + operationInfo.getReviewJs() + " 类型：" + operationInfo.getType() + " 处理人类型：" + operationInfo.getHandlerType());
						out.println("<br>");
					}
				}
			}
			
			out.println("<br>");
			out.println("工作项信息：");
			out.println("<br>");
			List<?> currentWorkitems =  processInstanceInfo.getCurrentWorkitems();
			for (int i = 0; i < currentWorkitems.size(); i++) {
				LbpmWorkitem workitem = (LbpmWorkitem) currentWorkitems.get(i);
				out.println("当前工作项：" + workitem.getFdId());
				out.println("<br>");
				out.println("工作项是否锁定：" + (ExecutionLocker.getInstance().isLocked(workitem) ? "是" : "否"));
				out.println("<br>");
				NodeInstanceInfo nodeInstanceInfo = null;
				for (int k = 0; k < currentNodeInfos.size(); k++) {
					NodeInstanceInfo nodeInfo = (NodeInstanceInfo) currentNodeInfos.get(k);
					if(nodeInfo.getNodeInstance().equals(workitem.getFdNode())) {
						nodeInstanceInfo = nodeInfo;
						break;
					}
				}
				if(nodeInstanceInfo == null) {
					continue;
				}
				List<?> operationTypes = OperationTypeManager.getInstance()
						.getHandlerOperationsByTask(workitem.getFdActivityType(),
								processInstanceInfo.getProcessInstance().getFdModelName());
				OperationCheckerParameters checkParam = new OperationCheckerParameters(workitem, nodeInstanceInfo);
				for (int j = 0; j < operationTypes.size(); j++) {
					IOperationBehaviour behaviour = (IOperationBehaviour) ((OperationType)operationTypes.get(j))
							.getBehaviour();
					// 判断是否能执行
					if (!behaviour.checkUser(checkParam)) {
						out.println("当前用户没有操作权限：" + behaviour.getClass().getName());
						out.println("<br>");
						continue;
					}
					OperationInfo operationInfo = behaviour.getOperationInfo(checkParam);
					if (operationInfo != null) {
						out.println("当前用户拥有操作：" + behaviour.getClass().getName());
						out.println("<br>");
						out.println("操作：" + operationInfo.getName() + " 操作js：" + operationInfo.getReviewJs() + " 类型：" + operationInfo.getType() + " 处理人类型：" + operationInfo.getHandlerType());
						out.println("<br>");
					} else {
						out.println("当前用户没有操作：" + behaviour.getClass().getName());
						out.println("<br>");
					}
				}
			}
		}
	} catch(Exception e) {
		e.printStackTrace();
	}
}
%>
<%
final ApplicationContext ctx = WebApplicationContextUtils.getRequiredWebApplicationContext(session.getServletContext());
final String processId = request.getParameter("processId");
String userId = request.getParameter("userId");
IBackgroundAuthService backgroundAuthService = (IBackgroundAuthService)ctx.getBean("backgroundAuthService");
if(StringUtil.isNotNull(userId)) {
	backgroundAuthService.switchUserById(userId,
			new Runner(){
		public Object run(Object parameter) throws Exception{
			JspWriter out = (JspWriter)parameter;
			logInfo(out, processId, ctx);
			return null;
		}
	}, out);
} else {
	logInfo(out, processId, ctx);
}
%>
</kmss:authShow>
</body>
</html>