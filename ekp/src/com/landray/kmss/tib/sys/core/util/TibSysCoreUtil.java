package com.landray.kmss.tib.sys.core.util;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.ArrayUtils;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.tib.sys.core.provider.model.TibSysCoreIface;
import com.landray.kmss.tib.sys.core.provider.plugins.TibSysCoreProviderPlugins;
import com.landray.kmss.tib.sys.core.provider.process.provider.interfaces.ITibSysCoreProvider;
import com.landray.kmss.tib.sys.core.provider.service.ITibSysCoreIfaceImplService;
import com.landray.kmss.tib.sys.core.provider.service.ITibSysCoreIfaceService;
import com.landray.kmss.tib.sys.core.provider.util.ProviderXmlOperation;
import com.landray.kmss.tib.sys.core.provider.vo.TibSysCoreProviderVo;
import com.landray.kmss.tib.sys.core.provider.vo.TibSysCoreStore;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

import edu.emory.mathcs.backport.java.util.Collections;

public class TibSysCoreUtil extends ProviderXmlOperation {
	/**
	 * 过滤器 处理特殊字符
	 * 
	 * @param value
	 * @return
	 */
	public static String filter(String src) {
		if (src == null)
			return null;
		String rtnVal = src.replaceAll("&", "&amp;");
		rtnVal = rtnVal.replaceAll("\"", "&quot;");
		rtnVal = rtnVal.replaceAll("<", "&lt;");
		rtnVal = rtnVal.replaceAll(">", "&gt;");
		rtnVal = rtnVal.replaceAll("'", "&#39;");
		return rtnVal;
	}
	
	public static String addSprit(String src){
		String str = src.replaceAll("\"","\\\\\""); 
		return str;
	}
	
	
	/**
	 * 异常信息转字符串,方便用来记录异常
	 * @param throwable
	 * @return
	 */
    public static String getStackTraceString(Throwable throwable){
    	  StringWriter sw = new StringWriter();
          PrintWriter pw = new PrintWriter(sw, true);
          throwable.printStackTrace(pw);
          pw.flush();
          sw.flush();
          return sw.toString();
    }
    
    /**
     * 通过传入xml数据获取属性值
     * @param doc
     * @return
     * @throws Exception
     */
    public static String parseKey(Document doc) throws Exception {
		NodeList nodeList = doc.getElementsByTagName("tib");
		for (int i = 0, len = nodeList.getLength(); i < len; i++) {
			Node node = nodeList.item(i);
			if (node.getNodeType() == Node.ELEMENT_NODE) {
				Node attrNode = node.getAttributes().getNamedItem("key");
				if (attrNode != null) {
					String value = attrNode.getNodeValue();
					return value;
				}
			}
		}
		throw new Exception("解析不出对应key:");
	}
    
    /**
     * 通过传入xml数据获取属性值
     * @param doc
     * @return
     * @throws Exception
     */
    public static String parseAttrValue(Object obj, String attrName) throws Exception {
    	Document doc = null;
    	if (obj instanceof String) {
    		doc = stringToDoc(String.valueOf(obj));
    	} else if (obj instanceof Document){
    		doc = (Document)obj;
    	}
    	NodeList nodeList = doc.getElementsByTagName("tib");
    	for (int i = 0, len = nodeList.getLength(); i < len; i++) {
    		Node node = nodeList.item(i);
    		if (node.getNodeType() == Node.ELEMENT_NODE) {
    			Node attrNode = node.getAttributes().getNamedItem(attrName);
    			if (attrNode != null) {
    				String value = attrNode.getNodeValue();
    				return value;
    			}
    		}
    	}
    	return null;
    }
    
