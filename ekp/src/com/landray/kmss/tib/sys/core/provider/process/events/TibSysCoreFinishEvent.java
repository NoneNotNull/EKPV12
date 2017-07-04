package com.landray.kmss.tib.sys.core.provider.process.events;

import org.springframework.context.ApplicationEvent;

/**
 * 
 * @author 
 * 当TIB交互完成，发布完成事件
 *
 */
public class TibSysCoreFinishEvent extends ApplicationEvent  {

	private static final long serialVersionUID = 1L;
	
	public TibSysCoreFinishEvent(Object source) {
		super(source);
		// TODO 自动生成的构造函数存根
	}
	

}
