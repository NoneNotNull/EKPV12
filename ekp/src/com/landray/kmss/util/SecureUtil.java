package com.landray.kmss.util;

import org.apache.commons.codec.binary.Base64;

public class SecureUtil {

	public static String BASE64Encoder(String str) {
		if (str == null)
			return null;
		return new String(Base64.encodeBase64(str.getBytes()));
	}

	public static String BASE64Decoder(String str) {
		if (str == null)
			return null;
		try {
			return new String(Base64.decodeBase64(str.getBytes()));
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return "";
	}

}
