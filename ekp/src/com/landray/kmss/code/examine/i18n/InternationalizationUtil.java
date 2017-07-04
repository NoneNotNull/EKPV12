package com.landray.kmss.code.examine.i18n;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;

import com.landray.kmss.util.StringUtil;

/**
 * 创建日期 2011-九月-01
 * 
 * @author 庄为亮
 * @国际化资源文件导入导出工具（Excel版）
 * 
 */
public class InternationalizationUtil {

	// 中文资源文件
	private static final String zhCn = "ApplicationResources.properties";

	// 英文资源文件
	private static final String enUs = "ApplicationResources_en_US.properties";

	// 导出excel时，待翻译列标题显示的文字。如：英文、法文、德文等等（如果以后需要导出法文、德文未翻译资源文件时需要修改此项）
	private static String translationTitle = "英文";

	/**
	 * 将还没翻译或中文资源文件属性值已有变化的部分导出到excel
	 * 
	 * @param exportPath
	 *            导出目录路径（导出的excel文件将在该路径下找到）
	 * @param projectPath
	 *            需要导出资源文件的工程资源文件路径
	 * @param propertyName
	 *            需要导出未翻译资源文件的名称（导出时该类文件将会与中文资源文件比较，并将未翻译的部分导出）
	 * @throws Exception
	 */
	public static void export(String exportPath, String projectPath,
			String propertyName) throws Exception {
		List<File> zhPropertiesList = new ArrayList<File>();
		List<File> enPropertiesList = new ArrayList<File>();
		// 获取工程中所有中文资源文件列表
		zhPropertiesList = getFileProperty(projectPath, zhPropertiesList, zhCn);
		// 获取工程中所有英文资源文件列表
		enPropertiesList = getFileProperty(projectPath, enPropertiesList,
				propertyName);
		// 创建一个excel工作簿，将未翻译和有改变内容写入到excel中
		HSSFWorkbook workbook = buildWorkBook(zhPropertiesList,
				enPropertiesList, projectPath, propertyName);
		FileOutputStream out = null;
		try {
			out = new FileOutputStream(exportPath);
			workbook.write(out);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (out != null) {
				out.flush();
				out.close();
			}
		}
		System.out.println("未翻译的资源文件比较导出完毕！");
	}

