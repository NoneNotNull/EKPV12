package com.landray.kmss.tib.soap.mapping.plugins.controls;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;

import org.apache.commons.codec.binary.Base64;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.Text;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.sys.xform.base.service.controls.relation.RelationParamsField;
import com.landray.kmss.sys.xform.base.service.controls.relation.RelationParamsTemplate;
import com.landray.kmss.tib.common.mapping.plugins.control.ITibCommonMappingControlDispatcher;
import com.landray.kmss.tib.common.mapping.plugins.control.TibCommonMappingControlTreeVo;
import com.landray.kmss.tib.common.mapping.plugins.control.service.ITibCommonMappControlFieldService;
import com.landray.kmss.tib.common.util.DomUtil;
import com.landray.kmss.tib.sys.core.provider.util.ProviderXmlOperation;
import com.landray.kmss.tib.sys.soap.connector.interfaces.ITibSysSoap;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapCategory;
import com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapMain;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapCategoryService;
import com.landray.kmss.tib.sys.soap.connector.service.ITibSysSoapMainService;
import com.landray.kmss.tib.sys.soap.connector.util.executor.vo.ITibSysSoapRtn;
import com.landray.kmss.tib.sys.soap.connector.util.header.SoapInfo;
import com.landray.kmss.tib.sys.soap.connector.util.xml.ParseSoapXmlUtil;
import com.landray.kmss.util.IDGenerator;
import com.landray.kmss.util.SpringBeanUtil;
import com.landray.kmss.util.StringUtil;

public class TibSoapControlTreeInfo extends HibernateDaoSupport implements ITibCommonMappingControlDispatcher {

	private final static String TYPE_OBJECT = "对象类型";
	private final static String TYPE_TABLE = "明细表";
	private final static String TYPE_MULTI = "多值字段";
	
	private ITibSysSoapCategoryService tibSysSoapCategoryService;
	
	private ITibSysSoapMainService tibSysSoapMainService;
	
	private ITibCommonMappControlFieldService tibCommonMappControlFieldService;
	
	public ITibSysSoapCategoryService getTibSysSoapCategoryService() {
		return tibSysSoapCategoryService;
	}
	
	public void setTibSysSoapCategoryService(
			ITibSysSoapCategoryService tibSysSoapCategoryService) {
		this.tibSysSoapCategoryService = tibSysSoapCategoryService;
	}
	
	public ITibSysSoapMainService getTibSysSoapMainService() {
		return tibSysSoapMainService;
	}

	public void setTibCommonMappControlFieldService(
			ITibCommonMappControlFieldService tibCommonMappControlFieldService) {
		this.tibCommonMappControlFieldService = tibCommonMappControlFieldService;
	}

	public void setTibSysSoapMainService(
			ITibSysSoapMainService tibSysSoapMainService) {
		this.tibSysSoapMainService = tibSysSoapMainService;
	}


	public List<TibCommonMappingControlTreeVo> getCateInfo(String selectId, String pluginKey)
			throws Exception {
		List<TibCommonMappingControlTreeVo> cateVos =new ArrayList<TibCommonMappingControlTreeVo>(1);
		HQLInfo hqlInfo = new HQLInfo();
		if (StringUtil.isNull(selectId)) {
			hqlInfo
					.setWhereBlock("tibSysSoapCategory.hbmParent.fdId is null");
			hqlInfo.setOrderBy("tibSysSoapCategory.fdOrder");
		} else {
			hqlInfo
					.setWhereBlock(" tibSysSoapCategory.hbmParent.fdId =:fdId ");
			hqlInfo.setParameter("fdId", selectId);
			hqlInfo.setOrderBy("tibSysSoapCategory.fdOrder");
		}
		List<TibSysSoapCategory> dbList = tibSysSoapCategoryService
				.findList(hqlInfo);
		for (TibSysSoapCategory tibSysSoapCategory : dbList) {
			Map<String, String> h_map = new HashMap<String, String>();
			TibCommonMappingControlTreeVo cate=new TibCommonMappingControlTreeVo(tibSysSoapCategory.getFdId(),tibSysSoapCategory.getFdName(),pluginKey );
			cateVos.add(cate);
		}
		return cateVos;
	}
	
