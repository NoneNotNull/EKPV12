package com.landray.kmss.tib.sys.core.provider.process.provider.interfaces;

import java.util.List;

import com.landray.kmss.tib.sys.core.provider.vo.TibSysCateVo;
import com.landray.kmss.tib.sys.core.provider.vo.TibSysFuncVo;

/**
 * 获取服务信息接口
 * @author fat_tian
 *
 */
public interface ITibSysCoreInfo {
	
	public List<TibSysCateVo> getCateInfo(String selectId,String pluginKey)  throws Exception;
	
	public List<TibSysFuncVo> getFuncDataList(String cateId,String pluginKey) throws Exception;

}