	/**
	 * 将已经翻译好了的excel文件导入到工程
	 * 
	 * @param excelFilePath
	 *            选择的excel文件路径
	 * @param projectPath
	 *            需要导入资源文件的工程资源文件路径
	 * @param propertyName
	 *            需要导入资源文件的名称
	 * @throws IOException
	 */
	public static void importExcel(String excelFilePath, String projectPath,
			String propertyName) throws IOException {
		// 待翻译资源文件map，从excel导入到工程时，将用于缓存需要追加或更新的资源文件及内容
		Map<String, PropertiesConfiguration> propertiesMap = new HashMap<String, PropertiesConfiguration>();
		// 备份资源文件map，从excel导入到工程时，将用于缓存需要重新备份的资源文件及内容
		Map<String, PropertiesConfiguration> bakPropertiesMap = new HashMap<String, PropertiesConfiguration>();
		HSSFWorkbook wb = getWorkbook(excelFilePath);
		HSSFSheet sheet = wb.getSheetAt(0);
		PropertiesConfiguration enProperty = null;
		PropertiesConfiguration bakProperty = null;
		String propertyFilePath = null;
		for (int i = 1; i <= sheet.getLastRowNum(); i++) {
			HSSFCell cell1 = sheet.getRow(i).getCell(0);
			String modulePath = "";// 模块路径
			if (cell1 != null) {
				modulePath = cell1.getStringCellValue();
			}
			HSSFCell cell2 = sheet.getRow(i).getCell(1);
			String fdKey = "";// key
			if (cell2 != null) {
				fdKey = cell2.getStringCellValue();
			}
			HSSFCell cell3 = sheet.getRow(i).getCell(2);
			String zhValue = "";// 中文内容
			if (cell3 != null) {
				zhValue = cell3.getStringCellValue();
			}
			HSSFCell cell4 = sheet.getRow(i).getCell(3);
			String translation = "";// 翻译内容
			if (cell4 != null) {
				translation = cell4.getStringCellValue();
			}
			// 如果还没翻译，将不做导入
			if (StringUtil.isNull(translation))
				continue;
			// 获取工程中英文property文件
			enProperty = propertiesMap.get(modulePath);
			if (enProperty == null) {
				propertyFilePath = projectPath + modulePath + propertyName;
				File enFile = new File(propertyFilePath);
				if (enFile.exists())
					enProperty = getProperties(propertyFilePath);
				else
					enProperty = new PropertiesConfiguration();
				propertiesMap.put(modulePath, enProperty);
			}
			// 如果已经有该值就更新，没有就添加
			if (getLastValue(enProperty, fdKey) != null) {
				enProperty.setProperty(fdKey, translation);
			} else {
				enProperty.addProperty(fdKey, translation);
			}

			// 中文内容不为空时，重新备份
			if (StringUtil.isNotNull(zhValue)) {
				// 获取英文备份文件
				bakProperty = bakPropertiesMap.get(modulePath);
				if (bakProperty == null) {
					propertyFilePath = projectPath + modulePath
							+ getBakPropName(propertyName);
					File bakFile = new File(propertyFilePath);
					if (bakFile.exists())
						bakProperty = getProperties(propertyFilePath);
					else {
						// 工程中备份文件为空时，将整个中文文件备份
						File zhFile = new File(projectPath + modulePath + zhCn);
						if (bakFile.exists()) {
							bakProperty = getProperties(zhFile.toString());
						} else {
							bakProperty = new PropertiesConfiguration();
						}
					}
					bakPropertiesMap.put(modulePath, bakProperty);
				}
				// 如果已经有该值就更新，没有就添加
				if (getLastValue(bakProperty, fdKey) != null) {
					bakProperty.setProperty(fdKey, zhValue);
				} else {
					bakProperty.addProperty(fdKey, zhValue);
				}
			}

		}
		// 将已经翻译的资源文件回写到工程中
		writeProps2Project(propertiesMap, projectPath, propertyName);
		System.out.println("已翻译内容导入完毕！");
		// 将需要备份的资源备份文件回写到工程中
		writeProps2Project(bakPropertiesMap, projectPath,
				getBakPropName(propertyName));
		System.out.println("资源文件备份完毕！");
	}

	/**
	 * 根据资源文件名称返回备份资源文件名称
	 * 
	 * @param propertyName
	 * @return
	 */
	public static String getBakPropName(String propertyName) {
		if (propertyName == null)
			return propertyName;
		return propertyName.replace(".properties", ".bak.properties");
	}

	/**
	 * 备份工程中所有资源文件
	 * 
	 * @param projectPath
	 *            需要备份资源文件的工程资源文件路径
	 * @param beforeName
	 *            备份前（需要备份）的资源文件名称
	 * @param afterName
	 *            备份后的资源文件路径
	 * @param afterName
	 *            备份后的工程资源文件路径（备份后的文件可以在这里找到，为空时备份到跟原资源文件相同目录）
	 */
	public static void backupAllProperties(String projectPath,
			String beforeName, String afterName, String toProjectPath) {
		List<File> propertiesList = new ArrayList<File>();
		// 获取工程中所有中文资源文件列表
		propertiesList = getFileProperty(projectPath, propertiesList,
				beforeName);
		String toPath = null;
		int i = 0;
		for (File cnFile : propertiesList) {
			toPath = cnFile.toString().replace(beforeName, afterName);
			if (StringUtil.isNotNull(toProjectPath))
				toPath = toPath.replace(projectPath, toProjectPath);
			backupProperty(cnFile.toString(), toPath);
			i++;
			System.out.println("成功备份：" + cnFile.toString());
		}
		System.out.println("总共备份：" + i + "个文件！");
	}

	/**
	 * 根据资源文件类型名称，删除工程中所有该类型名称的资源文件 <br>
	 * 如：工程中所有英文备份资源文件时：fileName = "ApplicationResources_en_US.bak.properties"
	 */
	public static void deleteAllProperties(String projectPath,
			String propertyName) {
		List<File> propertiesList = new ArrayList<File>();
		// 获取工程中所有备份资源文件列表
		propertiesList = getFileProperty(projectPath, propertiesList,
				propertyName);
		int i = 0;
		for (File file : propertiesList) {
			if (file.exists()) {
				file.delete();
				i++;
				System.out.println("成功删除：" + file.toString());
			}

		}
		System.out.println("总共删除：" + i + "个文件！");
	}

