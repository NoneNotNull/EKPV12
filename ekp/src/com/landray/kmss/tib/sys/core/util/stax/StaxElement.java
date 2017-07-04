package com.landray.kmss.tib.sys.core.util.stax;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 组装一个节点
 * 
 * @author zhangtian date :2012-8-8 上午05:25:19
 */
public class StaxElement {

	private String tagName;
	private String nodeValue;
	private Map<String, StaxAttr> attrs;
	//private boolean isWarp;
	// 如果是数组,包裹一层
	//private String defalutWarp = "_S";
	private List<StaxElement>  childStaxElement=new ArrayList<StaxElement>();
	
	public StaxElement(String tagName){
		this.tagName = tagName;
	}

	public StaxElement(String tagName, String nodeValue, Map<String, StaxAttr> attrMap) {
		this.tagName = tagName;
		this.nodeValue = nodeValue;
//		this.isWarp = false;
		mergeAttrs(attrMap);
	}

	public StaxElement(String tagName, String nodeValue,
			Map<String, StaxAttr> attrMap, boolean isWarp) {
		this.tagName = tagName;
		this.nodeValue = nodeValue;
//		this.isWarp = isWarp;
		mergeAttrs(attrMap);
	}

	public StaxElement(String tagName, String nodeValue,
			Map<String, StaxAttr> attrMap, boolean isWarp, String warpPre) {
		this.tagName = tagName;
		this.nodeValue = nodeValue;
		mergeAttrs(attrMap);
	}

	public void mergeAttrs(Map<String, StaxAttr> attrMap) {
		if (attrMap != null) {
			if (attrs == null) {
				this.attrs = new HashMap<String, StaxAttr>();
			}

			for (String key : attrMap.keySet()) {
				attrs.put(key, attrMap.get(key));
			}
		}

	}

	public void addAttr(StaxAttr attr) {
		if (attrs == null) {
			this.attrs = new HashMap<String, StaxAttr>();
		}
		attrs.put(attr.getKey(), attr);
	}

	public StaxAttr getAttrByKey(String key) {
		return attrs.get(key);
	}

	public String getTagName() {
		return tagName;
	}

	public void setTagName(String tagName) {
		this.tagName = tagName;
	}

	public String getNodeValue() {
		return nodeValue;
	}

	public void setNodeValue(String nodeValue) {
		this.nodeValue = nodeValue;
	}

	public Map<String, StaxAttr> getAttrs() {
		return attrs;
	}

	public void setAttrs(Map<String, StaxAttr> attrs) {
		this.attrs = attrs;
	}

	public List<StaxElement> getChildStaxElement() {
		return childStaxElement;
	}

	public void setChildStaxElement(List<StaxElement> childStaxElement) {
		this.childStaxElement = childStaxElement;
	}

//	public boolean isWarp() {
//		return isWarp;
//	}
//
//	public void setWarp(boolean isWarp) {
//		this.isWarp = isWarp;
//	}
//
//	public String getDefalutWarp() {
//		return defalutWarp;
//	}
//
//	public void setDefalutWarp(String defalutWarp) {
//		this.defalutWarp = defalutWarp;
//	}

}
