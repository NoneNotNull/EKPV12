package com.landray.kmss.code.examine.i18n;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;

/**
 * 创建日期 2009-九月-02
 * 
 * @author 聂凡、缪贵荣
 * @将未翻译的资源文件导出
 */
public class ExportNotTransMsg {

	// 请修改要比较的工程的名称
	private static String projectName = "ekp8";

	// 工程中资源文件的路径
	private static String projectPath = "D:\\java\\workspace\\" + projectName
			+ "\\src\\com\\landray\\kmss\\";

	private static String exportFolderName = "NotTranslatedProperties";

	// 中文资源文件
	private static String zhCn = "ApplicationResources.properties";

	// 英文资源文件
	private static String enUs = "ApplicationResources_en_US.properties";

	// 英文资源文件list
	private static List<File> enList = new ArrayList<File>();

	// 中文资源文件list
	private static List<File> zhList = new ArrayList<File>();

	// Unicode转换为utf-8批处理文件
	private static String batFileName = "D:\\ConvertEncodeing" + ".bat";;

	public static void main(String args[]) throws Exception {

		// 在导出目录中创建项目中不存在的英文资源文件，并列出存在资源文件的中文内容
		List<String> hasEnPropertiesList = createNotExistedProperties();

		// 写入的命令文件
		File fileBat = new File(batFileName);

		// 如果文件存在则删除 否则追加会重复
		if (fileBat.exists()) {
			fileBat.delete();
		}
		FileWriter writerBat = new FileWriter(fileBat, true);
		BufferedWriter bwBat = new BufferedWriter(writerBat);

		// 比较中英文资源文件内容，将中文中比英文多出的部分按目录导出
		for (int i = 0; i < hasEnPropertiesList.size(); i++) {
			PropertiesConfiguration newMsgProperty = exportNewMsg(hasEnPropertiesList
					.get(i));
			if (newMsgProperty.getKeys().hasNext()) {
				File newMsgfile = createDir(hasEnPropertiesList.get(i).replace(
						zhCn, enUs), enUs);
				FileOutputStream outPutStream = new FileOutputStream(newMsgfile);
				try {
					newMsgProperty.save(outPutStream);
				} catch (ConfigurationException e) {
					e.printStackTrace();
				}
				outPutStream.close();
				String root = hasEnPropertiesList.get(i).replace(projectPath,
						"");
				root = "D:\\" + exportFolderName + "\\"
						+ root.replace(zhCn, enUs);
				String content = "native2ascii -reverse " + root + " " + root;
				bwBat.write(content);
				bwBat.newLine();
				bwBat.flush();
			}

		}
		bwBat.close();

		// 编码格式转换
		Runtime r = Runtime.getRuntime();
		r.exec("cmd.exe /c " + "start " + batFileName);
		System.out.println("未翻译的资源文件比较导出完毕！");
	}

	public static List<File> getFileDirectiory(String sourceDir,
			List<File> listSource, String Language) {

		// 获取源文件夹当前下的文件或目录
		File[] file = (new File(sourceDir)).listFiles();
		for (int i = 0; i < file.length; i++) {

			if (file[i].isFile()) {

				// 源文件
				File sourceFile = file[i];
				if (sourceFile.getName().equals(Language)) {
					if (!listSource.contains(sourceFile)) {
						listSource.add(sourceFile);
					}

				}
			}
			if (file[i].isDirectory()) {
				// 准备复制的源文件夹
				String dir1 = sourceDir + "/" + file[i].getName();
				// 准备复制的目标文件夹
				getFileDirectiory(dir1, listSource, Language);
			}
		}

		return listSource;
	}

	// 获取资源文件
	public static PropertiesConfiguration getProperties(String fileName)
			throws IOException {
		FileInputStream is = new FileInputStream(fileName);
		PropertiesConfiguration newProperties = new PropertiesConfiguration();
		try {
			newProperties.load(is);
		} catch (ConfigurationException e) {
			e.printStackTrace();
		}
		is.close();
		return newProperties;
	}

