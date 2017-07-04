package com.landray.kmss.km.review.dao;

import com.landray.kmss.common.dao.IBaseDao;

/**
 * 创建日期 2007-Aug-30
 * 
 * @author 舒斌 审批文档基本信息数据访问接口
 */
public interface IKmReviewMainDao extends IBaseDao {

	/**
	 * 
	 * @return 根据类别得到当前的流水号
	 * @param templateId
	 *            模板ID
	 */
	public Object[] getCurrentFlowNumber(String templateId,
			String fdNumberPattern) throws Exception;

	/**
	 * 批量转移文档
	 * 
	 * @param ids
	 * @param templateId
	 * @throws Exception
	 */
	public int updateDocumentTemplate(String ids, String templateId)
			throws Exception;

}
