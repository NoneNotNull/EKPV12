package com.landray.kmss.util;

import java.beans.DefaultPersistenceDelegate;
import java.beans.Encoder;
import java.beans.Expression;
import java.beans.PersistenceDelegate;
import java.beans.XMLDecoder;
import java.beans.XMLEncoder;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class ObjectXML {

	public static void objectXmlEncoder(Object obj, String fileName)
			throws FileNotFoundException, IOException, Exception {
		String path = fileName.substring(0, fileName.lastIndexOf('/'));
		if (path.indexOf('/') != -1) {
			File pFile = new File(path);
			if (!pFile.exists()) {
				pFile.mkdirs();
			}
		}
		File fo = new File(fileName);
		FileOutputStream fos = new FileOutputStream(fo);
		XMLEncoder encoder = new XMLEncoder(fos);
		encoder.writeObject(obj);
		encoder.flush();
		encoder.close();
		fos.close();
	}
	
	private static final PersistenceDelegate bigDecimalPersistenceDelegate = new DefaultPersistenceDelegate() {
		protected Expression instantiate(Object oldInstance,
				Encoder out) {
			BigDecimal bd = (BigDecimal) oldInstance;
			return new Expression(oldInstance, oldInstance
					.getClass(), "new", new Object[] { bd
					.toString() });
		}

		protected boolean mutatesTo(Object oldInstance,
				Object newInstance) {
			return oldInstance.equals(newInstance);
		}
	};

	public static String objectXmlEncoder(Object obj)
			throws FileNotFoundException, IOException, Exception {
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		XMLEncoder encoder = new XMLEncoder(baos);
		encoder.setPersistenceDelegate(BigDecimal.class,
				bigDecimalPersistenceDelegate);
		encoder.writeObject(obj);
		encoder.flush();
		encoder.close();
		String rtnVal = new String(baos.toByteArray(), "UTF-8");
		baos.close();
		return rtnVal;
	}

	/**
	 * 读取由objSource指定的XML文件中的序列化保存的对象,返回的结果经过了List封装
	 * 
	 * @param objSource
	 *            带全部文件路径的文件全名
	 * @return 由XML文件里面保存的对象构成的List列表(可能是一个或者多个的序列化保存的对象)
	 * @throws FileNotFoundException
	 *             指定的对象读取资源不存在
	 * @throws IOException
	 *             读取发生错误
	 * @throws Exception
	 *             其他运行时异常发生
	 */
	public static List objectXmlDecoder(String objSource)
			throws FileNotFoundException, IOException, Exception {
		File fin = new File(objSource);
		return objectXmlDecoder(new FileInputStream(fin));
	}

	public static List objectXMLDecoderByString(String ins) throws Exception {
		String safeIns = ins.replaceAll("[\\x00-\\x08\\x0b-\\x0c\\x0e-\\x1f]", "");
		return objectXmlDecoder(new ByteArrayInputStream(safeIns.getBytes("UTF-8")));
	}

	public static List objectXmlDecoder(InputStream ins) throws IOException,
			Exception {
		List objList = new ArrayList();
		XMLDecoder decoder = new XMLDecoder(ins);
		Object obj = null;
		try {
			while ((obj = decoder.readObject()) != null) {
				objList.add(obj);
			}
		} catch (Exception e) {
		}
		ins.close();
		decoder.close();
		return objList;
	}

}
