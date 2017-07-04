package com.landray.kmss.tib.sap.mapping.plugins.controls;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.codec.binary.Base64;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.Text;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.sys.xform.base.service.controls.relation.RelationParamsField;
import com.landray.kmss.sys.xform.base.service.controls.relation.RelationParamsTemplate;
import com.landray.kmss.tib.common.mapping.plugins.control.ITibCommonMappingControlDispatcher;
import com.landray.kmss.tib.common.mapping.plugins.control.TibCommonMappingControlTreeVo;
import com.landray.kmss.tib.common.util.DomUtil;
import com.landray.kmss.tib.sys.sap.connector.interfaces.ITibSysSapJcoFunctionUtil;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcCategory;
import com.landray.kmss.tib.sys.sap.connector.model.TibSysSapRfcSetting;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapRfcCategoryService;
import com.landray.kmss.tib.sys.sap.connector.service.ITibSysSapRfcSettingService;
import com.landray.kmss.tib.sys.sap.connector.util.TibSysSapReturnVo;
import com.landray.kmss.util.IDGenerator;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

public class TibSapControlTreeInfo extends HibernateDaoSupport implements ITibCommonMappingControlDispatcher {
	
	private ITibSysSapRfcCategoryService tibSysSapRfcCategoryService;
	
	private ITibSysSapRfcSettingService tibSysSapRfcSettingService;

	public ITibSysSapRfcSettingService getTibSysSapRfcSettingService() {
		return tibSysSapRfcSettingService;
	}

	public void setTibSysSapRfcSettingService(
			ITibSysSapRfcSettingService tibSysSapRfcSettingService) {
		this.tibSysSapRfcSettingService = tibSysSapRfcSettingService;
	}

	public ITibSysSapRfcCategoryService getTibSysSapRfcCategoryService() {
		return tibSysSapRfcCategoryService;
	}

	public void setTibSysSapRfcCategoryService(
			ITibSysSapRfcCategoryService tibSysSapRfcCategoryService) {
		this.tibSysSapRfcCategoryService = tibSysSapRfcCategoryService;
	}


	public List<TibCommonMappingControlTreeVo> getCateInfo(String selectId,String pluginKey) throws Exception {
		
			List<TibCommonMappingControlTreeVo> cateList=new ArrayList<TibCommonMappingControlTreeVo>(1);
		
			HQLInfo hqlInfo = new HQLInfo();
			String whereBlock="";
			if (StringUtil.isNull(selectId)) {
				whereBlock = " tibSysSapRfcCategory.hbmParent.fdId is null ";
			} else {
				whereBlock = " tibSysSapRfcCategory.hbmParent.fdId=:hbmParentFdId ";
				hqlInfo.setParameter("hbmParentFdId", selectId);
			}
			
			hqlInfo.setWhereBlock(whereBlock);
			hqlInfo.setOrderBy(" tibSysSapRfcCategory.fdOrder ");
			List<TibSysSapRfcCategory> resList = (List<TibSysSapRfcCategory>)tibSysSapRfcCategoryService.findList(hqlInfo);
			for (Iterator<TibSysSapRfcCategory> iterator = resList.iterator(); iterator.hasNext();) {
				TibSysSapRfcCategory tibSysSapRfcCategory = iterator
						.next();
				TibCommonMappingControlTreeVo tibSysCateVo =new TibCommonMappingControlTreeVo(tibSysSapRfcCategory.getFdId(),tibSysSapRfcCategory.getFdName(),pluginKey);
				cateList.add(tibSysCateVo);
			}
			return cateList;
	}
	
