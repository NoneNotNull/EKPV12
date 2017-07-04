package com.landray.kmss.tib.sys.core.provider.process.events;

import org.springframework.context.ApplicationEvent;

/**
 * 
 * @author fat_tian
 * 当Tib接收到数据发布事件
 *
 */
public class TibSysCoreReceiveEvent extends ApplicationEvent  {

	private static final long serialVersionUID = 1L;

	public TibSysCoreReceiveEvent(Object source) {
		super(source);
		// TODO 自动生成的构造函数存根
	}
	

}
