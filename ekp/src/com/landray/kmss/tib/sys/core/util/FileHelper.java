package com.landray.kmss.tib.sys.core.util;

import java.beans.XMLDecoder;
import java.beans.XMLEncoder;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import com.landray.kmss.util.IDGenerator;
import com.landray.kmss.util.StringUtil;

public class FileHelper {

	private File sDir;
	private File tDir;

	public FileHelper(String s, String d) {
		this(new File(s), new File(d));
	}

	public FileHelper(File sDir, File tDir) {
		this.sDir = sDir;
		this.tDir = tDir;
	}

	public void copyDir() throws Exception {
		deleteDir(tDir);
		tDir.mkdirs();
		// 遍历源文件夹。
		listAll(sDir);
	}

	/*
	 * 将遍历目录封装成方法。 在遍历过程中，遇到文件创建文件。 遇到目录创建目录。
	 */
	private void listAll(File dir) throws Exception {
		File[] files = dir.listFiles();
		for (int x = 0; x < files.length; x++) {
			if (files[x].isDirectory()) {
				createDir(files[x]);// 调用创建目录的方法。
				listAll(files[x]);// 在继续进行递归。进入子级目录。
			} else {
				createFile(files[x]);// 调用创建文件的方法。
			}
		}
	}

	/*
	 * copy目录。通过源目录在目的目录创建新目录。
	 */
	private void createDir(File dir) {
		File d = replaceFile(dir);
		d.mkdir();
	}

	/*
	 * copy文件。
	 */
	private void createFile(File file) throws Exception {
		File newFile = replaceFile(file);
		BufferedReader br = null;
		BufferedWriter bw = null;
		XMLDecoder xmlIn = null;
		XMLEncoder xmlOut = null;
		try {
			br = new BufferedReader(new InputStreamReader(new FileInputStream(
					file), "UTF-8"));
			bw = new BufferedWriter(new OutputStreamWriter(
					new FileOutputStream(newFile, false), "UTF-8"));
			String data = null;
			StringBuffer dataBuf = new StringBuffer();
			while ((data = br.readLine()) != null) {
				dataBuf.append(data);
			}
			Document doc = TibSysCoreUtil.stringToDoc(dataBuf.toString());
			// 移除doc中的接口xml,并将其返回
			String fdIfaceXmlValue = getIfaceXml(doc);
			// 写入文件
			bw.write(TibSysCoreUtil.DocToString(doc));
			bw.flush();
			
			// 再写入接口XML（帮助转义）
			xmlIn = new XMLDecoder(new FileInputStream(file));
			Map<String, Object> inDataMap = (Map<String, Object>) xmlIn.readObject(); 
			Pattern p = Pattern.compile("\t|\r|\n");
			Matcher m = p.matcher(fdIfaceXmlValue);
			fdIfaceXmlValue = m.replaceAll("");
			inDataMap.put("fdIfaceXml", fdIfaceXmlValue.replaceAll("\"", "\\\\\""));
			// 写fdId(不存在则写入新的)
			String fdId = (String) inDataMap.get("fdId");
			if (StringUtil.isNull(fdId)) {
				inDataMap.put("fdId", IDGenerator.generateID());
			}
			//将修改后的内容输出到xml文件中
			xmlOut = new XMLEncoder(new BufferedOutputStream(new FileOutputStream(newFile)));
			xmlOut.writeObject(inDataMap);
		} finally {
			if (br != null) {
				br.close();
			}
			if (bw != null) {
				bw.close();
			}
			if (xmlIn != null) {
				xmlIn.close();
			}
			if (xmlOut != null) {
				xmlOut.close();
			}
		}
	}

	/*
	 * 替换路径。
	 */
	private File replaceFile(File f) {
		// 原理是：将源目录的父目录(C:\\Tset)，替换成目的父目录。（d:\\abc\\Test）
		String path = f.getAbsolutePath();// 获取源文件或者文件夹的决定路径。
		// 将源文件或者文件夹的绝对路径替换成目的路径。
		String newPath = path.replace(sDir.getAbsolutePath(), tDir
				.getAbsolutePath());
		// 将新的目的路径封装成File对象
		File newFile = new File(newPath);
		return newFile;
	}
	
	private static String getIfaceXml(Document doc) throws Exception {
		List<Element> eleList = TibSysCoreUtil.selectElement("/java/object/void/string", doc);
		// 存放接口xml值
		String fdIfaceXmlValue = "";
		for (int i = 0, len = eleList.size(); i < len; i++) {
			Element ele = eleList.get(i);
			Node node = ele.getFirstChild();
			// 判断文本节点
			if (node != null && node.getNodeType() == Node.TEXT_NODE) {
				String fieldName = node.getNodeValue();
				// 找出接口xml
				if ("fdIfaceXml".equals(fieldName)) {
					Element valueEle = eleList.get(i + 1);
					// 取出接口xml
					for (int j = 0; j < valueEle.getChildNodes().getLength(); j++) {
						Node nd = valueEle.getChildNodes().item(j);
						if (nd.getNodeType() == Node.ELEMENT_NODE) {
							fdIfaceXmlValue += TibSysCoreUtil.nodeToString(nd);
						}
					}
					// 重新设置接口xml(先删除)
					valueEle.removeChild(valueEle.getFirstChild());
				}
			}
		}
		return fdIfaceXmlValue;
	}

	/**
	 * 删除目录，包括其下的所有子目录和文件
	 * 
	 * @param dir
	 *            被删除的目录名
	 * @return boolean 是否删除成功
	 * @throws Exception
	 *             删除目录过程中的任何异常
	 */
	public static boolean deleteDir(File dir) throws Exception {
		if (dir.isFile()) {
			deleteFile(dir);
		}
		File[] files = dir.listFiles();
		if (files != null) {
			for (File file : files) {
				if (file.isFile()) {
					file.delete();
				} else {
					deleteDir(file);
				}
			}
		}
		return dir.delete();
	}

	/**
	 * 删除文件
	 * 
	 * @param file
	 *            被删除文件
	 * @return boolean 是否删除成功
	 * @throws Exception
	 *             删除文件过程中的任何异常
	 */
	private static boolean deleteFile(File file) throws Exception {
		if (file.isDirectory()) {
			return deleteDir(file);
		}
		if (!file.exists()) {
			return false;
		}
		return file.delete();
	}
}
