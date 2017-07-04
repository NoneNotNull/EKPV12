package com.landray.kmss.tib.common.util;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;

public class FileUtil {
	
	/**
	 * 获取字符缓读取存流，并指定编码
	 * @param file			文件
	 * @param encode		编码
	 * @return
	 * @throws Exception
	 */
	public static BufferedReader getBufferedReader(File file, 
			String encode) throws Exception {
		return new BufferedReader(new InputStreamReader(
				new FileInputStream(file), encode));
	}
	
	/**
	 * 获取字符缓存写入流
	 * @param file		文件
	 * @param encode	编码
	 * @param append	是否追加内容
	 * @return
	 * @throws Exception
	 */
	public static BufferedWriter getBufferedWriter (File file, 
			String encode, boolean append) throws Exception {
		return new BufferedWriter(new OutputStreamWriter(
				new FileOutputStream(file, append), encode));
	}
}
