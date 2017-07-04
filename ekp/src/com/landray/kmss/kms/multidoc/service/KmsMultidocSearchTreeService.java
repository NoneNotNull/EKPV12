package com.landray.kmss.kms.multidoc.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.hibernate.Query;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.kms.multidoc.model.KmsMultidocTemplate;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.sys.property.model.SysPropertyDefine;
import com.landray.kmss.sys.property.model.SysPropertyFilterSetting;
import com.landray.kmss.sys.property.model.SysPropertyTree;
import com.landray.kmss.sys.property.service.ISysPropertyFilterService;
import com.landray.kmss.sys.property.service.ISysPropertyFilterSettingService;
import com.landray.kmss.sys.property.service.ISysPropertyTreeService;
import com.landray.kmss.sys.property.util.PropertyType;
import com.landray.sso.client.util.StringUtil;

/**
 * 创建日期 2009-七月-15
 * 
 * @author 组合查询页的左边树
 */
public class KmsMultidocSearchTreeService implements IXMLDataBean {
	// private String modelName =
	// "com.landray.kmss.kms.multidoc.model.KmsMultidocKnowledge";
	private ISysPropertyFilterSettingService sysPropertyFilterSettingService;
	private ISysPropertyFilterService sysPropertyFilterService;
	private IKmsMultidocKnowledgeService kmsMultidocKnowledgeService;
	private IKmsMultidocTemplateService kmsMultidocTemplateService;
	private ISysPropertyTreeService sysPropertyTreeService;

	List<Map<String, String>> rtnList = null;

	public void setSysPropertyTreeService(
			ISysPropertyTreeService sysPropertyTreeService) {
		this.sysPropertyTreeService = sysPropertyTreeService;
	}

	public void setKmsMultidocTemplateService(
			IKmsMultidocTemplateService kmsMultidocTemplateService) {
		this.kmsMultidocTemplateService = kmsMultidocTemplateService;
	}

	public void setKmsMultidocKnowledgeService(
			IKmsMultidocKnowledgeService kmsMultidocKnowledgeService) {
		this.kmsMultidocKnowledgeService = kmsMultidocKnowledgeService;
	}

	public void setSysPropertyFilterSettingService(
			ISysPropertyFilterSettingService sysPropertyFilterSettingService) {
		this.sysPropertyFilterSettingService = sysPropertyFilterSettingService;
	}

	public void setSysPropertyFilterService(
			ISysPropertyFilterService sysPropertyFilterService) {
		this.sysPropertyFilterService = sysPropertyFilterService;
	}

