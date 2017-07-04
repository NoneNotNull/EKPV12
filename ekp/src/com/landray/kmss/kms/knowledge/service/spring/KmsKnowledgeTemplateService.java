package com.landray.kmss.kms.knowledge.service.spring;

import java.util.Map;

import javax.servlet.ServletRequest;

import com.landray.kmss.kms.knowledge.forms.KmsKnowledgeCategoryForm;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeCategoryService;
import com.landray.kmss.kms.knowledge.util.KmsKnowledgeConstant;
import com.landray.kmss.kms.knowledge.util.KmsKnowledgeConstantUtil;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.web.taglib.xform.ICustomizeDataSourceWithRequest;

/**
 * 内容模板选择
 * 
 * */
public class KmsKnowledgeTemplateService implements
		ICustomizeDataSourceWithRequest {

	private IKmsKnowledgeCategoryService kmsKnowledgeCategoryService = null;
	private KmsKnowledgeCategoryForm form;

	public IKmsKnowledgeCategoryService getKmsKnowledgeCategoryService() {
		if (kmsKnowledgeCategoryService == null) {
			kmsKnowledgeCategoryService = (IKmsKnowledgeCategoryService) SpringBeanUtil
					.getBean("kmsKnowledgeCategoryService");
		}
		return kmsKnowledgeCategoryService;
	}

	public void setRequest(ServletRequest request) {
		form = (KmsKnowledgeCategoryForm) request
				.getAttribute("kmsKnowledgeCategoryForm");
		String parentId = form.getFdParentId();
		if (StringUtil.isNotNull(parentId)) {
			try {
				KmsKnowledgeCategory parent = (KmsKnowledgeCategory) getKmsKnowledgeCategoryService()
						.findByPrimaryKey(parentId);
				parentTemplateType = parent.getFdTemplateType();
			} catch (Exception e) {
				parentTemplateType = String
						.valueOf(KmsKnowledgeConstant.KNOWLEDGE_TYPE_MUORWIKI);
				e.printStackTrace();
			}
		} else {
			parentTemplateType = String
					.valueOf(KmsKnowledgeConstant.KNOWLEDGE_TYPE_MUORWIKI);
		}
	}

	String parentTemplateType = null;

	public String getDefaultValue() {
		return KmsKnowledgeConstantUtil.getTemplateType(parentTemplateType);
	}

	/**
	 * 复选框选项
	 */
	public Map<String, String> getOptions() {
		return KmsKnowledgeConstantUtil.getTemplateMap(parentTemplateType);
	}

}
