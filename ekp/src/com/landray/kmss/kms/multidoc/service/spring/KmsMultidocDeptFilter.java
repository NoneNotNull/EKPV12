package com.landray.kmss.kms.multidoc.service.spring;

import java.util.ArrayList;
import java.util.List;

import com.landray.kmss.constant.SysOrgConstant;
import com.landray.kmss.kms.multidoc.service.IKmsMultidocKnowledgeService;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.sys.organization.model.SysOrgElement;
import com.landray.kmss.sys.property.constant.ITypeConstant;
import com.landray.kmss.sys.property.filter.FilterItem;
import com.landray.kmss.sys.property.filter.FilterOption;
import com.landray.kmss.sys.property.filter.SysPropertyDeptFilter;
import com.landray.kmss.sys.property.model.SysPropertyDefine;
import com.landray.kmss.sys.property.model.SysPropertyFilterSetting;
import com.landray.kmss.util.UserUtil;

public class KmsMultidocDeptFilter extends SysPropertyDeptFilter {
	IKmsMultidocKnowledgeService kmsMultidocKnowledgeService;

	public void setKmsMultidocKnowledgeService(
			IKmsMultidocKnowledgeService kmsMultidocKnowledgeService) {
		this.kmsMultidocKnowledgeService = kmsMultidocKnowledgeService;
	}

	public boolean accept(SysDictModel sysDictModel,
			SysPropertyDefine sysPropertyDefine) throws Exception {
		String type = sysPropertyDefine.getFdType();

		String displayType = sysPropertyDefine.getFdDisplayType();
		if (ITypeConstant.TYPE_SYS_ORG_ELEMENT.equals(type)
				&& "docDept".equals(displayType)) {
			return true;
		}
		return false;
	}

	@Override
	public FilterItem doOptionFilter(SysDictModel sysDictModel,
			SysPropertyFilterSetting sysPropertyFilterSetting) throws Exception {
		SysOrgElement dept = null; // 所在部门
		SysOrgElement dept2 = null;// 上级部门
		List<SysOrgElement> results = new ArrayList<SysOrgElement>();

		if (UserUtil.getUser().getFdParent() != null) {
			dept = UserUtil.getUser().getFdParent();
			if (dept != null) {
				results.add(dept);
				List temp = sysOrgCoreService.findDirectChildren(
						dept.getFdId(), SysOrgConstant.ORG_TYPE_DEPT);
				results.addAll(temp);
			}
			if (UserUtil.getUser().getFdParent().getFdParent() != null) {
				dept2 = UserUtil.getUser().getFdParent().getFdParent();
				if (dept2 != null) {
					results = sysOrgCoreService.findDirectChildren(dept2
							.getFdId(), SysOrgConstant.ORG_TYPE_DEPT);
				}
			}
		}
		results = null;// 默认所有一级部门
		if (results == null || results.isEmpty()) {// 所有部门
			results = sysOrgCoreService.findDirectChildren(null,
					SysOrgConstant.ORG_TYPE_DEPT);
		}

		FilterItem filterItem = new FilterItem();
		for (int i = 0; i < results.size(); i++) {
			SysOrgElement dpt = (SysOrgElement) results.get(i);
			filterItem.addOption(new FilterOption(dpt.getFdName(), dpt
					.getFdId()));
			if (i >= 10) {
				break;
			}
		}

		filterItem.setIsOrg(true);
		filterItem
				.setDialogJsOption("Dialog_Address(!{mulSelect}, '!{idField}', '!{nameField}', null, 'ORG_TYPE_DEPT', SysProp_FilterSel);");
		filterItem.setType(PROP_FILTER_TYPE_DEPT);
		return filterItem;
	}

}