    //找全部实现
    public static List<TibSysCoreProviderVo> findServiceList(String key) throws Exception {
    	List<TibSysCoreProviderVo> providerVoList = new ArrayList<TibSysCoreProviderVo>();
    	// 扩展点找实现（排除sap、soap）
    	List<Map<String, String>> pList = TibSysCoreProviderPlugins.getConfigs();
    	for (Map<String, String> pMap : pList) {
    		String pluginKey = pMap.get("key");
    		if (pluginKey == null || "sap".equals(pluginKey) || "soap".equals(pluginKey)) {
    			continue;
    		}
    		// 判断是否包含key
    		boolean flag = ArrayUtils.contains(pluginKey.split(";"), key);
    		TibSysCoreProviderVo providerVo = new TibSysCoreProviderVo();
    		if (flag) {
    			String beanName = pMap.get("executeClass");
    			String orderBy = pMap.get("orderBy");
            	ITibSysCoreProvider provider = (ITibSysCoreProvider) SpringBeanUtil.getBean(beanName);
            	providerVo.setITibSysCoreProvider(provider);
            	providerVo.setOrderBy(orderBy == null ? "" : orderBy);
            	providerVoList.add(providerVo);
    		}
    	}
    	// 数据库找接口实现（此情况存在函数id）
    	HQLInfo hqlInfo = new HQLInfo();
    	hqlInfo.setSelectBlock("tibSysCoreIfaceImpl.fdImplRef, tibSysCoreIfaceImpl.fdFuncType, " +
    			"tibSysCoreIfaceImpl.fdImplRefData, tibSysCoreIfaceImpl.fdOrderBy");
    	hqlInfo.setWhereBlock("tibSysCoreIfaceImpl.tibSysCoreIface.fdIfaceKey=:fdIfaceKey");
    	hqlInfo.setParameter("fdIfaceKey", key);
    	ITibSysCoreIfaceImplService implService = (ITibSysCoreIfaceImplService) SpringBeanUtil
    			.getBean("tibSysCoreIfaceImplService");
    	List<Object[]> objList = implService.findValue(hqlInfo);
    	for (Object[] objs : objList) {
    		TibSysCoreProviderVo providerVo = new TibSysCoreProviderVo();
    		providerVo.setFuncId(String.valueOf(objs[0]));
    		Map<String, String> map = TibSysCoreProviderPlugins.getConfigByKey(String.valueOf(objs[1]));
    		ITibSysCoreProvider provider = (ITibSysCoreProvider) SpringBeanUtil
    				.getBean(map.get("executeClass"));
    		providerVo.setITibSysCoreProvider(provider);
    		providerVo.setFuncMappData(String.valueOf(objs[2]));
    		String orderBy = String.valueOf(objs[3]);
    		providerVo.setOrderBy(orderBy == null ? "" : orderBy);
    		providerVoList.add(providerVo);
    	}
    	// 排序
    	Collections.sort(providerVoList, new Comparator(){
			public int compare(Object o1, Object o2) {
				String orderBy1 = ((TibSysCoreProviderVo)o1).getOrderBy();
				String orderBy2 = ((TibSysCoreProviderVo)o2).getOrderBy();
				int flag = orderBy1.compareTo(orderBy2);
				return flag;
			}
    	});
    	return providerVoList;
    }
    
