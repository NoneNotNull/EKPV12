package com.landray.kmss.tib.jdbc.util;

import org.apache.commons.lang.StringUtils;

public class JdbcSqlServerUtil{
	/**
	 * 
	 * @param columnType
	 * @return
	 */
	public static boolean typeSmallDateTime(String columnType) {
		return columnType.toUpperCase().equals("SMALLDATETIME") ? true : false;
	}

	/**
	 * 
	 * @param columnType
	 * @return
	 */
	public static boolean typeDate(String columnType) {
		return columnType.toUpperCase().equals("DATE") ? true : false;
	}

	/**
	 * 
	 * @param columnType
	 * @return
	 */
	public static boolean typeDateTime(String columnType) {
		return columnType.toUpperCase().equals("DATETIME") ? true : false;
	}

	/**
	 * 
	 * @param columnType
	 * @return
	 */
	public static boolean typeDateTime2(String columnType) {
		return columnType.toUpperCase().equals("DATETIME2") ? true : false;
	}

	/**
	 * 
	 * @param columnType
	 * @return
	 */
	public static boolean typeDateTimeOffset(String columnType) {
		return columnType.toUpperCase().equals("DATETIMEOFFSET") ? true : false;
	}

	/**
	 * 验证符合上面种的一种
	 * 
	 * @param columnType
	 * @return
	 */
	public static boolean validateRQType4SqlServer(String columnType) {
		return typeDate(columnType) || typeDateTime(columnType)
				|| typeDateTime2(columnType) || typeSmallDateTime(columnType)
				|| typeDateTimeOffset(columnType);
	}

	public static boolean validataColumnType4RQ(String columnType) {
		return validateRQType4SqlServer(columnType);
	}
	
	/**
	 * 验证是否是timestamp类型
	 */
	
	public static boolean validateColumnType4Timestamp(String columnType) {
		if (StringUtils.isNotEmpty(columnType)) {
			columnType = columnType.trim();
			int indexNum = columnType.indexOf("(");
			columnType = columnType.substring(0, indexNum);
			columnType=columnType.toUpperCase();
			if ("TIMESTAMP".equals(columnType)) {
				return true;
			} else {
				return false;
			}
		}
		  return false;
	}
}
