package com.landray.kmss.kms.knowledge.service;

import net.sf.json.JSONObject;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.forms.IExtendForm;
import com.landray.kmss.common.service.IBaseService;

public interface IKmsMultipleUploadService extends IBaseService{
	public String saveDoc(IExtendForm form, RequestContext requestContext, JSONObject jsonObject) throws Exception;
}
