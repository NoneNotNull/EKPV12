package com.landray.kmss.common.event;

import org.springframework.context.ApplicationEvent;

public class Event_CommonDelete extends ApplicationEvent {
	public Event_CommonDelete(Object mainModel) {
		super(mainModel);
	}
}