	/**
	 * 将一个项目中的资源文件合并到另外一个项目中
	 * 
	 * @param fromProjectPath
	 *            合并来源项目路径
	 * @param toProjectPath
	 *            合并目标项目路径
	 * @param fromPropName
	 *            合并来源资源文件名称
	 * @param toPropName
	 *            合并目标资源文件名称
	 * @param isMergeExistingModule
	 *            是否只合并目标项目中已有的模块（true：只合并目标项目中已有的模块；false：不管目标项目中是否有该模块，都做合并）
	 * 
	 * @throws IOException
	 */
	public static void merge(String fromProjectPath, String toProjectPath,
			String fromPropName, String toPropName,
			boolean isMergeExistingModule) throws IOException {
		Map<String, PropertiesConfiguration> propertiesMap = new HashMap<String, PropertiesConfiguration>();
		// 获取来源项目中需要合并的所有资源文件
		List<File> fromPropList = new ArrayList<File>();
		fromPropList = getFileProperty(fromProjectPath, fromPropList,
				fromPropName);
		PropertiesConfiguration toProperty = null;
		int i = 0;
		for (File propFile : fromPropList) {
			String key = propFile.toString().replace(fromProjectPath, "")
					.replace(fromPropName, "");
			File moduleDirFile = new File(toProjectPath + key);//
			// 如果只合并目标文件中已有的模块，并且该模块不存在于目标项目中时，跳过合并
			if (isMergeExistingModule && !moduleDirFile.exists()) {
				System.out.println("找不到模块：" + toProjectPath + key + " 不做合并！");
				continue;
			}
			toProperty = propertiesMap.get(key);
			if (toProperty == null) {
				String toPropPath = toProjectPath + key + toPropName;
				File toFile = new File(toPropPath);
				if (toFile.exists())
					toProperty = getProperties(toPropPath);
				else
					toProperty = new PropertiesConfiguration();
				propertiesMap.put(key, toProperty);
			}
			PropertiesConfiguration fromProperty = getProperties(propFile
					.toString());
			// 对比合并
			for (Iterator<Object> keys = fromProperty.getKeys(); keys.hasNext();) {
				String key1 = (String) keys.next();
				String value = getLastValue(fromProperty, key1);
				// 如果已经存在，则更新，否则添加
				if (getLastValue(toProperty, key1) == null) {
					toProperty.addProperty(key1, value);
				} else {
					toProperty.setProperty(key1, value);
				}
			}
			i++;
		}
		// 将资源文件回写到目标工程中
		writeProps2Project(propertiesMap, toProjectPath, toPropName);
		System.out.println("成功合并" + i + "个文件！");
	}

	/**
	 * 根据文件夹路径获取该目录下面所有的properties文件路径，并追加到propertiesList中
	 * 
	 * @param dirPath
	 *            文件夹路径
	 * @param propertiesList
	 *            资源文件路径列表
	 * @param language
	 *            资源文件类型名称
	 * @return
	 */
	public static List<File> getFileProperty(String dirPath,
			List<File> propertiesList, String language) {
		File[] file = (new File(dirPath)).listFiles();
		if (file == null)
			return propertiesList;
		for (int i = 0; i < file.length; i++) {
			if (file[i].isDirectory()) {
				String sourceDir = dirPath + "/" + File.separator
						+ file[i].getName();
				if (!file[i].getName().equals(".svn")) {
					propertiesList = getFileDirectiory(sourceDir,
							propertiesList, language);
				}
			} else if (file[i].isFile()) {
				File sourceFile = file[i];
				if (sourceFile.getName().equals(language)) {
					if (!propertiesList.contains(sourceFile)) {
						propertiesList.add(sourceFile);
					}
				}
			}
		}
		return propertiesList;
	}

	/**
	 * 获取源文件夹当前下的文件或目录
	 * 
	 * @param sourceDir
	 * @param listSource
	 * @param Language
	 * @return
	 */
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

