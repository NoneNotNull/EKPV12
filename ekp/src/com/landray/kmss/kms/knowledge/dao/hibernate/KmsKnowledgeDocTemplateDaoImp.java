package com.landray.kmss.kms.knowledge.dao.hibernate;

import java.util.Date;

import com.landray.kmss.common.dao.BaseDaoImp;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.kms.knowledge.dao.IKmsKnowledgeDocTemplateDao;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeDocTemplate;
import com.landray.kmss.util.UserUtil;

/**
 * 文档知识模版数据访问接口实现
 * 
 * @author 
 * @version 1.0 2013-11-07
 */
public class KmsKnowledgeDocTemplateDaoImp extends BaseDaoImp implements IKmsKnowledgeDocTemplateDao {

	public String add(IBaseModel modelObj) throws Exception {
		KmsKnowledgeDocTemplate model = (KmsKnowledgeDocTemplate) modelObj;
		model.setDocCreateTime(new Date());
		model.setDocCreator(UserUtil.getUser());
		return super.add(modelObj);
	}
}