	public List<TibCommonMappingControlTreeVo> getFuncDataList(String cateId,String pluginKey) throws Exception{
		HQLInfo hqlInfo = new HQLInfo();
		List<TibCommonMappingControlTreeVo> tibSysFuncVos=new ArrayList<TibCommonMappingControlTreeVo>();
		if (StringUtil.isNull(cateId)) {
			hqlInfo.setWhereBlock("tibSysSoapMain.wsEnable = 1 and tibSysSoapMain.docIsNewVersion = '1' ");
		} else {
			//hqlInfo.setSelectBlock(" tibSysSoapMain.docSubject,tibSysSoapMain.fdId ");
			hqlInfo
					.setWhereBlock("tibSysSoapMain.wsEnable = 1 and tibSysSoapMain.docIsNewVersion = '1' and "
							+ " tibSysSoapMain.docCategory.fdId in "
							+ " (select tibSysSoapCategory.fdId from com.landray.kmss.tib.sys.soap.connector.model.TibSysSoapCategory tibSysSoapCategory where tibSysSoapCategory.fdHierarchyId like :selectId ) ");
			hqlInfo.setParameter("selectId", "%"+cateId+"%");
		}
		List<TibSysSoapMain> dbList = tibSysSoapMainService.findList(hqlInfo);
		
		for(TibSysSoapMain tibSysSoapMain:dbList){
			
			TibCommonMappingControlTreeVo tsv=new TibCommonMappingControlTreeVo(tibSysSoapMain.getFdId(),tibSysSoapMain.getDocSubject(),pluginKey);
			tibSysFuncVos.add(tsv);
		}
		return tibSysFuncVos;
	}

