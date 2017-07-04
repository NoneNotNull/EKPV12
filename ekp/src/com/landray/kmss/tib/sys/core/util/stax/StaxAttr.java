package com.landray.kmss.tib.sys.core.util.stax;



/**
 * 组装属性
 * @author zhangtian
 * date :2012-8-8 上午05:25:39
 */
public class StaxAttr {
	private String key;
	private String value ;
	
	public StaxAttr(String key ,String value){
		this.key=key;
		this.value=value ;
	}
	
	public StaxAttr(){}
	
	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	


}
