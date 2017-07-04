package com.landray.kmss.tib.sys.u8.provider.interfaces.impl;

import java.util.ArrayList;
import java.util.List;

import com.landray.kmss.tib.sys.core.provider.process.provider.interfaces.ITibSysCoreInfo;
import com.landray.kmss.tib.sys.core.provider.vo.TibSysCateVo;
import com.landray.kmss.tib.sys.core.provider.vo.TibSysFuncVo;
import com.landray.kmss.util.ResourceUtil;

public class TibSysU8Info implements ITibSysCoreInfo{

	public List<TibSysCateVo> getCateInfo(String selectId, String pluginKey)
			throws Exception {
		return null;
	}

	public List<TibSysFuncVo> getFuncDataList(String cateId, String pluginKey)
			throws Exception {
		List<TibSysFuncVo> funcList=new ArrayList<TibSysFuncVo>();
		// 写凭证
		String fillCertificate = ResourceUtil.getString("tibSysU8.fillCertificate", "tib-sys-u8");
		funcList.add(new TibSysFuncVo("transportFuncId_u8", fillCertificate, pluginKey));
		return funcList;
	}

}
