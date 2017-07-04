package com.landray.kmss.kms.knowledge.service;

import java.util.List;

import com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory;
import com.landray.kmss.sys.simplecategory.service.ISysSimpleCategoryService;

/**
 * 知识分类业务对象接口
 * 
 * @author 
 * @version 1.0 2013-09-26
 */
public interface IKmsKnowledgeCategoryService extends ISysSimpleCategoryService {
	
	public List<?> findFirstLevelCategory();
	
	/**
	 * 
	 * 查找直接的下级子类
	 * @param templateId 
	 * @return
	 * @throws Exception
	 */
	public List<KmsKnowledgeCategory> findChildren(String templateId); 

	/**
	 * 
	 * 是否有同名的模板名称
	 * @param templateId 
	 * @return  true=有重名，false=无重名
	 * @throws Exception
	 */
   public boolean checkCategoryNameExist(String templateId,String templateName,String parentId)throws Exception;
 
}
