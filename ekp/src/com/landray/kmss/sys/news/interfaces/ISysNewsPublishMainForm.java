package com.landray.kmss.sys.news.interfaces;

import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.sys.news.forms.SysNewsPublishMainForm;

/**
 * 发布机制对应Form模型需实现的接口
 * 
 * @author 周超
 * 
 */
public interface ISysNewsPublishMainForm extends IExtendForm {
	/**
	 * 获取页面中的配置信息
	 * 
	 * @return
	 */
	public SysNewsPublishMainForm getSysNewsPublishMainForm();
}
