package com.landray.kmss.tib.sys.core.provider.process.events;

import org.springframework.context.ApplicationEvent;

/**
 * 
 * @author 
 * 当TIB发生异常时候发布异常事件
 *
 */
public class TibSysCoreExceptionEvent extends ApplicationEvent  {

	private static final long serialVersionUID = 1L;
	
	public TibSysCoreExceptionEvent(Object source) {
		super(source);
		// TODO 自动生成的构造函数存根
	}
	

}
