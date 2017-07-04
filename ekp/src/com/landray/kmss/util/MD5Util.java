package com.landray.kmss.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Random;

public class MD5Util {
	/**
	 * 默认的密码字符串组合，用来将字节转换成 16 进制表示的字符,apache校验下载的文件的正确性用的就是默认的这个组合
	 */
	protected static char hexDigits[] = { '0', '1', '2', '3', '4', '5', '6',
			'7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };

	private static ThreadLocal<MessageDigest> messagedigest = new ThreadLocal<MessageDigest>() {
		protected MessageDigest initialValue() {
			try {
				return MessageDigest.getInstance("MD5");
			} catch (NoSuchAlgorithmException e) {
				System.err.println(MD5Util.class.getName()
						+ "初始化失败，MessageDigest不支持MD5Util。");
				return null;
			}
		}
	};

	/**
	 * 生成字符串的md5校验值
	 * 
	 * @param s
	 * @return
	 */
	public static String getMD5String(String s) {
		return getMD5String(s.getBytes());
	}

	/**
	 * 生成文件的md5校验值
	 * 
	 * @param file
	 * @return
	 * @throws IOException
	 */
	public static String getMD5String(File file) throws IOException {
		if (!file.exists())
			return "";
		messagedigest.get().reset();
		InputStream fis = new FileInputStream(file);
		String result = getMD5String(fis);
		fis.close();
		return result;
	}

	/**
	 * 生成流的md5校验码
	 * 
	 * @param in
	 * @return
	 * @throws IOException
	 */
	public static String getMD5String(InputStream in) throws IOException {
		messagedigest.get().reset();
		byte[] buffer = new byte[0x10000];
		int numRead = 0;
		while ((numRead = in.read(buffer)) > 0) {
			messagedigest.get().update(buffer, 0, numRead);
		}
		return bufferToHex(messagedigest.get().digest());
	}

	/**
	 * 生成字节的md5校验码
	 * 
	 * @param bytes
	 * @return
	 */
	public static String getMD5String(byte[] bytes) {
		messagedigest.get().reset();
		messagedigest.get().update(bytes);
		return bufferToHex(messagedigest.get().digest());
	}

	private static String bufferToHex(byte bytes[]) {
		return bufferToHex(bytes, 0, bytes.length);
	}

	private static String bufferToHex(byte bytes[], int m, int n) {
		StringBuffer stringbuffer = new StringBuffer(2 * n);
		int k = m + n;
		for (int l = m; l < k; l++) {
			appendHexPair(bytes[l], stringbuffer);
		}
		return stringbuffer.toString();
	}

	private static void appendHexPair(byte bt, StringBuffer stringbuffer) {
		char c0 = hexDigits[(bt & 0xf0) >> 4];// 取字节中高 4 位的数字转换, >>>
		// 为逻辑右移，将符号位一起右移,此处未发现两种符号有何不同
		char c1 = hexDigits[bt & 0xf];// 取字节中低 4 位的数字转换
		stringbuffer.append(c0);
		stringbuffer.append(c1);
	}

	public static void main(String[] args) {
		MD5Util md5 = new MD5Util();
		for (int i = 0; i < 200; i++) {
			R r = md5.new R();
			Thread t = new Thread(r);
			t.start();
		}
	}

	class R implements Runnable {
		public void run() {
			System.out.println(MD5Util.getMD5String(new Random().nextFloat()
					+ ""));
		}
	}
}