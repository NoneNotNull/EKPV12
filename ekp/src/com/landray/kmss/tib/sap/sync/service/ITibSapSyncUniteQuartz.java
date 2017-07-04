package com.landray.kmss.tib.sap.sync.service;

import com.landray.kmss.sys.quartz.interfaces.SysQuartzJobContext;

/**
 * 统一定时任务接口
 * @author user
 *
 */
public interface ITibSapSyncUniteQuartz {

	public void methodJob(SysQuartzJobContext sysQuartzJobContext) throws Exception;
}
