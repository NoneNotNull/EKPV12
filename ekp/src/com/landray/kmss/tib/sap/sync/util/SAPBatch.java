package com.landray.kmss.tib.sap.sync.util;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.util.StringUtil;

/**
 * 用于组装批量更新，批量插入对象
 * @author zhangtian
 *
 * @version 2012-2-15
 */
public class SAPBatch implements Serializable  {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private Map<String,Object> params=new HashMap<String, Object>();
	private List<String> keyNames=new ArrayList<String>();
	private Map<String,String> keyNamesSAP=new HashMap<String,String>();
	private String dbId;
	private String tableName;
	
	SAPBatch(){
		 /*if(QuartzCfg.USE_FDID){
		    	this.params.put("fd_id", IDGenerator.generateID());
		    }*/
		
		/*//判断目标表是否存在fd_id，如果存在则自动按我们EKP的规则自动生成一个fd_id赋值进去，如不存在就不用管
		if(params!=null && params.containsKey("fd_id")){
	    	this.params.put("fd_id", IDGenerator.generateID());
	    }*/
		
	}
	public SAPBatch(Map<String,Object> params,List<String> keyNames,Map<String,String> keyNamesSAP, String dbId,String tableName) {
		// TODO Auto-generated constructor stub
	    this.params=params;
	    this.keyNames=keyNames;
	    this.dbId=dbId;
	    this.tableName=tableName;
	    this.keyNamesSAP=keyNamesSAP;
	    /*if(QuartzCfg.USE_FDID){
	    	this.params.put("fd_id", IDGenerator.generateID());
	    }*/
	    
	 /* //判断目标表是否存在fd_id，如果存在则自动按我们EKP的规则自动生成一个fd_id赋值进去，如不存在就不用管
		if(params!=null && params.containsKey("fd_id")){
	    	this.params.put("fd_id", IDGenerator.generateID());
	    }*/
	}
	public Map<String, Object> getParams() {
		return params;
	}
	public void setParams(Map<String, Object> params) {
		this.params = params;
	}
	public List<String> getKeyNames() {
		return keyNames;
	}
	public void setKeyNames(List<String> keyNames) {
		this.keyNames = keyNames;
	}
	public String getDbId() {
		return dbId;
	}
	public void setDbId(String dbId) {
		this.dbId = dbId;
	}
	public String getTableName() {
		return tableName;
	}
	public void setTableName(String tableName) {
		this.tableName = tableName;
	}
	public Map<String, String> getKeyNamesSAP() {
		return keyNamesSAP;
	}
	public void setKeyNamesSAP(Map<String, String> keyNamesSAP) {
		this.keyNamesSAP = keyNamesSAP;
	}
	public String hashKey(){
		StringBuffer sb=new StringBuffer();
		boolean first=true;
		for(String key : keyNames){
			if(first){
				first=false;
			}
			else{
				sb.append("_");				
			}
			sb.append(params.get(key));
		}
		return sb.toString();
	}
	
	/**
	 * 只支持字符串数据
	 * 组装sql使用 (key='value' and key1='value')
	 * @return
	 */
	public String getWhereBlock(){
		StringBuffer sb=new StringBuffer("(");
		boolean first=true;
		for(String key : keyNames){
			if(first){
				first=false;
			}
			else{
				sb.append(" and ");				
			}
			String param=StringUtil.isNotNull((String)params.get(key))?(String)params.get(key):"";
			sb.append(key+"='"+param+"'");
		}
		sb.append(")");
		return sb.toString();
	}
	
	public String getKeysVal(){
		
		StringBuffer sb=new StringBuffer("{");
		int index=0;
		int len =keyNames.size();
		for(String key : keyNames){
			sb.append(key+":"+params.get(key));
			if(index<len-1){
				sb.append(",");
			}
		}
		sb.append("}");
		
		return sb.toString();
	}
	

}
