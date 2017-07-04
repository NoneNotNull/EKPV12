package com.landray.kmss.code.examine;

import java.io.File;

import com.landray.kmss.code.spring.SpringBean;
import com.landray.kmss.code.spring.SpringBeans;
import com.landray.kmss.util.StringUtil;

public class SpringExaminer implements IExaminer {

	public void examine(ExamineContext context) throws Exception {
		File file = context.getCurrentFile();
		if (!file.getName().equals("spring.xml"))
			return;
		SpringBeans beans = SpringBeans.getInstance(file);
		for (int i = 0; i < beans.getBeans().size(); i++) {
			SpringBean bean = beans.getBeans().get(i);
			String id = bean.getId();
			if (StringUtil.isNotNull(id)) {
				if (!id.startsWith(context.getModulePrefix())) {
					context.addError("spring.xml配置中，bean的命名必须以"
							+ context.getModulePrefix() + "开始：" + id);
				}
			}
		}
	}

}
