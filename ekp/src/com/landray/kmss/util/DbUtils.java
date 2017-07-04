package com.landray.kmss.util;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.sql.Blob;
import java.sql.SQLException;
import java.util.Date;

import org.apache.commons.codec.binary.Base64;
import org.hibernate.Hibernate;

import com.landray.kmss.sys.config.service.ISysEmptyService;

/**
 * 数据库相关操作
 * 
 * @author 叶中奇
 * 
 */
public abstract class DbUtils {
	private static ISysEmptyService sysEmptyService = null;

	private static long delta = 0;

	private static long updateTime = 0;

	private static ISysEmptyService getSysEmptyService() {
		if (sysEmptyService == null) {
			sysEmptyService = (ISysEmptyService) SpringBeanUtil
					.getBean("sysEmptyService");
		}
		return sysEmptyService;
	}

	/**
	 * 获取数据库的当前时间
	 * 
	 * @return
	 * @throws Exception
	 */
	public static Date getDbTime() throws Exception {
		long localTime = System.currentTimeMillis();
		if (localTime - updateTime > DateUtil.HOUR) {
			long dbTime = getSysEmptyService().getDbTime().getTime();
			localTime = System.currentTimeMillis();
			delta = localTime - dbTime;
			updateTime = localTime;
		}
		return new Date(localTime - delta);
	}

	/**
	 * 对象转成Blob
	 * 
	 * @param obj
	 * @return
	 * @throws IOException
	 */
	public static Blob obj2Blob(Serializable obj) throws IOException {
		ByteArrayOutputStream baos = null;
		ObjectOutputStream oos = null;
		try {
			baos = new ByteArrayOutputStream();
			oos = new ObjectOutputStream(baos);
			oos.writeObject(obj);
			return Hibernate.createBlob(baos.toByteArray());
		} finally {
			if (oos != null)
				oos.close();
			if (baos != null)
				baos.close();
		}
	}

	/**
	 * Blob转成对象
	 * 
	 * @param blob
	 * @return
	 * @throws IOException
	 * @throws SQLException
	 * @throws ClassNotFoundException
	 */
	public static Object blob2Obj(Blob blob) throws IOException, SQLException,
			ClassNotFoundException {
		ObjectInputStream ois = null;
		try {
			ois = new ObjectInputStream(blob.getBinaryStream());
			return ois.readObject();
		} finally {
			if (ois != null)
				ois.close();
		}
	}

	/**
	 * 对象转成String
	 * 
	 * @param obj
	 * @return
	 * @throws IOException
	 */
	public static String obj2String(Serializable obj) throws IOException {
		ByteArrayOutputStream baos = null;
		ObjectOutputStream oos = null;
		try {
			baos = new ByteArrayOutputStream();
			oos = new ObjectOutputStream(baos);
			oos.writeObject(obj);
			return new String(Base64.encodeBase64(baos.toByteArray()));
		} finally {
			if (oos != null)
				oos.close();
			if (baos != null)
				baos.close();
		}
	}

	/**
	 * String转成对象
	 * 
	 * @param s
	 * @return
	 * @throws IOException
	 * @throws SQLException
	 * @throws ClassNotFoundException
	 */
	public static Object string2Obj(String s) throws IOException, SQLException,
			ClassNotFoundException {
		ObjectInputStream ois = null;
		ByteArrayInputStream bis = null;
		try {
			bis = new ByteArrayInputStream(Base64.decodeBase64(s.getBytes()));
			ois = new ObjectInputStream(bis);
			return ois.readObject();
		} finally {
			if (ois != null)
				ois.close();
			if (bis != null)
				bis.close();
		}
	}
}