	// 创建导出目录
	public static File createDir(String exportPath, String propertyLang)
			throws IOException {
		exportPath = exportPath.replace(projectPath, "");
		exportPath = "D:\\" + exportFolderName + "\\"
				+ exportPath.replace(propertyLang, "");
		File file = new File(exportPath);

		// 创建目录
		if (!file.exists()) {
			file.mkdirs();
		}

		// 创建空资源文件
		File property = new File(exportPath + "\\" + propertyLang);
		property.createNewFile();
		return property;
	}

	// 获取所有的properties文件
	public static List<File> getFileProperty(String urlSource,
			List<File> propertiesList, String language) {
		File[] file = (new File(urlSource)).listFiles();
		for (int i = 0; i < file.length; i++) {
			if (file[i].isDirectory()) {
				String sourceDir = urlSource + "/" + File.separator
						+ file[i].getName();

				if (!file[i].getName().equals(".svn")) {
					propertiesList = getFileDirectiory(sourceDir,
							propertiesList, language);
				}
			}
		}
		return propertiesList;
	}

	// 找出没还有英文资源文件的模块，并在相应的导出模块中创建出来
	public static List<String> createNotExistedProperties() throws IOException {

		List<File> zhPropertiesList = getFileProperty(projectPath, zhList, zhCn);
		List<File> enPropertiesList = getFileProperty(projectPath, enList, enUs);

		List<String> hasEnPropertiesList = new ArrayList<String>();
		for (int i = 0; i < zhPropertiesList.size(); i++) {
			String zhProperty = zhPropertiesList.get(i).toString();

			String enProperty = zhProperty.replace(zhCn, enUs);
			File enFile = new File(enProperty);
			if (!enPropertiesList.contains(enFile)) {
				System.out.println("No English property for " + zhProperty);

				// 在导出目录中创建新增的文件夹
				File file = createDir(enProperty, enUs);

				// 将中文资源文件中的内容copy到新建的英文资源文件中
				copyZh2En(file, zhProperty);
			}
			if (enPropertiesList.contains(enFile)) {
				hasEnPropertiesList.add(zhProperty.replace("zhCn", ""));
			}
		}

		return hasEnPropertiesList;
	}

	// 将中文资源文件中的内容copy到新建的英文资源文件中
	@SuppressWarnings("unchecked")
	public static void copyZh2En(File file, String fileName) throws IOException {
		BufferedWriter writer = new BufferedWriter(new FileWriter(file));
		PropertiesConfiguration zhProperty = getProperties(fileName);

		for (Iterator<Object> keys = zhProperty.getKeys(); keys.hasNext();) {
			String key = (String) keys.next();
			String value = "";
			if (zhProperty.getProperty(key) instanceof String) {
				value = zhProperty.getProperty(key).toString();
			}
			if (zhProperty.getProperty(key) instanceof ArrayList) {
				List<String> StrList = (ArrayList<String>) zhProperty
						.getProperty(key);
				for (String str : StrList) {
					value += str;
				}
			}
			writer.write(key + "=" + new String(value.getBytes(), "UTF-8"));
			writer.write("\r\n");
		}
		writer.close();
	}

	@SuppressWarnings("unchecked")
	public static PropertiesConfiguration exportNewMsg(String projectPath)
			throws Exception {

		PropertiesConfiguration newMsgProperty = new PropertiesConfiguration();

		PropertiesConfiguration enProperty = getProperties(projectPath.replace(
				zhCn, "")
				+ enUs);

		PropertiesConfiguration zhProperty = getProperties(projectPath);

		for (Iterator<Object> keys = zhProperty.getKeys(); keys.hasNext();) {
			String key = (String) keys.next();
			String value = "";
			if (zhProperty.getProperty(key) != null
					&& enProperty.getProperty(key) == null) {
				if (zhProperty.getProperty(key) instanceof String) {
					value = (String) zhProperty.getProperty(key);
				}
				if (zhProperty.getProperty(key) instanceof ArrayList) {
					List<String> valueList = (ArrayList<String>) zhProperty
							.getProperty(key);
					for (String str : valueList) {
						value += str;
					}
				}
				newMsgProperty.setProperty(key, value);
			}
		}
		return newMsgProperty;
	}

}
