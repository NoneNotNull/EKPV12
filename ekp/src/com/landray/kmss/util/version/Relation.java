package com.landray.kmss.util.version;

import java.util.ArrayList;
import java.util.List;

/**
 * 创建日期 2010-十一月-05
 * 
 * @author 缪贵荣 关联信息
 */
public class Relation {

	/**
	 * 关联组件
	 */
	protected List<String> relationModuleList = new ArrayList<String>();

	public List<String> getRelationModuleList() {
		return relationModuleList;
	}

	public void setRelationModuleList(List<String> relationModuleList) {
		this.relationModuleList = relationModuleList;
	}

}
