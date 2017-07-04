package com.landray.kmss.common.event;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;

import com.landray.kmss.common.model.IBaseModel;

public class KmssEventTracer implements ApplicationListener {
	private static final Log logger = LogFactory.getLog(KmssEventTracer.class);

	public void onApplicationEvent(ApplicationEvent event) {
		if (event == null || !logger.isDebugEnabled())
			return;
		if (!event.getClass().getName().startsWith("com.landray.kmss"))
			return;
		StringBuffer sb = new StringBuffer();
		sb.append("接收通知:").append(event.getClass().getName());
		Object source = event.getSource();
		if (source != null) {
			sb.append(",内容:").append(source.getClass().getName());
			if (source instanceof IBaseModel) {
				sb.append(",ID:").append(((IBaseModel) source).getFdId());
			}
		}
		logger.debug(sb);
	}
}
