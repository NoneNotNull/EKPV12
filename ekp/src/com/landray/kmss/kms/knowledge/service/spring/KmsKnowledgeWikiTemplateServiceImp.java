package com.landray.kmss.kms.knowledge.service.spring;

import java.util.Date;
import java.util.List;

import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.common.service.BaseServiceImp;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeWikiCatalog;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeWikiTemplate;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeWikiTemplateService;
import com.landray.kmss.sys.transport.service.ISysTransportImport;
import com.landray.kmss.util.UserUtil;

/**
 * 模板表业务接口实现
 * 
 * @author chenyy
 * @version 1.0 2012-03-23
 */
public class KmsKnowledgeWikiTemplateServiceImp extends BaseServiceImp implements
		IKmsKnowledgeWikiTemplateService, ISysTransportImport {

	public String add(IBaseModel modelObj) throws Exception {
		KmsKnowledgeWikiTemplate newModel = (KmsKnowledgeWikiTemplate) modelObj;
		newModel.setDocCreator(UserUtil.getUser());
		newModel.setDocCreateTime(new Date());
		String rtnVal = getBaseDao().add(modelObj);
		if (dispatchCoreService != null)
			dispatchCoreService.add(modelObj);
		return rtnVal;
	}

	public void update(IBaseModel modelObj) throws Exception {
		KmsKnowledgeWikiTemplate newModel = (KmsKnowledgeWikiTemplate) modelObj;
		newModel.setDocAlteror(UserUtil.getUser());
		newModel.setDocAlterTime(new Date());
		getBaseDao().update(modelObj);
		if (dispatchCoreService != null)
			dispatchCoreService.update(modelObj);
	}

	public void addImport(IBaseModel modelObj) throws Exception {
		if (modelObj != null) {
			KmsKnowledgeWikiTemplate kmsWikiTemplate = (KmsKnowledgeWikiTemplate) modelObj;
			addCatalog(kmsWikiTemplate);
			// if (kmsWikiTemplate.getSysWfTemplateModels() == null) {
			// kmsWikiTemplate.setSysWfTemplateModels(this
			// .findDefaultWf(kmsWikiTemplate.getFdId()));
			// }
			add(kmsWikiTemplate);
		}
	}

	public void updateImport(IBaseModel modelObj) throws Exception {
		if (modelObj != null) {
			KmsKnowledgeWikiTemplate kmsWikiTemplate = (KmsKnowledgeWikiTemplate) modelObj;
			addCatalog(kmsWikiTemplate);
			update(kmsWikiTemplate);
		}
	}

	/**
	 * 新建模板同步建立目录列表
	 * 
	 * @param kmsWikiTemplate
	 * @throws Exception
	 */
	private void addCatalog(KmsKnowledgeWikiTemplate kmsWikiTemplate) throws Exception {
		if (kmsWikiTemplate.getFdCatalogStr() != null) {
			String fdCatalogStrs = kmsWikiTemplate.getFdCatalogStr();
			String fdCatalogStr[] = fdCatalogStrs.split("[;；]");
			// 添加导入目录
			List<KmsKnowledgeWikiCatalog> fdCatelogList = kmsWikiTemplate
					.getFdCatelogList();
			fdCatelogList.clear();
			for (int i = 0; i < fdCatalogStr.length; i++) {
				KmsKnowledgeWikiCatalog kmsCatelogTemplate = new KmsKnowledgeWikiCatalog();
				kmsCatelogTemplate.setFdName(fdCatalogStr[i]);
				kmsCatelogTemplate.setFdOrder(i + 1);
				kmsCatelogTemplate.setFdTemplate(kmsWikiTemplate);
				// kmsWikiCatelogTemplateService.add(kmsCatelogTemplate);
				fdCatelogList.add(kmsCatelogTemplate);
			}
			kmsWikiTemplate.setFdCatelogList(fdCatelogList);
		}
	}

}
