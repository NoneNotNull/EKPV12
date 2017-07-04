/**
 * 
 */
package com.landray.kmss.tib.sap.mapping.plugins.controls.common;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.util.StringUtil;

/**
 * @author 邱建华
 * @version 1.0
 * @2013-3-9
 */
public class TibSapMappingShowDataBean 
		implements IXMLDataBean {

	public List getDataList(RequestContext requestInfo) throws Exception {
		// 在搜索栏中输入的关键字
		String keyword = requestInfo.getParameter("keyword");
		String showValueTitle = requestInfo.getParameter("showValueTitle");
		String showValueDesc = requestInfo.getParameter("showValueDesc");
		String showValueActual = requestInfo.getParameter("showValueActual");
		// 是否打开选择框，默认加载列表数据
		boolean isLoadData= "false".equals(requestInfo.getParameter("isLoadData"))?false:true;
		List<Object> rtnList = new ArrayList<Object>();
		String[] titleValue = showValueTitle.split("-split-");
		String[] descValue = showValueDesc.split("-split-");
		String[] actualValue = showValueActual.split("-split-");
		// 计算出传出表格映射个数（传出表格映射数是显示值的倍数）
		//System.out.println(showValueTitle+"--------showValueTitle");
		if (isLoadData || StringUtil.isNotNull(keyword)) {
			// 是否加入关键字
			if (StringUtil.isNotNull(keyword)) {
				for (int i = 0; i < titleValue.length; i++) {
					Map<String, String> map = new HashMap<String, String>();
					if (StringUtil.isNotNull(titleValue[i]) 
							&& StringUtil.isNotNull(descValue[i]) 
							&& StringUtil.isNotNull(actualValue[i])) {
						// 忽略大小写，关键字包含在内则出现
						if (titleValue[i].toUpperCase().contains(keyword.toUpperCase())) {
							map.put("id", actualValue[i]);
							map.put("name", titleValue[i]);
							map.put("info", descValue[i]);
						}
						
					} else {
						map.put("no", "no");
					}
					rtnList.add(map);
				}
			// 没有关键字
			} else {
				for (int i = 0; i < titleValue.length; i++) {
					Map<String, String> map = new HashMap<String, String>();
					if (StringUtil.isNotNull(titleValue[i]) 
							&& StringUtil.isNotNull(descValue[i])
							&& StringUtil.isNotNull(actualValue[i])) {
						map.put("id", actualValue[i]);
						map.put("name", titleValue[i]);
						map.put("info", descValue[i]);
					} else {
						map.put("no", "no");
					}
					rtnList.add(map);
				}
			}
			
		}
		return rtnList;
	}

}
