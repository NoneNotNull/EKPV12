package com.landray.kmss.km.doc.dao;

import com.landray.kmss.sys.doc.dao.ISysDocBaseInfoDao;

/**
 * 创建日期 2006-九月-04
 * 
 * @author 王晖 知识库文档数据访问接口
 */
public interface IKmDocKnowledgeDao extends ISysDocBaseInfoDao {
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
}
