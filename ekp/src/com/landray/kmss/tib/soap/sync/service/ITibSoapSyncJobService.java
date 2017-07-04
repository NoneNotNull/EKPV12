package com.landray.kmss.tib.soap.sync.service;

import java.util.Set;

import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.common.service.IBaseService;

/**
 * 定时任务业务对象接口
 * 
 * @author 
 * @version 1.0 2014-02-20
 */
public interface ITibSoapSyncJobService extends IBaseService {
public void updateChgEnabled(String[] ids,boolean isEnable) throws Exception;
	
	/**
	 * 启用或禁用quartz,用来修改soap Quartz 的 启用状态
	 * 用来同步sys quartz
	 * @param ids sys quartz下的定时任务
	 * @param fenable
	 */
	public void updateEnableTibSoapSync(String[] ids,Boolean fenable) throws Exception ;
	
	/**
	 * 通过ekp定时任务id查找soap定时任务Id
	 * @param ekpQuartzID
	 * @return 
	 */
	public IBaseModel findByEkpQuartzID(String ekpQuartzID) throws Exception;
	
	/**
	 * 同步更新quartz 的runjob 方法
	 * @param quartzEkpID
	 */
	public void updateAfterRunJob(String quartzEkpID) throws Exception;

	/**
	 * 通过id查找对应定时任务映射关系下得xml下的表
	 * @param quartzId
	 * @throws Exception
	 */
	public Set findTableByQuartzId(String quartzId) throws Exception;
}
