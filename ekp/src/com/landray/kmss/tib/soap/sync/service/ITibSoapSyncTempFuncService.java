package com.landray.kmss.tib.soap.sync.service;

import com.landray.kmss.common.service.IBaseService;
import com.sunbor.web.tag.Page;

/**
 * 定时任务对应函数表业务对象接口
 * 
 * @author 
 * @version 1.0 2014-02-20
 */
public interface ITibSoapSyncTempFuncService extends IBaseService {
	/**
	 * 根据数据源分页查询
	 * @param dbID 数据源id
	 * @param tableName 表名
	 * @param tempId 映射关系id
	 * @param pageno 当前页
	 * @param rowsize 每页条数
	 * @param orderby 排序
	 * @return
	 * @throws Exception 
	 */
	public Page findPageByData(String dbID, String tableName, String tempId,
			int pageno, int rowsize, String orderby) throws Exception;
}
