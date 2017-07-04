package com.landray.kmss.tib.sys.sap.connector.util.xmlbind;
import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlValue;

@XmlRootElement(name="field")
public class Field {
	
	
	private String name ;
	private String title ;
	private String ctype;
	private String maxLength;
	private String decimals;
	private String isoptional;
	private String ekpId;
	private String dbiskey;
	private String ekpName;
	private String isBack;
	private String value ;

	@XmlAttribute(name="name")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@XmlAttribute(name="title")
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	@XmlAttribute(name="ctype")
	public String getCtype() {
		return ctype;
	}

	public void setCtype(String ctype) {
		this.ctype = ctype;
	}

	@XmlAttribute(name="maxlength")
	public String getMaxLength() {
		return maxLength;
	}

	public void setMaxLength(String maxLength) {
		this.maxLength = maxLength;
	}

	@XmlAttribute(name="decimals")
	public String getDecimals() {
		return decimals;
	}

	public void setDecimals(String decimals) {
		this.decimals = decimals;
	}

	@XmlAttribute(name="isoptional")
	public String getIsoptional() {
		return isoptional;
	}

	public void setIsoptional(String isoptional) {
		this.isoptional = isoptional;
	}

	@XmlAttribute(name="ekpid")
	public String getEkpId() {
		return ekpId;
	}

	public void setEkpId(String ekpId) {
		this.ekpId = ekpId;
	}

	@XmlAttribute(name="dbiskey")
	public String getDbiskey() {
		return dbiskey;
	}

	public void setDbiskey(String dbiskey) {
		this.dbiskey = dbiskey;
	}

	@XmlAttribute(name="ekpname")
	public String getEkpName() {
		return ekpName;
	}

	public void setEkpName(String ekpName) {
		this.ekpName = ekpName;
	}

	@XmlAttribute(name="isback")
	public String getIsBack() {
		return isBack;
	}

	public void setIsBack(String isBack) {
		this.isBack = isBack;
	}

	@XmlValue
	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}
	
	
	

}
