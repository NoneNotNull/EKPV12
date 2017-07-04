package com.landray.kmss.tib.sys.soap.provider.interfaces.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.tib.sys.core.provider.process.provider.interfaces.ITibSysCoreInfo;
import com.landray.kmss.tib.sys.core.provider.vo.TibSysCateVo;
import com.landray.kmss.tib.sys.core.provider.vo.TibSysFuncVo;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapCategory;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapMain;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapCategoryService;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapMainService;
import com.landray.kmss.util.StringUtil;

public class TibSysSoapInfo implements ITibSysCoreInfo {

	private ITibSysSoapCategoryService tibSysSoapCategoryService;
	
	private ITibSysSoapMainService tibSysSoapMainService;
	
	public ITibSysSoapCategoryService getTibSysSoapCategoryService() {
		return tibSysSoapCategoryService;
	}
	
	public void setTibSysSoapCategoryService(
			ITibSysSoapCategoryService tibSysSoapCategoryService) {
		this.tibSysSoapCategoryService = tibSysSoapCategoryService;
	}
	
	public ITibSysSoapMainService getTibSysSoapMainService() {
		return tibSysSoapMainService;
	}


	public void setTibSysSoapMainService(
			ITibSysSoapMainService tibSysSoapMainService) {
		this.tibSysSoapMainService = tibSysSoapMainService;
	}


	public List<TibSysCateVo> getCateInfo(String selectId, String pluginKey)
			throws Exception {
		// TODO 自动生成的方法存根
		List<TibSysCateVo> cateVos =new ArrayList<TibSysCateVo>(1);
		HQLInfo hqlInfo = new HQLInfo();
		if (StringUtil.isNull(selectId)) {
			hqlInfo
					.setWhereBlock("tibSysSoapCategory.hbmParent.fdId is null");
			hqlInfo.setOrderBy("tibSysSoapCategory.fdOrder");
		} else {
			hqlInfo
					.setWhereBlock(" tibSysSoapCategory.hbmParent.fdId =:fdId ");
			hqlInfo.setParameter("fdId", selectId);
			hqlInfo.setOrderBy("tibSysSoapCategory.fdOrder");
		}
		List<TibSysSoapCategory> dbList = tibSysSoapCategoryService
				.findList(hqlInfo);
		for (TibSysSoapCategory tibSysSoapCategory : dbList) {
			Map<String, String> h_map = new HashMap<String, String>();
			TibSysCateVo cate=new TibSysCateVo(tibSysSoapCategory.getFdId(),tibSysSoapCategory.getFdName(),pluginKey );
			cateVos.add(cate);
		}
		return cateVos;
	}
	
	public List<TibSysFuncVo> getFuncDataList(String cateId,String pluginKey) throws Exception{
		HQLInfo hqlInfo = new HQLInfo();
		List<TibSysFuncVo> tibSysFuncVos=new ArrayList<TibSysFuncVo>();
		if (StringUtil.isNull(cateId)) {
			hqlInfo.setWhereBlock("tibSysSoapMain.wsEnable = 1 and tibSysSoapMain.docIsNewVersion = '1' ");
		} else {
			//hqlInfo.setSelectBlock(" tibSysSoapMain.docSubject,tibSysSoapMain.fdId ");
			hqlInfo
					.setWhereBlock("tibSysSoapMain.wsEnable = 1 and tibSysSoapMain.docIsNewVersion = '1' and "
							+ " tibSysSoapMain.docCategory.fdId in "
							+ " (select tibSysSoapCategory.fdId from com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapCategory tibSysSoapCategory where tibSysSoapCategory.fdHierarchyId like :selectId ) ");
			hqlInfo.setParameter("selectId", "%"+cateId+"%");
		}
		List<TibSysSoapMain> dbList = tibSysSoapMainService.findList(hqlInfo);
		
		for(TibSysSoapMain tibSysSoapMain:dbList){
			
			TibSysFuncVo tsv=new TibSysFuncVo(tibSysSoapMain.getFdId(),tibSysSoapMain.getDocSubject(),pluginKey);
			tibSysFuncVos.add(tsv);
		}
		return tibSysFuncVos;
	}



	
	

}
