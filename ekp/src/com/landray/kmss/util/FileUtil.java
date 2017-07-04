package com.landray.kmss.util;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.Reader;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import java.util.jar.JarEntry;
import java.util.jar.JarOutputStream;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.io.IOUtils;

public class FileUtil {
	public static String getFilePath(String source_filename,
			String pointFilePath) {
		String ext = "";
		String source_filename_no_ext = source_filename;
		if (source_filename.indexOf(".") > 0) {
			ext = source_filename.substring(source_filename.lastIndexOf("."));
			source_filename_no_ext = source_filename.substring(0,
					source_filename.lastIndexOf("."));
		}

		String uploadRefPath = (pointFilePath == null || pointFilePath.trim()
				.length() == 0) ? getSystemTempPath() : pointFilePath;
		if (uploadRefPath != null
				&& !uploadRefPath
						.endsWith(System.getProperty("file.separator"))
				&& !uploadRefPath.endsWith("/")
				&& !uploadRefPath.endsWith("\\")) {
			uploadRefPath += System.getProperty("file.separator");
		}
		String uploadPath = uploadRefPath;
		File uploadDir = new File(uploadPath);
		if (!uploadDir.exists())
			uploadDir.mkdirs();
		Date today = new Date();
		String formatString = "yyyyMMddHHmmss";
		SimpleDateFormat dateformat = new SimpleDateFormat(formatString);
		String filename = source_filename_no_ext + dateformat.format(today);
		for (int i = 0; i < 10000; i++) {
			String real_filename = filename + "_" + i + ext;
			File file = new File(uploadDir, real_filename);
			if (!file.exists()) {
				return uploadRefPath + real_filename;
			}
		}
		return null;
	}

	/**
	 * 获取系统的临时目录
	 * 
	 * @return
	 */
	public static String getSystemTempPath() {
		return System.getProperty("java.io.tmpdir");
	}

	// ~ Methods add by wubing
	// -------------------------------------------------------------

	/**
	 * 获得指定配置文件属性
	 * 
	 * @param fileName
	 *            文件名称
	 * @return Properties 文件中所包含的所有属性
	 * @throws Exception
	 *             读取属性过程中的任何异常
	 */
	public static Properties getProperties(String fileName) throws Exception {
		Properties initProps = new Properties();
		InputStream in = null;

		try {
			in = getInputStream(fileName);
			initProps.load(in);
		} finally {
			try {
				if (in != null) {
					in.close();
				}
			} catch (Exception e) {
			}
		}

		return initProps;
	}

	/**
	 * 获取指定配置文件属性的读取流，读取路径为本类的CLASSLOADER或者父CLASSLOADER
	 * 
	 * @param fileName
	 *            文件名称
	 * 
	 * @return InputStream 该文件所对应的输入流
	 * @throws Exception
	 *             读取输入流过程中的任何异常
	 */
	public static InputStream getInputStream(String fileName) throws Exception {
		return getInputStream(getFile(getFileURL(fileName).getFile()));
	}

	public static InputStream getInputStream(File file) throws Exception {
		return new BufferedInputStream(new FileInputStream(file));
	}

	/**
	 * 根据文件名获取其在应用中的相对路径
	 * 
	 * @param fileName
	 *            文件名
	 * @return URL 文件在应用中的相对路径
	 * @throws Exception
	 *             获取路径过程中的任何异常
	 */
	public static URL getFileURL(String fileName) throws Exception {
		// 从本类CLASSLOADER相应路径中读取文件
		URL fileURL = FileUtil.class.getClassLoader().getResource(fileName);

		if (fileURL == null) {
			FileUtil.class.getClassLoader().getResource("/" + fileName);
		}

		if (fileURL == null) {
			Thread.currentThread().getContextClassLoader()
					.getResource(fileName);
		}

		if (fileURL == null) {
			fileURL = ClassLoader.getSystemResource(fileName);
		}

		if (fileURL == null) {
			fileURL = new File(fileName).toURL();
		}

		return fileURL;
	}

	/**
	 * 保存属性到文件
	 * 
	 * @param fileName
	 *            文件名
	 * @param prop
	 *            需存储的属性
	 * @throws Exception
	 *             存储属性过程中的任何异常
	 */
	public static void setProperties(String fileName, Properties prop)
			throws Exception {
		FileOutputStream fs = null;
		try {
			fs = new FileOutputStream(getFileURL(fileName).getFile());
			prop.store(fs, "store at " + new Date());
		} finally {
			// 关闭流
			IOUtils.closeQuietly(fs);
		}
	}

