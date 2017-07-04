package com.landray.kmss.tib.soap.sync.service;

import com.landray.kmss.sys.quartz.interfaces.SysQuartzJobContext;

/**
 * 统一定时任务接口
 * @author user
 *
 */
public interface ITibSoapSyncUniteQuartz {

	public final short SYNC_FULL = 2;				// 全量
	public final short SYNC_INCR = 1;				// 增量
	public final short SYNC_INCR_DATE = 3;			// 增量（时间戳）
	public final short SYNC_INCR_BEFORE_DEL = 4;	// 增量（插入前删除）
	public final short SYNC_INCR_CONDITION_DEL = 5;	// 增量（条件删除）
	
	public void methodJob(SysQuartzJobContext sysQuartzJobContext) throws Exception;
}
