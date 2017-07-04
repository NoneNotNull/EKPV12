package com.landray.kmss.tib.sys.core.provider.actions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;

import com.landray.kmss.common.actions.ExtendAction;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.common.test.TimeCounter;
import com.landray.kmss.tib.sys.core.provider.forms.TibSysCoreIfaceImplForm;
import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreIfaceImpl;
import com.landray.kmss.tib.sys.core.provider.service.ITibSysCoreIfaceImplService;
import com.landray.kmss.util.CriteriaUtil;
import com.landray.kmss.util.CriteriaValue;
import com.landray.kmss.util.KmssMessages;
import com.landray.kmss.util.KmssReturnPage;
import com.landray.kmss.util.ResourceUtil;

/**
 * 接口实现 Action
 * 
 * @author 
 * @version 1.0 2013-08-08
 */
public class TibSysCoreIfaceImplIndexAction extends ExtendAction {
	protected ITibSysCoreIfaceImplService tibSysCoreIfaceImplService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if(tibSysCoreIfaceImplService == null)
			tibSysCoreIfaceImplService = (ITibSysCoreIfaceImplService)getBean("tibSysCoreIfaceImplService");
		return tibSysCoreIfaceImplService;
	}
	
	@Override
	protected void changeFindPageHQLInfo(HttpServletRequest request,
			HQLInfo hqlInfo) throws Exception {
		super.changeFindPageHQLInfo(request, hqlInfo);
		// 新UED查询
		CriteriaUtil.buildHql(new CriteriaValue(request), hqlInfo,
				TibSysCoreIfaceImpl.class);
	}

}

