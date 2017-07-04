package com.landray.kmss.tib.sys.sap.connector.util.xmlbind;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement(name="records")
public class Record {
	
	private String row;
	private List<Field> fields;
	
	@XmlAttribute(name="row")
	public String getRow() {
		return row;
	}
	public void setRow(String row) {
		this.row = row;
	}
	
	@XmlElement(name="field")
	public List<Field> getFields() {
		return fields;
	}
	public void setFields(List<Field> fields) {
		nameFieleKey.clear();
		this.fields = fields;
	}
	
	public transient Map<String, Field> nameFieleKey =new HashMap<String, Field>();
	
	public Field getFieldByName(String name){
//		if(nameFieleKey.size()==0){
			for(Field field:fields){
				nameFieleKey.put(field.getName(), field);
			}
//		}
		return nameFieleKey.get(name);
	}
	

}
