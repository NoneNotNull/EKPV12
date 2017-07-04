package com.landray.kmss.kms.knowledge.service;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLWrapper;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory;

/**
 * 文档基本信息业务对象接口
 * 
 * @author
 * @version 1.0 2013-09-26
 */
public interface IKmsKnowledgeBaseDocService extends IBaseService {

	/**
	 * 获取分类service
	 * 
	 * @return
	 */
	IKmsKnowledgeCategoryService getCategoryServiceImp();

	/**
	 * 批量更新属性
	 * 
	 * @param form
	 * @param requestContext
	 * @throws Exception
	 */
	void updateProperty(IExtendForm form, RequestContext requestContext)
			throws Exception;

	// 经过筛选器筛选后的文档hql（已权限处理）
	public HQLWrapper getDocHql(String whereBlock, String __joinBlock,
			HttpServletRequest request) throws Exception;



	/**
	 * 获取当前分类为第几级分类
	 * 
	 * @throws Exception
	 */
	public int getLevelCount(KmsKnowledgeCategory kmsKnowledgeCategory)
			throws Exception;

	/**
	 * 根据分类拼出该分类的fdSetTopLevel排序码
	 * 
	 * @throws Exception
	 */
	public String getFdSetTopLevel(KmsKnowledgeCategory kmsKnowledgeCategory,
			String str) throws Exception;
	
	/**
	 * 清空回收站
	 * @param ids
	 * @throws Exception
	 */
	//public void deleteClearRecycleBin(String[] ids) throws Exception;
	
	/**
	 * 回收站中批量恢复文档
	 */
	public void updateRecover(String[] ids, String description) throws Exception;
}
