package com.landray.kmss.tib.common.log.dao.hibernate;

import java.util.Date;

import com.landray.kmss.common.dao.BaseDaoImp;
import com.landray.kmss.tib.common.log.dao.ITibCommonLogMainDao;


/**
 * TIB_COMMON日志管理数据访问接口实现
 * 
 * @author 
 * @version 1.0 2012-08-20
 */
public class TibCommonLogMainDaoImp extends BaseDaoImp implements ITibCommonLogMainDao {

	public void backup(boolean isBackup, Date backupDate) {
		if (isBackup) {
			getSession().createQuery(
					"insert into TibCommonLogMainBackup (fdId,fdType,fdUrl,fdIsErr,funcName," +
					"fdPoolName,fdStartTime,fdEndTime,fdImportPar,fdExportPar,fdMessages) " +
					"select fdId,fdType,fdUrl,fdIsErr,funcName,fdPoolName,fdStartTime," +
					"fdEndTime,fdImportPar,fdExportPar,fdMessages from TibCommonLogMain " +
					"tibCommonLogMain where fdStartTime<:backupdate")
				.setDate("backupdate", backupDate).executeUpdate();
		}
		getSession().createQuery(
				"delete TibCommonLogMain where fdStartTime<:backupdate").setDate(
				"backupdate", backupDate).executeUpdate();
	}
	
}
