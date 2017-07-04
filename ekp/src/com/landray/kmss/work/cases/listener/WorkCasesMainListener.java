package com.landray.kmss.work.cases.listener;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.constant.SysNotifyConstant;
import com.landray.kmss.sys.lbpm.engine.manager.event.EventExecutionContext;
import com.landray.kmss.sys.lbpm.engine.manager.event.IEventListener;
import com.landray.kmss.sys.lbpm.engine.node.endnode.LbpmProcessFinishedEvent;
import com.landray.kmss.sys.lbpm.pvm.event.EngineEvent;
import com.landray.kmss.sys.notify.interfaces.ISysNotifyMainCoreService;
import com.landray.kmss.sys.notify.interfaces.NotifyContext;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.work.cases.model.WorkCasesMain;
import com.landray.kmss.work.cases.service.IWorkCasesMainService;

public class WorkCasesMainListener implements IEventListener{

	private IWorkCasesMainService workCasesMainService;
	private ISysNotifyMainCoreService sysNotifyMainCoreService;

	public void setWorkCasesMainService(
			IWorkCasesMainService workCasesMainService) {
		this.workCasesMainService = workCasesMainService;
	}
	
	public void setSysNotifyMainCoreService(
			ISysNotifyMainCoreService sysNotifyMainCoreService) {
			this.sysNotifyMainCoreService = sysNotifyMainCoreService;
	}
	@Override
	public void handleEvent(EventExecutionContext context, String param)
			throws Exception {
		IBaseModel mainModel = context.getMainModel();
		if (mainModel instanceof WorkCasesMain) {
			WorkCasesMain workCasesMain = (WorkCasesMain) mainModel;
			EngineEvent event = context.getEvent();
			// 流程结束
			if (event instanceof LbpmProcessFinishedEvent) {
				workCasesMain.setDocPublishTime(new Date());
				sendTodoFromResource(workCasesMain);
			}
		}
	}
	
	public void sendTodoFromResource(WorkCasesMain workCasesMain)
			throws Exception {
		//获取上下文
		NotifyContext notifyContext = (NotifyContext) sysNotifyMainCoreService
				.getContext("work-cases:workCasesMain.notify");
        //获取通知方式
		notifyContext.setNotifyType(workCasesMain.getFdNotifyType());
		// 设置发布类型为“待办”（默认为待阅）
        //“待办”消息发送出去后，需要到某事件发生后才变成已办，如审批通过等
		if (StringUtil.isNotNull(workCasesMain.getFdNotifyType())){
			notifyContext.setFlag(SysNotifyConstant.NOTIFY_TODOTYPE_MANUAL);
		}else{
			notifyContext.setNotifyType("todo");
			notifyContext.setFlag(SysNotifyConstant.NOTIFY_TODOTYPE_ONCE);
		}
		// 设置发布KEY值，为后面的删除准备
		notifyContext.setKey("sendFromResource");
        //获取通知人
		List targets = new ArrayList();
		targets = workCasesMain.getFdNotifiers();
        //设置发布通知人
		notifyContext.setNotifyTarget(targets);
		sysNotifyMainCoreService.send(workCasesMain, notifyContext,
				getReplaceMap(workCasesMain));
	}

	
	private HashMap getReplaceMap(
			WorkCasesMain workCasesMain) {
			HashMap replaceMap = new HashMap();
		    replaceMap.put("work-cases:workCasesMain.docSubject",
		    		workCasesMain.getDocSubject());
			return replaceMap;
		}
	
	/*
	 * 取消由sendTodoFromResource发出去的待办
	 */
	private void cancelTodo(
			WorkCasesMain workCasesMain)
			throws Exception {
		sysNotifyMainCoreService.getTodoProvider().remove(
				workCasesMain, "sendFromResource");
	}

	
	


}
