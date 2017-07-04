package com.landray.kmss.kms.knowledge.actions;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeDocTemplateService;



/**
 * 文档知识模版 Action
 * 
 * @author 
 * @version 1.0 2013-11-07
 */
public class KmsKnowledgeDocTemplateAction extends ExtendAction {
	protected IKmsKnowledgeDocTemplateService kmsKnowledgeDocTemplateService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(kmsKnowledgeDocTemplateService == null)
			kmsKnowledgeDocTemplateService = (IKmsKnowledgeDocTemplateService)getBean("kmsKnowledgeDocTemplateService");
		return kmsKnowledgeDocTemplateService;
	}
}

