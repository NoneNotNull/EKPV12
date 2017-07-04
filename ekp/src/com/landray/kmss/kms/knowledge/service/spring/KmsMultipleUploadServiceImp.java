package com.landray.kmss.kms.knowledge.service.spring;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import net.sf.cglib.beans.BeanCopier;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.service.BaseServiceImp;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.constant.SysDocConstant;
import com.landray.kmss.kms.knowledge.forms.KmsKnowledgeBaseDocForm;
import com.landray.kmss.kms.knowledge.forms.KmsMultipleUploadEditDocForm;
import com.landray.kmss.kms.knowledge.forms.KmsMultipleUploadMainForm;
import com.landray.kmss.kms.knowledge.service.IKmsMultipleUploadService;
import com.landray.kmss.kms.knowledge.util.KmsKnowledgeMultiUploadUtil;
import com.landray.kmss.sys.attachment.forms.AttachmentDetailsForm;
import com.landray.kmss.sys.doc.forms.SysDocBaseInfoForm;
import com.landray.kmss.sys.metadata.interfaces.IExtendDataService;
import com.landray.kmss.sys.organization.model.SysOrgPerson;
import com.landray.kmss.util.ArrayUtil;
import com.landray.kmss.util.AutoHashMap;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

import edu.emory.mathcs.backport.java.util.Collections;

public class KmsMultipleUploadServiceImp extends BaseServiceImp implements IKmsMultipleUploadService{
	
	public String saveDoc(IExtendForm form, RequestContext requestContext,JSONObject jsonObject)throws Exception {
		String errorMessage = null;
		KmsMultipleUploadMainForm multiForm = (KmsMultipleUploadMainForm) form;
		Map<String, String> attIdAndNameMap = KmsKnowledgeMultiUploadUtil
				.extractAttRelateJsonToMap(multiForm.getAttIdAndAttNameJson(),
						"attId", "attName");
		// 获取前端生成的DOC_ID与在数据库表中产生的fd_id的对应关系，主要是为了区分编辑的form对应哪一个附件
		Map<String, String> attIdMap = KmsKnowledgeMultiUploadUtil
				.extractAttRelateJsonToMap(multiForm.getFdAttIdsJson(),
						"attId", "docAttId");
		// 有效的附件上传附件个数
		int effectiveAttIdSize = KmsKnowledgeMultiUploadUtil
				.getAttachementCountByKey(multiForm.getAttachmentForms(),
						multiForm.getFdKey());
		// 所有已经在缓存中存在的ID
		//String addIds = requestContext.getParameter("fdDocAddIds");
		String addIds = multiForm.getFdDocAddIds();
		
		IExtendDataService service = KmsKnowledgeMultiUploadUtil
				.getService(multiForm.getModelClassName());
		// 如果没有编辑任何文档
		//RequestContext context = new RequestContext(request);
		try {
			if (isDriectSubmit(addIds, multiForm)) {
				errorMessage = processDirectlySave(multiForm, addIds, requestContext,
						attIdMap, effectiveAttIdSize, attIdAndNameMap, service, jsonObject);
			} else {
				errorMessage = processOtherwiseSave(multiForm, addIds, requestContext,
						attIdMap, effectiveAttIdSize, attIdAndNameMap, service, jsonObject);
			}
		} finally {
			KmsKnowledgeMultiUploadUtil.cacheHealthCheck();
		}
		return errorMessage;
		
	}
	
	private boolean isDriectSubmit(String addIds,
			KmsMultipleUploadMainForm multiForm) {
		if (KmsKnowledgeMultiUploadUtil.getFormSize() == 0
				|| addIds.length() == 0
				&& multiForm.getBatchIdJson().length() < 3) {
			return true;
		}
		return false;
	}
	
