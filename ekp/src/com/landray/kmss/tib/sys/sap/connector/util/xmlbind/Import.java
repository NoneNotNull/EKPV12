package com.landray.kmss.tib.sys.sap.connector.util.xmlbind;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang.StringUtils;

@XmlRootElement(name="import")
public class Import {
	
	@SuppressWarnings("unused")
	private String clocal;
	private String clocalExtend1;
	private String clocalExtend2;
	private String clocalExtend3;
	private String clocalExtend4;
	private String clocalExtend5;
	
	private List<Field> fields;
	private List<Structure> structures;
	
	@XmlAttribute(name="clocal")
	public String getClocal() {
		StringBuffer buf=new StringBuffer("");
		if(StringUtils.isEmpty(clocalExtend1))
			return null;
		buf.append(clocalExtend1);
		
		if(StringUtils.isEmpty(clocalExtend2))
			return buf.toString();
		buf.append(":"+clocalExtend2);
		
		if(StringUtils.isEmpty(clocalExtend3))
			return buf.toString();
		buf.append(":"+clocalExtend3);
		
		if(StringUtils.isEmpty(clocalExtend4))
			return buf.toString();
		buf.append(":"+clocalExtend4);
		
		if(StringUtils.isEmpty(clocalExtend5))
			return buf.toString();
		buf.append(":"+clocalExtend5);
		
		return buf.toString();
	}
	public void setClocal(String clocal) {
		emptyClocal();
		if(StringUtils.isNotEmpty(clocal)){
			String[] array=StringUtils.split(clocal,":");
			resetClocal(array);
		}
		this.clocal = getClocal();
	}
	@XmlElement(name="field")
	public List<Field> getFields() {
		return fields;
	}
	public void setFields(List<Field> fields) {
		this.fields = fields;
	}
	
	@XmlElement(name="structure")
	public List<Structure> getStructures() {
		return structures;
	}
	public void setStructures(List<Structure> structures) {
		this.structures = structures;
	}
	
	private void emptyClocal(){
		this.clocalExtend1=null;
		this.clocalExtend2=null;
		this.clocalExtend3=null;
		this.clocalExtend4=null;
		this.clocalExtend5=null;
		this.clocal=null;
	}
	
	private void resetClocal(String[] str){
		String pre_field="clocalExtend";
		for(int i=0,len=5,maxLen=str.length;i<len&&i<maxLen;i++){
		     String temp=str[i];
		     String fieldName=pre_field+(i+1);
		     if(PropertyUtils.isWriteable(this, fieldName)){
		    	 try {
					PropertyUtils.setProperty(this, fieldName, temp);
				} catch (Exception e){
					System.out.println("error 转换字段 "+fieldName+" in "+this.getClass());
				}
		     }
		}
		
	}
	
	// 添加可快速搜索到field的方法
	public transient Map<String, Field> nameFieleKey =new HashMap<String, Field>();
	public Field getFieldByName(String name){
//		if(nameFieleKey.size()==0){
			for(Field field:fields){
				nameFieleKey.put(field.getName(), field);
			}
//		}
		return nameFieleKey.get(name);
	}
	
	
	/**
	 * 根据名字取table
	 * @param tableName
	 * @return
	 */
	public Structure getStructureByName(String structureName){
		for(Structure structure : structures){
			if(structure.getName().equals(structureName)){
				return structure;
			}
		}
		return null;
	}
	
	

}