	/**
	 * 判断是否需要重新LOAD地址配置文件
	 * 
	 * @param fileName
	 *            文件名
	 * @param lastModify
	 *            原最后修改时间
	 * @return boolean 是否需要重新读取
	 * @throws Exception
	 *             判断重新LOAD过程中的任何异常
	 */
	public static boolean needReload(String fileName, long lastModify)
			throws Exception {
		// 判断文件最后更新时间，决定是否RELOAD
		if (getLastModify(fileName) > lastModify) {
			return true;
		}

		return false;
	}

	/**
	 * 根据文件名获取文件对象，在当前CLASSLOADER路径下寻找文件
	 * 
	 * @param fileName
	 *            文件名
	 * @return File 文件对象
	 * @throws Exception
	 *             获取文件过程中的任何异常
	 */
	public static File getFile(String fileName) throws Exception {
		return new File(getFileURL(fileName).getFile());
	}

	/**
	 * 获取文件最后修改时间
	 * 
	 * @param fileName
	 *            文件名
	 * @return long 文件最后修改时间
	 * @throws Exception
	 *             获取最后修改时间过程中的任何异常
	 */
	public static long getLastModify(String fileName) throws Exception {
		// 获取当前文件最新修改时间
		return getFile(fileName).lastModified();
	}

	/**
	 * 创建一个目录
	 * 
	 * @param dir
	 *            目录路径
	 * @param ignoreIfExitst
	 *            如果已经存在该目录是否忽略
	 * @return boolean 是否创建成功
	 * @throws Exception
	 *             创建目录过程中的任何异常
	 */
	public static boolean createDir(String dir, boolean ignoreIfExitst)
			throws Exception {
		File file = getFile(dir);

		if (ignoreIfExitst && file.exists()) {
			return false;
		}

		return file.mkdir();
	}

	/**
	 * 创建一个目录，如果它的父目录不存在，则自动创建
	 * 
	 * @param dir
	 *            目录路径
	 * @param ignoreIfExitst
	 *            如果已经存在该目录是否忽略
	 * @return boolean 是否创建成功
	 * @throws Exception
	 *             创建目录过程中的任何异常
	 */
	public static boolean createDirs(String dir, boolean ignoreIfExitst)
			throws Exception {
		File file = getFile(dir);

		if (ignoreIfExitst && file.exists()) {
			return false;
		}

		return file.mkdirs();
	}

