package com.landray.kmss.tib.sap.mapping.service.spring;

import java.util.List;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.sys.xform.base.model.AbstractFormTemplate;
import com.landray.kmss.sys.xform.base.service.parse.JspGenerateConext;
import com.landray.kmss.sys.xform.base.service.parse.JspGenerator;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingFuncService;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

/**
 * 表单事件引入 jsp 片段
 * 
 * @author zhangtian
 * 
 */
public class TibSapFormEventJspGenerator implements JspGenerator {
	private String getJspHead(String fdTemplateId) throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setSelectBlock("tibCommonMappingFunc.fdId");
		hqlInfo.setWhereBlock("tibCommonMappingFunc.fdInvokeType=:fdInvokeType and " +
				"tibCommonMappingFunc.fdTemplateId=:fdTemplateId and " +
				"tibCommonMappingFunc.fdIntegrationType=:fdIntegrationType");
		hqlInfo.setParameter("fdInvokeType", 0);
		hqlInfo.setParameter("fdTemplateId", fdTemplateId);
		hqlInfo.setParameter("fdIntegrationType", "1");
		ITibCommonMappingFuncService tibCommonMappingFuncService = (ITibCommonMappingFuncService) 
				SpringBeanUtil.getBean("tibCommonMappingFuncService");
		List list = tibCommonMappingFuncService.findValue(hqlInfo);
		if (list != null && list.size() > 0) {
			return "<%@ include file=\"/tib/sap/mapping/sapEkpFormEventInclude.jsp\"%>\r\n";
		} else {
			return "";
		}
	}

	public void execute(JspGenerateConext context) throws Exception {
		AbstractFormTemplate template = (AbstractFormTemplate) context
				.getModel();
		String fdTemplateId = template.getFdModelId();
		String jspStr = getJspHead(fdTemplateId);
		if (StringUtil.isNotNull(jspStr)) {
			template.setFdDisplayJsp(template.getFdDisplayJsp() + jspStr);
		}
	}

}
