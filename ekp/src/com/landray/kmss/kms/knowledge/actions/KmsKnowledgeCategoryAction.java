package com.landray.kmss.kms.knowledge.actions;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.exception.NoRecordException;
import com.landray.kmss.common.exception.UnexpectedRequestException;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.kms.knowledge.forms.KmsKnowledgeCategoryForm;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeBaseDocService;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeCategoryService;
import com.landray.kmss.kms.knowledge.util.KmsKnowledgeConstantUtil;
import com.landray.kmss.sys.attachment.forms.AttachmentDetailsForm;
import com.landray.kmss.sys.config.model.SysConfigParameters;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.sys.property.service.ISysPropertyTemplateService;
import com.landray.kmss.sys.simplecategory.actions.SysSimpleCategoryAction;
import com.landray.kmss.sys.simplecategory.forms.ISysSimpleCategoryForm;
import com.landray.kmss.sys.simplecategory.model.ISysSimpleCategoryModel;
import com.landray.kmss.sys.tag.forms.SysTagTemplateForm;
import com.landray.kmss.sys.tag.model.SysTagTemplate;
import com.landray.kmss.util.ArrayUtil;
import com.landray.kmss.util.AutoHashMap;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.StringUtil;
import com.sunbor.web.tag.Page;

/**
 * 知识分类 Action
 * 
 * @author
 * @version 1.0 2013-09-26
 */
public class KmsKnowledgeCategoryAction extends SysSimpleCategoryAction {

	// 文档默认存放期限
	public static final String DEF_EXPIRE = "0";

	protected IKmsKnowledgeCategoryService kmsKnowledgeCategoryService;

	protected ISysPropertyTemplateService sysPropertyTemplateService;

	protected IKmsKnowledgeCategoryService getServiceImp(
			HttpServletRequest request) {
		if (kmsKnowledgeCategoryService == null)
			kmsKnowledgeCategoryService = (IKmsKnowledgeCategoryService) getBean("kmsKnowledgeCategoryService");
		return kmsKnowledgeCategoryService;
	}

	protected ISysPropertyTemplateService getPropertyTemplateServiceImp(
			HttpServletRequest request) {
		if (sysPropertyTemplateService == null)
			sysPropertyTemplateService = (ISysPropertyTemplateService) getBean("sysPropertyTemplateService");
		return sysPropertyTemplateService;
	}

	IKmsKnowledgeBaseDocService kmsKnowledgeBaseDocService;

	protected IKmsKnowledgeBaseDocService getKmsKnowledgeBaseDocServiceImp(
			HttpServletRequest request) {
		if (kmsKnowledgeBaseDocService == null) {
			kmsKnowledgeBaseDocService = (IKmsKnowledgeBaseDocService) getBean("kmsKnowledgeBaseDocService");
		}
		return kmsKnowledgeBaseDocService;
	}

	protected String getParentProperty() {
		return "hbmParent";
	}

