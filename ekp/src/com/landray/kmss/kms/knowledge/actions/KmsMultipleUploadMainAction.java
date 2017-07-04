package com.landray.kmss.kms.knowledge.actions;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.kms.knowledge.forms.KmsMultipleUploadEditDocForm;
import com.landray.kmss.kms.knowledge.forms.KmsMultipleUploadMainForm;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory;
import com.landray.kmss.kms.knowledge.service.IKmsKnowledgeCategoryService;
import com.landray.kmss.kms.knowledge.service.IKmsMultipleUploadService;
import com.landray.kmss.kms.knowledge.util.KmsKnowledgeMultiUploadUtil;
import com.landray.kmss.util.AutoHashMap;
import com.landray.kmss.util.IDGenerator;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

public class KmsMultipleUploadMainAction extends ExtendAction {
	
	protected IKmsMultipleUploadService kmsMultipleUploadService;
	private IKmsMultipleUploadService getMultipleUploadServiceImp() {
		if (kmsMultipleUploadService == null)
			kmsMultipleUploadService = (IKmsMultipleUploadService) getBean("kmsMultipleUploadService");
		return kmsMultipleUploadService;
	}
	/**
	 * 保存文档
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @param attName
	 * @return
	 * @throws Exception
	 */
	public ActionForward saveDoc(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String errorMessage = null;
		response.setContentType("application/json");
		response.setCharacterEncoding("utf-8");
		
		KmsMultipleUploadMainForm multiForm = (KmsMultipleUploadMainForm) form;
		
		errorMessage = getMultipleUploadServiceImp().saveDoc(multiForm, new RequestContext(request),new JSONObject());
		writeUploadStatus(errorMessage, response);
		return null;
	}
	
	public ActionForward getAttFileInfo(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		TimeCounter.logCurrentTime("Action-loadAuthodInfo", true, getClass());
		KmssMessages messages = new KmssMessages();
		try {
			KmsMultipleUploadMainForm multiForm = (KmsMultipleUploadMainForm) form;
			AutoHashMap attForm = multiForm.getAttachmentForms();
			String categoryId = multiForm.getFdCategoryId();
			String categoryName = ((KmsKnowledgeCategory) getkmsKnowledgeCategoryServiceImp()
								.findByPrimaryKey(categoryId)).getFdName();
			
			Map<String, String> attIdAndNameMap = KmsKnowledgeMultiUploadUtil
							.extractAttRelateJsonToMap(multiForm.getAttIdAndAttNameJson(),
										"attId", "attName");
			Set<Map.Entry<String, String>> entrySet = attIdAndNameMap.entrySet();
			List<String> fileNames = new ArrayList<String>();
			JSONArray jArray = new JSONArray();
			
			// 所有已经在缓存中存在的ID
			List<String> addIdsList = null;
			String addIds = request.getParameter("fdDocAddIds");
			String docAuthorName = null;
			if (StringUtil.isNotNull(addIds)) {
				String addIdsArray[] = addIds.split(";");
				addIdsList = new ArrayList<String>(Arrays.asList(addIdsArray));
				
				for (String actuallyId : addIdsList) {
					if (StringUtil.isNull(actuallyId)) {
						continue;
					}
					Map<String, KmsMultipleUploadEditDocForm> bufferMap = KmsKnowledgeMultiUploadUtil
										.getFormBuffer();
					KmsMultipleUploadEditDocForm mainForm = bufferMap.get(actuallyId);
					docAuthorName = mainForm.getDocAuthorName();
				}
			} 
			
			JSONObject json = new JSONObject();
			for (Map.Entry<String, String> entry : entrySet) {
				JSONObject jObject = new JSONObject();
				jObject.element("fdId", IDGenerator.generateID());
				jObject.element("fdName", entry.getValue());
				jObject.element("categoryName", categoryName);
				jObject.element("docAuthorName", docAuthorName==null?UserUtil.getUser().getFdName():docAuthorName);
				jArray.add(jObject);
			}
			json.accumulate("fileInfo", jArray);
			json.accumulate("attForm", attForm);
			request.setAttribute("lui-source", json);
		} catch (Exception e) {
			e.printStackTrace();
			messages.addError(e);
		}
		KmssReturnPage.getInstance(request).addMessages(messages).addButton(
				KmssReturnPage.BUTTON_CLOSE).save(request);
		TimeCounter.logCurrentTime("Action-loadAuthodInfo", false, getClass());
		if (messages.hasError())
			return getActionForward("failure", mapping, form, request, response);
		else
			return getActionForward("lui-source", mapping, form, request, response);
	}
	
