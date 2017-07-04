package com.landray.kmss.tib.sys.sap.connector.util.xmlbind;

import java.util.List;

import javax.xml.bind.annotation.XmlAttribute;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlElementWrapper;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement(name = "jco")
public class Jco {

	
	private String id;
	
	private String name;
	
	private String timestamp;
	
	private String version;
	
	private Import importModel;
	
	private Export exportModel;
	
	private List<Table> tables;
	@XmlAttribute(name = "id")
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
	@XmlAttribute(name = "name")
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	@XmlAttribute(name = "timestamp")
	public String getTimestamp() {
		return timestamp;
	}

	public void setTimestamp(String timestamp) {
		this.timestamp = timestamp;
	}
	@XmlAttribute(name = "version")
	public String getVersion() {
		return version;
	}

	public void setVersion(String version) {
		this.version = version;
	}
	@XmlElement(name = "import", type = Import.class)
	public Import getImportModel() {
		return importModel;
	}

	public void setImportModel(Import importModel) {
		this.importModel = importModel;
	}
	@XmlElement(name = "export", type = Export.class)
	public Export getExportModel() {
		return exportModel;
	}
	public void setExportModel(Export exportModel) {
		this.exportModel = exportModel;
	}
	
	@XmlElementWrapper(name = "tables")
	@XmlElement(name = "table", type = Table.class)
	public List<Table> getTables() {
		return tables;
	}

	public void setTables(List<Table> tables) {
		this.tables = tables;
	}
	
	
	/**
	 * 根据名字取table
	 * @param tableName
	 * @return
	 */
	public Table getTablesByName(String tableName){
		for(Table table : tables){
			if(table.getName().equals(tableName)){
				return table;
			}
		}
		return null;
	}

}
