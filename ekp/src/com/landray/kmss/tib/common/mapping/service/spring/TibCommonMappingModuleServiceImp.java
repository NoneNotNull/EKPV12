package com.landray.kmss.tib.common.mapping.service.spring;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import javax.servlet.http.HttpServletRequest;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.common.service.BaseServiceImp;
import com.landray.kmss.tib.common.mapping.forms.TibCommonMappingModuleForm;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingModule;
import com.landray.kmss.tib.common.mapping.plugins.TibCommonMappingIntegrationPlugins;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingModuleService;
import com.landray.kmss.tib.common.mapping.service.bean.TibCommonMappingGlobalCategoryTreeBean;
import com.landray.kmss.tib.common.mapping.service.bean.TibCommonMappingSimpleCategoryTreeBean;
import com.landray.kmss.util.StringUtil;

/**
 * 应用模块注册配置表业务接口实现
 * 
 * @author
 * @version 1.0 2011-10-14
 */
public class TibCommonMappingModuleServiceImp extends BaseServiceImp implements
		ITibCommonMappingModuleService {
	private static final Log logger = LogFactory.getLog(TibCommonMappingModuleServiceImp.class);
	// 以前判断是否注册没有判断不同模块,线程安全问题。
	public static Map<String, String[]> registerModelHash = new HashMap<String, String[]>();

	public static ConcurrentHashMap<String, Map<String, Object>> REGISTERMODELS = new ConcurrentHashMap<String, Map<String, Object>>(
			1);

	// 模板名称
	private static final String REGISTERMODELS_TEMFIELDNAME_KEY = "tempField";
	// 主文档名称
	private static final String REGISTERMODELS_MAINMODEL_KEY = "mainModel";
	// 类型
	private static final String REGISTERMODELS_FDTYPE_KEY = "fdtype";
	// 是否启用
	private static final String REGISTERMODELS_ISENABLE_KEY = "isenable";

	private static final String REGISTERMODELS_INIT_KEY = "init";

	public ConcurrentHashMap<String, Map<String, Object>> getRegisterModelHash() {
		return REGISTERMODELS;
	}

	// model注册
	private void initRegModel() throws Exception {

		List<TibCommonMappingModule> tibCommonMappingModuleList = findList(
				"tibCommonMappingModule.fdUse=1", null);

		for (TibCommonMappingModule modelSetting : tibCommonMappingModuleList) {
			if (StringUtil.isNull(modelSetting.getFdType())) {
				continue;
			}
			Map<String, Object> setting = new HashMap<String, Object>();
			setting.put(REGISTERMODELS_TEMFIELDNAME_KEY,
					modelSetting.getFdModelTemFieldName());
			setting.put(REGISTERMODELS_MAINMODEL_KEY,
					modelSetting.getFdMainModelName());
			setting.put(REGISTERMODELS_FDTYPE_KEY, modelSetting.getFdType());
			setting.put(REGISTERMODELS_ISENABLE_KEY, modelSetting.getFdUse()
					.toString());
			REGISTERMODELS.put(modelSetting.getFdMainModelName(), setting);
		}
		REGISTERMODELS.put(REGISTERMODELS_INIT_KEY,
				new HashMap<String, Object>(1));
	}

	// 应用模块注册
	public Map<String, Object> getRegisterModelInfo(String mainName)
			throws Exception {
		if (REGISTERMODELS.get(REGISTERMODELS_INIT_KEY) == null) {
			initRegModel();
		}
		return REGISTERMODELS.get(mainName);
	}

	public boolean ifRegisterByMainName(String mainName, String type) {
		// templateName会带有$符号，所以需要截取比较
		int $index = mainName.indexOf("$");
		if ($index > -1)
			mainName = mainName.substring(0, $index);
		Map<String, Object> regInfo;
		try {
			regInfo = getRegisterModelInfo(mainName);
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
		if (regInfo == null) {
			return false;
		}
		Boolean rtnBool = new Boolean(
				(String) regInfo.get(REGISTERMODELS_ISENABLE_KEY));
		String types = (String) regInfo.get(REGISTERMODELS_FDTYPE_KEY);
		return rtnBool && hasFdType(type, types);

	}

	public boolean hasFdType(String fdType, String typeString) {
		if (StringUtil.isNotNull(typeString)) {
			String[] tys = typeString.split(";");
			for (String s : tys) {
				if (s.equals(fdType)) {
					return true;
				}
			}
		}
		return false;
	}

	public boolean ifRegister(String templateName, String type)
			throws Exception {
		return ifRegisterByMainName(templateName, type);
	}

	public boolean ifRegister(IBaseModel model, String type) throws Exception {
		return ifRegisterByMainName(model.getClass().getName(), type);
	}

	public String getFdModelTemFieldName(String mainName) throws Exception {
		Map<String, Object> getModelInfo = getRegisterModelInfo(mainName);
		if (getModelInfo == null)
			return "";
		return (String) getModelInfo.get(REGISTERMODELS_TEMFIELDNAME_KEY);
	}

	public void initRegisterModelHash() throws Exception {
		initRegModel();
	}

	@Override
	public void update(IBaseModel modelObj) throws Exception {
		TibCommonMappingModule main = (TibCommonMappingModule) modelObj;
		// registerModelHash.put(main.getFdMainModelName(), main.getFdUse());
		String[] tmpV = new String[2];
		tmpV[0] = main.getFdUse().toString();
		tmpV[1] = main.getFdModelTemFieldName();
		registerModelHash.put(main.getFdMainModelName(), tmpV);
		super.update(modelObj);
	}

	@Override
	public String add(IExtendForm form, RequestContext requestContext)
			throws Exception {
		TibCommonMappingModuleForm mainForm = (TibCommonMappingModuleForm) form;
		String[] tmpV = new String[2];
		tmpV[0] = mainForm.getFdUse();
		tmpV[1] = mainForm.getFdModelTemFieldName();
		registerModelHash.put(mainForm.getFdMainModelName(), tmpV);
		String fdId = super.add(form, requestContext);
		return fdId;
	}
	
	@Override
	public void delete(IBaseModel modelObj) throws Exception {
		super.delete(modelObj);
		TibCommonMappingModule mappModule = (TibCommonMappingModule)modelObj;
		String mainModelName = mappModule.getFdMainModelName();
		// 移除注册模块缓存
		removeRegisterModule(mainModelName);
	}

	/**
	 * 检查是否包含目标类型
	 * @param type @see  com.landray.kmss.tib.common.mapping.constant.Constant
	 * @return
	 * @throws Exception 
	 */
	public boolean checkModuleContainType(String settingId, String type)
			throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setSelectBlock("fdType");
		hqlInfo.setWhereBlock("fdId=:fdId");
		hqlInfo.setParameter("fdId", settingId);
		hqlInfo.setOrderBy(" fdId desc");
		List<String> types = (List<String>) findValue(hqlInfo);
		if (types.isEmpty()) {
			return false;
		} else {
			if (types.size() > 1) {
				logger.debug("存在2个相同fdId一用注册模块~!只取第一个使用");
			}
			String type1 = (String) types.get(0);
			String[] i_type = type1.split(";");
			if (i_type == null) {
				logger.debug("注册类型为空");
			}
			for (String str : i_type) {
				Map<String, String> infoMap = TibCommonMappingIntegrationPlugins
						.getConfigByType(str);
				if (infoMap.get(
						TibCommonMappingIntegrationPlugins.fdIntegrationType)
						.equals(type)) {
					return true;
				}
			}
		}
		return false;

	}

	@Override
	public void update(IExtendForm form, RequestContext requestContext)
			throws Exception {
		super.update(form, requestContext);
		TibCommonMappingModuleForm moduleForm = (TibCommonMappingModuleForm) form;
		// 移除注册模块缓存
		removeRegisterModule(moduleForm.getFdMainModelName());
	}
	
	/**
	 * 移除注册模块缓存
	 * @param mainModelName
	 */
	private void removeRegisterModule(String mainModelName) {
		Map<String, Object> initMap = REGISTERMODELS.get(REGISTERMODELS_INIT_KEY);
		if (initMap != null) {
			initMap.remove(mainModelName);
		}
	}

	public JSONArray treeView(HttpServletRequest request) throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		JSONArray jsonArray = new JSONArray();
		String parentId = request.getParameter("parentId");
		if (StringUtil.isNull(parentId)) {
			String whereBlock = "tibCommonMappingModule.fdUse=1 ";
//			if (StringUtil.isNotNull(id)) {
//				whereBlock += " and fdId=:fdId";
//				hqlInfo.setParameter("fdId", id);
//			}
			//List<Map<String, Object>> rtnList = new ArrayList<Map<String, Object>>();
			List<TibCommonMappingModule> TibCommonMappingModuleList = findList(hqlInfo);
			for (TibCommonMappingModule tibCommonMappingModule : TibCommonMappingModuleList) {
				//Map<String, Object> map = new HashMap<String, Object>();
				JSONObject jsonObject = new JSONObject();
				String type=tibCommonMappingModule.getFdType();
				String str="("+type2SimpleName(type)+")";
				// 前缀区分简单分类还是全局分类
				jsonObject.put("value", "tib_"+ tibCommonMappingModule.getFdCate() 
						+"_"+ tibCommonMappingModule.getFdId());
				jsonObject.put("text", tibCommonMappingModule.getFdModuleName()+str);
				//jsonObject.put("isAutoFetch", "0");
				//jsonObject.put("target", 2);
				jsonObject.put("autoFetch", true);
				//String path=requestInfo.getContextPath()+"/tib/common/mapping/tib_common_mapping_main/tibCommonMappingMain.do";
//				jsonObject.put("href", path+"?method=forwardModuleCate&moduleName=aaa"
//					//+ tibCommonMappingModule.getFdModuleName()// 模块名字
//					+ "&cateType="
//					+ tibCommonMappingModule.getFdCate()
//					+ "&templateName="
//					+ tibCommonMappingModule.getFdTemplateName()
//					+ "&mainModelName="
//					+ tibCommonMappingModule.getFdMainModelName()
//					+"&settingId="
//	                +tibCommonMappingModule.getFdId()+"');"				
//				);

				jsonArray.add(jsonObject);
			}
		} else if (parentId.indexOf("tib_") != -1){
			String[] params = parentId.split("_");
			// 没有父类型的情况
			TibCommonMappingModule mappingModule = (TibCommonMappingModule) 
					findByPrimaryKey(params[2]);
			parentId = null;
			String fdId = mappingModule.getFdId();
			String modelName = mappingModule.getFdTemplateName();
			String mainModelName = mappingModule.getFdMainModelName();
			String currId = request.getParameter("currId");
			String expandStr = request.getParameter("expand");
			String __currId = null;
			
			// currId区分全局分类，简单分类
			if ("0".equals(params[1])) {
				String href = "javascript:parent.tibLoadList('"+
					"/tib/common/mapping/tib_common_mapping_main/tibCommonMappingMain.do" +
					"?method=add&templateId=!{parentId}&name=!{text}&templateName="+ modelName +
					"&mainModelName="+ mainModelName +"&settingId="+ fdId +"&cateType=0');";
				jsonArray = tibCommonMappingSimpleCategoryTreeBean
					.treeView(modelName, parentId, currId, __currId, expandStr, href,
							mainModelName, fdId, request);
			} else {
				String href = "javascript:parent.tibLoadList('"+
					"/tib/common/mapping/tib_common_mapping_main/tibCommonMappingMain.do" +
					"?method=listTemplate&parentId=!{parentId}&templateName="+ modelName +
					"&mainModelName="+ mainModelName +"&settingId="+ fdId +"&cateType=1');";
				jsonArray = tibCommonMappingGlobalCategoryTreeBean
					.treeView(parentId, modelName, currId, expandStr, __currId, href, 
							mainModelName, fdId, request);
			}
		} else if (parentId.indexOf("_") != -1) {
			// 遍历之后有父类型的情况
			String[] params = parentId.split("_");
			String modelName = params[0];
			String cateType = params[1];
			parentId = params[2];
			String mainModelName = params[3];
			String fdId = params[4];
			String __currId = null;
			String currId = request.getParameter("currId");
			String expandStr = request.getParameter("expand");
			if ("0".equals(cateType)) {
				String href = "javascript:parent.tibLoadList('"+
						"/tib/common/mapping/tib_common_mapping_main/tibCommonMappingMain.do" +
						"?method=add&templateId=!{parentId}&name=!{text}&templateName="+ modelName +
						"&mainModelName=!{mainModelName}&settingId=!{fdId}&cateType=0');";
				jsonArray = tibCommonMappingSimpleCategoryTreeBean
						.treeView(modelName, parentId, currId, __currId, expandStr, 
								href, mainModelName, fdId, request);
			} else {
				String href = "javascript:parent.tibLoadList('"+
						"/tib/common/mapping/tib_common_mapping_main/tibCommonMappingMain.do" +
						"?method=listTemplate&parentId=!{parentId}&templateName="+ modelName +
						"&mainModelName=!{mainModelName}&settingId=!{fdId}&cateType=1');";
				jsonArray = tibCommonMappingGlobalCategoryTreeBean
						.treeView(parentId, modelName, currId, expandStr, 
								__currId, href,  mainModelName, fdId, request);
			}
		}
		
		return jsonArray;
	}
	
	
	private String type2SimpleName(String type){
		if(StringUtil.isNull(type)){
			return "";
		}
		String[] typeArray=type.split(";");
		StringBuffer buf=new StringBuffer();
		for(String str:typeArray){
			Map<String, String>  mapInfo=TibCommonMappingIntegrationPlugins.getConfigByType(str);
			if(mapInfo==null){
				continue;
			}
			String preKey=mapInfo.get(TibCommonMappingIntegrationPlugins.integrationKey);
			if(StringUtil.isNotNull(preKey)){
				if(buf.length()>0){
					buf.append(",");
				}
				buf.append(preKey);
			}
		}
		return buf.toString();
	}
	
	private TibCommonMappingSimpleCategoryTreeBean tibCommonMappingSimpleCategoryTreeBean;
	private TibCommonMappingGlobalCategoryTreeBean tibCommonMappingGlobalCategoryTreeBean;
	
	public void setTibCommonMappingSimpleCategoryTreeBean(
			TibCommonMappingSimpleCategoryTreeBean tibCommonMappingSimpleCategoryTreeBean) {
		this.tibCommonMappingSimpleCategoryTreeBean = tibCommonMappingSimpleCategoryTreeBean;
	}

	public void setTibCommonMappingGlobalCategoryTreeBean(
			TibCommonMappingGlobalCategoryTreeBean tibCommonMappingGlobalCategoryTreeBean) {
		this.tibCommonMappingGlobalCategoryTreeBean = tibCommonMappingGlobalCategoryTreeBean;
	}
	
}