	/**
	 * 删除文件
	 * 
	 * @param filename
	 *            被删除文件的文件名
	 * @return boolean 是否删除成功
	 * @throws Exception
	 *             删除文件过程中的任何异常
	 */
	public static boolean deleteFile(String filename) throws Exception {
		File file = getFile(filename);

		return deleteFile(file);
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
	public static boolean deleteFile(File file) throws Exception {
		if (file.isDirectory()) {
			return deleteDir(file);
		}

		if (!file.exists()) {
			return false;
		}

		return file.delete();
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
			for (int i = 0; i < files.length; i++) {
				File file = files[i];

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
	 * 使用流里的内容创建一个新文件
	 * 
	 * @param stream
	 *            原文件流
	 * @param fileName
	 *            指定的文件路径及文件名
	 * @return File 生成的新文件
	 * @throws Exception
	 *             生成文件过程中的任何异常
	 */
	public static File createFile(InputStream stream, String fileName)
			throws Exception {
		File newFile = new File(fileName);
		OutputStream fileOut = new BufferedOutputStream(new FileOutputStream(
				newFile));
		byte[] buffer = new byte[8192];
		int bytesRead = 0;

		while ((bytesRead = stream.read(buffer, 0, 8192)) != -1) {
			fileOut.write(buffer, 0, bytesRead);
		}

		fileOut.close();
		stream.close();

		return newFile;
	}

	public static void createFile(String output, String content, String charset)
			throws Exception {
		FileOutputStream fos = null;
		OutputStreamWriter fw = null;
		try {
			fos = new FileOutputStream(output);
			if (StringUtil.isNotNull(charset))
				fw = new OutputStreamWriter(fos, charset);
			else
				fw = new OutputStreamWriter(fos);
			PrintWriter out = new PrintWriter(fw);
			out.print(content);
			out.close();
			fw.close();
		} catch (Exception ex) {
			throw new Exception(ex);
		} finally {
			try {
				fos.close();
			} catch (Exception e) {
			}
			try {
				fw.close();
			} catch (Exception e) {
			}
		}
	}

	public static void createFile(String output, String content)
			throws Exception {
		createFile(output, content, null);
	}

	// 获取可写流
	public static Writer openWithWrite(String file, boolean append)
			throws Exception {
		return new BufferedWriter(
				new FileWriter(FileUtil.getFile(file), append));
	}

	// 获取可读流
	public static Reader openWithRead(String file) throws Exception {
		return new BufferedReader(new FileReader(FileUtil.getFile(file)));
	}

	// 获得文件字节流
	public static byte[] getFileBytes(InputStream inputStream) throws Exception {
		ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream(
				1024);
		byte[] block = new byte[512];

		while (true) {
			int readLength = inputStream.read(block);

			if (readLength == -1) {
				break; // end of file
			}

			byteArrayOutputStream.write(block, 0, readLength);
		}

		byte[] retValue = byteArrayOutputStream.toByteArray();

		byteArrayOutputStream.close();

		return retValue;
	}

	// 获得文件字节流
	public static byte[] getFileBytes(String file) throws Exception {
		return getFileBytes(getInputStream(file));
	}

	public static void move(String input, String output) throws Exception {
		File inputFile = new File(input);
		File outputFile = new File(output);
		try {
			inputFile.renameTo(outputFile);
		} catch (Exception ex) {
			throw new Exception("Can not mv" + input + " to " + output
					+ ex.getMessage());
		}
	}

	public static boolean copy(String input, String output) throws Exception {
		int BUFSIZE = 0x10000;
		FileInputStream fis = new FileInputStream(input);
		FileOutputStream fos = new FileOutputStream(output);
		try {
			byte buf[] = new byte[BUFSIZE];
			int i;
			while ((i = fis.read(buf)) > -1) {
				fos.write(buf, 0, i);
			}
		} catch (Exception ex) {
			throw new Exception("makeHome" + ex.getMessage());
		} finally {
			fis.close();
			fos.close();
		}
		return true;
	}

	public static void makeHome(String home) throws Exception {
		File homedir = new File(home);
		if (!homedir.exists()) {
			try {
				homedir.mkdirs();
			} catch (Exception ex) {
				throw new Exception("Can not mkdir :" + home
						+ " Maybe include special charactor!");
			}
		}
	}

	public static void copyDir(String sourcedir, String destdir)
			throws Exception {
		File dest = new File(destdir);
		File source = new File(sourcedir);
		String files[] = source.list();
		try {
			makeHome(destdir);
		} catch (Exception ex) {
			throw new Exception("CopyDir:" + ex.getMessage());
		}
		for (int i = 0; i < files.length; i++) {
			String sourcefile = source + File.separator + files[i];
			String destfile = dest + File.separator + files[i];
			File temp = new File(sourcefile);
			if (temp.isFile()) {
				try {
					copy(sourcefile, destfile);
				} catch (Exception ex) {
					throw new Exception("CopyDir:" + ex.getMessage());
				}
			}
		}

	}

	public static void recursiveRemoveDir(File directory) throws Exception {
		if (!directory.exists()) {
			throw new IOException(directory.toString() + " do not exist!");
		}
		String filelist[] = directory.list();
		File tmpFile = null;
		for (int i = 0; i < filelist.length; i++) {
			tmpFile = new File(directory.getAbsolutePath(), filelist[i]);
			if (tmpFile.isDirectory()) {
				recursiveRemoveDir(tmpFile);
			} else if (tmpFile.isFile()) {
				try {
					tmpFile.delete();
				} catch (Exception ex) {
					throw new Exception(tmpFile.toString()
							+ " can not be deleted " + ex.getMessage());
				}
			}
		}

		try {
			directory.delete();
		} catch (Exception ex) {
			throw new Exception(directory.toString() + " can not be deleted "
					+ ex.getMessage());
		} finally {
			filelist = null;
		}
	}

	// 从远程读文件，且保存在本地
	public static boolean remoteFileRead(String sUrl, String path) {
		try {
			URL url = new URL(sUrl);
			URLConnection conn = url.openConnection();
			conn.connect();
			HttpURLConnection httpConn = (HttpURLConnection) conn;
			if (httpConn.getResponseCode() == 200) {
				System.out.println("Connect to " + sUrl
						+ " failed,return code:" + httpConn.getResponseCode());
				return false;
			}
			File file = createFile(conn.getInputStream(), path);
			return true;
		} catch (Exception ex) {
			ex.printStackTrace();
			return false;
		}
	}

	public static String getFileString(String fileName) throws Exception {
		StringBuffer sb = new StringBuffer();
		BufferedReader br = null;
		String line = null;
		try {
			br = new BufferedReader(new InputStreamReader(new FileInputStream(
					fileName)));
			while ((line = br.readLine()) != null) {
				sb.append(line + "\n");
			}
		} finally {
			// 关闭流
			IOUtils.closeQuietly(br);
		}
		return sb.toString();
	}

	public static String getFileString(String fileName, String charSet)
			throws Exception {
		StringBuffer sb = new StringBuffer();
		BufferedReader br = null;
		String line = null;
		try {
			br = new BufferedReader(new InputStreamReader(new FileInputStream(
					fileName), charSet));
			while ((line = br.readLine()) != null) {
				sb.append(line);
			}
		} finally {
			// 关闭流
			IOUtils.closeQuietly(br);
		}
		return sb.toString();
	}

	// 将文本转成流
	public static InputStream stringToInputStream(String str)
			throws UnsupportedEncodingException {
		ByteArrayInputStream stream = new ByteArrayInputStream(str
				.getBytes("UTF-8"));
		return stream;
	}

	/**
	 * 搜索文件
	 * 
	 * @param dir
	 *            起始文件夹
	 * @param s
	 * @return
	 */
	public static File[] searchFiles(String dir, String s) {
		// 起始文件夹
		File file = new File(dir);
		s = s.replace('.', '#');
		s = s.replaceAll("#", "\\\\.");
		s = s.replace('*', '#');
		s = s.replaceAll("#", ".*");
		s = s.replace('?', '#');
		s = s.replaceAll("#", ".?");
		s = "^" + s + "$";
		Pattern p = Pattern.compile(s);
		List<File> list = filePattern(file, p);
		if (list == null) {
			return null;
		}
		File[] rtn = new File[list.size()];
		list.toArray(rtn);
		return rtn;
	}

	/**
	 * @param file
	 *            File 起始文件夹
	 * @param p
	 *            Pattern 匹配类型
	 * @return ArrayList 其文件夹下的文件夹
	 */
	private static List<File> filePattern(File file, Pattern p) {
		if (file == null) {
			return null;
		} else if (file.isFile()) {
			Matcher fMatcher = p.matcher(file.getName());
			if (fMatcher.matches()) {
				List<File> list = new ArrayList<File>();
				list.add(file);
				return list;
			}
		} else if (file.isDirectory()) {
			File[] files = file.listFiles();
			if (files != null && files.length > 0) {
				List<File> list = new ArrayList<File>();
				for (int i = 0; i < files.length; i++) {
					List<File> rlist = filePattern(files[i], p);
					if (rlist != null) {
						list.addAll(rlist);
					}
				}
				return list;
			}
		}
		return null;
	}

	/**
	 * 打jar、war、zip包
	 * 
	 * @param jarFileName
	 * @param inputFilePath
	 * @param base
	 */
	public static void pack(String jarFileName, String inputFilePath,
			String base) {
		JarOutputStream jarOutputStream = null;
		try {
			File inputFile = new File(inputFilePath);
			jarOutputStream = new JarOutputStream(new FileOutputStream(
					jarFileName));
			pack(jarOutputStream, inputFile, base);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				jarOutputStream.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	private static void pack(JarOutputStream jarOutputStream, File inputFile,
			String base) throws IOException {
		if (inputFile.isDirectory()) {
			File[] files = inputFile.listFiles();
			jarOutputStream.putNextEntry(new JarEntry(base + "/"));
			base = base.length() == 0 ? "" : base + "/";
			for (int i = 0; i < files.length; i++) {
				pack(jarOutputStream, files[i], base + files[i].getName());
			}
		} else {
			jarOutputStream.putNextEntry(new JarEntry(base));
			FileInputStream in = null;
			try {
				in = new FileInputStream(inputFile);
				int b;
				while ((b = in.read()) != -1) {
					jarOutputStream.write(b);
				}
			} finally {
				in.close();
			}
		}
	}
}