	public List<TibCommonMappingControlTreeVo> getFuncDataList(String cateId,String pluginKey) throws Exception{
		
		String whereBlock = "tibSysSapRfcSetting.docIsNewVersion = '1' ";
		List<TibCommonMappingControlTreeVo> tibSysFuncVos=new ArrayList<TibCommonMappingControlTreeVo>();
		HQLInfo hqlFunc=new HQLInfo();
		if (StringUtil.isNull(cateId)) {
			whereBlock += " and tibSysSapRfcSetting.fdUse=1 and tibSysSapRfcSetting.docOriginDoc =null";
			hqlFunc.setWhereBlock(whereBlock);
		} else {
			String inStr = "";
			List<?> tibSysSapRfcCategoryFdIdList = new ArrayList();
			HQLInfo hqlInfoCate = new HQLInfo();
			hqlInfoCate.setSelectBlock("tibSysSapRfcCategory.fdId");
			hqlInfoCate.setWhereBlock("tibSysSapRfcCategory.fdHierarchyId like :fdHierarchyId");
			hqlInfoCate.setParameter("fdHierarchyId", "%" + cateId + "%");
			tibSysSapRfcCategoryFdIdList = tibSysSapRfcCategoryService.findValue(hqlInfoCate);
			
			for (Iterator iterator = tibSysSapRfcCategoryFdIdList.iterator(); iterator
					.hasNext();) {
				String idTmp = (String) iterator.next();
				inStr += "".equals(inStr) ? ("'" + idTmp + "'") : (",'"
						+ idTmp + "'");
			}
			whereBlock += " and tibSysSapRfcSetting.docCategory.fdId in ("
					+ inStr
					+ ") and tibSysSapRfcSetting.fdUse=1 and tibSysSapRfcSetting.docOriginDoc =null";
			hqlFunc.setWhereBlock(whereBlock);
		}
		List<TibSysSapRfcSetting> resList = tibSysSapRfcSettingService.findList(hqlFunc);
		for (Iterator iterator = resList.iterator(); iterator.hasNext();) {
			TibSysSapRfcSetting tibSysSapRfcSetting = (TibSysSapRfcSetting) iterator.next();
			TibCommonMappingControlTreeVo tsv=new TibCommonMappingControlTreeVo(tibSysSapRfcSetting.getFdId(),tibSysSapRfcSetting.getFdFunctionName(),pluginKey);
			tibSysFuncVos.add(tsv);
		}
		return tibSysFuncVos;
	}

	public String getTemplateXml(String funcId) throws Exception {
		ITibSysSapJcoFunctionUtil tibSysSapJcoFunctionUtil = (ITibSysSapJcoFunctionUtil) SpringBeanUtil
			.getBean("tibSysSapJcoFunctionUtil");
		String funcXml = (String) tibSysSapJcoFunctionUtil
			.getFunctionToXmlById(funcId);
		return funcXml;
	}

	/**
	 * 设置 模版
	 * @param nodeList
	 * @param xpath		初始为/，拼成后为//nodeName1/nodeName2/...
	 * @throws Exception
	 */
	private void loopSetTemplate(NodeList nodeList, List<RelationParamsField> 
			paramsField, String xpath, String namePath) throws Exception {
		for (int i = 0, len = nodeList.getLength(); i < len; i++) {
			Node curNode = nodeList.item(i);
			if (curNode != null && Node.ELEMENT_NODE == curNode.getNodeType()) {
				String nodeName = curNode.getNodeName();
				NamedNodeMap attrMap = curNode.getAttributes();
				Node nameNode = attrMap.getNamedItem("name");
				Node titleNode = attrMap.getNamedItem("title");
				// 设置显示的名字
				String curNamePath = namePath;
				if (nameNode != null) {
					String name = nameNode.getNodeValue();
					// 设置显示的名字
					if (titleNode != null && !"".equals(titleNode.getNodeValue())) {
						curNamePath = namePath.equals("") ? titleNode.getNodeValue() : namePath +"."+ titleNode.getNodeValue(); 
					} else {
						curNamePath = namePath.equals("") ? name : namePath +"."+ name;
					}
					String curXpath = xpath +"/"+ nodeName +"[@name='"+ name +"']";
					RelationParamsField childField = new RelationParamsField();
					// 设置唯一值xpath
					childField.setUuId(new String(Base64.encodeBase64(curXpath.getBytes())));
					childField.set_xpath(curXpath);
					// 设置节点名
					childField.setFieldId(curXpath.replace("//", "").replaceAll("/", "."));
					// 是否有子节点
					if (!"field".equals(nodeName)) {
						// 表格和结构体的情况
						loopSetTemplate(curNode.getChildNodes(), paramsField, curXpath, curNamePath);
					} else {
						// 普通参数情况
						Node ctypeNode = attrMap.getNamedItem("ctype");
						if (ctypeNode != null) {
							String ctype = ctypeNode.getNodeValue();
							String maxlength = attrMap.getNamedItem("maxlength").getNodeValue();
							String isoptional = attrMap.getNamedItem("isoptional").getNodeValue();
							Node dispNode = attrMap.getNamedItem("disp");
							childField.set_multi("0");
							childField.set_ctype(ctype);
							childField.set_minlength("0");
							childField.set_maxlength(maxlength);
							childField.set_required(isoptional.equals("true") ? "1" : "0");
							if (dispNode != null) {
								//childField.set_disp(dispNode.getNodeValue());
							}
							childField.setFieldName(curNamePath);
						} 
						paramsField.add(childField);
					}
				} else if (curNode.hasChildNodes()){
					// 不存在name属性，但有子节点继续遍历
					String curXpath = xpath +"/"+ nodeName;
					loopSetTemplate(curNode.getChildNodes(), paramsField, curXpath, curNamePath);
				}
			}
		}
	}

