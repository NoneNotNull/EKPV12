package com.landray.kmss.km.doc.actions;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;
import com.landray.kmss.common.service.IBaseService;
import com.landray.kmss.km.doc.forms.KmDocTemplateForm;
import com.landray.kmss.km.doc.service.IKmDocTemplateService;
import com.landray.kmss.km.doc.util.Constants;
import com.landray.kmss.sys.attachment.forms.AttachmentDetailsForm;
import com.landray.kmss.sys.simplecategory.actions.SysSimpleCategoryAction;
import com.landray.kmss.util.AutoHashMap;

/**
 * 创建日期 2007-Sep-18
 * 
 * @author 王晖
 */
public class KmDocTemplateAction extends SysSimpleCategoryAction {
	protected IKmDocTemplateService kmDocTemplateService;

	protected IBaseService getServiceImp(HttpServletRequest request) {
		if (kmDocTemplateService == null)
			kmDocTemplateService = (IKmDocTemplateService) getBean("kmDocTemplateService");
		return kmDocTemplateService;
	}

	protected String getParentProperty() {
		return "hbmParent";
	}

	protected ActionForm createNewForm(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		KmDocTemplateForm kmDocTemplateForm = (KmDocTemplateForm) super
				.createNewForm(mapping, form, request, response);
		kmDocTemplateForm.setDocExpire(Constants.DEF_EXPIRE);
		kmDocTemplateForm.setDocContent(null);
		kmDocTemplateForm.setDocPostsNames(null);
		kmDocTemplateForm.setDocPostsIds(null);
		kmDocTemplateForm.setDocKeywordNames(null);
		kmDocTemplateForm.setAttachmentForms(new AutoHashMap(
				AttachmentDetailsForm.class));

		return kmDocTemplateForm;
	}
	
}