	/**
	 * 处理用户没有进行任何编辑，直接提交
	 * 
	 * @param multiForm
	 * @param addIds
	 * @param context
	 * @param attIdMap
	 * @param effectiveAttIdSize
	 * @param attIdAndNameMap
	 * @param service
	 * @throws Exception
	 */
	private String processDirectlySave(KmsMultipleUploadMainForm multiForm,
			String addIds, RequestContext context,
			Map<String, String> attIdMap, int effectiveAttIdSize,
			Map<String, String> attIdAndNameMap, IExtendDataService service,
			JSONObject infoList)
			throws Exception { 
		// 如果缓存中没有数据或者没有编辑保存，并且不包含批量操作
		StringBuilder buliderMessage = new StringBuilder();
		AttachmentDetailsForm wholeAttForm = (AttachmentDetailsForm) multiForm
				.getAttachmentForms().get(multiForm.getFdKey());
		Set<Map.Entry<String, String>> entrySet = attIdAndNameMap.entrySet();
		List<IExtendForm> formList = createIExtendFormList(multiForm, context
				.getRequest(), effectiveAttIdSize);
		
		int index = 0;
		
		for (Map.Entry<String, String> entry : entrySet) {
			IExtendForm extendForm = formList.get(index);
			setDocInfo(extendForm, entry.getValue());
			String docAttId = attIdMap.get(entry.getKey());
			setAttachmentForm(extendForm, docAttId, wholeAttForm);
			
			JSONArray jArray = new JSONArray();
			String attId = entry.getKey();
			String docId = ((SysDocBaseInfoForm)extendForm).getFdId();
			String authorName = ((SysDocBaseInfoForm)extendForm).getDocAuthorName();
			jArray.add(docId);
			jArray.add(authorName);
			infoList.accumulate(attId, jArray);
			
			index++;
			cleanRequestCache(context);
			
			try {
				service.add(extendForm, context);
			} catch (Exception e) {
				buliderMessage.append(entry.getValue()).append(",");
			}
		}
		
		buildErrorBuild(buliderMessage);
		return buliderMessage.toString();
	}
	
	/**
	 * 执行保存，包含未被用户编辑以及编辑并保存的数据，然后合并数据，保存
	 * 
	 * @param multiForm
	 * @param addIds
	 *            编辑并保存的formId集合
	 * @param context
	 * @param attIdMap
	 *            附件id与附件的数据库ID的对应关系
	 * @param effectiveAttIdSize
	 *            有效的附件个数
	 * @param attIdAndNameMap
	 *            附件自身的ID与附件名称的对应关系
	 * @param service
	 * @throws Exception
	 */
	private String processOtherwiseSave(KmsMultipleUploadMainForm multiForm,
			String addIds, RequestContext context,
			Map<String, String> attIdMap, int effectiveAttIdSize,
			Map<String, String> attIdAndNameMap, IExtendDataService service,
			JSONObject infoList)
			throws Exception {

		Set<Map.Entry<String, String>> entrySet = attIdAndNameMap.entrySet();
		List<String> addIdsList = null;
		if (StringUtil.isNotNull(addIds)) {
			String addIdsArray[] = addIds.split(";");
			addIdsList = new ArrayList<String>(Arrays.asList(addIdsArray));
		} else {
			addIdsList = Collections.emptyList();
		}
		// 在提交前被删除的formID
		String delIds = multiForm.getFdDelIds();
		delCacheUnlessData(addIdsList, delIds, context);
		List<IExtendForm> formList = new ArrayList<IExtendForm>();
		Map<String, KmsMultipleUploadEditDocForm> bufferMap = KmsKnowledgeMultiUploadUtil
				.getFormBuffer();
		// 取出暂存的对象，并合并数据到目标form
		for (String actuallyId : addIdsList) {
			if (StringUtil.isNull(actuallyId)) {
				continue;
			}
			KmsMultipleUploadEditDocForm mainForm = bufferMap.get(actuallyId);
			// 为空，则说明该form是批量form信息的载体，所以这里不处理，仅仅处理点击单个编辑的form
			if (mainForm == null || StringUtil.isNull(mainForm.getAttId())) {
				continue;
			}
			// 上传之后数据库中产生的FD_id
			String uploadAttId = attIdMap.get(mainForm.getAttId());
			if (StringUtil.isNotNull(uploadAttId)) {
				IExtendForm targetForm = KmsKnowledgeMultiUploadUtil
						.buildExtendFormInstance(multiForm, context
								.getRequest());
				KmsKnowledgeMultiUploadUtil.initForm(targetForm, multiForm,
						context.getRequest());
				// 从缓存中移除
				bufferMap.remove(actuallyId);
				mainForm.setFdId(targetForm.getFdId());
				KmsKnowledgeMultiUploadUtil.traslateFormData(targetForm,
						mainForm);
				//附件文档封面
				AttachmentDetailsForm attachmentDetailsForm = (AttachmentDetailsForm) ((KmsKnowledgeBaseDocForm)targetForm)
													.getAttachmentForms().get("spic");
				attachmentDetailsForm.setAttachmentIds(mainForm.getSpicAttIds());
				attachmentDetailsForm.setDeletedAttachmentIds(mainForm.getSpicDeleteAttIds());
				
				setAttachmentForm(targetForm, uploadAttId,
						(AttachmentDetailsForm) multiForm.getAttachmentForms()
								.get(multiForm.getFdKey()));
				
				setDocInfo(targetForm, attIdAndNameMap.get(mainForm
						.getAttId()));
				formList.add(targetForm);
				
				//装入附件转文档后的文档信息，知识专辑使用到
				addAttDocInfo(infoList,mainForm,mainForm.getAttId());
				
				// 删除已经名花有主的附件附件ID
				attIdMap.remove(mainForm.getAttId());
				attIdAndNameMap.remove(mainForm.getAttId());
			}
		}

		// 获取需要创建的form实例个数
		int createFormInstanceSize = effectiveAttIdSize - addIdsList.size();
		// 等于0则说明不需要再生成form实例了
		if (createFormInstanceSize == 0) {
			return saveDoc(formList, service, context);
		} else {
			// 批量操作的列表
			Map<String, String> batchIdMap = KmsKnowledgeMultiUploadUtil
					.extractAttRelateJsonToMap(multiForm.getBatchIdJson(),
							"attId", "formId");
			List<IExtendForm> newFormList = createIExtendFormList(multiForm,
					context.getRequest(), createFormInstanceSize);
			int index = 0;
			
			for (Map.Entry<String, String> entry : entrySet) {
				String attId = entry.getKey();
				// 处理批量操作
				processBatchOperate(batchIdMap, newFormList.get(index), attId);
				String attName = entry.getValue();
				// 获取附件在数据库中的FD_ID
				String attDocId = attIdMap.get(attId);
				setAttachmentForm(newFormList.get(index), attDocId,
						(AttachmentDetailsForm) multiForm.getAttachmentForms()
								.get(multiForm.getFdKey()));
				
				setDocInfo(newFormList.get(index), attName);
				
				//装入附件转文档后的文档信息，知识专辑使用到
				SysDocBaseInfoForm docForm= (SysDocBaseInfoForm)newFormList.get(index);
				addAttDocInfo(infoList,docForm,attId);
				
				index++;
			}
			// 删除批量的formId从缓存
			cleanBatchCacheForm(batchIdMap);
			formList.addAll(newFormList);
			
			return saveDoc(formList, service, context);
		}

	}
	
