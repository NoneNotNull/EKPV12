package com.landray.kmss.code.examine;

import java.io.File;

import com.landray.kmss.code.util.XMLReaderUtil;
import com.landray.kmss.util.StringUtil;
import com.sunbor.web.tag.enums.ColumnEnums;
import com.sunbor.web.tag.enums.Type;

public class EnumsExaminer implements IExaminer {

	public void examine(ExamineContext context) throws Exception {
		File file = context.getCurrentFile();
		if (!file.getName().equals("enums.xml"))
			return;
		ColumnEnums columnEnums = (ColumnEnums) XMLReaderUtil.getInstance(file,
				ColumnEnums.class);
		for (int i = 0; i < columnEnums.getTypes().size(); i++) {
			Type t = (Type) columnEnums.getTypes().get(i);
			String name = t.getName();
			if (StringUtil.isNotNull(name)) {
				if (!name.startsWith(context.getModulePrefix())) {
					context.addError("enums.xml配置中，枚举类型的命名必须以"
							+ context.getModulePrefix() + "开始：" + name);
				}
			}
		}
	}

}
