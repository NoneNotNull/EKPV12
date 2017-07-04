package com.landray.kmss.code.examine;

import java.io.File;
import java.util.Arrays;

import com.landray.kmss.sys.config.design.SysCfgModule;
import com.landray.kmss.sys.config.design.SysConfigs;
import com.landray.kmss.util.StringUtil;

public class DesignExaminer implements IExaminer {

	public void examine(ExamineContext context) throws Exception {
		File file = context.getCurrentFile();
		if (!file.getName().equals("design.xml"))
			return;
		SysConfigs configs = SysConfigs.getInstance();
		SysCfgModule module = configs.getModule("/" + context.getModulePath()
				+ "/");
		if (module == null) {
			context.addError("design.xml中没有配置模块信息");
			return;
		}
		if (StringUtil.isNotNull(module.getRoles())) {
			String rolePrefix = "ROLE_"
					+ context.getModulePrefix().toUpperCase();
			String[] roleArr = module.getRoles().trim().split("\\s*[;]\\s*");
			for (int i = 0; i < roleArr.length; i++) {
				if (!roleArr[i].startsWith(rolePrefix)) {
					context.addError("design.xml配置中，角色的命名必须以" + rolePrefix
							+ "开始：" + roleArr[i]);
				}
			}
			if (!Arrays.asList(roleArr).contains(rolePrefix + "_DEFAULT")) {
				context.addError("design.xml配置中，必须定义默认角色：" + rolePrefix
						+ "_DEFAULT");
			}
		}
		if (StringUtil.isNull(module.getDefaultValidator())) {
			context.addError("design.xml配置中，必须配置module的：defaultValidator属性");
		}

		if (configs.getHomePages().get(context.getModulePath()) == null) {
			context.addError("design.xml配置中，必须主页连接信息");
		}

	}

}
