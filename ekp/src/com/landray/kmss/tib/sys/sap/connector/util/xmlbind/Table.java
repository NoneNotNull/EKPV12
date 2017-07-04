package com.landray.kmss.tib.sys.sap.connector.util.xmlbind;

import java.util.List;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

import org.apache.commons.beanutils.PropertyUtils;
import org.apache.commons.lang.StringUtils;

@XmlRootElement(name="table")
public class Table {
	
	private String name ;
	private String rows;
	private String isin;
	private String writeType;
	private String writeKey;
	
	@SuppressWarnings("unused")
	private String clocal;
	
	private List<Record> records;
	
	private String clocalExtend1;
	private String clocalExtend2;
	private String clocalExtend3;
	private String clocalExtend4;
	private String clocalExtend5;
	
	@XmlAttribute(name="name")
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	@XmlAttribute(name="rows")
	public String getRows() {
		return rows;
	}
	public void setRows(String rows) {
		this.rows = rows;
	}
	
	@XmlAttribute(name="isin")
	public String getIsin() {
		return isin;
	}
	public void setIsin(String isin) {
		this.isin = isin;
	}
	
	@XmlAttribute(name="writeType")
	public String getWriteType() {
		return writeType;
	}
	public void setWriteType(String writeType) {
		this.writeType = writeType;
	}
	
	@XmlAttribute(name="writeKey")
	public String getWriteKey() {
		return writeKey;
	}
	public void setWriteKey(String writeKey) {
		this.writeKey = writeKey;
	}
	
	@XmlElement(name="records",type=Record.class)
	public List<Record> getRecords() {
		return records;
	}
	public void setRecords(List<Record> records) {
		this.records = records;
	}
	
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
	

	public String getClocalExtend1() {
		return clocalExtend1;
	}
	public void setClocalExtend1(String clocalExtend1) {
		this.clocalExtend1 = clocalExtend1;
	}
	public String getClocalExtend2() {
		return clocalExtend2;
	}
	public void setClocalExtend2(String clocalExtend2) {
		this.clocalExtend2 = clocalExtend2;
	}
	public String getClocalExtend3() {
		return clocalExtend3;
	}
	public void setClocalExtend3(String clocalExtend3) {
		this.clocalExtend3 = clocalExtend3;
	}
	public String getClocalExtend4() {
		return clocalExtend4;
	}
	public void setClocalExtend4(String clocalExtend4) {
		this.clocalExtend4 = clocalExtend4;
	}
	public String getClocalExtend5() {
		return clocalExtend5;
	}
	public void setClocalExtend5(String clocalExtend5) {
		this.clocalExtend5 = clocalExtend5;
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
	

}
