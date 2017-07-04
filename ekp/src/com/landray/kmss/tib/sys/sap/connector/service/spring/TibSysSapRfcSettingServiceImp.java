package com.landray.kmss.tib.sys.sap.connector.service.spring;

import java.util.List;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.service.BaseCoreInnerServiceImp;
import com.landray.kmss.sys.edition.interfaces.ISysEditionMainModel;
import com.landray.kmss.tib.sys.sap.connector.forms.TibSysSapRfcSettingForm;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcSetting;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapRfcSettingService;

/**
 * RFC函数配置业务接口实现
 * 
 * @author 573
 * @version 1.0 2011-10-09
 */
public class TibSysSapRfcSettingServiceImp extends BaseCoreInnerServiceImp implements
		ITibSysSapRfcSettingService {

	public String add(IExtendForm form, RequestContext requestContext)
			throws Exception {
		TibSysSapRfcSettingForm tibSysSapRfcSettingForm = (TibSysSapRfcSettingForm) form;
		TibSysSapRfcSetting tibSysSapRfcSetting = (TibSysSapRfcSetting) convertFormToModel(
				tibSysSapRfcSettingForm, null, requestContext);
		add(tibSysSapRfcSetting);
		ISysEditionMainModel editionMainModel = (ISysEditionMainModel) tibSysSapRfcSetting;
		ISysEditionMainModel originModel = editionMainModel.getDocOriginDoc();
		if (originModel == null) {
		} else {
			List historyList = originModel.getDocHistoryEditions();
			if (historyList != null) {
				for (int i = 0; i < historyList.size(); ++i) {
					ISysEditionMainModel historyDoc = (ISysEditionMainModel) historyList
							.get(i);
					if (historyDoc.getFdId().equals(editionMainModel.getFdId()))
						continue;
					historyDoc.setDocOriginDoc(editionMainModel);
					saveMainModel(historyDoc);
				}
			}
			originModel.setDocOriginDoc(editionMainModel);
			originModel.setDocIsNewVersion(new Boolean(false));
			saveLockedFlag(originModel, false);
			editionMainModel.setDocIsNewVersion(new Boolean(true));
			editionMainModel.setDocOriginDoc(null);
			saveMainModel(editionMainModel);
		}
		return null;

	}

	public void saveLockedFlag(ISysEditionMainModel model, boolean lockFlag)
			throws Exception {
		model.setDocIsLocked(new Boolean(lockFlag));
		saveMainModel(model);
	}
}