	public RelationParamsTemplate getParamsTemplate(String key, String fdData)
			throws Exception {
		RelationParamsTemplate paramsTemplate = new RelationParamsTemplate();
		paramsTemplate.set_source("TIB_SAP");
		paramsTemplate.set_key(key);
		
		Document templateDoc = DomUtil.stringToDoc(fdData);
		// 传入
		List<RelationParamsField> insParamsField = new ArrayList<RelationParamsField>();
		NodeList nodeList = DomUtil.selectNode("/jco/import"+
				"|/jco/tables/table[@isin='1']", templateDoc);
		loopSetTemplate(nodeList, insParamsField, "/", "");
		paramsTemplate.setIns(insParamsField);
		// 传出
		List<RelationParamsField> outsParamsField = new ArrayList<RelationParamsField>();
		NodeList outNodeList = DomUtil.selectNode("/jco/export"+
				"|/jco/tables/table[@isin='0']", templateDoc);
		loopSetTemplate(outNodeList, outsParamsField, "/", "");
		paramsTemplate.setOuts(outsParamsField);
		return paramsTemplate;
	}

	public RelationParamsTemplate execute(String fdData,
			RelationParamsTemplate params, String funcId) throws Exception {
		Connection conn = null;
		PreparedStatement ps = null;
		try {
			Document doc = DomUtil.stringToDoc(fdData);
			// 传入塞值
			List<RelationParamsField> inFieldList = params.getIns();
			for (RelationParamsField inField : inFieldList) {
				String xpath = new String(Base64.decodeBase64(inField.getUuId().getBytes()));
				Element curEle = DomUtil.selectEle(xpath, doc);
				if(curEle.hasChildNodes()) {
					curEle.removeChild(curEle.getFirstChild());
				}
				String fieldValue = inField.getFieldValueForm();
				if (StringUtil.isNotNull(fieldValue)) {
					Text curText = doc.createTextNode(fieldValue);
					curEle.appendChild(curText);
				}
			}
			ITibSysSapJcoFunctionUtil sapFuncUtil = (ITibSysSapJcoFunctionUtil) SpringBeanUtil.getBean("tibSysSapJcoFunctionUtil");
			TibSysSapReturnVo sapReturnVo = sapFuncUtil.getXMLtoFunction(funcId, DomUtil.DocToString(doc));
			String outContent = String.valueOf(sapReturnVo.getResult());
			// 传出塞值
			String conditionsUuid = params.getConditionsUUID();
			List<RelationParamsField> outFieldList = params.getOuts();
			List<RelationParamsField> newFieldList = new ArrayList<RelationParamsField>();
			// 如果为空，那么从模版获取
			if (outFieldList.isEmpty()) {
				outFieldList.addAll(getParamsTemplate(params.get_key(), fdData).getOuts());
			} 
			String sql = "insert into tib_common_mapp_control_field" +
					"(fd_id, uu_id, conditions_uuid,  field_value, row_index, doc_create_time) values (?, ?, ?, ?, ?, ?)";
			conn = this.getSession().connection();
			conn.setAutoCommit(false);
			ps = conn.prepareStatement(sql);
			for (RelationParamsField outField : outFieldList) {
				String xpath = new String(Base64.decodeBase64(outField.getUuId().getBytes()));
				Document outDoc = DomUtil.stringToDoc(outContent);
				List<Element> curEleList = DomUtil.selectEleList(xpath, outDoc);
				if (curEleList != null && curEleList.size() > 0) {
					for (int i = 0, len = curEleList.size(); i < len; i++) {
						Element curEle = curEleList.get(i);
						String textContent = curEle.getTextContent();
						if (textContent == null) {
							textContent = "";
						}
						// 存数据库
						ps.setString(1, IDGenerator.generateID());
						ps.setString(2, outField.getUuId());
						ps.setString(3, conditionsUuid);
						ps.setString(4, textContent);
						ps.setInt(5, i + 1);
						ps.setTimestamp(6, new Timestamp(new java.util.Date().getTime()));
//						if (i == 0) {
//							outField.setFieldValue(textContent);
//						} else {
//							// 多条那么追加克隆
//							RelationParamsField newField = (RelationParamsField) outField.clone();
//							newField.setFieldValue(textContent);
//							newFieldList.add(newField); 
//						}
						ps.addBatch();
						// 3000条进行一次批量插入，否则在最后一条时插入
						if(i != 0 && i % 3000 == 0) {
							ps.executeBatch();
							conn.commit();
							ps.clearBatch();
						} else if (i == len -1){
							ps.executeBatch();
							conn.commit();
							ps.clearBatch();
						}
					}
				}
			}
//			if (newFieldList.size() > 0) {
//				outFieldList.addAll(newFieldList);
//			}
		} finally {
			if (conn != null) {
				conn.close();
			}
			if (ps != null) {
				ps.close();
			}
		}
		return params;
	}

}
