package com.landray.kmss.kms.knowledge.util;

import java.beans.PropertyDescriptor;
import java.lang.reflect.Method;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.TimeZone;
import java.util.concurrent.ConcurrentHashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.beanutils.PropertyUtils;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.kms.knowledge.forms.KmsKnowledgeBaseDocForm;
import com.landray.kmss.kms.knowledge.forms.KmsMultipleUploadEditDocForm;
import com.landray.kmss.kms.knowledge.forms.KmsMultipleUploadMainForm;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeCategory;
import com.landray.kmss.kms.knowledge.model.KmsKnowledgeDocTemplate;
import com.landray.kmss.sys.attachment.forms.AttachmentDetailsForm;
import com.landray.kmss.sys.authentication.user.KMSSUser;
import com.landray.kmss.sys.authorization.interfaces.ISysAuthAreaForm;
import com.landray.kmss.sys.config.dict.SysDataDict;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.sys.metadata.forms.ExtendDataFormInfo;
import com.landray.kmss.sys.metadata.interfaces.IExtendDataService;
import com.landray.kmss.sys.tag.forms.SysTagMainForm;
import com.landray.kmss.sys.workflow.interfaces.SysWfBusinessForm;
import com.landray.kmss.util.AutoHashMap;
import com.landray.kmss.util.IDGenerator;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

/**
 * 文档批量上载工具类
 * 
 * @author Administrator
 * 
 */
public class KmsKnowledgeMultiUploadUtil {

	private static final Map<String, KmsMultipleUploadEditDocForm> FORM_BUFFER = new ConcurrentHashMap<String, KmsMultipleUploadEditDocForm>();

	private final static Pattern CURRENT_PATH_PATTERN = Pattern
			.compile("^(/\\w+/\\w+/).+");

	public static String getModelPath(String modelName) {
		SysDictModel dictModel = SysDataDict.getInstance().getModel(modelName);
		String url = dictModel.getUrl();
		Matcher matcher = CURRENT_PATH_PATTERN.matcher(url);
		String currentPath = null;
		if (matcher.find()) {
			currentPath = matcher.group(1);
		}
		return currentPath;
	}

	public static Map<String, KmsMultipleUploadEditDocForm> getFormBuffer() {
		return FORM_BUFFER;
	}

	public static void addFormToBuffer(String fdId,
			KmsMultipleUploadEditDocForm form) {

		FORM_BUFFER.put(fdId, form);

	}

	public static KmsMultipleUploadEditDocForm getFormFromBuffer(String fdId) {

		return FORM_BUFFER.get(fdId);

	}

	public static KmsMultipleUploadEditDocForm removeFormFromBuffer(String fdId) {

		return FORM_BUFFER.remove(fdId);

	}

	public static int getFormSize() {

		return FORM_BUFFER.size();

	}

	/**
	 * form数据互转
	 * 
	 * @param targetForm
	 * @param sourceForm
	 */
	public static void traslateFormData(IExtendForm targetForm,
			IExtendForm sourceForm) {
		PropertyDescriptor[] propertyDescriptors = PropertyUtils
				.getPropertyDescriptors(targetForm);
		String requestProperty = null;
		Class<?> propertyType = null;
		Object sourceValue = null;
		for (int i = 0; i < propertyDescriptors.length; i++) {
			requestProperty = propertyDescriptors[i].getName();
			try {
				propertyType = PropertyUtils.getPropertyType(targetForm,
						requestProperty);
				sourceValue = PropertyUtils.getProperty(sourceForm,
						requestProperty);
				if ("fdId".equals(requestProperty)) {
					continue;
				}
				if (propertyType.isAssignableFrom(String.class)) {
					if (StringUtil.isNotNull((String) sourceValue)) {
						PropertyUtils.setProperty(targetForm, requestProperty,
								sourceValue);
					}
				} else if (propertyType
						.isAssignableFrom(ExtendDataFormInfo.class)) {
					ExtendDataFormInfo targetValue = (ExtendDataFormInfo) PropertyUtils
							.getProperty(targetForm, requestProperty);
					ExtendDataFormInfo formInfo = (ExtendDataFormInfo) sourceValue;
					targetValue.getFormData().putAll(formInfo.getFormData());
					targetValue.setExtendFilePath(formInfo.getExtendFilePath());
				} else if (propertyType.isAssignableFrom(SysTagMainForm.class)) {
					SysTagMainForm targetValue = (SysTagMainForm) PropertyUtils
							.getProperty(targetForm, requestProperty);
					SysTagMainForm tagForm = (SysTagMainForm) sourceValue;
					targetValue.setFdTagNames(tagForm.getFdTagNames());
				} else if (propertyType
						.isAssignableFrom(SysWfBusinessForm.class)) {
					Object targetValue = PropertyUtils.getProperty(targetForm,
							requestProperty);
					PropertyUtils.copyProperties(targetValue, sourceValue);
				}

			} catch (Exception e) {
				continue;
			}
		}
	}