	/**
	 * 根据资源文件路径获取一个资源文件并转成对象返回
	 * 
	 * @param fileName
	 * @return
	 * @throws IOException
	 */
	public static PropertiesConfiguration getProperties(String fileName) {
		File file = new File(fileName);
		if (!file.exists())
			return null;
		FileInputStream in = null;
		PropertiesConfiguration newProperties = new PropertiesConfiguration();
		try {
			in = new FileInputStream(file);
			newProperties.load(in);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (ConfigurationException e) {
			e.printStackTrace();
		} finally {
			try {
				in.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return newProperties;
	}

	// 创建一个excel工作簿，将未翻译和有改变内容写入到excel中
	private static HSSFWorkbook buildWorkBook(List<File> zhPropertiesList,
			List<File> propertiesList, String projectPath, String propertyName)
			throws Exception {
		/* 创建一个excel工作簿对象 */
		HSSFWorkbook workbook = new HSSFWorkbook();
		/* 创建一个工作表对象 */
		HSSFSheet sheet = workbook.createSheet();
		sheet.setColumnWidth(0, 5000);
		sheet.setColumnWidth(1, 13000);
		sheet.setColumnWidth(2, 11000);
		sheet.setColumnWidth(3, 11000);
		workbook.setSheetName(0, "待翻译工作表");// 工作表名
		HSSFCellStyle titleStyle = getTitleCellStyle(workbook);
		short rowIndex = 0;
		/* 标题行 */
		HSSFRow titlerow = sheet.createRow(rowIndex++);
		HSSFCell cell1 = titlerow.createCell(0);
		cell1.setCellValue("模块");
		cell1.setCellStyle(titleStyle);
		HSSFCell cell2 = titlerow.createCell(1);
		cell2.setCellValue("key");
		cell2.setCellStyle(titleStyle);
		HSSFCell cell3 = titlerow.createCell(2);
		cell3.setCellValue("中文");
		cell3.setCellStyle(titleStyle);
		HSSFCell cell4 = titlerow.createCell(3);
		cell4.setCellValue(translationTitle);
		cell4.setCellStyle(titleStyle);
		/* 内容部分 */
		for (File zhProperties : zhPropertiesList) {
			String zhPropertyPath = zhProperties.toString();
			// 中文资源文件
			PropertiesConfiguration zhProperty = getProperties(zhPropertyPath);
			// 备份文件
			PropertiesConfiguration bakProperty = getProperties(zhPropertyPath
					.replace(zhCn, getBakPropName(propertyName)));
			// 需翻译的资源文件
			String propertyPath = zhPropertyPath.replace(zhCn, propertyName);
			File file = new File(propertyPath);
			// 如果存在需翻译资源文件，则只导出还没翻译的，并且跟备份文件对比有差异的部分
			if (propertiesList.contains(file)) {
				PropertiesConfiguration enProperty = getProperties(propertyPath);
				for (Iterator<Object> keys = zhProperty.getKeys(); keys
						.hasNext();) {
					String key = (String) keys.next();
					String value = "";
					// 跟待翻译资源文件比较，将待翻译资源文件中没有的值返回
					if (zhProperty.getProperty(key) != null
							&& enProperty.getProperty(key) == null) {
						value = getLastValue(zhProperty, key);
					}
					// 跟备份文件比较，并将有差别的值返回
					if (bakProperty != null)
						value = compareWithBakFile(zhProperty, bakProperty,
								key, value);
					// 插入内容
					if (StringUtil.isNotNull(value))
						insertContentRow(sheet, rowIndex++, zhPropertyPath
								.replace(projectPath, "").replace(zhCn, ""),
								key, value, "");
				}
			} else {// 待翻译资源文件不存在，则全部导出
				for (Iterator<Object> keys = zhProperty.getKeys(); keys
						.hasNext();) {
					String key = (String) keys.next();
					String value = getLastValue(zhProperty, key);
					// 插入内容
					insertContentRow(sheet, rowIndex++, zhPropertyPath.replace(
							projectPath, "").replace(zhCn, ""), key, value, "");
				}
			}
		}
		return workbook;
	}

	/**
	 * 跟备份资源文件比较，如果相同的key中文和备份文件对应的值不一致，则取中文资源文件属性的值返回
	 * 
	 * @param zhProperty
	 * @param bakProperty
	 * @param key
	 * @param value
	 * @return
	 */
	public static String compareWithBakFile(PropertiesConfiguration zhProperty,
			PropertiesConfiguration bakProperty, String key, String value) {
		Object zhValue = getLastValue(zhProperty, key);
		Object bakValue = getLastValue(bakProperty, key);
		if (zhValue != null
				&& bakValue != null
				&& !((String) zhValue).trim()
						.equals(((String) bakValue).trim())) {
			System.out.println("找出中文资源文件跟 备份资源文件有差异项：zhProperty：key=" + key
					+ " value=" + zhProperty.getProperty(key)
					+ " bakProperty:key=" + key + " value="
					+ bakProperty.getProperty(key));
			value = getLastValue(zhProperty, key);
		}
		return value;
	}

	/**
	 * 备份一份资源文件
	 * 
	 * @param sourcePath
	 *            原资源文件路径
	 * @param toPath
	 *            备份后资源文件路径
	 */
	public static void backupProperty(String sourcePath, String toPath) {
		File sourceFile = new File(sourcePath);
		if (!sourceFile.exists()) {
			System.out.println(sourcePath + "找不到，备份失败！");
			return;
		}
		File bakFile = new File(toPath);
		// 如果中文资源文件备份文件存在的话，将其删除
		if (bakFile.exists()) {
			bakFile.delete();
		}
		FileOutputStream bakOut = null;
		FileInputStream sourceIn = null;
		try {
			// 取到原资源文件
			sourceIn = new FileInputStream(sourceFile);
			PropertiesConfiguration sourceProperty = new PropertiesConfiguration();
			sourceProperty.load(sourceIn);
			// 备份资源文件
			bakOut = new FileOutputStream(bakFile);
			sourceProperty.save(bakOut);
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (ConfigurationException e) {
			e.printStackTrace();
		} finally {
			if (sourceIn != null) {
				try {
					sourceIn.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			if (bakOut != null) {
				try {
					bakOut.flush();
					bakOut.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}

	// 往excel中插入内容行
	private static void insertContentRow(HSSFSheet sheet, short rowIndex,
			String modulePath, String fdKey, String zhValue, String enValue) {
		// 内容行
		HSSFRow controw = sheet.createRow(rowIndex);
		HSSFCell contCell1 = controw.createCell(0);// 模块路径
		contCell1.setCellValue(modulePath);
		HSSFCell contCell2 = controw.createCell(1);// key
		contCell2.setCellValue(fdKey);
		HSSFCell contCell3 = controw.createCell(2);// 中文值
		contCell3.setCellValue(zhValue);
		HSSFCell contCell4 = controw.createCell(3);// 英文值
		contCell4.setCellValue(enValue);
	}

	// 得到excel标题单元格样式
	private static HSSFCellStyle getTitleCellStyle(HSSFWorkbook workbook) {
		HSSFCellStyle titleCellStyle = workbook.createCellStyle();
		HSSFFont titleFont = workbook.createFont();
		titleFont.setFontHeightInPoints((short) 11);// 大小
		titleFont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);// 粗体
		titleFont.setItalic(new Boolean(true));// 斜体
		titleCellStyle.setFont(titleFont);
		titleCellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);// 居中对齐
		titleCellStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		titleCellStyle
				.setFillForegroundColor(HSSFColor.LIGHT_CORNFLOWER_BLUE.index);
		return titleCellStyle;
	}

	/**
	 * 将资源文件回写到工程中
	 * 
	 * @param propertiesMap
	 * @param projectPath
	 * @param propertyName
	 */
	public static void writeProps2Project(
			Map<String, PropertiesConfiguration> propertiesMap,
			String projectPath, String propertyName) {
		String cnPropertyPath = null;
		String propertyPath = null;
		File cnFile = null;
		File propertyFile = null;
		FileOutputStream propertyOut = null;
		for (String key : propertiesMap.keySet()) {
			// 工程中文资源文件
			cnPropertyPath = projectPath + key + zhCn;
			cnFile = new File(cnPropertyPath);
			// 工程中文资源备份文件
			// 如果中文文件存在的话，才需要回写资源文件
			if (cnFile.exists()) {
				try {
					propertyPath = projectPath + key + propertyName;
					propertyFile = new File(propertyPath);
					propertyOut = new FileOutputStream(propertyFile);
					propertiesMap.get(key).save(propertyOut);
				} catch (FileNotFoundException e) {
					e.printStackTrace();
				} catch (ConfigurationException e) {
					e.printStackTrace();
				} finally {
					if (propertyOut != null) {
						try {
							propertyOut.flush();
							propertyOut.close();
						} catch (IOException e) {
							e.printStackTrace();
						}
					}
				}
			}
		}
	}

	/**
	 * 从excel导入到工程时，根据选择的excel文件路径获取excel，并转换成工作簿对象返回
	 * 
	 * @param excelFilePath
	 * @return
	 */
	public static HSSFWorkbook getWorkbook(String excelFilePath) {
		File excelFile = new File(excelFilePath);
		HSSFWorkbook wb = null;
		InputStream in = null;
		POIFSFileSystem fs = null;
		try {
			in = new FileInputStream(excelFile);
			fs = new POIFSFileSystem(in);
			wb = new HSSFWorkbook(fs);
		} catch (FileNotFoundException e) {
			System.out.println("找不到文件：" + excelFilePath);
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (in != null) {
				try {
					in.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		return wb;
	}

	/**
	 * 根据资源文件和key返回对应的值，如果有相同的key，则取最后一个key的value
	 * 
	 * @param pc
	 * @param key
	 * @return
	 */
	public static String getLastValue(PropertiesConfiguration pc, String key) {
		String[] values = pc.getStringArray(key);
		if (values != null && values.length > 0) {
			return values[values.length - 1];
		}
		return null;
	}

	/**
	 * 将工程中所有资源文件重新编码
	 * 
	 * @param projectPath
	 *            工程中资源文件路径
	 * @param propertyName
	 *            资源文件名称
	 * @param param
	 *            编码参数<br>
	 *            1、为空：将本地编码转为Unicode编码；<br>
	 *            2、-reverse:将Unicode编码转为本地编码
	 */
	public static void unicoding(String projectPath, String propertyName,
			String param) {
		if (param == null)
			param = "";
		String batFileName = "C:\\ConvertEncodeing" + ".bat";
		File fileBat = new File(batFileName);
		if (fileBat.exists()) {
			fileBat.delete();
		}
		FileWriter writerBat = null;
		BufferedWriter bwBat = null;
		try {
			writerBat = new FileWriter(fileBat, true);
			bwBat = new BufferedWriter(writerBat);
			List<File> propertyList = new ArrayList<File>();
			propertyList = getFileProperty(projectPath, propertyList,
					propertyName);
			for (File file : propertyList) {
				String content = "native2ascii " + param + file.toString()
						+ " " + file.toString();
				bwBat.write(content);
				bwBat.newLine();
				bwBat.flush();
			}
			Runtime r = Runtime.getRuntime();
			r.exec("cmd.exe /c " + "start " + batFileName);
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (writerBat != null) {
				try {
					writerBat.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			if (bwBat != null) {
				try {
					bwBat.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}

	public static void main(String args[]) throws Exception {
		// 导入导出excel文件路径
		String excelFilePath = "F://ekp90(20111101).xls";
		// 工程的名称
		String projectName = "ekp_rtc2";
		// 工程中资源文件路径
		String projectPath = "D:\\java\\workspace\\" + projectName + "\\src\\";
		/* 1、将还没翻译或中文资源文件已经做了修改的资源属性导出到excel */
		// InternationalizationUtil.export(excelFilePath, projectPath, enUs);
		/* 2、将已经翻译好了的excel文件导入到工程 */
		InternationalizationUtil.importExcel(excelFilePath, projectPath, enUs);
		/* 3、根据资源文件类型名称，删除工程中所有该类型名称的资源文件 */
		// InternationalizationUtil.deleteAllProperties(projectPath,
		// getBakPropName(enUs));
		/* 4、备份工程中所有中文资源文件 */
		// InternationalizationUtil.backupAllProperties(projectPath, zhCn,
		// getBakPropName(enUs), null);
		/* 5、将一个项目中的资源文件合并到另外一个项目中 */
		// String fromProjectPath = "D:\\11\\msg\\bak\\";
		// String toProjectPath =
		// "D:\\java\\workspace\\ekp_rtc2\\src\\com\\landray\\kmss\\";
		// String fromPropName = "ApplicationResources.properties.bak";
		// String toPropName = getBakPropName(enUs);
		// InternationalizationUtil.merge(fromProjectPath, toProjectPath,
		// fromPropName, toPropName, false);
		/* 6、将D:\11\msg\bak\下面的所有英文资源文件重新编码，把unicode编码转为中文 */
		// InternationalizationUtil.unicoding("D:\\11\\msg\\bak\\", enUs, "");
	}
}
