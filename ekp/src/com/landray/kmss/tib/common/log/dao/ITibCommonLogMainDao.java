package com.landray.kmss.tib.common.log.dao;

import java.util.Date;

import com.landray.kmss.common.dao.IBaseDao;

/**
 * TIB_COMMON日志管理数据访问接口
 * 
 * @author 
 * @version 1.0 2012-08-20
 */
public interface ITibCommonLogMainDao extends IBaseDao {
	public void backup(boolean isBackup, Date backupDate);
}