	public static Object invokeMethod(Object obj, String methodName,
			Class<?>[] parameterTypes, Object[] parameterValues)
			throws Exception {
		Method method = obj.getClass().getMethod(methodName, parameterTypes);
		return method.invoke(obj, parameterValues);
	}

	public static int getAttachementCountByKey(AutoHashMap map, String fdKey) {
		AttachmentDetailsForm form = (AttachmentDetailsForm) map.get(fdKey);
		String attids = form.getAttachmentIds();
		return attids == null ? 0 : attids.split(";").length;
	}

	/**
	 * 创建form实例,根据model name
	 * 
	 * @param fdModelName
	 * @return
	 * @throws Exception
	 */
	public static IExtendForm buildExtendFormInstance(
			KmsMultipleUploadMainForm multiForm, HttpServletRequest request)
			throws Exception {
		String fdModelName = request.getParameter("fdModelName");
		if (StringUtil.isNull(fdModelName)) {
			fdModelName = multiForm.getModelClassName();
		}
		Class<?> modelClass = Class.forName(fdModelName);
		IBaseModel modelObj = (IBaseModel) modelClass.newInstance();
		Method formClassMethod = modelClass.getMethod("getFormClass",
				(Class[]) null);
		Class<?> extendFormClass = (Class<?>) formClassMethod.invoke(modelObj,
				(Object[]) null);
		IExtendForm form = (IExtendForm) extendFormClass.newInstance();
		form.setFdId(IDGenerator.generateID());
		// 设置场所
		if (form instanceof ISysAuthAreaForm) {
			ISysAuthAreaForm sysAuthAreaForm = (ISysAuthAreaForm) form;
			KMSSUser user = UserUtil.getKMSSUser();
			sysAuthAreaForm.setAuthAreaId(user.getAuthAreaId());
			sysAuthAreaForm.setAuthAreaName(user.getAuthAreaName());
		}
		return form;
	}

	/**
	 * 构建RequestContext对象
	 * 
	 * @param categoryId
	 * @param request
	 * @return
	 * @throws Exception
	 */
	public static RequestContext buildRequestContext(
			HttpServletRequest request, KmsMultipleUploadMainForm form)
			throws Exception {
		String categoryId = request.getParameter("cateId");
		String categoryIndicateName = request
				.getParameter("categoryIndicateName");
		if (StringUtil.isNull(categoryId)) {
			categoryId = form.getFdCategoryId();
		}
		if (StringUtil.isNull(categoryIndicateName)) {
			categoryIndicateName = form.getCategoryIndicateName();
		}
		RequestContext requestContext = new RequestContext();
		// 这个参数灰常重要,不设置无法初始化流程
		requestContext.setParameter(categoryIndicateName, categoryId);
		return requestContext;
	}

