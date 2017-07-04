/**
 * 
 */
package com.landray.kmss.tib.common.inoutdata.service.spring;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.Query;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.dao.HQLParameter;
import com.landray.kmss.common.dao.HQLWrapper;
import com.landray.kmss.common.exception.KmssRuntimeException;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.sys.authentication.filter.HQLFragment;
import com.landray.kmss.sys.authorization.constant.ISysAuthConstant;
import com.landray.kmss.sys.authorization.interfaces.SysAuthAreaUtils;
import com.landray.kmss.sys.authorization.model.SysAuthArea;
import com.landray.kmss.sys.authorization.service.ISysAuthAreaService;
import com.landray.kmss.sys.category.model.SysCategoryMain;
import com.landray.kmss.sys.category.service.ISysCategoryMainService;
import com.landray.kmss.sys.category.service.SysCatetoryTreeAuthCheck;
import com.landray.kmss.sys.config.dict.SysDataDict;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.sys.organization.model.SysOrgPerson;
import com.landray.kmss.tib.common.inoutdata.service.ITibCommonInoutdataCategoryService;
import com.landray.kmss.tib.common.inoutdata.util.TibCommonInoutdataConstant;
import com.landray.kmss.tib.common.mapping.model.TibCommonMappingModule;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingModuleService;
import com.landray.kmss.util.HQLUtil;
import com.landray.kmss.util.KmssMessage;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;
import com.landray.kmss.util.UserUtil;

/**
 * @author 邱建华
 * @version 1.0 2013-1-9
 */
