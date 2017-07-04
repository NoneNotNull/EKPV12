package com.landray.kmss.kms.multidoc.dao;

import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.sys.doc.dao.ISysDocBaseInfoDao;
import com.landray.kmss.sys.metadata.interfaces.IExtendDataDao;

/**
 * 创建日期 2006-九月-04
 * 
 * @author 王晖 知识库文档数据访问接口
 */
public interface IKmsMultidocKnowledgeDao extends ISysDocBaseInfoDao, IExtendDataDao {
	/**
	 * 转移模板
	 * 
	 * @param ids
	 * @param templateId
	 * @return
	 * @throws Exception
	 */
	public int updateDocumentTemplate(String ids, String templateId)
			throws Exception;
	
	/**
	 * 回收文档，调用此方法会删除搜索索引
	 * @param modelObj
	 * @throws Exception
	 */
	public void updateDocdelete(IBaseModel modelObj) throws Exception;
}
