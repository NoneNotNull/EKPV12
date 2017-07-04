package com.landray.kmss.common.event;

import java.util.Map;

import org.springframework.context.ApplicationEvent;

public class Event_Common extends ApplicationEvent {

	private static final long serialVersionUID = -238419385350963785L;

	/** 参数 */
	private Map params;

	public Event_Common(Object source, Map params) {
		super(source);
		this.params = params;
	}

	public Map getParams() {
		return params;
	}

	public Event_Common(Object source) {
		super(source);
	}
}