public class TibCommonInoutdataCategoryServiceImp extends HibernateDaoSupport implements
		ITibCommonInoutdataCategoryService, ApplicationContextAware {

	ApplicationContext applicationContext;

	public void setApplicationContext(ApplicationContext applicationContext)
			throws BeansException {
		this.applicationContext = applicationContext;
	}
	
	private ISysCategoryMainService sysCategoryMainService;
	
	private ISysAuthAreaService sysAuthAreaService;
	
	public void setSysCategoryMainService(
			ISysCategoryMainService sysCategoryMainService) {
		this.sysCategoryMainService = sysCategoryMainService;
	}

	public void setSysAuthAreaService(ISysAuthAreaService sysAuthAreaService) {
		this.sysAuthAreaService = sysAuthAreaService;
	}

	public List<Map<String, Object>> getGlobalCategoryList(String categoryId, String modelName,
			String authType, String isGetTemplate, String showType)
			throws Exception {
		List<Map<String, Object>> rtnList = new ArrayList<Map<String, Object>>();
		SysCatetoryTreeAuthCheck sysCatetoryTreeAuthCheck = new SysCatetoryTreeAuthCheck(authType);
		sysCatetoryTreeAuthCheck
				.setFilterUrl("sys_category_main/sysCategoryMain.do");

		if (StringUtil.isNull(isGetTemplate))
			isGetTemplate = "0";
		if (StringUtil.isNull(showType))
			showType = "0";

		if (modelName == null) {
			throw new KmssRuntimeException(new KmssMessage(
					"sys-category:error.noenoughparameter"));
		}
		
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setSelectBlock("sysCategoryMain.fdName, sysCategoryMain.fdId");
		hqlInfo.setOrderBy("sysCategoryMain.fdOrder");

		StringBuffer whereString = new StringBuffer(
				"sysCategoryMain.fdModelName=:modelname");
		hqlInfo.setParameter("modelname", modelName);

		if (StringUtil.isNull(categoryId)|| (categoryId.indexOf(";") > 0 
				&& "notExport".equals(categoryId.split(";")[0]))) {
			whereString.append(" and sysCategoryMain.hbmParent is null");
		} else {
			// 将传过来的值分割出categoryId
			categoryId = categoryId.split(";")[0];
			whereString
					.append(" and sysCategoryMain.hbmParent.fdId=:categoryId");
			hqlInfo.setParameter("categoryId", categoryId);
		}
		if (logger.isDebugEnabled()) {
			logger.debug("获取分类信息,categoryId=" + categoryId + ",modelName="
					+ modelName + ",isGetTemplate=" + isGetTemplate
					+ ",showType=" + showType + ",authType="
					+ sysCatetoryTreeAuthCheck.getAuthType());
		}
		
		String strOrgId = UserUtil.getKMSSUser().getAuthAreaId();
		if (StringUtil.isNotNull(strOrgId)
				&& SysAuthAreaUtils.isAreaEnabled(modelName)
				&& ISysAuthConstant.IS_ISOLATION_ENABLED) {
			SysAuthArea authArea = (SysAuthArea) sysAuthAreaService
					.findByPrimaryKey(strOrgId);

			if (authArea != null) {
				String curOrgHyId = authArea.getFdHierarchyId();
				String treeStringSon = "sysCategoryMain.authArea.fdHierarchyId like :fdHierarchyId";
				String curOrgHyId4In = curOrgHyId.replace("x", "','");
				curOrgHyId4In = curOrgHyId4In.substring(2, curOrgHyId4In
						.length() - 2);
				String treeStringParent = " sysCategoryMain.authArea.fdId in ("
						+ curOrgHyId4In + ")";
				whereString.append(" and ");
				if ("1".equals(showType)) {
					whereString.append(treeStringParent);
				} else {
					whereString.append("(" + treeStringParent + " or "
							+ treeStringSon + ")");
					hqlInfo.setParameter("fdHierarchyId", curOrgHyId + "%");
				}
			}
		}
		
		hqlInfo.setWhereBlock(whereString.toString());

		if (logger.isDebugEnabled()) {
			logger.debug("搜索类别信息：" + whereString.toString());
		}

		List<?> categoriesList = sysCategoryMainService.findValue(hqlInfo);
		for (int i = 0; i < categoriesList.size(); i++) {
			Object[] info = (Object[]) categoriesList.get(i);
			sysCatetoryTreeAuthCheck.checkAuth(info[1].toString());
			if (sysCatetoryTreeAuthCheck.isShowInfo()) {
				Map<String, Object> node = new HashMap<String, Object>();
				node.put("text", info[0]);
				// id, 模块名称, ErpInoutdataConstant.FormFlowMappingChild代表表单流程下面的节点, 1代表全局分类, 模版名称
				node.put("value", info[1] +";"+ SysCategoryMain.class.getName() +";"+ 
						TibCommonInoutdataConstant.FormFlowMappingChild +";1;"+ modelName);
				node.put("nodeType", "CATEGORY");
				rtnList.add(node);
			}
		}
		// 获取分类下所有模版信息
		List<Object[]> templateList = listTemplate(categoryId, modelName);
		for (Object[] obj : templateList) {
			Map<String, Object> map = new HashMap<String, Object>();
			// id, 模块名称, ErpInoutdataConstant.FormFlowMappingChild代表表单流程下面的节点, 1代表全局分类, 模版名称
			map.put("value", (String)obj[0] +";"+ modelName +";"+ 
					TibCommonInoutdataConstant.FormFlowMappingChild +";1;"+ modelName);
			map.put("text", (String)obj[1]);
			map.put("isAutoFetch", "0");
			rtnList.add(map);
//			for (Object[] mainObj : funMainList) {
//				Map<String, Object> map = new HashMap<String, Object>();
//				map.put("value", (String)mainObj[0] +";"+ ERPTEMPFUNCMAIN_NAME);
//				map.put("text", (String)obj[1]);
//				map.put("isAutoFetch", "0");
//				rtnList.add(map);
//			}
		}
		return rtnList;
	}

	public List<Map<String, Object>> getSimpleCategoryList(String categoryId, String modelName,
			String authType) throws Exception {
		List<Map<String, Object>> rtnList = new ArrayList<Map<String, Object>>();
		SysDictModel dict = SysDataDict.getInstance().getModel(modelName);
		IBaseService service = (IBaseService) SpringBeanUtil.getBean(dict
				.getServiceBean());
		SysCatetoryTreeAuthCheck sysCatetoryTreeAuthCheck = new SysCatetoryTreeAuthCheck(
				authType);
		sysCatetoryTreeAuthCheck.setBaseUrl("");
		sysCatetoryTreeAuthCheck.setFilterUrl(dict.getUrl().substring(0,
				dict.getUrl().indexOf("?")));
		String tableName = ModelUtil.getModelTableName(modelName);
		// 构建hqlInfo
		HQLInfo hqlInfo = new HQLInfo();
		if (categoryId.indexOf(";") == -1 || (categoryId.indexOf(";") > 0 
				&& "notExport".equals(categoryId.split(";")[0]))) {
			hqlInfo.setWhereBlock(tableName + ".hbmParent is null");
		} else {
			// 将传过来的值分割出categoryId
			categoryId = categoryId.split(";")[0];
			hqlInfo.setWhereBlock(tableName + ".hbmParent.fdId=:categoryId");
			hqlInfo.setParameter("categoryId", categoryId);
		}
		hqlInfo.setSelectBlock(tableName + ".fdName, " + tableName + ".fdId, "
				+ tableName + ".fdHierarchyId");
		hqlInfo.setOrderBy(tableName + ".fdOrder");
		// 获取分类list
		List<?> categoriesList = service.findValue(hqlInfo);
		for (int i = 0; i < categoriesList.size(); i++) {
			Object[] info = (Object[]) categoriesList.get(i);
			sysCatetoryTreeAuthCheck.checkAuth(info[1].toString());
			if (!sysCatetoryTreeAuthCheck.isShowInfo()) {
				continue;
			}
			HashMap<String, Object> node = new HashMap<String, Object>();
			if (!sysCatetoryTreeAuthCheck.isShowValue()) {
				if (isFilterNode(authType, dict, modelName, tableName, service,
						info[1].toString(), info[2].toString())) {
					continue;
				}
			}
			node.put("text", (String)info[0]);
			// 模块id, 模块名称, ErpInoutdataConstant.FormFlowMappingChild代表表单流程下面的节点, 0代表简单分类, 模版名称
			node.put("value", (String)info[1] +";"+ modelName +";"+ 
					TibCommonInoutdataConstant.FormFlowMappingChild +";0;"+ modelName);
			node.put("nodeType", "CATEGORY");
			rtnList.add(node);
			
		}
		// TempFunMain中的数据列表
//		List<Object[]> funMainList = listTempFunMain(categoryId);
//		for (Object[] mainObj : funMainList) {
//			Map<String, Object> map = new HashMap<String, Object>();
//			map.put("value", (String)mainObj[0] +";"+ ERPTEMPFUNCMAIN_NAME);
//			map.put("text", requestInfo.getParameter("text"));
//			map.put("isAutoFetch", "0");
//			rtnList.add(map);
//		}
		return rtnList;
	}
	
	/**
	 * 获取分类下的所有模版
	 * @param rtnList
	 * @param parentId
	 * @param templateName
	 * @return
	 * @throws Exception
	 */
	@SuppressWarnings("unchecked")
	private List<Object[]> listTemplate(String parentId, String templateName) throws Exception {
		String tableName = ModelUtil.getModelTableName(templateName);
		/*
		 * 通过templateName找到对应启用模块的的一些字段信息，
		 * 只取第一个 如果存在多个认为相关配置是相同的，可以限制不能配置多个相同的
		 */
		ITibCommonMappingModuleService tibCommonMappingModuleService = (ITibCommonMappingModuleService) 
				SpringBeanUtil.getBean("tibCommonMappingModuleService");
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock("tibCommonMappingModule.fdTemplateName=:fdTemplateName " +
				"and tibCommonMappingModule.fdUse=1");
		hqlInfo.setParameter("fdTemplateName", templateName);
		List<TibCommonMappingModule> tibCommonMappingModuleList = tibCommonMappingModuleService
				.findList(hqlInfo);
		TibCommonMappingModule tibCommonMappingModule = tibCommonMappingModuleList.get(0);
		// 一般为fdName
		String fdTemNameFieldName = tibCommonMappingModule.getFdTemNameFieldName();
		// 一般为docCategory
		String fdTemCateFieldName = tibCommonMappingModule.getFdTemCateFieldName();
		String whereBlock = "";
		if (StringUtil.isNull(parentId)) {
			whereBlock = tableName + "." + fdTemCateFieldName + ".fdId is null";
		} else {
			whereBlock = tableName + "." + fdTemCateFieldName + ".fdId='" + parentId + "'";
		}
		Query query = this.getSession().createQuery(
				"select " + tableName + ".fdId," + tableName + "."
						+ fdTemNameFieldName + " from " + templateName + " "
						+ tableName + " where " + whereBlock);
		List<Object[]> list = query.list();
		return list;
	}
	
	/**
	 * 获取表单流程模版中配置了的TibCommonEkpTempFuncMain文档
	 * @param templateId
	 * @return
	 * @throws Exception 
	 */
	private List<Object[]> listTempFunMain(String templateId) throws Exception {
		//String modelName = "com.landray.kmss.third.tibCommon.common.ekp.model.TibCommonEkpTempFuncMain";
		String tableName = ModelUtil.getModelTableName(TIB_COMMONMAPPINGMAIN_NAME);
		Query query = this.getSession().createQuery(
				"select "+ tableName +".fdId,"+ tableName +".fdTemplateName from "+ TIB_COMMONMAPPINGMAIN_NAME +" "
						+ tableName + " where "+ tableName +".fdTemplateId='"+ templateId +"'");
		return query.list();
	}
	
	private boolean isFilterNode(String authType, SysDictModel sysDictModel,
			String modelName, String tableName, IBaseService service,
			String fdId, String fdHierarchyId) throws Exception {
		if (UserUtil.getKMSSUser().isAdmin()) {
			// 管理员不过滤
			return false;
		}
		if (!"01".equals(authType) && !"02".equals(authType)) {
			return false;
		}
		if (sysDictModel.getPropertyMap().get("authAllReaders") == null
				&& sysDictModel.getPropertyMap().get("authAllEditors") == null) {
			// 没有可使用者和可维护者不进行过滤
			return false;
		}
		if ("02".equals(authType)) {
			if (sysDictModel.getPropertyMap().get("authAllReaders") != null) {
				// 计算节点的子节点是否可使用
				HQLInfo hqlInfo = new HQLInfo();
				hqlInfo.setSelectBlock("count(*)");
				hqlInfo.setWhereBlock(tableName
						+ ".fdHierarchyId like :fdHierarchyId and " + tableName
						+ ".fdId <> :fdId");
				hqlInfo.setParameter("fdHierarchyId", fdHierarchyId + "%");
				hqlInfo.setParameter("fdId", fdId);
				HQLFragment hqlFragment = getAuthHQLInfo(modelName, tableName,
						"authAllReaders.fdId");
				if (sysDictModel.getPropertyMap().get("authReaderFlag") != null) {
					hqlFragment.setWhereBlock("(" + tableName
							+ ".authReaderFlag = 1" + " or ("
							+ hqlFragment.getWhereBlock() + "))");
				}
				copyHQLInfo(hqlFragment, hqlInfo);
				List<?> results = service.findValue(hqlInfo);
				if (!results.isEmpty()) {
					Long n = ((Long) results.get(0)).longValue();
					if (n > 0) {
						return false;
					}
				}
			}
		}
		if ("02".equals(authType) || "01".equals(authType)) {
			if (sysDictModel.getPropertyMap().get("authAllEditors") != null) {
				// 计算节点的子节点是否可维护者
				HQLInfo hqlInfo = new HQLInfo();
				hqlInfo.setSelectBlock("count(*)");
				hqlInfo.setWhereBlock(tableName
						+ ".fdHierarchyId like :fdHierarchyId and " + tableName
						+ ".fdId <> :fdId");
				hqlInfo.setParameter("fdHierarchyId", fdHierarchyId + "%");
				hqlInfo.setParameter("fdId", fdId);
				HQLFragment hqlFragment = getAuthHQLInfo(modelName, tableName,
						"authAllEditors.fdId");
				copyHQLInfo(hqlFragment, hqlInfo);
				List<?> results = service.findValue(hqlInfo);
				if (!results.isEmpty()) {
					Long n = ((Long) results.get(0)).longValue();
					if (n > 0) {
						return false;
					}
				}
			}
		}
		return true;
	}

	private void copyHQLInfo(HQLFragment hqlFragment, HQLInfo hqlInfo) {
		hqlInfo.setWhereBlock(StringUtil.linkString(
				hqlFragment.getWhereBlock(), " and ", hqlInfo.getWhereBlock()));
		hqlInfo.setJoinBlock(StringUtil.linkString(hqlFragment.getJoinBlock(),
				"", hqlInfo.getJoinBlock()));
		if (hqlFragment.getIsDistinct() != null) {
			if (hqlFragment.getIsDistinct().booleanValue()) {
				hqlInfo.setDistinctType(HQLInfo.DISTINCT_YES);
			} else {
				hqlInfo.setDistinctType(HQLInfo.DISTINCT_NO);
			}
		}
		hqlInfo.setParameter(hqlFragment.getParameterList());
	}

	@SuppressWarnings("unchecked")
	protected HQLFragment getAuthHQLInfo(String modelName,
			String modelTableName, String field) throws Exception {
		boolean distinct = false;
		StringBuffer joinBlock = new StringBuffer();
		StringBuffer whereBlock = new StringBuffer();
		HQLFragment hqlFragment = new HQLFragment();
		int index = field.lastIndexOf('.');
		boolean isPerson = false;
		String fieldName;
		String[] rtnValues;
		if (index > -1) {
			String firstProperty = field.substring(0, index);
			String type = ModelUtil.getPropertyType(modelName, firstProperty);
			isPerson = type.startsWith(SysOrgPerson.class.getName());
			if (!isPerson && !distinct && type.endsWith("[]"))
				distinct = true;
			fieldName = "auth_field_" + HQLUtil.getFieldIndex();
			joinBlock.append(" left join " + modelTableName + "."
					+ firstProperty + " " + fieldName);
			rtnValues = HQLUtil.formatPropertyWithJoin(modelName, field
					.substring(index + 1), fieldName);
		} else {
			String type = ModelUtil.getPropertyType(modelName, field);
			isPerson = type.startsWith(SysOrgPerson.class.getName());
			rtnValues = HQLUtil.formatPropertyWithJoin(modelTableName, field,
					null);
		}
		fieldName = rtnValues[0];
		if (isPerson) {
			String para = "auth_field_para_" + HQLUtil.getFieldIndex();
			whereBlock.append(fieldName).append(("=:" + para));
			HQLParameter hqlParameter = new HQLParameter(para, UserUtil
					.getKMSSUser().getPerson().getFdId());
			hqlFragment.setParameter(hqlParameter);
		} else {
			List authOrgIds = new ArrayList();
			authOrgIds.add(UserUtil.getEveryoneUser().getFdId()); // 所有者
			authOrgIds.addAll(UserUtil.getKMSSUser().getUserAuthInfo()
					.getAuthOrgIds());
			HQLWrapper hqlWrapper = HQLUtil.buildPreparedLogicIN(fieldName,
					authOrgIds);
			whereBlock.append(hqlWrapper.getHql());
			for (HQLParameter hqlParameter : hqlWrapper.getParameterList()) {
				hqlFragment.setParameter(hqlParameter);
			}
		}
		if (!rtnValues[1].equals("")) {
			joinBlock.append(rtnValues[1]);
			if (!isPerson && !distinct)
				distinct = true;
		}
		hqlFragment.setJoinBlock(joinBlock.toString());
		hqlFragment.setWhereBlock(whereBlock.toString());
		if (distinct) {
			hqlFragment.setIsDistinct(true);
		}
		return hqlFragment;
	}

}
