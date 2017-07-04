package com.landray.kmss.km.review.service;

import java.util.List;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.km.review.model.KmReviewMain;
import com.landray.kmss.sys.metadata.interfaces.IExtendDataService;

/**
 * 创建日期 2007-Aug-30
 * 
 * @author 舒斌 审批文档基本信息业务对象接口
 */
public interface IKmReviewMainService extends IExtendDataService {

	/**
	 * 转移流程文档
	 * 
	 * @param fdId
	 *            文档ID
	 * @param categoryId
	 *            目标类ID
	 * @throws Exception
	 */
	public void updateDocumentCategory(String fdId, String categoryId)
			throws Exception;

	/**
	 * 修改流程文档权限
	 * 
	 * @param form
	 * @param requestContext
	 * @throws Exception
	 */
	public void updateDocumentPermission(IExtendForm form,
			RequestContext requestContext) throws Exception;

	/**
	 * 批量转移文档
	 * 
	 * @param ids
	 * @param templateId
	 * @throws Exception
	 */
	public int updateDucmentTemplate(String ids, String templateId)
			throws Exception;

	/**
	 * 文档指定反馈人
	 * 
	 * @param main
	 * @param notifyTarget
	 * @throws Exception
	 */
	public void updateFeedbackPeople(KmReviewMain main, List notifyTarget)
			throws Exception;

}
