package com.landray.kmss.kms.knowledge.service;

import com.landray.kmss.common.service.IBaseService;


/**
 * @author 
 * 知识仓库文档的专属操作接口
 */ 
public interface IKmsKnowledgeBaseService extends IBaseService{
	/**
	 * 根据id回收文档
	 * @param id
	 * @throws Exception
	 */
	public void updateRecycle(String id) throws Exception;
	
	
	/**
	 * 批量回收文档
	 * 
	 */
	public void updateRecycle(String[] ids) throws Exception;
	
	
	/**
	 * 恢复文档
	 * 
	 */
	public void updateRecover(String id, String description) throws Exception;
	
}
