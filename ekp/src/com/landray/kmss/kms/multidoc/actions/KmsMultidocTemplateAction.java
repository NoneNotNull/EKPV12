package com.landray.kmss.kms.multidoc.actions;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.upload.FormFile;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.exception.NoRecordException;
import com.landray.kmss.common.exception.UnexpectedRequestException;
import com.landray.kmss.common.forms.ExtendForm;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.kms.multidoc.forms.KmsMultidocTemplateForm;
import com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge;
import com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocKnowledgeService;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocTemplateService;
import com.landray.kmss.kms.multidoc.util.Constants;
import com.landray.kmss.sys.attachment.forms.AttachmentDetailsForm;
import com.landray.kmss.sys.category.model.SysCategoryProperty;
import com.landray.kmss.sys.config.model.SysConfigParameters;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.sys.property.model.SysPropertyTemplate;
import com.landray.kmss.sys.property.service.ISysPropertyTemplateService;
import com.landray.kmss.sys.simplecategory.actions.SysSimpleCategoryAction;
import com.landray.kmss.sys.simplecategory.forms.ISysSimpleCategoryForm;
import com.landray.kmss.sys.simplecategory.model.ISysSimpleCategoryModel;
import com.landray.kmss.sys.tag.forms.SysTagTemplateForm;
import com.landray.kmss.sys.tag.model.SysTagTemplate;
import com.landray.kmss.util.ArrayUtil;
import com.landray.kmss.util.AutoHashMap;
import com.landray.kmss.util.KmssMessage;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;
import com.sunbor.web.tag.Page;

/**
 * 创建日期 2011-Sep-18
 * 
 * @author
 */
public class KmsMultidocTemplateAction extends SysSimpleCategoryAction {
	protected IKmsMultidocTemplateService kmsMultidocTemplateService;

	protected IKmsMultidocTemplateService getServiceImp(
			HttpServletRequest request) {
		if (kmsMultidocTemplateService == null)
			kmsMultidocTemplateService = (IKmsMultidocTemplateService) getBean("kmsMultidocTemplateService");
		return kmsMultidocTemplateService;
	}

	protected String getParentProperty() {
		return "hbmParent";
	}

	protected ActionForm createNewForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmsMultidocTemplateForm kmsMultidocTemplateForm = (KmsMultidocTemplateForm) super
				.createNewForm(mapping, form, request, response);
		kmsMultidocTemplateForm.setDocExpire(Constants.DEF_EXPIRE);
		// kmsMultidocTemplateForm.setDocContent(null);
		kmsMultidocTemplateForm.setDocPostsNames(null);
		kmsMultidocTemplateForm.setDocPostsIds(null);
		kmsMultidocTemplateForm.setDocKeywordNames(null);
		kmsMultidocTemplateForm.setAttachmentForms(new AutoHashMap(
				AttachmentDetailsForm.class));
		// 继承父类的标签
		String parentId = request.getParameter("parentId");
		AutoHashMap childTagForms = new AutoHashMap(SysTagTemplateForm.class);
		if (StringUtil.isNotNull(parentId)) {
			KmsMultidocTemplate parentModel = (KmsMultidocTemplate) getServiceImp(
					request).findByPrimaryKey(parentId);
			List tagList = parentModel.getSysTagTemplates();
			if (tagList.size() > 0) {
				for (int i = 0; i < tagList.size(); i++) {
					SysTagTemplate tagTemplate = (SysTagTemplate) tagList
							.get(i);
					if (tagTemplate != null) {
						SysTagTemplateForm childTagform = new SysTagTemplateForm();
						childTagform.setFdKey(tagTemplate.getFdKey());
						childTagform.setFdModelId(kmsMultidocTemplateForm
								.getFdId());
						childTagform.setFdModelName(tagTemplate
								.getFdModelName());
						childTagform.setFdTagIds(tagTemplate.getFdTagIds());
						childTagform.setFdTagNames(tagTemplate.getFdTagNames());
						childTagForms.put(tagTemplate.getFdKey(), childTagform);
					}
				}
				kmsMultidocTemplateForm.setSysTagTemplateForms(childTagForms);
			}// 继承父类属性模板
			if (parentModel.getSysPropertyTemplate() != null) {
				kmsMultidocTemplateForm.setFdSysPropTemplateId(parentModel
						.getSysPropertyTemplate().getFdId());
				kmsMultidocTemplateForm.setFdSysPropTemplateName(parentModel
						.getSysPropertyTemplate().getFdName());
			}// 继承父类的辅类别
			if (parentModel.getDocProperties() != null
					&& !parentModel.getDocProperties().isEmpty()) {
				List<SysCategoryProperty> list = parentModel.getDocProperties();
				String ids = list.get(0).getFdId();
				String names = list.get(0).getFdName();
				for (int i = 1; i < list.size(); i++) {
					ids = ids + ";" + list.get(i).getFdId();
					names = names + ";" + list.get(i).getFdName();
				}
				kmsMultidocTemplateForm.setDocPropertyNames(names);
				kmsMultidocTemplateForm.setDocPropertyIds(ids);
			}
		}

