package com.landray.kmss.tib.sys.soap.connector.util.header.licence;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.landray.kmss.tib.sys.soap.connector.forms.MapVo;

public interface ITibSysSoapParamsParser {
	
	/**
	 * 收集request数据
	 * @param request
	 * @return
	 */
	public List<MapVo> paramsParse(HttpServletRequest request); 
 
}
