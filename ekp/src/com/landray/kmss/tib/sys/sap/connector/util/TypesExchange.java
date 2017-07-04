package com.landray.kmss.tib.sys.sap.connector.util;

import java.math.BigDecimal;
import java.text.ParseException;
import java.util.Date;

import org.apache.commons.beanutils.ConvertUtils;
import org.apache.commons.lang.time.DateUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.landray.kmss.tib.sys.sap.constant.MessageConstants;
import com.landray.kmss.tib.sys.sap.constant.QuartzCfg;
import com.landray.kmss.util.StringUtil;

public class TypesExchange {
	
	private static Log logger = LogFactory.getLog(TypesExchange.class);
	/**
	 * 数据类型转换
	 * @param type 类型
	 * @param value xml值
	 * @param useDefaultType 是否使用默认类型(true 则使用默认数据类型String,否则使用type参数的类型)
	 *                       例如数据库配置字符型参数，在xml上type是date型，则使用useDefaultType设置true
	 *                       反之。
	 * @param pattern 可空,表达式,用来对时间类型或者其他可需要类型扩展,把字符转换成表达式类型                     
	 * @return 
	 */
	public static Object exSwitchValue(String type,String value,boolean useDefaultType,String pattern)
	{
		//使用默认配置类型
		if(useDefaultType==QuartzCfg.EXCHANGE_TYPE_ISDEFAULT){
//			//======保留数据类型不转换，海信——需要=====
//			if(MessageConstants.java_int.equals(type)){
//				return ConvertUtils.convert(value, Integer.class);
//			}
//			//======保留数据类型不转换，海信——需要=====
			return 
			StringUtil.isNotNull(value)?value.toString():"";
		}
		
		
		if(MessageConstants.DOUBLE.equals(type))
		{
			 return  ConvertUtils.convert(value, Double.class);
		}
		else if(MessageConstants.java_int.equals(type))
		{
			 return ConvertUtils.convert(value, Integer.class);//useDefaultType?toInt(value):value;
		}
		//对于时间类型转换错误的话就直接返回字符串
		else if(MessageConstants.java_date.equals(type))
		{
			try {
				
				Object result=simpleConvert(value);
				if(result==null){
					if(logger.isDebugEnabled()){
					logger.debug("数据类型转换错误@ type:"+type+" \n value："+value+" 转换出空值,用字符串替代");
					}
					return value;
				}
				return result;
			} catch (Exception e) {
				//System.out.print("数据类型转换错误@"+TypesExchange.class.getName());
				if(logger.isDebugEnabled()){
				logger.debug("数据类型转换错误@ type:"+type+" \n value："+value+" \n exception:"+e);
				}
				return StringUtil.isNotNull(value)?value.toString():"";
			}
		}
		else if(MessageConstants.BIGDECIMAL.equals(type)){
				try {
					return ConvertUtils.convert(value, BigDecimal.class);
				} catch (Exception e) {
					//System.out.print("数据类型转换错误@"+TypesExchange.class.getName());
					logger.debug("数据类型转换错误@ type:"+type+" \n value："+value+" \n exception:"+e);
					return StringUtil.isNotNull(value)?value.toString():"";
				}
		}
		else if(MessageConstants.java_String.equals(type))
		{
			return StringUtil.isNotNull(value)?value.toString():"";
		}
		else
		{
			//其他类型统一转换字符类型
			return  StringUtil.isNotNull(value.toString())?value.toString():"";
		}
	}
	
	public static Object exSwitchValue(String type,String value,boolean useDefaultType){
		return exSwitchValue(type, value, useDefaultType, null);
	}
	
	
	public static Date simpleConvert(String dateString) {

		String[] pattern = new String[] { "yyyyMMdd", "yyyy-MM-dd", "yyyy/MM/dd",
				"yyyy-MM-dd HH:mm:ss", "yyyy/MM/dd HH:mm:ss","yyyyMMdd HH:mm:ss" };

		try {
			Date date = DateUtils.parseDate(dateString, pattern);
			if (date.getTime() > 0) {
				return date;
			} else {
				return null; 
			}
		} catch (ParseException e) {
			logger.debug("数据类型转换错误@ type:date \n value："+dateString+" \n exception:"+e);
			return null;
		}
	}
	
	
	
	public static boolean getBoolean(String s) {
		if (null == s || "".equals(s)) {
			return false;
		} else {
			return s.trim().equals("1") || s.trim().equalsIgnoreCase("true") ? true
					: false;
		}
	}
	

}