	protected ActionForm createNewForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmsKnowledgeCategoryForm kmsKnowledgeCategoryForm = (KmsKnowledgeCategoryForm) super
				.createNewForm(mapping, form, request, response);
		kmsKnowledgeCategoryForm.setDocExpire(DEF_EXPIRE);
		kmsKnowledgeCategoryForm.setDocPostsNames(null);
		kmsKnowledgeCategoryForm.setDocPostsIds(null);
		// kmsKnowledgeCategoryForm.setDocKeywordNames(null);
		kmsKnowledgeCategoryForm.setAttachmentForms(new AutoHashMap(
				AttachmentDetailsForm.class));
		// 继承父类的标签
		String parentId = request.getParameter("parentId");
		AutoHashMap childTagForms = new AutoHashMap(SysTagTemplateForm.class);
		if (StringUtil.isNotNull(parentId)) {
			KmsKnowledgeCategory parentModel = (KmsKnowledgeCategory) getServiceImp(
					request).findByPrimaryKey(parentId);
			List<?> tagList = parentModel.getSysTagTemplates();
			for (int i = 0; i < tagList.size(); i++) {
				SysTagTemplate tagTemplate = (SysTagTemplate) tagList.get(i);
				if (tagTemplate != null) {
					SysTagTemplateForm childTagform = new SysTagTemplateForm();
					childTagform.setFdKey(tagTemplate.getFdKey());
					childTagform.setFdModelId(kmsKnowledgeCategoryForm
							.getFdId());
					childTagform.setFdModelName(tagTemplate.getFdModelName());
					childTagform.setFdTagIds(tagTemplate.getFdTagIds());
					childTagform.setFdTagNames(tagTemplate.getFdTagNames());
					childTagForms.put(tagTemplate.getFdKey(), childTagform);
				}
				kmsKnowledgeCategoryForm.setSysTagTemplateForms(childTagForms);
			}
			// 继承父类属性模板
			if (parentModel.getSysPropertyTemplate() != null) {
				kmsKnowledgeCategoryForm.setFdSysPropTemplateId(parentModel
						.getSysPropertyTemplate().getFdId());
				kmsKnowledgeCategoryForm.setFdSysPropTemplateName(parentModel
						.getSysPropertyTemplate().getFdName());
			}
		}
		return kmsKnowledgeCategoryForm;
	}

	public ActionForward update(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-update", true, getClass());
		KmssMessages messages = new KmssMessages();

		try {
			if (!request.getMethod().equals("POST"))
				throw new UnexpectedRequestException();
			getServiceImp(request).update((IExtendForm) form,
					new RequestContext(request));
		} catch (Exception e) {
			messages.addError(e);
		}

		TimeCounter.logCurrentTime("Action-update", false, getClass());

		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages).save(
					request);
			return getActionForward("edit", mapping, form, request, response);
		} else {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("success", mapping, form, request, response);
		}
	}

	public ActionForward listProperty(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-view", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			List<?> rtnList = getServiceImp(request).findFirstLevelCategory();
			request.setAttribute("templateList", rtnList);
			String fdModelName = request.getParameter("fdModelName");
			if (StringUtil.isNotNull(fdModelName)) {
				List<?> propertyList = getPropertyTemplateServiceImp(request)
						.findByFdModelName(fdModelName);
				request.setAttribute("propertyList", propertyList);
			}
		} catch (Exception e) {
			messages.addError(e);
		}
		TimeCounter.logCurrentTime("Action-view", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("listProperty", mapping, form, request,
					response);
		}
	}

	public ActionForward getParentMaintainer(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		try {
			String parentId = request.getParameter("parentId");
			ISysSimpleCategoryModel category = (ISysSimpleCategoryModel) getServiceImp(
					request).findByPrimaryKey(parentId);
			response(response, getParentMaintainer(category, request, true));
		} catch (Exception e) {
			e.printStackTrace();
			response(response, "");
		}
		return null;
	}

	public ActionForward getParentMaintainer2(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		try {
			String parentId = request.getParameter("parentId");
			ISysSimpleCategoryModel category = (ISysSimpleCategoryModel) getServiceImp(
					request).findByPrimaryKey(parentId);
			response(response, getParentMaintainer2(category, request, true));
		} catch (Exception e) {
			e.printStackTrace();
			response(response, "");
		}
		return null;
	}

	protected ActionForm getNewFormFromCate(String parentId,
			HttpServletRequest request, boolean isParent) throws Exception {
		ISysSimpleCategoryModel category = (ISysSimpleCategoryModel) getServiceImp(
				request).findByPrimaryKey(parentId);
		ISysSimpleCategoryForm categoryForm = (ISysSimpleCategoryForm) getServiceImp(
				request).cloneModelToForm(null, category,
				new RequestContext(request));
		if (isParent) {
			categoryForm.setFdParentId(category.getFdId().toString());
			categoryForm.setFdParentName(category.getFdName());
			categoryForm.setAuthReaderIds(null);
			categoryForm.setAuthReaderNames(null);
			categoryForm.setAuthEditorIds(null);
			categoryForm.setAuthEditorNames(null);
			categoryForm.setFdOrder(null);
			categoryForm.setFdName(null);
			categoryForm.setAuthNotReaderFlag("false");
			// 设置继承的权限
			setRightInherit(categoryForm, category);
		} else {
			categoryForm.setFdOrder(null);
			categoryForm.setFdName(ResourceUtil.getString(
					"sysSimpleCategory.copyOf", "sys-simplecategory")
					+ " " + categoryForm.getFdName());
		}

		categoryForm.setFdIsinheritMaintainer("true");
		categoryForm.setFdIsinheritUser("false");

		((ExtendForm) categoryForm).setMethod("add");
		((ExtendForm) categoryForm).setMethod_GET("add");
		if ("true".equals(categoryForm.getFdIsinheritMaintainer())) {
			request.setAttribute("parentMaintainer", getParentMaintainer(
					category, request, isParent));
			request.setAttribute("parentMaintainer2", getParentMaintainer2(
					category, request, isParent));
		}
		return (ExtendForm) categoryForm;
	}

	protected void loadActionForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		ISysSimpleCategoryForm rtnForm = null;
		String id = request.getParameter("fdId");
		if (!StringUtil.isNull(id)) {
			KmsKnowledgeCategory model = (KmsKnowledgeCategory) getServiceImp(
					request).findByPrimaryKey(id);
			if (model != null) {
				rtnForm = (ISysSimpleCategoryForm) getServiceImp(request)
						.convertModelToForm((IExtendForm) form, model,
								new RequestContext(request));
				if ("true".equals(rtnForm.getFdIsinheritMaintainer())) {
					request.setAttribute("parentMaintainer",
							getParentMaintainer(model, request, false));
					request.setAttribute("parentMaintainer2",
							getParentMaintainer2(model, request, false));
				}
			}
			if (rtnForm != form)
				request.setAttribute(getFormName(rtnForm, request), rtnForm);
		}
		if (rtnForm == null)
			throw new NoRecordException();
	}

	private void response(HttpServletResponse response, String message)
			throws Exception {
		response.setCharacterEncoding("UTF-8");
		response.getOutputStream().write(message.getBytes("UTF-8"));
	}

	// 页面上得到 可维护者， 可编辑者
	private String getParentMaintainer(ISysSimpleCategoryModel category,
			HttpServletRequest request, boolean isParent) throws Exception {
		List<?> allEditors = new ArrayList<Object>();
		if (!isParent) {
			category = (ISysSimpleCategoryModel) category.getFdParent();

		}
		while ((category != null)
				&& (category.getFdIsinheritMaintainer() != null)
				&& (category.getFdIsinheritMaintainer().booleanValue())) {
			ArrayUtil.concatTwoList(category.getAuthEditors(), allEditors);
			category = (ISysSimpleCategoryModel) category.getFdParent();

		}
		return ArrayUtil.joinProperty(allEditors, "fdName", ";")[0];
	}

	// 页面上得到 可使用者， 可阅读者
	private String getParentMaintainer2(ISysSimpleCategoryModel category,
			HttpServletRequest request, boolean isParent) throws Exception {
		List<?> allReaders = new ArrayList<Object>();
		if (!isParent) {
			category = (ISysSimpleCategoryModel) category.getFdParent();

		}
		while ((category != null)
				&& (category.getFdIsinheritMaintainer() != null)
				&& (category.getFdIsinheritMaintainer().booleanValue())) {
			ArrayUtil.concatTwoList(category.getAuthReaders(), allReaders);
			category = (ISysSimpleCategoryModel) category.getFdParent();

		}
		return ArrayUtil.joinProperty(allReaders, "fdName", ";")[0];
	}

	// 新建类别时候设置继承来的权限信息
	private void setRightInherit(ISysSimpleCategoryForm form,
			ISysSimpleCategoryModel model) throws Exception {
		if (model != null && model.getAuthEditors() != null) {
			List<?> list = model.getAuthEditors();
			String ids = "";
			String names = "";
			for (int i = 0; i < list.size(); i++) {
				Object o = list.get(i);
				if (o instanceof SysOrgElement) {
					SysOrgElement e = (SysOrgElement) o;
					names = names + e.getFdName() + ";";
					ids = ids + e.getFdId() + ";";
					continue;
				}
			}
			if (ids.length() > 0)
				ids = ids.substring(0, ids.lastIndexOf(";"));
			if (names.length() > 0)
				names = names.substring(0, names.lastIndexOf(";"));

			form.setAuthEditorIds(ids);
			form.setAuthEditorNames(names);
		}
		if (model != null && model.getAuthReaders() != null) {
			List<?> list = model.getAuthReaders();
			String ids = "";
			String names = "";

			for (int i = 0; i < list.size(); i++) {
				Object o = list.get(i);
				if (o instanceof SysOrgElement) {
					SysOrgElement e = (SysOrgElement) o;
					names = names + e.getFdName() + ";";
					ids = ids + e.getFdId() + ";";
					continue;
				}
			}
			if (ids.length() > 0)
				ids = ids.substring(0, ids.lastIndexOf(";"));
			if (names.length() > 0)
				names = names.substring(0, names.lastIndexOf(";"));

			form.setAuthReaderIds(ids);
			form.setAuthReaderNames(names);
			Boolean notReaderFlag = (Boolean) getProperty(model,
					"authNotReaderFlag");
			form.setAuthNotReaderFlag(notReaderFlag.booleanValue() ? "true"
					: "false");

		}

	}

	private Object getProperty(Object bean, String property)
			throws IllegalAccessException, InvocationTargetException,
			NoSuchMethodException {
		return PropertyUtils.getProperty(bean, property);
	}

	/**
	 * pda自定义视图
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward listTemplate(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-listTemplate", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			String s_pageno = request.getParameter("pageno");
			String s_rowsize = request.getParameter("rowsize");
			String orderby = request.getParameter("orderby");
			String ordertype = request.getParameter("ordertype");
			boolean isReserve = false;
			if (ordertype != null && ordertype.equalsIgnoreCase("down")) {
				isReserve = true;
			}
			int pageno = 0;
			int rowsize = SysConfigParameters.getRowSize();
			if (s_pageno != null && s_pageno.length() > 0) {
				pageno = Integer.parseInt(s_pageno);
			}
			if (s_rowsize != null && s_rowsize.length() > 0) {
				rowsize = Integer.parseInt(s_rowsize);
			}
			if (isReserve)
				orderby += " desc";
			HQLInfo hqlInfo = new HQLInfo();
			hqlInfo.setOrderBy(orderby);
			hqlInfo.setPageNo(pageno);
			hqlInfo.setRowSize(rowsize);
			changeFindPageHQLInfo(request, hqlInfo);
			Page page = getServiceImp(request).findPage(hqlInfo);
			request.setAttribute("queryPage", page);
		} catch (Exception e) {
			messages.addError(e);
		}
		TimeCounter.logCurrentTime("Action-list", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("listTemplate", mapping, form, request,
					response);
		}
	}

	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		super.changeFindPageHQLInfo(request, hqlInfo);
		String whereBlock = hqlInfo.getWhereBlock();
		if (StringUtil.isNull(whereBlock)) {
			whereBlock = "1=1 ";
		}
		String strPara = request.getParameter("parentId");
		String tableName = ModelUtil.getModelTableName(this.getServiceImp(
				request).getModelName());
		if (strPara != null) {
			whereBlock += " and " + tableName + ".hbmParent.fdId = :strPara ";
			hqlInfo.setParameter("strPara", strPara);
		} else {
			whereBlock += " and " + tableName + ".hbmParent is null";
		}
		hqlInfo.setWhereBlock(whereBlock);

		// 区分维基库&多维库分类
		String fdTemplateType = request.getParameter("fdTemplateType");
		KmsKnowledgeConstantUtil.buildHqlByTemplateType(fdTemplateType,
				hqlInfo, tableName);
	}

	public ActionForward findTemplate(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-findTemplate", true, getClass());
		KmssMessages messages = new KmssMessages();

		String fdId = request.getParameter("qq.id");
		if (StringUtil.isNotNull(fdId)) {
			JSONArray array = new JSONArray();
			KmsKnowledgeCategory category = (KmsKnowledgeCategory) this
					.getServiceImp(request).findByPrimaryKey(fdId);
			Map<String, String> map = KmsKnowledgeConstantUtil
					.getTemplateMap(category.getFdTemplateType());
			if (!map.isEmpty()) {
				Iterator<Entry<String, String>> it = map.entrySet().iterator();
				while (it.hasNext()) {
					Entry<String, String> entry = it.next();
					array.add(fillToJson(entry.getValue(), entry.getKey()));
				}
			}
			request.setAttribute("lui-source", array);
		}
		TimeCounter.logCurrentTime("Action-select", false, getClass());
		if (messages.hasError()) {
			KmssReturnPage.getInstance(request).addMessages(messages)
					.addButton(KmssReturnPage.BUTTON_CLOSE).save(request);
			return getActionForward("failure", mapping, form, request, response);
		} else {
			return getActionForward("lui-source", mapping, form, request,
					response);
		}
	}

	protected JSONObject fillToJson(Object text, Object value) {
		JSONObject row = new JSONObject();
		row.put("value", value);
		row.put("text", text);
		return row;
	}
}
