package com.landray.kmss.tib.jdbc.util;

public class JdbcOracleUtil{
	/**
	 * 验证是否是日期类型 
	 * @param columnType
	 * @return
	 */
    public static boolean  typeDate(String columnType){
    	return  columnType.toUpperCase().equals("DATE")?true:false;
    }
 
    /**
     * 验证是否是timestamp类型 
     * @param columnType
     * @return
     */
    public static boolean  typeTimesTamp(String columnType){
    	return  columnType.toUpperCase().equals("TIMESTAMP")?true:false;
    }
    
    
    /**
     * 验证是否是上面中的一种
     * @param columnType
     * @return
     */
    public static boolean  validateRQType4Oracle(String columnType){
    	return typeDate(columnType)||typeTimesTamp(columnType);
    }
    
	public  static boolean validataColumnType4RQ(String columnType) {
		return validateRQType4Oracle(columnType);
	}
	/**
	 * 根据字段类型转换成对应的日期时间字符串
	 * @param fieldInfor
	 * @return
	 */
	public String fieldTypeConvert(String fieldInfor){
		String arr[]=fieldInfor.split("|");
		String dataType=arr[1];
		String resultType="";
		String fieldColumn=arr[0];
		if(dataType.toUpperCase().equals("DATE")){
			resultType="char("+fieldColumn+",iso)||" + "'"+ " 00:00:00"+ "'";
		}else if(dataType.toUpperCase().equals("TIMESTAMP")){
			resultType="TO_CHAR(TIMESTAMP("+fieldColumn+"),'YYYY-MM-DD HH24:MI:SS')";
		}
		return resultType;
	
	}
}
