package com.landray.kmss.code.examine;

import java.io.File;

import com.landray.kmss.code.struts.FormBean;
import com.landray.kmss.code.struts.StrutsConfig;
import com.landray.kmss.code.struts.StrutsValidation;
import com.landray.kmss.code.struts.ValidateForm;
import com.landray.kmss.util.StringUtil;

public class StrutsExaminer implements IExaminer {

	public void examine(ExamineContext context) throws Exception {
		File file = context.getCurrentFile();
		if (file.getName().equals("struts.xml")) {
			StrutsConfig config = StrutsConfig.getInstance(file);
			for (int i = 0; i < config.getFormBeans().size(); i++) {
				FormBean bean = config.getFormBeans().get(i);
				String name = bean.getName();
				if (StringUtil.isNotNull(name)) {
					if (!name.startsWith(context.getModulePrefix())) {
						context.addError("struts.xml配置中，form-bean的命名必须以"
								+ context.getModulePrefix() + "开始：" + name);
					}
				}
			}
			if (config.getMessageResources() == null) {
				context.addError("struts.xml配置中，没有配置资源文件（message-resources）");
			} else {
				String[] strArr = context.getModulePath().split("/");
				String key = strArr[0] + "-" + strArr[1];
				if (!key.equals(config.getMessageResources().getKey())) {
					context
							.addError("struts.xml配置中，资源文件（message-resources）的key值应该是："
									+ key);
				}
			}
			return;
		}

		if (file.getName().equals("validation.xml")) {
			StrutsValidation validations = StrutsValidation.getInstance(file);
			for (int i = 0; i < validations.getValidateForms().size(); i++) {
				ValidateForm form = validations.getValidateForms().get(i);
				String name = form.getName();
				if (StringUtil.isNotNull(name)) {
					if (!name.startsWith(context.getModulePrefix())) {
						context.addError("validation.xml配置中，form的命名必须以"
								+ context.getModulePrefix() + "开始：" + name);
					}
				}
			}
		}

	}

}
