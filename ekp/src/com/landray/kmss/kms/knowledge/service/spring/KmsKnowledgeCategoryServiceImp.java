package com.landray.kmss.kms.knowledge.service.spring;

import java.util.ArrayList;
import java.util.List;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.common.service.BaseServiceImp;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeCategoryService;
import com.landray.kmss.sys.simplecategory.model.ISysSimpleCategoryModel;
import com.landray.kmss.sys.tag.model.SysTagTemplate;
import com.landray.kmss.sys.transport.service.ISysTransportImport;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 知识分类业务接口实现
 * 
 * @author
 * @version 1.0 2013-09-26
 */
public class KmsKnowledgeCategoryServiceImp extends BaseServiceImp implements
		IKmsKnowledgeCategoryService, ISysTransportImport {

	private static final String PATH = "/kms/knowledge/xform/";

	public List<?> findFirstLevelCategory() {
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock("kmsKnowledgeCategory.hbmParent is null");
		hqlInfo.setOrderBy("kmsKnowledgeCategory.fdOrder");
		try {
			return this.findList(hqlInfo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public void update(IExtendForm form, RequestContext requestContext)
			throws Exception {
		IBaseModel model = convertFormToModel(form, null, requestContext);
		// 修改子分类及文档
		setAppToChildren((KmsKnowledgeCategory) model, requestContext);
		super.update(model);
	}

	private void setAppToChildren(KmsKnowledgeCategory model,
			RequestContext requestContext) throws Exception {
		String appToMyDoc = requestContext.getParameter("appToMyDoc");
		String appToChildren = requestContext.getParameter("appToChildren");
		String appToChildrenDoc = requestContext
				.getParameter("appToChildrenDoc");

		if (StringUtil.isNotNull(appToMyDoc)) { // 本类的知识前缀，属性模板
			changeDoc(model,model.getFdId());
			
		}
		if (StringUtil.isNotNull(appToChildren)
				|| StringUtil.isNotNull(appToChildrenDoc)) { // 子类信息
			HQLInfo hqlInfo = new HQLInfo();
			hqlInfo
					.setWhereBlock("kmsKnowledgeCategory.fdHierarchyId like :fdHierarchyId "
							+ "and kmsKnowledgeCategory.fdId!=:templateId");
			hqlInfo.setParameter("fdHierarchyId", model.getFdHierarchyId()
					+ "%");
			hqlInfo.setParameter("templateId", model.getFdId());
			List<?> list = this.findList(hqlInfo);
			if (list.size() > 0) {
				for (int i = 0; i < list.size(); i++) {
					KmsKnowledgeCategory childModel = (KmsKnowledgeCategory) list
							.get(i);
					if (StringUtil.isNotNull(appToChildren)) {
						changeChildTemplate(model, childModel);
					}
					if (StringUtil.isNotNull(appToChildrenDoc)) {
						changeDoc(model, childModel.getFdId());
					}
				}
			}
		}
	}

	// 修改类别下的文档
	private void changeDoc(KmsKnowledgeCategory model,
			String fdId) throws Exception {

		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo
				.setWhereBlock("kmsKnowledgeBaseDoc.docCategory.fdId=:categoryId");
		hqlInfo.setParameter("categoryId", fdId);
		hqlInfo.setModelName("com.landray.kmss.kms.knowledge.model.KmsKnowledgeBaseDoc");
		List<?> list = this.findList(hqlInfo);
		IBaseService docService= (IBaseService) SpringBeanUtil.getBean("kmsKnowledgeBaseDocService");
		for (int i = 0; i < list.size(); i++) {
			KmsKnowledgeBaseDoc doc = (KmsKnowledgeBaseDoc) list.get(i);
			if (model.getSysPropertyTemplate() != null) {
				String e = PATH + model.getSysPropertyTemplate().getFdId()
						+ "/" + model.getSysPropertyTemplate().getFdId();
				doc.setExtendFilePath(e);
			} else
				doc.setExtendFilePath(null);
			docService.update(doc);
		}
	}

	// 修改子类
	private void changeChildTemplate(KmsKnowledgeCategory model,
			KmsKnowledgeCategory childModel) throws Exception {
		if (model.getSysPropertyTemplate() != null) {
			childModel.setSysPropertyTemplate(model.getSysPropertyTemplate());
		} else {
			childModel.setSysPropertyTemplate(null);
		}
		childModel.setFdNumberPrefix(model.getFdNumberPrefix());
		childModel.setFdTemplateType(model.getFdTemplateType());
		// 应用父类的标签
		List childTags = new ArrayList();;
		List<?> tagList = model.getSysTagTemplates();
		for (int i = 0; i < tagList.size(); i++) {
			SysTagTemplate tagTemplate = (SysTagTemplate) tagList.get(i);
			if (tagTemplate != null) {
				SysTagTemplate childTag = new SysTagTemplate();
				childTag.setFdKey(tagTemplate.getFdKey());
				childTag.setFdModelId(childModel
						.getFdId());
				childTag.setFdModelName(tagTemplate.getFdModelName());
				childTag.setFdTagIds(tagTemplate.getFdTagIds());
				childTag.setFdTagNames(tagTemplate.getFdTagNames());
				childTags.add(childTag);
			}
		}
		childModel.setSysTagTemplates(childTags);
		this.update(childModel);
		
	}

	public boolean checkCategoryNameExist(String templateId,
			String templateName, String parentId) throws Exception {
		if (StringUtil.isNull(templateId) || StringUtil.isNull(templateName)) {
			return true;
		}
		String wherepid = "";
		if (StringUtil.isNotNull(parentId)) {
			wherepid = "and kmsKnowledgeCategory.hbmParent.fdId ='" + parentId
					+ "'";
		} else {
			wherepid = "and kmsKnowledgeCategory.hbmParent.fdId is null";
		}

		String sql = "kmsKnowledgeCategory.fdId <> :templateId  and kmsKnowledgeCategory.fdName= :templateName "
				+ wherepid;
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock(sql);
		hqlInfo.setParameter("templateId", templateId);
		hqlInfo.setParameter("templateName", templateName);
		List<KmsKnowledgeCategory> results = findList(hqlInfo);
		if (results == null || results.isEmpty()) {
			return false;
		} else {
			return true;
		}

	}

	public List<KmsKnowledgeCategory> findChildren(String templateId) {
		if (StringUtil.isNull(templateId)) {
			return null;
		}
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo
				.setWhereBlock("kmsKnowledgeCategory.hbmParent.fdId = :templateId");
		hqlInfo.setParameter("templateId", templateId);
		List<KmsKnowledgeCategory> results = null;
		try {
			results = findList(hqlInfo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return results;
	}

	public List<KmsKnowledgeCategory> getAllChildCategory(
			ISysSimpleCategoryModel category) {
		if (category == null) {
			return null;
		}
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock("kmsKnowledgeCategory.fdId !='"
				+ category.getFdId()
				+ "' and kmsKnowledgeCategory.fdHierarchyId like '"
				+ category.getFdHierarchyId() + "%' ");
		List<KmsKnowledgeCategory> results = null;
		try {
			results = findList(hqlInfo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return results;
	}

	@Override
	public void addImport(IBaseModel modelObj) throws Exception {
		setTemplateType(modelObj);
		this.add(modelObj);
	}

	@Override
	public void updateImport(IBaseModel modelObj) throws Exception {
		setTemplateType(modelObj);
		this.update(modelObj);
	}

	private void setTemplateType(IBaseModel modelObj) {
		KmsKnowledgeCategory mainModel = (KmsKnowledgeCategory) modelObj;
		if (StringUtil.isNull(mainModel.getFdTemplateType())) {
			// 为空时，设置通用知识模版类型
			mainModel.setFdTemplateType("3");
		}
	}
}
