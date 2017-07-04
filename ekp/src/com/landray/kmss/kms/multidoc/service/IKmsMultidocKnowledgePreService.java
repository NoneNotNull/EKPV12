package com.landray.kmss.kms.multidoc.service;

import java.util.List;

import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge;
import com.landray.kmss.kms.multidoc.model.KmsMultidocTemplatePreview;

/**
 * @author zhangwentian 2010-9-9
 */
public interface IKmsMultidocKnowledgePreService extends IBaseService {

	public List<KmsMultidocKnowledge> getLatestDoc() throws Exception;

	public List<KmsMultidocKnowledge> getHotDoc() throws Exception;

	public List<KmsMultidocTemplatePreview> getMainContent() throws Exception;

	public Integer getDocAmount(KmsKnowledgeCategory kmsKnowledgeCategory,
			String authAreaId) throws Exception;

	public List<KmsMultidocKnowledge> getSameTemplateDoc(String fdId,
			String templateId) throws Exception;

	public void updateKnowledgePre() throws Exception;

	public String updatePre(String fdCategoryId) throws Exception;
}
