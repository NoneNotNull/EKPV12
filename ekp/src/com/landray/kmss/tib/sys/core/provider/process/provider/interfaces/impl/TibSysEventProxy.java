package com.landray.kmss.tib.sys.core.provider.process.provider.interfaces.impl;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

import com.landray.kmss.tib.sys.core.provider.process.events.TibSysCoreExceptionEvent;
import com.landray.kmss.tib.sys.core.provider.process.events.TibSysCoreFinishEvent;
import com.landray.kmss.tib.sys.core.provider.process.events.TibSysCoreReceiveEvent;
import com.landray.kmss.tib.sys.core.provider.vo.TibSysEventDataVo;

public class TibSysEventProxy implements ApplicationContextAware {
	private static final Log logger = LogFactory.getLog(TibSysEventProxy.class);

	public static final int EVENT_BEFORE = 1;

	public static final int EVENT_AFTER = 2;

	public static final int EVENT_ERROR = 3;

	private ApplicationContext ctx = null;

	public void publicTibEvent(Object data, String key, int eventType) {

		switch (eventType) {
		
		case EVENT_BEFORE:
			TibSysEventDataVo dataBefore=new TibSysEventDataVo(data, key, eventType);
			ctx.publishEvent(new TibSysCoreReceiveEvent(dataBefore));
			logger.debug(" 发布了接收事件~ ");
			break;
		case EVENT_AFTER:
			TibSysEventDataVo dataAfter=new TibSysEventDataVo(data, key, eventType);
			ctx.publishEvent(new TibSysCoreFinishEvent(dataAfter));
			logger.debug(" 发布了完成事件~ ");
			break;
		case EVENT_ERROR:
			TibSysEventDataVo dataError=new TibSysEventDataVo(data, key, eventType);
			ctx.publishEvent(new TibSysCoreExceptionEvent(dataError));
			logger.debug(" 发布了错误事件~ ");
			break;

		default:
			logger.warn(" 没有发布事件~，没有对应eventType ~");
			break;
		}

	}

	public void setApplicationContext(ApplicationContext ctx)
			throws BeansException {
		this.ctx = ctx;
	}

	public ApplicationContext getCtx() {
		return ctx;
	}

}