	public String getTemplateXml(String funcId) throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setSelectBlock("tibSysSoapMain.wsMapperTemplate");
		hqlInfo.setWhereBlock("tibSysSoapMain.fdId = :funcId");
		hqlInfo.setParameter("funcId", funcId);
		List<Object> list = tibSysSoapMainService.findList(hqlInfo);
		Object obj = list.get(0);
		String templateXml = obj.toString();
		Document doc = ProviderXmlOperation.stringToDoc(templateXml);
		// 移除禁用节点
		ParseSoapXmlUtil.getTemplateXmlLoop(doc.getDocumentElement().getChildNodes());
		return DomUtil.DocToString(doc);
	}

	/**
	 * 设置 模版
	 * @param paramsField
	 * @param xpath		初始为/，拼成后为//nodeName1/nodeName2/...
	 * @throws Exception
	 */
	private void loopSetTemplate(NodeList nodeList, List<RelationParamsField> 
			paramsField, String xpath, String namePath) throws Exception {
		for (int i = 0, len = nodeList.getLength(); i < len; i++) {
			Node curNode = nodeList.item(i);
			if (curNode != null && Node.ELEMENT_NODE == curNode.getNodeType()) {
				String nodeName = curNode.getNodeName();
				int index = nodeName.indexOf(":");
				if (index != -1) {
					nodeName = nodeName.substring(index + 1);
				}
				String curXpath = xpath +"/"+ nodeName;
				JSONObject commentJsonObj = ParseSoapXmlUtil.findCommentJsonObj(curNode);
				// 没有注释，那么跳过，保留xpath
				if (commentJsonObj == null || (commentJsonObj != null 
						&& StringUtil.isNull(String.valueOf(commentJsonObj.get("ctype"))))) {
					if (curNode.hasChildNodes()) {
						loopSetTemplate(curNode.getChildNodes(), paramsField, curXpath, namePath);
					}
					continue;
				}
				Object title = commentJsonObj.get("title");
				// 设置显示的名字
				String curNamePath = "";
				if (title != null && !"".equals(String.valueOf(title))) {
					curNamePath = namePath.equals("") ? String.valueOf(title) : namePath +"."+ title; 
				} else {
					curNamePath = namePath.equals("") ? nodeName : namePath +"."+ nodeName;
				}
				Object ctype = commentJsonObj.get("ctype");
				if (ctype != null && StringUtil.isNotNull(ctype.toString())) {
					RelationParamsField childField = new RelationParamsField();
					// 设置唯一值xpath
					childField.setUuId(new String(Base64.encodeBase64(curXpath.getBytes())));
					childField.set_xpath(curXpath);
					// 设置节点名
					childField.setFieldId(curXpath.replace("//", "").replaceAll("/", "."));
					childField.setFieldName(curNamePath);
					if (TYPE_OBJECT.equals(ctype)) {
						// 对象类型
						loopSetTemplate(curNode.getChildNodes(), paramsField, curXpath, curNamePath);
					} else if (TYPE_TABLE.equals(ctype)) {
						// 明细表
						loopSetTemplate(curNode.getChildNodes(), paramsField, curXpath, curNamePath);
					} else if (TYPE_MULTI.equals(ctype)) {
						// 多值字段
						Object required = commentJsonObj.get("required");
						Object disp = commentJsonObj.get("disp");
						childField.set_multi("1");
						childField.set_ctype("array");
						childField.set_minlength("0");
						childField.set_maxlength("x");
						if (required != null) {
							childField.set_required("checked".equals(required.toString()) ? "1" : "0");
						}
						if (disp != null) {
							//childField.set_disp(String.valueOf(disp));
						}
						paramsField.add(childField);
					} else {
						// 普通字段
						Object required = commentJsonObj.get("required");
						Object disp = commentJsonObj.get("disp");
						childField.set_multi("0");
						childField.set_ctype(String.valueOf(ctype));
						childField.set_minlength("0");
						childField.set_maxlength("x");
						if (required != null) {
							childField.set_required("checked".equals(required.toString()) ? "1" : "0");
						}
						if (disp != null) {
							//childField.setColumnIndex(Integer((disp));
						}
						paramsField.add(childField);
					}
				}
			}
		}
	}

	/**
	 * 获取控件模版
	 */
	public RelationParamsTemplate getParamsTemplate(String key, String fdData)
			throws Exception {
		RelationParamsTemplate paramsTemplate = new RelationParamsTemplate();
		paramsTemplate.set_source("TIB_SOAP");
		paramsTemplate.set_key(key);
		
		Document templateDoc = DomUtil.stringToDoc(fdData);
		
		List<RelationParamsField> insParamsField = new ArrayList<RelationParamsField>();
		NodeList nodeList = DomUtil.selectNode("//Input/Envelope/Body/*", templateDoc);
		loopSetTemplate(nodeList, insParamsField, "/", "");
		paramsTemplate.setIns(insParamsField);
		// 传出
		List<RelationParamsField> outsParamsField = new ArrayList<RelationParamsField>();
		NodeList outNodeList = DomUtil.selectNode("//Output/Envelope/Body/*", templateDoc);
		loopSetTemplate(outNodeList, outsParamsField, "/", "");
		paramsTemplate.setOuts(outsParamsField);
		return paramsTemplate;
	}

	/**
	 * 执行控件填充的数据，并返回模版对象。
	 */
	public RelationParamsTemplate execute(String fdData,
			RelationParamsTemplate params, String funcId) throws Exception {
		Connection conn = null;
		PreparedStatement ps = null;
		try {
			// 传出容器
			List<RelationParamsField> newFieldList = new ArrayList<RelationParamsField>();
			List<RelationParamsField> outFieldList = params.getOuts();
			String conditionsUuid = params.getConditionsUUID();
			Document doc = DomUtil.stringToDoc(fdData);
			// 传入塞值
			List<RelationParamsField> inFieldList = params.getIns();
			for (RelationParamsField inField : inFieldList) {
				String xpath = new String(Base64.decodeBase64(inField.getUuId().getBytes()));
				Element curEle = DomUtil.selectEle(xpath, doc);
				Text curText = doc.createTextNode(inField.getFieldValueForm());
				curEle.appendChild(curText);
			}
			ITibSysSoap tibSysSoap = (ITibSysSoap) SpringBeanUtil.getBean("tibSysSoap");
			SoapInfo soapInfo = new SoapInfo();
			soapInfo.setRequestDocument(doc);
			TibSysSoapMain soapMain = (TibSysSoapMain) tibSysSoapMainService.findByPrimaryKey(funcId);
			soapInfo.setTibSysSoapMain(soapMain);
			ITibSysSoapRtn soapRtn = tibSysSoap.inputToOutputRtn(soapInfo);
			String outContent = soapRtn.getRtnContent();
			//String temp = DomUtil.DocToString(doc);
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
