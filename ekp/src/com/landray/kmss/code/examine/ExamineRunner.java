package com.landray.kmss.code.examine;

import java.io.File;

import com.landray.kmss.sys.config.loader.ConfigLocationsUtil;
import com.sunbor.web.tag.enums.ColumnEnumsDigest;

public class ExamineRunner {
	private static boolean isInit = false;

	public static String PATH_SRC = "src";

	public static String PATH_WEB = "WebContent";

	private String modulePath;

	public ExamineRunner(String modulePath) {
		this.modulePath = modulePath;
	}

	private IExaminer[] examiner = { new ModelExaminer(), new FormExaminer(),
			new SpringExaminer(), new StrutsExaminer(), new EnumsExaminer(),
			new DesignExaminer() };

	public void run() throws Exception {
		init();
		ExamineContext context = new ExamineContext(modulePath);
		examinePath(context, new File(PATH_SRC + "/com/landray/kmss/"
				+ modulePath));
		examinePath(context, new File(PATH_WEB + "/" + modulePath));
		examinePath(context, new File(PATH_WEB + "/WEB-INF/KmssConfig/"
				+ modulePath));
		context.printError();
		context.printWarn();
	}

	private void examinePath(ExamineContext context, File dir) throws Exception {
		String[] files = dir.list();
		if (files == null)
			return;
		String filePath = dir.getAbsolutePath();
		for (int i = 0; i < files.length; i++) {
			String fileName = files[i];
			if (".".equals(fileName) || "..".equals(fileName)
					|| ".svn".equalsIgnoreCase(fileName))
				continue;
			File file = new File(filePath + "/" + fileName);
			if (file.isDirectory()) {
				examinePath(context, file);
			} else {
				context.setCurrentFile(file);
				Class c = null;
				if (fileName.endsWith(".java")) {
					String className = filePath + "/" + fileName;
					className = className.replace('/', '.');
					className = className.replace('\\', '.');
					int index = className.lastIndexOf("com.landray.kmss");
					if (index > -1) {
						className = className.substring(index);
						className = className.substring(0,
								className.length() - 5);
						c = Class.forName(className);
					}
				}
				context.setCurrentClass(c);
				for (int j = 0; j < examiner.length; j++) {
					examiner[j].examine(context);
					context.reset();
				}
			}
		}
	}

	private void init() {
		if (isInit)
			return;
		ColumnEnumsDigest.columnEnumsFiles = ConfigLocationsUtil
				.getConfigLocations(PATH_WEB, "enums.xml", PATH_WEB);
		isInit = true;
	}

	public static void main(String[] args) throws Exception {
		new ExamineRunner("km/missive").run();
		// new ExamineRunner("sys/category").run();
	}
}