	/**
	 * 将上传后的状态写到返回流中
	 * 
	 * @param errorMessage
	 * @param response
	 * @throws Exception
	 */
	private void writeUploadStatus(String errorMessage,
			HttpServletResponse response) throws Exception {
		JSONObject object = new JSONObject();
		if (StringUtil.isNotNull(errorMessage)) {
			object.put("uploadStatus", errorMessage);
			response.getWriter().write(object.toString());
		} else {
			object.put("uploadStatus", "success");
			response.getWriter().write(object.toString());
		}
	}


	private void buildErrorBuild(StringBuilder buliderMessage) {
		if (buliderMessage.length() > 0) {
			buliderMessage.insert(0, "上传失败的文件有:");
		}

	}


	/**
	 * 创建form对象，并跳转到编辑页面
	 * 
	 * @param mapping
	 * @param form
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public ActionForward forwordEditor(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		ActionForm newForm = createNewForm(request, form);
		request.setAttribute(getFormName(newForm, request), newForm);
		return getActionForward("att_edit", mapping, form, request, response);
	}
	//知识专辑附件批量上传
	public ActionForward forwordUploadEdit(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		ActionForm newForm = createNewForm(request, form);
		request.setAttribute(getFormName(newForm, request), newForm);
		return getActionForward("upload_edit", mapping, form, request, response);
	}
	//在线学习附件上传
	public ActionForward forwordKmsLearnUpload(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		ActionForm newForm = createNewForm(request, form);
		request.setAttribute(getFormName(newForm, request), newForm);
		return getActionForward("kmsLearn_upload", mapping, form, request, response);
	}
	/**
	 * 创建KmsMultidocMultiFileForm
	 * 
	 * @param request
	 * @param form
	 * @return
	 */
	public ActionForm createNewForm(HttpServletRequest request, ActionForm form) {
		String fdModelName = request.getParameter("fdModelName");
		String fdKey = request.getParameter("fdKey");
		String categoryId = request.getParameter("cateId");
		String categoryName = request.getParameter("categoryName");
		String currentPathTitle = request.getParameter("title");
		String fdCategoryModelName = request
				.getParameter("fdCategoryModelName");
		String categoryIndicateName = request
				.getParameter("categoryIndicateName");
		KmsMultipleUploadMainForm newForm = (KmsMultipleUploadMainForm) form;
		newForm.setFdKey(fdKey);
		newForm.setModelClassName(fdModelName);
		newForm.setFdCategoryId(categoryId);
		newForm.setFdCategoryName(categoryName);
		newForm.setFdCategoryModelName(fdCategoryModelName);
		newForm.setCategoryIndicateName(categoryIndicateName);
		String title = ResourceUtil.getString(currentPathTitle);
		newForm.setTitle(title);
		String currentModelPath = KmsKnowledgeMultiUploadUtil
				.getModelPath(fdModelName);
		newForm.setModelPath(currentModelPath);
		return newForm;
	}

	

	
	private IKmsKnowledgeCategoryService kmsKnowledgeCategoryService;

	protected IKmsKnowledgeCategoryService getkmsKnowledgeCategoryServiceImp() {
		if (kmsKnowledgeCategoryService == null)
			kmsKnowledgeCategoryService = (IKmsKnowledgeCategoryService) getBean("kmsKnowledgeCategoryService");
		return kmsKnowledgeCategoryService;
	}
	
	@Override
	protected IBaseService getServiceImp(HttpServletRequest request) {
		// TODO 自动生成的方法存根
		return null;
	}

}