		return kmsMultidocTemplateForm;
	}

	protected ISysPropertyTemplateService sysPropertyTemplateService;

	protected ISysPropertyTemplateService getPropertyTemplateServiceImp(
			HttpServletRequest request) {
		if (sysPropertyTemplateService == null)
			sysPropertyTemplateService = (ISysPropertyTemplateService) getBean("sysPropertyTemplateService");
		return sysPropertyTemplateService;
	}

	protected IKmsMultidocKnowledgeService kmsMultidocKnowledgeService;

	protected IBaseService getKnowledgeServiceImp(HttpServletRequest request) {
		if (kmsMultidocKnowledgeService == null)
			kmsMultidocKnowledgeService = (IKmsMultidocKnowledgeService) getBean("kmsMultidocKnowledgeService");
		return kmsMultidocKnowledgeService;
	}

	public ActionForward update(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-update", true, getClass());
		KmssMessages messages = new KmssMessages();

		setAppToChildren(mapping, form, request, response);

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
			List<?> rtnList = getServiceImp(request).findLevelOneTemplate();
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

	public ActionForward importTemplate(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		return getActionForward("importTemplate", mapping, form, request,
				response);
	}

	public ActionForward importExcel(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-importExcel", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			KmsMultidocTemplateForm kmsMultidocTemplateForm = (KmsMultidocTemplateForm) form;
			FormFile file = kmsMultidocTemplateForm.getFile();
			if (file.getFileSize() == 0) {
				messages.addError(new KmssMessage(
						"kms-multidoc:kmsMultidocTemplate.noData"));
			} else {
				POIFSFileSystem fs = new POIFSFileSystem(file.getInputStream());
				HSSFWorkbook wb = new HSSFWorkbook(fs);
				HSSFSheet sheet = wb.getSheetAt(0);
				// System.out.println("****" + sheet.getLastRowNum());
				for (int i = 1; i <= sheet.getLastRowNum(); i++) {
					KmsMultidocTemplate template = new KmsMultidocTemplate();
					template.setDocExpire(0L);
					template.setDocAlteror(UserUtil.getUser());
					template.setDocAlterTime(new Date());
					template.setFdIsinheritMaintainer(true);
					template.setFdIsinheritUser(true);
					template.setAuthTmpAttNocopy(false);
					template.setAuthTmpAttNodownload(false);
					template.setAuthTmpAttNoprint(false);

					boolean flag = true;
					HSSFRow row = sheet.getRow(i);
					HSSFCell nameCell = row.getCell((short) 0);
					HSSFCell parentCell = row.getCell((short) 1);
					HSSFCell numberPrefixCell = row.getCell((short) 2);
					HSSFCell orderCell = row.getCell((short) 3);
					HSSFCell propertyCell = row.getCell((short) 4);

					String name = "";
					String numberPrefix = "";
					Double order = 0.0;
					// 读类别名称、编号前缀
					if (nameCell == null || numberPrefixCell == null) {
						flag = false;
						messages
								.addError(new KmssMessage(
										"kms-multidoc:kmsMultidocTemplate.noNameOrNoFrex"));
					} else {
						name = changeToString(nameCell);
						numberPrefix = changeToString(numberPrefixCell);
						template.setFdName(name);// 类别名称
						template.setFdNumberPrefix(numberPrefix);// 编号前缀

					}
					// 读取排序号
					if (orderCell != null) {
						order = orderCell.getNumericCellValue();
						template.setFdOrder(order.intValue());// 序号
					}
					// 读取属性模板名称
					if (propertyCell != null) {
						String property = changeToString(propertyCell);
						HQLInfo hqlInfo = new HQLInfo();
						hqlInfo.setWhereBlock(" fdName=:fdName");
						hqlInfo.setParameter("fdName", property.trim());
						List<SysPropertyTemplate> propertyList = getPropertyTemplateServiceImp(
								request).findList(hqlInfo);
						if (propertyList != null && !propertyList.isEmpty())
							template
									.setSysPropertyTemplate(propertyList.get(0));// 属性模板
						else
							template.setSysPropertyTemplate(null);// 属性模板
					}
					// 读父类别名称
					if (parentCell != null) {
						String parentName = changeToString(parentCell);
						if (StringUtil.isNotNull(parentName)) {
							List lists = findTemplate(parentName, request);
							if (lists.size() == 0) {
								// 如果父类别还没有创建，则将该条数据移到excel最下一行、不添加到数据库。
								/*
								 * HSSFRow ro = sheet.createRow(sheet
								 * .getLastRowNum() +1 ); HSSFCell cell =
								 * ro.createCell((short) 0); HSSFCell xcell =
								 * ro.createCell((short) 1); HSSFCell ycell =
								 * ro.createCell((short) 2);
								 * 
								 * cell.setCellValue(name);
								 * xcell.setCellValue(parentName);
								 * ycell.setCellValue(numberPrefix); if
								 * (orderCell != null) { HSSFCell zcell =
								 * ro.createCell((short) 3);
								 * zcell.setCellValue(order); } flag = false;
								 */

								continue; // 未创建的父类别不处理
							} else {
								template
										.setFdParent((KmsMultidocTemplate) lists
												.get(0));// 父类别
							}
						} else {
							// 如果该类别没有父类，则可以直接创建
							template.setFdParent(null);
						}
					}
					if (flag) {
						// 查找默认流程
						// template.setSysWfTemplateModels(getServiceImp(request).findDefaultWf(template.getFdId()));//
						// 流程
					}
					getServiceImp(request).add(template);
				}
			}
		} catch (Exception e) {
			messages.addError(e);
		}

		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_CLOSE).save(request);
		TimeCounter.logCurrentTime("Action-importExcel", false, getClass());
		if (messages.hasError())
			return getActionForward("failure", mapping, form, request, response);
		else
			return getActionForward("success", mapping, form, request, response);
	}

	public List findTemplate(String name, HttpServletRequest request)
			throws Exception {
		List list = null;
		list = getServiceImp(request).findList(
				"kmsMultidocTemplate.fdName='" + name + "'", "");
		return list;
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
			ISysSimpleCategoryModel model = (ISysSimpleCategoryModel) getServiceImp(
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

	private String changeToString(HSSFCell cell) throws Exception {
		String returnv = null;
		if (cell == null)
			return returnv;
		int type = cell.getCellType();
		switch (type) {
		case HSSFCell.CELL_TYPE_NUMERIC: {
			double b = cell.getNumericCellValue();
			returnv = String.valueOf(b);
			break;
		}
		case HSSFCell.CELL_TYPE_STRING:
			returnv = cell.getStringCellValue();
			break;
		default:
			break;
		}
		return returnv;
	}

	private void response(HttpServletResponse response, String message)
			throws Exception {
		response.setCharacterEncoding("UTF-8");
		response.getOutputStream().write(message.getBytes("UTF-8"));
	}

	// 页面上得到 可维护者， 可编辑者
	private String getParentMaintainer(ISysSimpleCategoryModel category,
			HttpServletRequest request, boolean isParent) throws Exception {
		List allEditors = new ArrayList();
		List allReaders = new ArrayList();
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
		List allReaders = new ArrayList();
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
			ISysSimpleCategoryModel model) {
		if (model != null && model.getAuthEditors() != null) {
			List list = model.getAuthEditors();
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
				/*
				 * if(o instanceof SysOrgPerson){ SysOrgPerson
				 * e=(SysOrgPerson)o; names=names+e.getFdName()+";";
				 * ids=ids+e.getFdId()+";"; continue; }
				 */
			}
			if (ids.length() > 0)
				ids = ids.substring(0, ids.lastIndexOf(";"));
			if (names.length() > 0)
				names = names.substring(0, names.lastIndexOf(";"));

			form.setAuthEditorIds(ids);
			form.setAuthEditorNames(names);
		}
		if (model != null && model.getAuthReaders() != null) {
			List list = model.getAuthReaders();
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
				/*
				 * if(o instanceof SysOrgPerson){ SysOrgPerson
				 * e=(SysOrgPerson)o; names=names+e.getFdName()+";";
				 * ids=ids+e.getFdId()+";"; continue; }
				 */
			}
			if (ids.length() > 0)
				ids = ids.substring(0, ids.lastIndexOf(";"));
			if (names.length() > 0)
				names = names.substring(0, names.lastIndexOf(";"));

			form.setAuthReaderIds(ids);
			form.setAuthReaderNames(names);

			if (model.getAuthReaderFlag())
				form.setAuthNotReaderFlag("false");
			else
				form.setAuthNotReaderFlag("true");

		}

	}

	private void setAppToChildren(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String fdId = request.getParameter("fdId");
		String appToMyDoc = request.getParameter("appToMyDoc");
		String appToChildren = request.getParameter("appToChildren");
		String appToChildrenDoc = request.getParameter("appToChildrenDoc");

		KmsMultidocTemplateForm kmsMultidocTemplateForm = (KmsMultidocTemplateForm) form;

		KmsMultidocTemplate model = (KmsMultidocTemplate) getServiceImp(request)
				.findByPrimaryKey(fdId);

		if (StringUtil.isNotNull(appToMyDoc)) { // 本类的知识前缀，属性模板，文档编号
			changeDoc(kmsMultidocTemplateForm, model, request);
		}
		if (StringUtil.isNotNull(appToChildren)
				|| StringUtil.isNotNull(appToChildrenDoc)) { // 子类信息
			HQLInfo hqlInfo = new HQLInfo();
			hqlInfo
					.setWhereBlock("kmsMultidocTemplate.fdHierarchyId like :fdHierarchyId "
							+ "and kmsMultidocTemplate.fdId!=:templateId");
			hqlInfo.setParameter("fdHierarchyId", model.getFdHierarchyId()
					+ "%");
			hqlInfo.setParameter("templateId", fdId);
			List list = getServiceImp(request).findList(hqlInfo);
			if (list.size() > 0) {
				for (int i = 0; i < list.size(); i++) {
					KmsMultidocTemplate m = (KmsMultidocTemplate) list.get(i);
					if (StringUtil.isNotNull(appToChildren)) {
						changeTemplate(kmsMultidocTemplateForm, m, request);
					}
					if (StringUtil.isNotNull(appToChildrenDoc)) {
						changeDoc(kmsMultidocTemplateForm, m, request);
					}
				}
			}
		}
	}

	// 修改类别下的文档
	private void changeDoc(KmsMultidocTemplateForm kmsMultidocTemplateForm,
			KmsMultidocTemplate model, HttpServletRequest request)
			throws Exception {

		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo
				.setWhereBlock("kmsMultidocKnowledge.kmsMultidocTemplate.fdId=:templateId");
		hqlInfo.setParameter("templateId", model.getFdId());
		List list = getKnowledgeServiceImp(request).findList(hqlInfo);
		for (int i = 0; i < list.size(); i++) {
			KmsMultidocKnowledge k = (KmsMultidocKnowledge) list.get(i);
			String prefix1 = null; // 新前缀

			if (StringUtil.isNotNull(kmsMultidocTemplateForm
					.getFdNumberPrefix())) {
				prefix1 = kmsMultidocTemplateForm.getFdNumberPrefix();
			} else {
				prefix1 = "";
			}

			String num = k.getFdNumber().substring(
					k.getFdNumber().length() - 12, k.getFdNumber().length());
			String newNum = prefix1 + num;
			k.setFdNumber(newNum);
			if (StringUtil.isNotNull(kmsMultidocTemplateForm
					.getFdSysPropTemplateId())) {
				String extendFilePath = k.getExtendFilePath();
				if (StringUtil.isNotNull(extendFilePath)) {
					String old = extendFilePath.substring(extendFilePath
							.lastIndexOf("/") + 1, extendFilePath.length());
					String e = extendFilePath.replace(old,
							kmsMultidocTemplateForm.getFdSysPropTemplateId());
					k.setExtendFilePath(e);
				} else {
					String e = "/kms/multidoc/xform/"
							+ kmsMultidocTemplateForm.getFdSysPropTemplateId()
							+ "/"
							+ kmsMultidocTemplateForm.getFdSysPropTemplateId();
					k.setExtendFilePath(e);
				}
			} else
				k.setExtendFilePath(null);

			getKnowledgeServiceImp(request).update(k);
		}
	}

	// 修改子类
	private void changeTemplate(KmsMultidocTemplateForm form,
			KmsMultidocTemplate model, HttpServletRequest request)
			throws Exception {
		if (StringUtil.isNotNull(form.getFdSysPropTemplateId())) {
			SysPropertyTemplate sysPropertyTemplate = (SysPropertyTemplate) getPropertyTemplateServiceImp(
					request).findByPrimaryKey(form.getFdSysPropTemplateId());
			model.setSysPropertyTemplate(sysPropertyTemplate);
		} else {
			model.setSysPropertyTemplate(null);
		}
		model.setFdNumberPrefix(form.getFdNumberPrefix());
		getServiceImp(request).update(model);
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
	}

}
