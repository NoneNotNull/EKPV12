package com.landray.kmss.kms.knowledge.actions;

import java.net.URLDecoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.forms.BaseForm;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.kms.knowledge.forms.KmsMultipleUploadEditDocForm;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeDocTemplate;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeCategoryService;
import com.landray.kmss.kms.knowledge.util.KmsKnowledgeMultiUploadUtil;
import com.landray.kmss.sys.organization.model.SysOrgPerson;
import com.landray.kmss.util.ArrayUtil;
import com.landray.kmss.util.IDGenerator;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

/**
 * 文档内容编辑处理
 * 
 * @author Administrator
 * 
 */
public class KmsMultipleUploadEditDocAction extends ExtendAction {
	/**
	 * 保存文档的內容到缓存
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward saveDoc(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmsMultipleUploadEditDocForm mainForm = (KmsMultipleUploadEditDocForm) form;
		String fdId = mainForm.getFdId();
		if (StringUtil.isNotNull(mainForm.getFdNewId())) {
			fdId = mainForm.getFdNewId();
			mainForm.setFdId(null);
		}
		mainForm.setOperateTime(KmsKnowledgeMultiUploadUtil
				.getChinaTimeZoneDate());
		KmsKnowledgeMultiUploadUtil.addFormToBuffer(fdId, mainForm);
		removeDelForm(mainForm);
		KmsKnowledgeMultiUploadUtil.cacheHealthCheck();
		return getActionForward("success", mapping, form, request, response);
	}

	/**
	 * 再次编辑文档
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @returnT
	 * @throws Exception
	 */
	public ActionForward edit(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmsMultipleUploadEditDocForm mainForm = (KmsMultipleUploadEditDocForm) form;
		String batchOperate = request.getParameter("isBatchOperate");
		// 如果是批量操作
		if (Boolean.valueOf(batchOperate)) {
			IExtendForm targetForm = KmsKnowledgeMultiUploadUtil
					.buildExtendFormInstance(null, request);
			KmsKnowledgeMultiUploadUtil.initForm(targetForm, null, request);
			KmsKnowledgeMultiUploadUtil.traslateFormData(mainForm, targetForm);
			mainForm.setFdId(targetForm.getFdId());
			SysOrgPerson u = UserUtil.getUser();
			mainForm.setDocPostsIds(ArrayUtil.joinProperty(u.getFdPosts(), "fdId",
					";")[0]);
			mainForm.setDocPostsNames(ArrayUtil.joinProperty(u.getFdPosts(),
					"fdName", ";")[0]);
			mainForm.setFdNewId(null);
			getTemplateContent(mainForm);//设置分类模版内容
			request.setAttribute("isBatchOperate", true);
		} else {
			// 如果是再次编辑修改
			if (StringUtil.isNotNull(request.getParameter("fdId"))) {
				mainForm = KmsKnowledgeMultiUploadUtil
						.getFormFromBuffer(request.getParameter("fdId"));
				KmsMultipleUploadEditDocForm newForm = new KmsMultipleUploadEditDocForm();
				newForm.setFdId(request.getParameter("fdId"));
				KmsKnowledgeMultiUploadUtil.traslateFormData(newForm, mainForm);
				restFormValue(newForm, request);
				String isBatchColumn = request.getParameter("isBatchColumn");
				if (Boolean.valueOf(isBatchColumn)) {
					// 因为这个ID会被删掉，所以需要重置FDID
					newForm.setFdNewId(IDGenerator.generateID());
					newForm.setBatchAttIds(null);
				}
				mainForm = newForm;
			} else {
				SysOrgPerson u = UserUtil.getUser();
				KmsMultipleUploadEditDocForm newForm = new KmsMultipleUploadEditDocForm();
				IExtendForm targetForm = KmsKnowledgeMultiUploadUtil
						.buildExtendFormInstance(null, request);
				KmsKnowledgeMultiUploadUtil.initForm(targetForm, null, request);
				KmsKnowledgeMultiUploadUtil.traslateFormData(newForm,
						targetForm);
				newForm.setFdId(targetForm.getFdId());
				newForm.setDocAuthorName(u.getFdName());
				newForm.setDocAuthorId(u.getFdId());
				newForm.setDocPostsIds(ArrayUtil.joinProperty(u.getFdPosts(), "fdId",
						";")[0]);
				newForm.setDocPostsNames(ArrayUtil.joinProperty(u.getFdPosts(),"fdName",
						";")[0]);
				restFormValue(newForm, request);
				mainForm = newForm;
				getTemplateContent(mainForm);//设置分类模版内容
			}
		}
		
		request.setAttribute("kmsMultipleUploadEditDocForm", mainForm);
		((BaseForm) mainForm).setMethod_GET("edit");
		((BaseForm) mainForm).setMethod("edit");
		return getActionForward("doc_edit", mapping, form, request, response);
	}

	private void restFormValue(KmsMultipleUploadEditDocForm newForm,
			HttpServletRequest request) throws Exception {
		if (StringUtil.isNotNull(request.getParameter("attId"))) {
			newForm.setAttId(request.getParameter("attId"));
		}
		String docSubject = request.getParameter("attName");
		if (StringUtil.isNotNull(docSubject)) {
			newForm.setDocSubject(URLDecoder.decode(docSubject, "UTF-8"));
		}
		String fdModelName = request.getParameter("fdModelName");
		newForm.setFdModelName(fdModelName);

	}

	private void removeDelForm(KmsMultipleUploadEditDocForm mainForm) {
		String delFormId = mainForm.getDelFormIds();
		KmsMultipleUploadEditDocForm docMainForm = null;
		if (StringUtil.isNotNull(delFormId)) {
			String formIdArray[] = delFormId.split(";");
			for (String formId : formIdArray) {

				docMainForm = KmsKnowledgeMultiUploadUtil
						.getFormFromBuffer(formId);

				// 因为批量操作会有多个记录引用一个共有的form
				if (docMainForm != null) {
					if (docMainForm.getBatchReferenceCount() > 0) {
						docMainForm.setBatchReferenceCount(docMainForm
								.getBatchReferenceCount() - 1);
					}
					if (docMainForm.getBatchReferenceCount() == 0) {
						KmsKnowledgeMultiUploadUtil
								.removeFormFromBuffer(formId);
					}
				}
			}
		}
		mainForm.setDelFormIds(null);
	}
	
	private void getTemplateContent(KmsMultipleUploadEditDocForm mainForm) 
								throws Exception{
		//分类模版内容
		if(StringUtil.isNull(mainForm.getDocContent())){
			String categoryId = mainForm.getDocCategoryId();
			IKmsKnowledgeCategoryService kmsKnowledgeCategoryService = (IKmsKnowledgeCategoryService)SpringBeanUtil.getBean("kmsKnowledgeCategoryService");
			KmsKnowledgeCategory kmsKnowledgeCategory = (KmsKnowledgeCategory)kmsKnowledgeCategoryService.findByPrimaryKey(categoryId);
			KmsKnowledgeDocTemplate content = kmsKnowledgeCategory.getDocTemplate();
			mainForm.setDocContent(content == null ? "" : content.getDocContent());
		}
	}
	
	@Override
	protected IBaseService getServiceImp(HttpServletRequest request) {
		// TODO 自动生成的方法存根
		return null;
	}

}
