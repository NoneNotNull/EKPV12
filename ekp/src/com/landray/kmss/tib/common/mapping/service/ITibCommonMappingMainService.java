package com.landray.kmss.tib.common.mapping.service;

import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.tib.common.mapping.plugins.TibCommonPageInfo;
import com.sunbor.web.tag.Page;

/**
 * 主文档表业务对象接口
 * 
 * @author
 * @version 1.0 2011-10-16
 */
public interface ITibCommonMappingMainService extends IBaseService {

	Page listTemplate(String parentId, String templateName, TibCommonPageInfo pageInfo)
			throws Exception;
}