	public List getDataList(RequestContext requestInfo) throws Exception {

		rtnList = new ArrayList<Map<String, String>>();
		String type_parentId_settingId = requestInfo
				.getParameter("type_parentId_settingId"); // 
		String typeName = null;
		String parentId = null;
		String settingId = null; // 针对Filter
		// System.out.println("=====type_parentId_value===="+type_parentId_settingId);
		if (StringUtil.isNotNull(type_parentId_settingId)) {
			String[] str = type_parentId_settingId.split(";");

			if (str.length == 1) {
				typeName = str[0];
			}
			if (str.length == 2) {
				typeName = str[0];
				parentId = str[1];
			}
			if (str.length >= 3) {
				typeName = str[0];
				parentId = str[1];
				settingId = str[2];
			}
		}

		HQLInfo hqlInfo = new HQLInfo();

		// 根
		if (StringUtil.isNull(parentId) && StringUtil.isNull(typeName)) {
			addRtnMap(false, "按分类", "TEMPLATE;");
			addRtnMap(false, "按部门", "DEPT;");
			addRtnMap(false, "按岗位", "POST;");

			// 自定义筛选项
			hqlInfo
					.setWhereBlock("sysPropertyFilterSetting.fdIsEnabled=true and "
							+ "sysPropertyFilterSetting.fdFilterBean in('sysPropertyLongEnumFilter','sysPropertyStringEnumFilter','sysPropertyTreeFilter')");
			List<SysPropertyFilterSetting> list5 = sysPropertyFilterSettingService
					.findList(hqlInfo);
			for (SysPropertyFilterSetting setting : list5) {
				List filterList = sysPropertyFilterService.findList(
						"sysPropertyFilter.fdFilterSetting.fdId='"
								+ setting.getFdId() + "'", "");
				if (filterList.isEmpty())
					continue;
				String type = setting.getFdFilterBean().equals(
						"sysPropertyTreeFilter") ? "TREE" : "FILTER";
				addRtnMap(false, setting.getFdName(), type, setting.getFdId(),
						setting.getFdId());
			}

			// 子
		} else {
			if (StringUtil.isNotNull(typeName)) {
				if ("DEPT".equals(typeName)) { // 部门
					List<SysOrgElement> list2 = null;
					if (StringUtil.isNotNull(parentId))
						list2 = kmsMultidocKnowledgeService.getOrgElement(
								"ORG_TYPE_DEPT", parentId, false);
					else
						list2 = kmsMultidocKnowledgeService.getOrgElement(
								"ORG_TYPE_DEPT", null, false);
					for (SysOrgElement l : list2) {
						addRtnMap(true, l.getFdName(), "DEPT", l.getFdId()
								+ ";");
					}
				}
				if ("POST".equals(typeName)) { // 岗位
					List<SysOrgElement> list3 = null;
					if (StringUtil.isNotNull(parentId))
						list3 = kmsMultidocKnowledgeService.getOrgElement(
								"ORG_TYPE_POST", parentId, true);
					else
						list3 = kmsMultidocKnowledgeService.getOrgElement(
								"ORG_TYPE_POST", null, true);
					for (SysOrgElement l : list3) {
						addRtnMap(true, l.getFdName(), "POST", l.getFdId());
					}
				}
				if ("TEMPLATE".equals(typeName)) { // 分类
					if (StringUtil.isNotNull(parentId))
						hqlInfo
								.setWhereBlock("kmsMultidocTemplate.hbmParent.fdId = '"
										+ parentId + "'");
					else
						hqlInfo
								.setWhereBlock("kmsMultidocTemplate.hbmParent is null");
					hqlInfo.setOrderBy("kmsMultidocTemplate.fdOrder");
					List<KmsMultidocTemplate> results = kmsMultidocTemplateService
							.findList(hqlInfo);
					for (int i = 0; i < results.size(); i++) {
						KmsMultidocTemplate template = (KmsMultidocTemplate) results
								.get(i);
						addRtnMap(true, template.getFdName(), "TEMPLATE",
								template.getFdId());
					}
				}
				if ("YEAR".equals(typeName)) { // 年度

				}

				if ("TREE".equals(typeName)) { // 自定义树
					String treeId = null;
					if (StringUtil.isNotNull(parentId)) {
						List<SysPropertyFilterSetting> filterSettingList = sysPropertyFilterSettingService
								.findList("fdId = '" + parentId + "'", null);
						if (filterSettingList.isEmpty()) {
							treeId = parentId;
						} else {
							SysPropertyFilterSetting filterSetting = (SysPropertyFilterSetting) filterSettingList
									.get(0);
							SysPropertyDefine define = filterSetting
									.getFdDefine();
							Map map = define.getFdParamMap();
							treeId = (String) map.get("fd_data_source");
						}

						List<SysPropertyTree> treeList = sysPropertyTreeService
								.getTree(treeId);

						for (SysPropertyTree l : treeList) {
							addRtnMap(true, l.getFdName(), "TREE", l.getFdId(),
									settingId);
						}
					}
				}
				// 枚举的自定义属性
				if ("FILTER".equals(typeName)) {

					if (StringUtil.isNotNull(parentId)
							&& StringUtil.isNotNull(settingId)) {
						List<SysPropertyFilterSetting> filterSettingList = sysPropertyFilterSettingService
								.findList("fdId = '" + parentId + "'", null);

						if (!filterSettingList.isEmpty()) {
							// 枚举项没有子节点
							SysPropertyFilterSetting filter = (SysPropertyFilterSetting) filterSettingList
									.get(0);
							SysPropertyDefine define = filter.getFdDefine();
							Map map = define.getFdParamMap();
							String filterType = findFilterType(define);
							String structureName = define.getFdStructureName();
							String fd_options = (String) map.get("fd_options");
							String sql = (String) map.get("fd_sql");

							if (StringUtil.isNotNull(fd_options)) {
								String optionsArray[] = fd_options
										.split("\r\n");
								for (int i = 0; i < optionsArray.length; i++) {
									String oStr = optionsArray[i];
									addRtnMap(true, oStr.substring(0, oStr
											.indexOf('|')), "FILTER", oStr
											.substring(oStr.indexOf('|') + 1,
													oStr.length()), settingId,
											structureName, filterType);
								}
							} else if (StringUtil.isNotNull(sql)) {
								Query query = sysPropertyFilterSettingService
										.getBaseDao().getHibernateSession()
										.createSQLQuery(sql);
								List<?> snList = query.list();
								for (int i = 0; i < snList.size(); i++) {
									Object[] obj = (Object[]) snList.get(i);
									addRtnMap(true, (String) obj[1], "FILTER",
											(String) obj[0], settingId,
											structureName, filterType);
								}
							}
						}
					}
				}
			}
		}
		return rtnList;
	}

	private void addRtnMap(boolean isShowCheckBox, String text,
			String... values) {
		Map<String, String> rtnMap = new HashMap<String, String>();
		StringBuffer str = new StringBuffer();
		for (String value : values) {
			str.append(value);
			str.append(getSplitStr());
		}
		rtnMap.put("value", str.toString());
		rtnMap.put("text", text);
		rtnMap.put("isShowCheckBox", String.valueOf(isShowCheckBox));
		rtnList.add(rtnMap);
	}

	private String getSplitStr() {
		return ";";
	}

	private String findFilterType(SysPropertyDefine define) {
		for (PropertyType type : PropertyType.values()) {
			if (type.toString().equals(define.getFdDisplayType())) {
				return type.getDisplayType(define.getFdType());
			}
		}
		return null;
	}
}
