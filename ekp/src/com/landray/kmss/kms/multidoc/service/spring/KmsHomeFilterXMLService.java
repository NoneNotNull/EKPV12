package com.landray.kmss.kms.multidoc.service.spring;

import java.util.List;

import net.sf.json.JSON;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.constant.SysAuthConstant;
import com.landray.kmss.kms.common.interfaces.IKmsDataBean;
import com.landray.kmss.sys.property.model.SysPropertyFilterMain;
import com.landray.kmss.sys.property.service.ISysPropertyFilterMainService;

public class KmsHomeFilterXMLService implements IKmsDataBean {

	private ISysPropertyFilterMainService syspropertyFilterMainService;

	public void setSysPropertyFilterMainService(
			ISysPropertyFilterMainService syspropertyFilterMainService) {
		this.syspropertyFilterMainService = syspropertyFilterMainService;
	}

	public JSON getDataJSON(RequestContext requestInfo) throws Exception {
		JSONArray jsonArray = new JSONArray();
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock("sysPropertyFilterMain.fdIsEnabled=true");
		hqlInfo.setOrderBy("fdOrder asc");
		hqlInfo.setCheckParam(SysAuthConstant.CheckType.AreaCheck,
				SysAuthConstant.AreaCheck.YES);
		List<SysPropertyFilterMain> list = syspropertyFilterMainService
				.findList(hqlInfo);
		for (SysPropertyFilterMain main : list) {
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("fdName", main.getFdName());
			jsonObject.put("fdId", main.getFdId());
			jsonArray.add(jsonObject);
		}
		return jsonArray;
	}

}
