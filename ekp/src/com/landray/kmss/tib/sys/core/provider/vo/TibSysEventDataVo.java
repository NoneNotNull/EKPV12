package com.landray.kmss.tib.sys.core.provider.vo;

import com.landray.kmss.tib.sys.core.provider.process.provider.interfaces.impl.TibSysEventProxy;

/**
 * 发布事件对象
 * @author fat_tian
 *
 */
public class TibSysEventDataVo {
	
//	数据
	private Object data;
//	key
	private String key ;
//	事件类型@see TibSysEventProxy.EVENT_ERROR EVENT_AFTER EVENT_ERROR
	private int eventType ;
	

	public TibSysEventDataVo(Object data, String key, int eventType) {
		super();
		this.data = data;
		this.key = key;
		this.eventType = eventType;
	}

	public Object getData() {
		return data;
	}

	public void setData(Object data) {
		this.data = data;
	}

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public int getEventType() {
		return eventType;
	}

	public void setEventType(int eventType) {
		this.eventType = eventType;
	}
	

}