	/**
	 * 初始化form
	 * 
	 * @param targetForm
	 * @param multiForm
	 * @param request
	 * @throws Exception
	 */
	public static void initForm(IExtendForm targetForm,
			KmsMultipleUploadMainForm form, HttpServletRequest request)
			throws Exception {
		String fdModelName = request.getParameter("fdModelName");
		
		if (StringUtil.isNull(fdModelName)) {
			fdModelName = form.getModelClassName();
		}
		
		IExtendDataService service = getService(fdModelName);
		RequestContext recontext = buildRequestContext(request, form);
		service.initFormSetting(targetForm, recontext);
		
		if(form != null){
			String fdCateModelName = form.getFdCategoryModelName();
			if(StringUtil.isNotNull(fdCateModelName)){
				IBaseService baseService = getCateService(fdCateModelName);
				KmsKnowledgeCategory categoryModel = (KmsKnowledgeCategory)baseService.findByPrimaryKey(form.getFdCategoryId());
				KmsKnowledgeDocTemplate docTemplate = categoryModel.getDocTemplate();
				if(docTemplate != null){
					String docContent = categoryModel.getDocTemplate().getDocContent();
					((KmsKnowledgeBaseDocForm)targetForm).setDocContent(docContent);
				}
			}
		}
	}

	public static IExtendDataService getService(String modelName) {
		SysDictModel dictModel = SysDataDict.getInstance().getModel(modelName);
		String serviceName = dictModel.getServiceBean();
		return (IExtendDataService) SpringBeanUtil.getBean(serviceName);
	}
	
	
	public static IBaseService getCateService(String cateModelName) {
		SysDictModel dictModel = SysDataDict.getInstance().getModel(cateModelName);
		String serviceName = dictModel.getServiceBean();
		return (IBaseService) SpringBeanUtil.getBean(serviceName);
	}
	
	public static Map<String, String> extractAttRelateJsonToMap(String json,
			String key1, String key2) {

		Map<String, String> relateMap = new HashMap<String, String>();
		if (StringUtil.isNotNull(json) && json.length() > 20) {
			try {
				// 如果出现json结束位置无']'只有','则做容错补全
				if (json.charAt(json.length()-1) == ',') {
					json = new String(json.substring(0, json.length() - 1));
					json += "]";
				}
				JSONArray jsonArray = JSONArray.fromObject(json);
				for (Iterator<JSONObject> it = jsonArray.iterator(); it
						.hasNext();) {
					JSONObject object = it.next();
					String attId = (String) object.get(key1);
					String docAttId = (String) object.get(key2);
					relateMap.put(attId, docAttId);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return relateMap;
	}

	/**
	 * 判断缓存中的数据是否过期
	 * 
	 * @param currentDate
	 * @param historyDate
	 * @return
	 */
	private static boolean isExpireData(Date currentDate, Date historyDate) {
		long diff = currentDate.getTime() - historyDate.getTime();
		long diffMinutes = diff / (60 * 1000) % 60;
		long diffHours = diff / (60 * 60 * 1000) % 24;
		long diffDays = diff / (24 * 60 * 60 * 1000);
		// 大于一天,或者大于1个小时或者是大于三十分钟
		if (diffDays > 0 || diffHours > 0 || diffMinutes > 30) {
			return true;
		}
		return false;
	}

	/**
	 * 缓存数据健康检查
	 */
	public static void cacheHealthCheck() {
		Date currentDate = getChinaTimeZoneDate();
		Set<Map.Entry<String, KmsMultipleUploadEditDocForm>> sets = FORM_BUFFER
				.entrySet();
		for (Map.Entry<String, KmsMultipleUploadEditDocForm> entry : sets) {
			KmsMultipleUploadEditDocForm form = entry.getValue();
			if (isExpireData(currentDate, form.getOperateTime())) {
				removeFormFromBuffer(entry.getKey());
			}
		}
	}

	/**
	 *当前获取北京时间
	 * 
	 * @return
	 */
	public static Date getChinaTimeZoneDate() {
		// new Date获取的当前时间可能比北京时间晚8小时
		TimeZone tz = TimeZone.getTimeZone("ETC/GMT-8");
		TimeZone.setDefault(tz);
		Calendar calendar = Calendar.getInstance();
		return calendar.getTime();
	}

	public static void main(String[] args) {
		extractAttRelateJsonToMap("[{attId:'SWFUpload_0_0',docAttId:'143bdd687237196106687634800ac432'},","","");
	}

}
