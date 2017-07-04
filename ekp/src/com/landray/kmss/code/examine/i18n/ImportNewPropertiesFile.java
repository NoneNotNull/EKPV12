package com.landray.kmss.code.examine.i18n;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;

import com.landray.kmss.util.StringUtil;

/**
 * 创建日期 2009-九月-02
 * 
 * @author 聂凡、缪贵荣
 * @将新翻译的英文资源文件导入并更新到项目
 */
public class ImportNewPropertiesFile {

	// ===========该类执行前需修改处开始===========
	// 请修改项目名称
	private static final String PRO_NAME = "EKP-last";
	// 请修改目标文件名称
	private static final String FOLDER_NAME = "ImCompare-last2";
	// 请修改需要导入的文件名
	private static final String FILE_NAME = "ApplicationResources_en_US.properties";

	// ===========该类执行前需要修改处结束===========

	public static void main(String[] args) throws Exception {
		ImportNewPropertiesFileMain();
		System.out.println("执行导入完毕");
	}

	// 导入的源路径
	private static final String ROOT_PATH = "D:\\" + FOLDER_NAME + "\\";
	// 目标路径
	private static final String TARGET_PATH = "D:\\java\\workspace\\"
			+ PRO_NAME + "\\src\\com\\landray\\kmss\\";

	// 获取rootDir下所有文件名为fileName的绝对路径(包括文件名)，结果存放在sourcesDirs
	public static void getAbsolutePaths(String rootDir, String fileName,
			List<String> sourcesDirs) {
		File sourceFile;
		String dirTmp;
		// 获取源文件夹当前下的文件或目录
		File[] files = (new File(rootDir)).listFiles();
		for (File file : files) {
			if (file.getName().equals(".svn")) {
				continue;
			}
			if (file.isFile()) {
				sourceFile = file;
				if (fileName.equals(sourceFile.getName())) {
					sourcesDirs.add(sourceFile.toString());
				}
			}
			if (file.isDirectory()) {
				dirTmp = rootDir + file.getName() + "\\";
				getAbsolutePaths(dirTmp, fileName, sourcesDirs);
			}
		}
	}

	// 获取相对路径
	public static List<String> getRelativePath(String rootDir, String fileName) {
		List<String> sourceDirs = new ArrayList<String>();
		getAbsolutePaths(rootDir, fileName, sourceDirs);
		List<String> trimDirs = new ArrayList<String>();
		for (String sourceDir : sourceDirs) {
			sourceDir = sourceDir.replace(rootDir, "");
			trimDirs.add(sourceDir);
		}
		return trimDirs;
	}

	// 获取资源文件
	public static PropertiesConfiguration getProperties(String fileDir)
			throws IOException, ConfigurationException {
		FileInputStream fileInputStream = new FileInputStream(fileDir);
		PropertiesConfiguration.setDefaultListDelimiter('\u22b1');
		PropertiesConfiguration propertiesConfiguration = new PropertiesConfiguration();
		propertiesConfiguration.load(fileInputStream);
		fileInputStream.close();
		return propertiesConfiguration;
	}

	// 将文件rootName写到targetName（相当于复制文件）
	public static void writePropertiesFile(String rootName, String targetName)
			throws IOException, ConfigurationException {
		PropertiesConfiguration newProperties = getProperties(rootName);
		File file = new File(targetName);
		FileOutputStream outPutStream = new FileOutputStream(file);
		newProperties.save(outPutStream);
		outPutStream.close();
	}

	// 对于已经存在的资源文件，进行比较，更新。 如果内容多出来则在后面追加
	private static void ImportNewPropertiesFileMain()
			throws ConfigurationException, IOException {
		List<String> listHass = compareFileName();
		for (String listHas : listHass) {
			System.out.println("开始更新资源文件：" + TARGET_PATH + listHas);
			PropertiesConfiguration newProperties = getProperties(ROOT_PATH
					+ listHas);
			PropertiesConfiguration oldProperties = getProperties(TARGET_PATH
					+ listHas);
			PropertiesConfiguration properties = comparePropertiesFileValue(
					newProperties, oldProperties);// 比较两资源文件
			File file = new File(TARGET_PATH + listHas);
			FileOutputStream outPutStream = new FileOutputStream(file);
			properties.save(outPutStream);
			outPutStream.close();
			System.out.println("完成更新资源文件：" + TARGET_PATH + listHas);
		}
	}

	// 比较两文件，存在则更新，不存在则新增
	private static List<String> compareFileName()
			throws ConfigurationException, IOException {
		// 不存在资源文件
		List<String> listHasnts = new ArrayList<String>();
		// 存在资源文件
		List<String> listHass = new ArrayList<String>();
		// 获取相对路径
		List<String> oldSourceFiles = getRelativePath(TARGET_PATH, FILE_NAME);
		List<String> newSourceFiles = getRelativePath(ROOT_PATH, FILE_NAME);
		// 两文件相对路径（包括文件名）进行比较
		for (String newSourceFile : newSourceFiles) {
			if (oldSourceFiles.contains(newSourceFile)) {
				listHass.add(newSourceFile);
			} else {
				listHasnts.add(newSourceFile);
			}
		}
		for (String listHasnt : listHasnts) {
			// 新建资源文件并写入内容
			writePropertiesFile(ROOT_PATH + listHasnt, TARGET_PATH + listHasnt);
			System.out.println("新增资源文件:" + TARGET_PATH + listHasnt);
		}
		for (String listHas : listHass) {
			System.out.println("需要更新的资源文件:" + TARGET_PATH + listHas);
		}
		return listHass;
	}

	// 比较内容
	private static PropertiesConfiguration comparePropertiesFileValue(
			PropertiesConfiguration newProperties,
			PropertiesConfiguration oldProperties) {
		// 设置分隔符（因为默认是逗号）
		PropertiesConfiguration.setDefaultListDelimiter('\u22b1');
		PropertiesConfiguration properties = new PropertiesConfiguration();
		for (Iterator<?> keys = oldProperties.getKeys(); keys.hasNext();) {
			String oldKeyName = (String) keys.next();
			String content = getLastValue(newProperties, oldKeyName);
			if (StringUtil.isNull(content)) {
				content = getLastValue(oldProperties, oldKeyName);
				System.out.println("原有的元素：" + oldKeyName + "=" + content);
			} else {
				System.out.println("更新的元素：" + oldKeyName + "=" + content);
			}
			properties.setProperty(oldKeyName, content);
		}
		for (Iterator<?> keyss = newProperties.getKeys(); keyss.hasNext();) {
			String newKeyNames = (String) keyss.next();
			String newContents = getLastValue(newProperties, newKeyNames);
			String oldContents = getLastValue(oldProperties, newKeyNames);
			if (StringUtil.isNotNull(newContents)
					&& StringUtil.isNull(oldContents)) {
				properties.setProperty(newKeyNames, newContents);
				System.out.println("新增的元素：" + newKeyNames + "=" + newContents);
			}
		}
		return properties;
	}

	// 如果有相同的key，则取最后一个key的value
	public static String getLastValue(PropertiesConfiguration pc, String key) {
		String[] values = pc.getStringArray(key);
		if (values != null && values.length > 0) {
			return values[values.length - 1];
		}
		return null;
	}
}
