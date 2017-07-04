package com.landray.kmss.tib.common.mapping.plugins.taglib;

import java.util.List;
import java.util.Map;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.tagext.BodyTagSupport;

import org.apache.commons.lang.ArrayUtils;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.tib.common.mapping.plugins.IBaseTibCommonMappingIntegration;
import com.landray.kmss.tib.common.mapping.plugins.TibCommonMappingIntegrationPlugins;
import com.landray.kmss.tib.common.mapping.service.ITibCommonMappingFuncService;
import com.landray.kmss.util.SpringBeanUtil;

public class TibCommonShowTempFunc extends BodyTagSupport {
	private String fdTemplateId;

	private String fdType;

	public String getFdTemplateId() {
		return fdTemplateId;
	}

	public void setFdTemplateId(String fdTemplateId) {
		this.fdTemplateId = fdTemplateId;
	}

	public int doStartTag() throws JspException {
		try {
			JspWriter out = pageContext.getOut();
			String fdTemplateId = getFdTemplateId();
			String[] fdTypes = fdType.split(";");
			ApplicationContext ctx = WebApplicationContextUtils
					.getRequiredWebApplicationContext(pageContext
							.getServletContext());
			ITibCommonMappingFuncService tibCommonMappingFuncService = (ITibCommonMappingFuncService) ctx
					.getBean("tibCommonMappingFuncService");
			// 通过加载扩展点获取对应扩展点模块信息
			StringBuffer buf = new StringBuffer();
			List<Map<String, String>> configs = TibCommonMappingIntegrationPlugins.getConfigs();
			for (Map<String, String> config : configs) {
				String pluginIntegrationType = config
						.get(TibCommonMappingIntegrationPlugins.fdIntegrationType);
				if (!ArrayUtils.contains(fdTypes, pluginIntegrationType)) {
					// 集成类型不存在或没在注册模块勾上
					continue;
				}
				// 获取扩展点配置bean
				String beanName = config
						.get(TibCommonMappingIntegrationPlugins.ekpIntegrationBean);
				Object serviceBean = SpringBeanUtil.getBean(beanName);
				// 获取spring 的bean 调用拆解出来的代码
				if (serviceBean instanceof IBaseTibCommonMappingIntegration) {
					HQLInfo hqlInfo = ((IBaseTibCommonMappingIntegration) serviceBean)
							.findSettingNameHQLByTempId(fdTemplateId,config.get(TibCommonMappingIntegrationPlugins.fdIntegrationType));
					List<Object> funcNameList = (List<Object>) tibCommonMappingFuncService
							.findValue(hqlInfo);
					mergeString(buf, "", funcNameList, config
							.get(TibCommonMappingIntegrationPlugins.integrationKey));
				}
			}
			out.write(buf.toString());
		} catch (Exception e) {
			throw new JspException(e);
		}
		return SKIP_BODY;
	}

	public StringBuffer mergeString(StringBuffer buf, String split,
			List<Object> funcNameList, String extend) {
		if (funcNameList.isEmpty()) {
			return buf;
		}
		int index = 1;
		boolean first=true;
		for (Object s : funcNameList) {
			Object[] str = (Object[]) s;
			if (!first) {
				buf.append(split);
			} else {
				first=false;
			}
			String displayName = displayName((Integer) str[1]);
			String str_f = str[0] != null ? str[0].toString() : "";
			buf.append(str_f + "[" + extend + "," + displayName + "]");
			if (index % 1 == 0) {
				buf.append("<br>");
				first = true;
			}
			index++;
		}
		return buf;
	}

	private String displayName(Integer invokeType) {
		switch (invokeType) {
		case 0:
			return "表单保存";
		case 2:
			return "表单删除";
		case 3:
			return "表单机器人";
		case 4:
			return "表单事件";
		case 5:
			return "表单控件";
		case 6:
			return "流程驳回";
		default:
			return "未知";
		}
	}

	public String getFdType() {
		return fdType;
	}

	public void setFdType(String fdType) {
		this.fdType = fdType;
	}
}
