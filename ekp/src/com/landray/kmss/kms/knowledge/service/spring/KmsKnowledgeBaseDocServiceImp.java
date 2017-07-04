package com.landray.kmss.kms.knowledge.service.spring;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLCombiner;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.dao.HQLWrapper;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.constant.SysAuthConstant;
import com.landray.kmss.kms.common.service.IKmsCommonRecycleLogService;
import com.landray.kmss.kms.knowledge.forms.KmsKnowledgeBaseDocForm;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeBaseDocService;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeBaseService;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeCategoryService;
import com.landray.kmss.kms.knowledge.util.KmsKnowledgeConstantUtil;
import com.landray.kmss.sys.config.dict.SysDataDict;
import com.landray.kmss.sys.config.dict.SysDictCommonProperty;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.sys.metadata.dict.SysDictExtendModel;
import com.landray.kmss.sys.metadata.dict.SysDictExtendProperty;
import com.landray.kmss.sys.metadata.interfaces.ExtendDataServiceImp;
import com.landray.kmss.sys.metadata.interfaces.IExtendDataService;
import com.landray.kmss.sys.metadata.interfaces.ISysMetadataParser;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 文档基本信息业务接口实现
 * 
 * @author
 * @version 1.0 2013-09-26
 */
public class KmsKnowledgeBaseDocServiceImp extends ExtendDataServiceImp
		implements IKmsKnowledgeBaseDocService, IKmsKnowledgeBaseService,
		IExtendDataService {

	private IKmsKnowledgeCategoryService kmsKnowledgeCategoryService;
	private ISysMetadataParser sysMetadataParser;
	private IKmsCommonRecycleLogService kmsCommonRecycleLogService;

	public void setKmsCommonRecycleLogService(
			IKmsCommonRecycleLogService kmsCommonRecycleLogService) {
		this.kmsCommonRecycleLogService = kmsCommonRecycleLogService;
	}

	public IKmsKnowledgeCategoryService getKmsKnowledgeCategoryService() {
		return kmsKnowledgeCategoryService;
	}

	public void setKmsKnowledgeCategoryService(
			IKmsKnowledgeCategoryService kmsKnowledgeCategoryService) {
		this.kmsKnowledgeCategoryService = kmsKnowledgeCategoryService;
	}

	public void setSysMetadataParser(ISysMetadataParser sysMetadataParser) {
		this.sysMetadataParser = sysMetadataParser;
	}

	/**
	 * 获取分类service
	 * 
	 * @return
	 */
	public IKmsKnowledgeCategoryService getCategoryServiceImp() {
		return kmsKnowledgeCategoryService;
	}

	/**
	 * 批量更新扩展属性
	 * 
	 * @param form
	 * @param requestContext
	 * @throws Exception
	 */
	public void updateProperty(IExtendForm form, RequestContext requestContext)
			throws Exception {

		String idList = ((KmsKnowledgeBaseDocForm) form).getIdList();
		String[] ids = idList.split(",");
		if (ids.length <= 0)
			return;
		Map<String, Object> newValueMap = ((KmsKnowledgeBaseDocForm) form)
				.getExtendDataFormInfo().getFormData();
		Object[] obKey = newValueMap.keySet().toArray();
		Object[] obvalue = newValueMap.values().toArray();
		int length = obKey.length;
		String[] extendModelKeyItem = new String[length];
		System.arraycopy(obKey, 0, extendModelKeyItem, 0, length);

		for (int i = 0; i < ids.length; i++) {
			if (StringUtil.isNull(ids[i]))
				continue;
			KmsKnowledgeBaseDoc knowledge = (KmsKnowledgeBaseDoc) this
					.findByPrimaryKey(ids[i], null, true);
			Map<String, SysDictCommonProperty> dictExtendMap = this
					.getDictExtendModelMap(knowledge);
			// 分别设置扩展属性值
			for (int j = 0; j < extendModelKeyItem.length; j++) {
				SysDictExtendProperty extendProperty = (SysDictExtendProperty) dictExtendMap
						.get(extendModelKeyItem[j]);
				Object oValue = sysMetadataParser.formatInputValue(obvalue[j],
						extendProperty);
				if (ids.length == 1
						|| (!(oValue instanceof HashMap) && oValue != null && !""
								.equals(oValue))
						|| (oValue instanceof HashMap && !((Map<?, ?>) oValue)
								.isEmpty())) {
					knowledge.getExtendDataModelInfo().getModelData().put(
							extendModelKeyItem[j], oValue);
				}
			}
			getBaseDao().update(knowledge);
		}
	}


	private Map<String, SysDictCommonProperty> getDictExtendModelMap(
			IBaseModel model) throws Exception {
		SysDictModel dictModel = sysMetadataParser.getDictModel(model);
		if (!(dictModel instanceof SysDictExtendModel))
			return null;
		return ((SysDictExtendModel) dictModel).getPropertyMap();
	}


	// 经过筛选器筛选后的文档hql（已权限处理）
	public HQLWrapper getDocHql(String whereBlock, String __joinBlock,
			HttpServletRequest request) throws Exception {

		HQLInfo hql = new HQLInfo();
		if (hql.getCheckParam(SysAuthConstant.CheckType.AllCheck) == null) {
			hql.setCheckParam(SysAuthConstant.CheckType.AllCheck,
					SysAuthConstant.AllCheck.DEFAULT);
		}
		hql.setSelectBlock("kmsKnowledgeBaseDoc.fdId");
		hql.setFromBlock(__joinBlock);
		hql
				.setModelName("com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc");
		hql.setWhereBlock(whereBlock);
		HQLCombiner hqlCombiner = (HQLCombiner) SpringBeanUtil
				.getBean("hqlCombiner");
		HQLWrapper hqlWrapper = hqlCombiner.buildQueryHQL(hql);
		return hqlWrapper;
	}

	// 获取当前分类为第几级分类
	public int getLevelCount(KmsKnowledgeCategory kmsKnowledgeCategory)
			throws Exception {
		String fdHierarchyId = kmsKnowledgeCategory.getFdHierarchyId();
		int countX = 0;
		for (int i = 0; i < fdHierarchyId.length(); i++) {
			if (fdHierarchyId.charAt(i) == 'x') {
				countX++;
			}
		}
		return countX - 1;
	}

	// 根据分类拼出该分类的fdSetTopLevel排序码
	public String getFdSetTopLevel(KmsKnowledgeCategory kmsKnowledgeCategory,
			String str) throws Exception {
		String fdHierarchyId = kmsKnowledgeCategory.getFdHierarchyId();
		int countX = 0;
		int levelCount = 0;
		for (int i = 0; i < fdHierarchyId.length(); i++) {
			if (fdHierarchyId.charAt(i) == 'x') {
				countX++;
			}
		}
		levelCount = countX - 1;
		String fdSetTopLevel = "";
		StringBuilder sb = new StringBuilder();
		for (int n = 0; n < levelCount - 1; n++) {
			sb.append("0");
		}
		fdSetTopLevel = sb.append(str).toString();
		return fdSetTopLevel;
	}

	@Override
	public void delete(IBaseModel modelObj) throws Exception {
		KmsKnowledgeBaseDoc kmsKnowledgeBaseDoc = (KmsKnowledgeBaseDoc) modelObj;
		String className = KmsKnowledgeConstantUtil
				.getTemplateModelName(kmsKnowledgeBaseDoc.getFdKnowledgeType()
						.toString());
		SysDictModel model = SysDataDict.getInstance().getModel(className);
		if (model != null) {
			IBaseService service = (IBaseService) SpringBeanUtil.getBean(model
					.getServiceBean());
			service.delete(modelObj.getFdId());
		}
	}

	@Override
	public void updateRecycle(String id) throws Exception {
		KmsKnowledgeBaseDoc kmsKnowledgeBaseDoc = (KmsKnowledgeBaseDoc) this
				.findByPrimaryKey(id);
		String className = KmsKnowledgeConstantUtil
				.getTemplateModelName(kmsKnowledgeBaseDoc.getFdKnowledgeType()
						.toString());
		SysDictModel model = SysDataDict.getInstance().getModel(className);
		if (model != null) {
			IKmsKnowledgeBaseService service = (IKmsKnowledgeBaseService) SpringBeanUtil
					.getBean(model.getServiceBean());
			service.updateRecycle(id);
		}
	}

	@Override
	public void updateRecycle(String[] ids) throws Exception {
		for (int i = 0; i < ids.length; i++) {
			updateRecycle(ids[i]);
		}
	}

	@Override
	public void updateRecover(String id, String description) throws Exception {
		KmsKnowledgeBaseDoc kmsKnowledgeBaseDoc = (KmsKnowledgeBaseDoc) this
				.findByPrimaryKey(id);
		String className = KmsKnowledgeConstantUtil
				.getTemplateModelName(kmsKnowledgeBaseDoc.getFdKnowledgeType()
						.toString());
		SysDictModel model = SysDataDict.getInstance().getModel(className);
		if (model != null) {
			IKmsKnowledgeBaseService service = (IKmsKnowledgeBaseService) SpringBeanUtil
					.getBean(model.getServiceBean());
			service.updateRecover(id, description);
		}
	}

	@Override
	public void updateRecover(String[] ids, String description)
			throws Exception {
		for (int i = 0; i < ids.length; i++) {
			updateRecover(ids[i], description);
		}
	}

}
