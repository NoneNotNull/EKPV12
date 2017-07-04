package com.landray.kmss.tib.sys.sap.provider.interfaces.impl;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.tib.sys.core.provider.process.provider.interfaces.ITibSysCoreInfo;
import com.landray.kmss.tib.sys.core.provider.vo.TibSysCateVo;
import com.landray.kmss.tib.sys.core.provider.vo.TibSysFuncVo;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcCategory;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcSetting;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapRfcCategoryService;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapRfcSettingService;
import com.landray.kmss.util.StringUtil;

public class TibSysSapInfo implements ITibSysCoreInfo {
	
	private ITibSysSapRfcCategoryService tibSysSapRfcCategoryService;
	
	private ITibSysSapRfcSettingService tibSysSapRfcSettingService;

	public ITibSysSapRfcSettingService getTibSysSapRfcSettingService() {
		return tibSysSapRfcSettingService;
	}

	public void setTibSysSapRfcSettingService(
			ITibSysSapRfcSettingService tibSysSapRfcSettingService) {
		this.tibSysSapRfcSettingService = tibSysSapRfcSettingService;
	}

	public ITibSysSapRfcCategoryService getTibSysSapRfcCategoryService() {
		return tibSysSapRfcCategoryService;
	}

	public void setTibSysSapRfcCategoryService(
			ITibSysSapRfcCategoryService tibSysSapRfcCategoryService) {
		this.tibSysSapRfcCategoryService = tibSysSapRfcCategoryService;
	}


	public List<TibSysCateVo> getCateInfo(String selectId,String pluginKey) throws Exception {
		
			List<TibSysCateVo> cateList=new ArrayList<TibSysCateVo>(1);
		
			HQLInfo hqlInfo = new HQLInfo();
			String whereBlock="";
			if (StringUtil.isNull(selectId)) {
				whereBlock = " tibSysSapRfcCategory.hbmParent.fdId is null ";
			} else {
				whereBlock = " tibSysSapRfcCategory.hbmParent.fdId=:hbmParentFdId ";
				hqlInfo.setParameter("hbmParentFdId", selectId);
			}
			
			hqlInfo.setWhereBlock(whereBlock);
			hqlInfo.setOrderBy(" tibSysSapRfcCategory.fdOrder ");
			List<TibSysSapRfcCategory> resList = (List<TibSysSapRfcCategory>)tibSysSapRfcCategoryService.findList(hqlInfo);
			for (Iterator<TibSysSapRfcCategory> iterator = resList.iterator(); iterator.hasNext();) {
				Map map = new HashMap<String,String>(1);
				TibSysSapRfcCategory tibSysSapRfcCategory = iterator
						.next();
				TibSysCateVo tibSysCateVo =new TibSysCateVo(tibSysSapRfcCategory.getFdId(),tibSysSapRfcCategory.getFdName(),pluginKey);
				cateList.add(tibSysCateVo);
			}
			return cateList;
	}
	
	public List<TibSysFuncVo> getFuncDataList(String cateId,String pluginKey) throws Exception{
		
		String whereBlock = "tibSysSapRfcSetting.docIsNewVersion = '1' ";
		List<TibSysFuncVo> tibSysFuncVos=new ArrayList<TibSysFuncVo>();
		HQLInfo hqlFunc=new HQLInfo();
		if (StringUtil.isNull(cateId)) {
			whereBlock += " and tibSysSapRfcSetting.fdUse=1 and tibSysSapRfcSetting.docOriginDoc =null";
			hqlFunc.setWhereBlock(whereBlock);
		} else {
			String inStr = "";
			List<?> tibSysSapRfcCategoryFdIdList = new ArrayList();
			HQLInfo hqlInfoCate = new HQLInfo();
			hqlInfoCate.setSelectBlock("tibSysSapRfcCategory.fdId");
			hqlInfoCate.setWhereBlock("tibSysSapRfcCategory.fdHierarchyId like :fdHierarchyId");
			hqlInfoCate.setParameter("fdHierarchyId", "%" + cateId + "%");
			tibSysSapRfcCategoryFdIdList = tibSysSapRfcCategoryService.findValue(hqlInfoCate);
			
			for (Iterator iterator = tibSysSapRfcCategoryFdIdList.iterator(); iterator
					.hasNext();) {
				String idTmp = (String) iterator.next();
				inStr += "".equals(inStr) ? ("'" + idTmp + "'") : (",'"
						+ idTmp + "'");
			}
			whereBlock += " and tibSysSapRfcSetting.docCategory.fdId in ("
					+ inStr
					+ ") and tibSysSapRfcSetting.fdUse=1 and tibSysSapRfcSetting.docOriginDoc =null";
			hqlFunc.setWhereBlock(whereBlock);
		}
		List<TibSysSapRfcSetting> resList = tibSysSapRfcSettingService.findList(hqlFunc);
		for (Iterator iterator = resList.iterator(); iterator.hasNext();) {
			TibSysSapRfcSetting tibSysSapRfcSetting = (TibSysSapRfcSetting) iterator.next();
			TibSysFuncVo tsv=new TibSysFuncVo(tibSysSapRfcSetting.getFdId(),tibSysSapRfcSetting.getFdFunctionName(),pluginKey);
			tibSysFuncVos.add(tsv);
		}
		return tibSysFuncVos;
	}
	

}