	/**
	 * 根据key查找目标数据库数据
	 * @param key
	 * @return
	 * @throws Exception
	 */
	public static TibSysCoreIface getTibSysCoreIface(String key) throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock(" fdIfaceKey = :fdIfaceKey ");
		hqlInfo.setParameter("fdIfaceKey", key);
		ITibSysCoreIfaceService tibSysCoreIfaceService= (ITibSysCoreIfaceService)SpringBeanUtil.getBean("tibSysCoreIfaceService");
		List<TibSysCoreIface> results = tibSysCoreIfaceService
				.findList(hqlInfo);
		if (results != null && !results.isEmpty()) {
			return results.get(0);
		} else {
			return null;
		}

	}
	
	/**
	 * 找key对应的映射信息
	 * @param key
	 * @param implFuncId
	 * @param data
	 * @return
	 * @throws Exception
	 */
	public static TibSysCoreStore getTibSysCoreStore(String key, String implFuncId, 
			Object data) throws Exception {
		TibSysCoreStore coreStore = null;
		TibSysCoreIface iface = TibSysCoreUtil.getTibSysCoreIface(key);
		if (data != null && data instanceof String) {
			Document dataDoc = stringToDoc((String)data);
			Element rootEle = dataDoc.getDocumentElement();
			String id = rootEle.getAttribute("id");
			String modelName = rootEle.getAttribute("modelname");
			String tagdb = rootEle.getAttribute("tagdb");
			String control = rootEle.getAttribute("control");
			// 填写VO信息
			coreStore = new TibSysCoreStore(key, control, implFuncId, iface.getFdIfaceXmlTrans(), 
					id, modelName, tagdb);
		} else {
			// 填写VO信息
			coreStore = new TibSysCoreStore(key, implFuncId, iface.getFdIfaceXmlTrans());
		}
		return coreStore;
	}
	
	/**
	 * 设置组件模版内容，即匹配映射数据
	 * @param templateNodeList
	 * @param dataDoc
	 * @param xpath
	 * @param realXPath
	 * @param mappJsonArray
	 * @throws Exception
	 */
	public static void setTemplateXmlLoop(NodeList templateNodeList, Document dataDoc, 
			String xpath, String realXPath, JSONArray mappJsonArray) throws Exception {
		for (int i = 0, len = templateNodeList.getLength(); i < len; i++) {
			if (mappJsonArray.size() == 0) {
				break;
			}
			Node templateNode = templateNodeList.item(i);
			if (templateNode.getNodeType() == Node.ELEMENT_NODE) {
				String nodeName = templateNode.getNodeName();
				int index = nodeName.indexOf(":");
				if (index != -1) {
					nodeName = nodeName.substring(index + 1);
				}
				String newRealXPath = xpath + "/" + nodeName;
				Node attrNode = templateNode.getAttributes().getNamedItem("name");
				if (attrNode != null) {
					nodeName = attrNode.getNodeValue();
				}
				String newXpath = xpath + "/" + nodeName;
				for (Iterator<JSONObject> it = mappJsonArray.iterator(); it.hasNext();) {
					JSONObject jsonObject = it.next(); 
					String sourceXPath = jsonObject.getString("sourceXPath");
					String targetXPath = jsonObject.getString("targetXPath");
					//System.out.println("targetXPath="+targetXPath+",newXpath="+newXpath+",sourceXPath="+sourceXPath);
					if (targetXPath.equals(newXpath)) {
						List<Element> eleList = selectElement(sourceXPath, dataDoc);
						for (int j = 0; j < eleList.size(); j++) {
							Element ele = eleList.get(j);
							if (j == 0) {
								// 设置节点值
								copyTextContent(templateNode, ele);
							} else {
								// 多值情况处理
								Document templateDoc = templateNode.getOwnerDocument();
								List<Element> eleSizeList = selectElement(newRealXPath, templateDoc);
								if (eleSizeList.size() > j) {
									// 存在节点
									Element sizeEle = eleSizeList.get(j);
									// 设置节点值
									copyTextContent(sizeEle, ele);
								} else {
									// 不存在节点，则克隆此节点
									Element cloneEle = templateDoc.createElement(templateNode.getNodeName());
									// 设置节点值
									copyTextContent(cloneEle, ele);
									templateNode.getParentNode().appendChild(cloneEle);
									if (templateNode.hasChildNodes()) {
										cloneNodeLoop(templateDoc, templateNode.getChildNodes(), cloneEle);
									}
								}
							}
						}
						it.remove();
					}
				}
				// 递归
				if (templateNode.hasChildNodes()) {
					setTemplateXmlLoop(templateNode.getChildNodes(), dataDoc, 
							newXpath, newRealXPath, mappJsonArray);
				}
			}
		}
	}
	
	private static void cloneNodeLoop(Document doc, NodeList templateNodeList, Element cloneEle) {
		for (int i = 0; i < templateNodeList.getLength(); i++) {
			Node node = templateNodeList.item(i);
			if (node.getNodeType() == Node.ELEMENT_NODE) {
				Element childCloneEle = doc.createElement(node.getNodeName());
				cloneEle.appendChild(childCloneEle);
				if (node.hasChildNodes()) {
					cloneNodeLoop(doc, node.getChildNodes(), childCloneEle);
				}
			}
		}
	}
	
	/**
	 * 对应设置内容
	 * @param nodeList
	 * @param store
	 * @param xpath
	 * @param buf
	 */
	public static void loopXMLUnite(NodeList nodeList, StringBuffer buf) {
		int count = 0;
		for (int i = 0, len = nodeList.getLength(); i < len; i++) {
			Node node = nodeList.item(i);
			if (node.getNodeType() == Node.ELEMENT_NODE) {
				count ++;
				// 超过100条数据则不再显示
				if (count > 100) {
					break;
				}
				Element ele = (Element)node;
				String tagName = ele.getTagName();
				String newTagName = ele.getAttribute("name");
				if (StringUtil.isNotNull(newTagName)) {
					tagName = newTagName; 
				}
				Node textEle = node.getFirstChild();
				// 判断是否存在内容
				if (textEle != null && textEle.getNodeType() == Node.TEXT_NODE) {
					buf.append("<"+ tagName +">");
					buf.append(textEle.getNodeValue());
					// 内容也是一个节点，所以要继续遍历（防止内容下一个还有节点）
					loopXMLUnite(node.getChildNodes(), buf);
					buf.append("</"+ tagName +">");
				} else {
					// 判断是否有子节点，没有则使用结束符，节省执行结果显示空间。
					if (node.hasChildNodes()) {
						buf.append("<"+ tagName +">");
						loopXMLUnite(node.getChildNodes(), buf);
						buf.append("</"+ tagName +">");
					} else {
						buf.append("<"+ tagName +"/>");
					}
				}
			}
		}
	}
	
	/**
	 * 对应设置内容
	 * @param nodeList
	 * @param store
	 * @param xpath
	 * @param buf
	 */
