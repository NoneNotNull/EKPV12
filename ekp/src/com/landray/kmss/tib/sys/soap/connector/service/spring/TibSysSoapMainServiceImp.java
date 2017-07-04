package com.landray.kmss.tib.sys.soap.connector.service.spring;

import java.util.List;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.service.BaseCoreInnerServiceImp;
import com.landray.kmss.sys.edition.interfaces.ISysEditionMainModel;
import com.landray.kmss.tib.sys.soap.connector.forms.TibSysSoapMainForm;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapMain;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapMainService;

/**
 * WEBSERVCIE服务函数业务接口实现
 * 
 * @author
 * @version 1.0 2012-08-06
 */
public class TibSysSoapMainServiceImp extends BaseCoreInnerServiceImp implements
		ITibSysSoapMainService {
	public String add(IExtendForm form, RequestContext requestContext)
			throws Exception {
		TibSysSoapMainForm TibSysSoapMainForm = (TibSysSoapMainForm) form;
		TibSysSoapMain TibSysSoapMain = (TibSysSoapMain) convertFormToModel(
				TibSysSoapMainForm, null, requestContext);
 		String fdId=add(TibSysSoapMain);
		ISysEditionMainModel editionMainModel = (ISysEditionMainModel) TibSysSoapMain;
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
		return fdId;

	}

	public void saveLockedFlag(ISysEditionMainModel model, boolean lockFlag)
			throws Exception {
		model.setDocIsLocked(new Boolean(lockFlag));
		saveMainModel(model);
	}
	
	public TibSysSoapMain findEnableServiceById(String fdId) throws Exception {
		HQLInfo hqlInfo = new HQLInfo ();
		hqlInfo.setWhereBlock(" fdId=:fdId and wsEnable=1 ");
		hqlInfo.setParameter("fdId", fdId);
		hqlInfo.setOrderBy(" docCreateTime desc");
		List<TibSysSoapMain> result=getBaseDao().findList(hqlInfo);
		if(!result.isEmpty()){
			return result.get(0);
		}
		return null;
		
	}
}
