package com.landray.kmss.tib.jdbc.service;

import com.landray.kmss.sys.quartz.interfaces.SysQuartzJobContext;

public interface ITibJdbcSyncUniteQuartzService {

	public void methodJob(SysQuartzJobContext sysQuartzJobContext) throws Exception;
}
