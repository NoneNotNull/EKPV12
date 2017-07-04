package com.landray.kmss.km.doc.service;

import com.landray.kmss.km.doc.model.KmDocTemplate;
import com.landray.kmss.sys.doc.service.ISysDocBaseInfoService;
import com.landray.kmss.sys.metadata.interfaces.IExtendDataService;
import com.landray.kmss.sys.quartz.interfaces.SysQuartzJobContext;

/**
 * 创建日期 2006-九月-04
 * 
 * @author 王晖 知识库文档业务对象接口
 */
public interface IKmDocKnowledgeService extends IExtendDataService,
		ISysDocBaseInfoService {

	/**
	 * 根据模板Id来查找模板
	 * 
	 * @param templateId
	 *            模板Id
	 * @return 模板域模型
	 * @throws Exception
	 */
	public KmDocTemplate getKmDocTemplate(String templateId) throws Exception;

	/**
	 * 根据传入的文档Id,和模板的Id更新模板
	 * 
	 * @param ids
	 *            主文档的Id,多个值之间用","隔开
	 * @param templateId
	 *            模板的Id
	 * @return
	 * @throws Exception
	 */
	public int updateDucmentTemplate(String ids, String templateId)
			throws Exception;

	/**
	 * 文档过期定时任务
	 * 
	 * @throws Exception
	 */
	public void updateDocExpire(SysQuartzJobContext context) throws Exception;
}