	//装入附件转文档后的文档信息，知识专辑使用到
	private void addAttDocInfo(JSONObject infoList,
			SysDocBaseInfoForm mainForm,String attId){
		
		JSONArray jArray = new JSONArray();
		String docId = mainForm.getFdId();
		String authorName = mainForm.getDocAuthorName();
		jArray.add(docId);
		jArray.add(authorName);
		infoList.accumulate(attId, jArray);
	}
	
	/**
	 * 根据指定的附件个数创建对应的form列表
	 * 
	 * @param multiForm
	 * @param request
	 * @param attachSize
	 * @return
	 * @throws Exception
	 */
	private List<IExtendForm> createIExtendFormList(
			KmsMultipleUploadMainForm multiForm, HttpServletRequest request,
			int attachSize) throws Exception {
		List<IExtendForm> formList = new ArrayList<IExtendForm>(attachSize);
		for (int i = 0; i < attachSize; i++) {
			IExtendForm targetForm = KmsKnowledgeMultiUploadUtil
					.buildExtendFormInstance(multiForm, request);
			KmsKnowledgeMultiUploadUtil
					.initForm(targetForm, multiForm, request);
			formList.add(targetForm);
		}
		return formList;
	}
	
	public static void setDocInfo(IExtendForm form, String docSubject)
			throws Exception {
		KmsKnowledgeBaseDocForm baseForm = (KmsKnowledgeBaseDocForm) form;
		baseForm.setDocSubject(docSubject);
		
		SysOrgPerson u = UserUtil.getUser();
		if(StringUtil.isNull(baseForm.getDocAuthorName())&&StringUtil.isNull(baseForm.getOuterAuthor())){
			baseForm.setDocAuthorId(u.getFdId());
			baseForm.setDocAuthorName(u.getFdName());
		}
		
		if(StringUtil.isNull(baseForm.getDocPostsIds())){
			baseForm.setDocPostsIds(ArrayUtil.joinProperty(u.getFdPosts(), "fdId",
					";")[0]);
			baseForm.setDocPostsNames(ArrayUtil.joinProperty(u.getFdPosts(),"fdName",
					";")[0]);
		}
	}
	
