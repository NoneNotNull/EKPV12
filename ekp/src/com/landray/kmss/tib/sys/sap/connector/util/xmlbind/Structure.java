package com.landray.kmss.tib.sys.sap.connector.util.xmlbind;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name="structure")
public class Structure {
	
	private String name ;
	List<Field> fields;
	
	@XmlAttribute(name="name")
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	@XmlElement(name="field",type=Field.class)
	public List<Field> getFields() {
		return fields;
	}
	public void setFields(List<Field> fields) {
		this.fields = fields;
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
	
	

}