//	public void loopXMLUnite(NodeList nodeList, TibSysCoreStore coreStore, String xpath, StringBuffer buf) {
//		int count = 0;
//		for (int i = 0, len = nodeList.getLength(); i < len; i++) {
//			Node node = nodeList.item(i);
//			if (node.getNodeType() == Node.ELEMENT_NODE) {
//				count ++;
//				// 超过100条数据则不再显示
//				if (count > 100) {
//					break;
//				}
//				Element ele = (Element)node;
//				String tagName = ele.getTagName();
//				tagName = tagName.substring(tagName.indexOf(":") + 1);
//				String nameAttr = ele.getAttribute("name");
////				if (StringUtil.isNotNull(nameAttr)) {
////					tagName = nameAttr; 
////				}
//				// xpath
//				String newXpath = xpath + "/" + tagName;
//				List<TibSysCoreNode> coreNodeList = store.findNodeByNodePath(newXpath);
//				if (coreNodeList.isEmpty()) {
//					if (node.hasChildNodes()) {
//						loopXMLUnite(node.getChildNodes(), store, newXpath, buf);
//					}
//				} else {
//					// 遍历多个相同节点
//					for (TibSysCoreNode coreNode : coreNodeList) {
//						if (StringUtil.isNull(nameAttr)) {
//							nameAttr = tagName;
//						}
//						if  (nameAttr.equals(coreNode.getFdNodeName())) {
//							Node textEle = node.getFirstChild();
//							// 判断是否存在内容
//							if (textEle != null && textEle.getNodeType() == Node.TEXT_NODE) {
//								buf.append("<"+ coreNode.getFdDefName() +">");
//								buf.append(textEle.getNodeValue());
//								// 内容也是一个节点，所以要继续遍历（防止内容下一个还有节点）
//								loopXMLUnite(node.getChildNodes(), store, newXpath, buf);
//								buf.append("</"+ coreNode.getFdDefName() +">");
//							} else {
//								// 判断是否有子节点，没有则使用结束符，节省执行结果显示空间。
//								if (node.hasChildNodes()) {
//									buf.append("<"+ coreNode.getFdDefName() +">");
//									loopXMLUnite(node.getChildNodes(), store, newXpath, buf);
//									buf.append("</"+ coreNode.getFdDefName() +">");
//								} else {
//									buf.append("<"+ coreNode.getFdDefName() +"/>");
//								}
//							}
//							
//						}
//					}
//				}
//			}
//		}
//	}
	
}