	/**
	 * 设置form的附件对象
	 * 
	 * @param targetForm
	 * @param attId
	 * @param attachForm
	 * @throws Exception
	 */
	private void setAttachmentForm(IExtendForm targetForm, String attId,
			AttachmentDetailsForm attachForm) throws Exception {
		AutoHashMap autoMap = (AutoHashMap) KmsKnowledgeMultiUploadUtil
				.invokeMethod(targetForm, "getAttachmentForms", (Class[]) null,
						(Object[]) null);
		AttachmentDetailsForm docDetailsForm = new AttachmentDetailsForm();
		BeanCopier copyInstance = BeanCopier
				.create(AttachmentDetailsForm.class,
						AttachmentDetailsForm.class, false);
		copyInstance.copy(attachForm, docDetailsForm, null);
		docDetailsForm.setAttachmentIds(attId);
		autoMap.put(attachForm.getFdKey(), docDetailsForm);
		SysDocBaseInfoForm baseForm = (SysDocBaseInfoForm) targetForm;
		baseForm.setDocStatus(SysDocConstant.DOC_STATUS_EXAMINE);
	}
	
	/**
	 * 删除请求对象中对model的缓存，否则当批量新增form中的fd_id会被重置，导致在调用流程的时候的时候无法找到对应的model实例
	 * 
	 * @param context
	 */
	private void cleanRequestCache(RequestContext context) {
		context.setAttribute("EXTENDDATASERVICE_MAIN_MODEL_CACHE", null);
	}
	
	private void buildErrorBuild(StringBuilder buliderMessage) {
		if (buliderMessage.length() > 0) {
			buliderMessage.insert(0, "上传失败的文件有:");
		}
	}
	
	/**
	 * 删除在缓存中保存的数据，当在界面点击删除链接的时候需要从缓存中清除无用的垃圾数据
	 * 
	 * @param addIdsList
	 * @param context
	 */
	private void delCacheUnlessData(List<String> addIdsList,String delIds,
			RequestContext context) {
		// 在提交前被删除的formID
		//String delIds = context.getParameter("fdDelIds");
		String delIdsArray[] = delIds.split(";");
		if (delIdsArray.length > 0) {
			for (String delId : delIdsArray) {
				if (StringUtil.isNotNull(delId)) {
					// 删除在缓存中的key
					KmsKnowledgeMultiUploadUtil.removeFormFromBuffer(delId);
				}
				if (!addIdsList.contains(delId)) {
					addIdsList.remove(delId);
				}
			}
		}
	}
	
	private String saveDoc(List<IExtendForm> formList, IBaseService service,
			RequestContext context) throws Exception {
		StringBuilder buliderMessage = new StringBuilder();
		for (IExtendForm extendForm : formList) {
			cleanRequestCache(context);
			try {
				service.add(extendForm, context);
			} catch (Exception e) {
				buliderMessage.append(
						((SysDocBaseInfoForm) extendForm).getDocSubject())
						.append(",");
			}
		}
		buildErrorBuild(buliderMessage);
		return buliderMessage.toString();
	}
	
	/**
	 * 处理批量操作的form
	 * 
	 * @param batchIdMap
	 * @param formInstance
	 * @param attId
	 * @throws Exception
	 */
	private void processBatchOperate(Map<String, String> batchIdMap,
			IExtendForm formInstance, String attId) throws Exception {
		Set<Map.Entry<String, String>> entrySet = batchIdMap.entrySet();
		KmsMultipleUploadEditDocForm form = null;
		for (Map.Entry<String, String> entry : entrySet) {
			if (attId.equals(entry.getKey())) {
				String formId = entry.getValue();
				form = KmsKnowledgeMultiUploadUtil.getFormFromBuffer(formId);
				KmsKnowledgeMultiUploadUtil
						.traslateFormData(formInstance, form);
			}
		}
	}
	

	private void cleanBatchCacheForm(Map<String, String> batchIdMap) {
		// 批量完成之后将Id剔除
		for (String cacheFormId : batchIdMap.values()) {
			KmsKnowledgeMultiUploadUtil.removeFormFromBuffer(cacheFormId);

		}
	}
}
