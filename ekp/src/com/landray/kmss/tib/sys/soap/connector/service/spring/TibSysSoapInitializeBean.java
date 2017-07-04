package com.landray.kmss.tib.sys.soap.connector.service.spring;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.InitializingBean;

import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.tib.sys.soap.connector.impl.TibSysSoapProjectFactory;

public class TibSysSoapInitializeBean implements InitializingBean{

	private static final Log logger = LogFactory
	.getLog(TibSysSoapInitializeBean.class);
	
	public void afterPropertiesSet() throws Exception {
		logger.info("SOAPUI初始化工作,创建比较耗时的操作~");
		TimeCounter.logCurrentTime("TibSysSoapInitializeBean-init", true, this.getClass());
		TibSysSoapProjectFactory.getWsdlProjectInstance();
		TimeCounter.logCurrentTime("TibSysSoapInitializeBean-init", false, this.getClass());
		logger.info("SOAPUI初始化工作完成~");
	}

}
