package com.landray.kmss.sys.news.service;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.common.service.IBaseCoreInnerService;

/**
 * 创建日期 2009-八月-02
 * 
 * @author 周超 发布机制主文档业务对象接口
 */
public interface ISysNewsPublishMainService extends IBaseCoreInnerService {
	public void addManuaPublish(IExtendForm mainForm, RequestContext request)
			throws Exception;

	public void AutoPublish(IBaseModel mainModel) throws Exception;

}
