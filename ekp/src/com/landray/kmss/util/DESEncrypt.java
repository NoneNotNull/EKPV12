package com.landray.kmss.util;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.security.Key;
import java.security.SecureRandom;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.DESKeySpec;

import org.apache.commons.codec.binary.Base64;
import org.apache.commons.io.IOUtils;

/**
 * DES加密解密<br>
 * 
 * DESEncrypt des = new DESEncrypt(); 字符串加密：des.encryptString(str);
 * 字符串解密：des.decryptString(str);
 * 
 * @author 缪贵荣
 * @version 1.0 2011-02-17
 */
public class DESEncrypt {

	private static final String ENCODING = "UTF-8";

	private static final String ALGORITHM_NAME = "DES";

	private static String strDefaultKey = "kmssSecureKey"; // 默认种子

	private Cipher encryptCipher = null;

	private Cipher decryptCipher = null;

	public DESEncrypt() throws Exception {
		this(strDefaultKey);
	}

	/**
	 * @param strKey
	 *            至少8位
	 * @throws Exception
	 */
	public DESEncrypt(String strKey) throws Exception {
		this(strKey, false);
	}

	@Deprecated
	public DESEncrypt(String strKey, boolean isRandom) throws Exception {
		Key key = null;
		if (!isRandom) {
			key = getKey(strKey);
		} else {
			key = getRandomKey(strKey);
		}
		encryptCipher = Cipher.getInstance("DES/ECB/PKCS5Padding");
		encryptCipher.init(Cipher.ENCRYPT_MODE, key);

		decryptCipher = Cipher.getInstance("DES/ECB/PKCS5Padding");
		decryptCipher.init(Cipher.DECRYPT_MODE, key);
	}

	/**
	 * 从指定字符串生成密钥
	 * 
	 * @param bytes
	 * @return
	 * @throws Exception
	 */
	private Key getKey(String str) throws Exception {
		DESKeySpec dks = new DESKeySpec(str.getBytes(ENCODING));
		SecretKeyFactory keyFactory = SecretKeyFactory
				.getInstance(ALGORITHM_NAME);
		return keyFactory.generateSecret(dks);
	}

	/**
	 * 从指定字符串随机生成密钥
	 * 
	 * @param bytes
	 * @return
	 * @throws Exception
	 */
	private Key getRandomKey(String str) throws Exception {
		KeyGenerator generator = KeyGenerator.getInstance(ALGORITHM_NAME);
		generator.init(new SecureRandom(str.getBytes(ENCODING)));
		return generator.generateKey();
	}

	/**
	 * 加密字节数组
	 * 
	 * @param bytes
	 * @return
	 * @throws BadPaddingException
	 * @throws IllegalBlockSizeException
	 * @throws Exception
	 */
	public byte[] encrypt(byte[] bytes) throws IllegalBlockSizeException,
			BadPaddingException {
		return encryptCipher.doFinal(bytes);
	}

	/**
	 * 解密字节数组
	 * 
	 * @param bytes
	 * @return
	 * @throws BadPaddingException
	 * @throws IllegalBlockSizeException
	 * @throws Exception
	 */
	public byte[] decrypt(byte[] bytes) throws IllegalBlockSizeException,
			BadPaddingException {
		return decryptCipher.doFinal(bytes);
	}

	/**
	 * 解密输入流
	 * 
	 * @param in
	 * @return
	 * @throws Exception
	 */
	public InputStream decrypt(InputStream in) throws Exception {// 对数据进行解密
		byte[] b = IOUtils.toByteArray(in);
		return new ByteArrayInputStream(decrypt(b));
	}

	/**
	 * 加密字符串
	 * 
	 * @param str
	 * @return
	 * @throws Exception
	 * @throws Exception
	 */
	public String encryptString(String str) throws Exception {
		return new String(Base64.encodeBase64(encrypt(str.getBytes(ENCODING)),
				true), ENCODING).replaceAll("\n", "");
	}

	/**
	 * 
	 * 解密字符串
	 * 
	 * @param str
	 * @return
	 * @throws Exception
	 */
	public String decryptString(String str) throws Exception {
		return new String(decrypt(Base64.decodeBase64(str.getBytes(ENCODING))),
				ENCODING);
	}

	public static void main(String[] args) throws Exception {
		String str = "password";
		// DESEncrypt des = new DESEncrypt();// 默认密钥
		DESEncrypt des = new DESEncrypt("kmssAdminKey");// 自定义密钥

		System.out.println("加密前的字符：" + str);
		String strTmp = des.encryptString(str);
		System.out.println("加密后的字符：" + strTmp);
		System.out.println("解密后的字符：" + des.decryptString(strTmp));

	}
}
