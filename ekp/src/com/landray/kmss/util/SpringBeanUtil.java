package com.landray.kmss.util;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.springframework.context.ApplicationContext;

public class SpringBeanUtil {
	private static ApplicationContext applicationContext = null;

	/**
	 * 判断是否SpringBeanUtil是否已经初时化
	 * 
	 * @return
	 */
	public static boolean isInit() {
		return applicationContext != null;
	}

	/**
	 * 获取spring的applicationContext
	 * 
	 * @return
	 */
	public static ApplicationContext getApplicationContext() {
		return applicationContext;
	}

	/**
	 * 设置spring的applicationContext
	 * 
	 * @param applicationContext
	 */
	public static void setApplicationContext(
			ApplicationContext applicationContext) {
		SpringBeanUtil.applicationContext = applicationContext;
	}

	/**
	 * 根据类型返回bean列表
	 * 
	 * @param type
	 * @return
	 */
	public static List getBeansForType(Class type) {
		if (applicationContext == null)
			return null;
		String[] beanNameArr = applicationContext.getBeanNamesForType(type);
		List beanNameList = Arrays.asList(beanNameArr);
		List beanList = new ArrayList();
		for (int i = 0; i < beanNameArr.length; i++) {
			if (beanNameArr[i].endsWith("Target")) {
				String serviceBeanName = beanNameArr[i].substring(0,
						beanNameArr[i].length() - 6)
						+ "Service";
				if (!beanNameList.contains(serviceBeanName))
					beanList.add(applicationContext.getBean(beanNameArr[i]));
			} else {
				beanList.add(applicationContext.getBean(beanNameArr[i]));
			}
		}
		return beanList;
	}

	/**
	 * 根据类型返回bean列表（去除exceptBeanName）
	 * 
	 * @param type
	 * @param exceptBeanName
	 * @return
	 */
	public static List getBeansForType(Class type, String exceptBeanName) {
		if (applicationContext == null)
			return null;
		String[] beanNameArr = applicationContext.getBeanNamesForType(type);
		List beanNameList = Arrays.asList(beanNameArr);
		List beanList = new ArrayList();
		for (int i = 0; i < beanNameArr.length; i++) {
			if (beanNameArr[i].equals(exceptBeanName))
				continue;
			if (beanNameArr[i].endsWith("Target")) {
				String serviceBeanName = beanNameArr[i].substring(0,
						beanNameArr[i].length() - 6)
						+ "Service";
				if (!beanNameList.contains(serviceBeanName))
					beanList.add(applicationContext.getBean(beanNameArr[i]));
			} else {
				beanList.add(applicationContext.getBean(beanNameArr[i]));
			}
		}
		return beanList;
	}

	/**
	 * 根据名称获取spring的bean
	 * 
	 * @param beanName
	 * @return
	 */
	public static Object getBean(String beanName) {
		if (applicationContext == null)
			return null;
		return applicationContext.getBean(beanName);
	}
}
