package com.landray.kmss.tib.sap.mapping.plugins.controls.list.service.spring;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.orm.hibernate3.support.HibernateDaoSupport;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.sap.mapping.plugins.controls.list.service.ITibSapMappingListControlMainService;
import com.landray.kmss.tib.sap.mapping.plugins.controls.list.util.ControlXmlDataParseUtil;
import com.landray.kmss.tib.sys.sap.connector.impl.TibSysSapJcoFunctionUtil;
import com.landray.kmss.util.IDGenerator;
import com.landray.kmss.util.SpringBeanUtil;

public class TibSapMappingListControlBackXmlBean extends HibernateDaoSupport implements IXMLDataBean{
	// 执行函数返回xml
	public List getDataList(RequestContext requestInfo) throws Exception {
		String xml = requestInfo.getParameter("xml");
		String fdKey = requestInfo.getParameter("fdKey");
		// String showValueJson = requestInfo.getParameter("showValueJson");
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>();
		Map<String, String> map = new HashMap<String, String>();
		// 检查是否已经进行过插入数据
		ITibSapMappingListControlMainService tibSapMappingListControlMainService = 
			(ITibSapMappingListControlMainService) SpringBeanUtil.
			getBean("tibSapMappingListControlMainService");
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setSelectBlock("tibSapMappingListControlMain.fdExportParam");
		hqlInfo.setWhereBlock("tibSapMappingListControlMain.fdKey = :fdKey");
		hqlInfo.setParameter("fdKey", fdKey);
		
		// 获取返回的XML
		String backXml = "";
		TibSysSapJcoFunctionUtil tibSysSapJcoFunctionUtil = (TibSysSapJcoFunctionUtil) 
				SpringBeanUtil.getBean("tibSysSapJcoFunctionUtil");
		Connection conn = null;
		PreparedStatement ps = null;
		try {
			List<Object> listControl = tibSapMappingListControlMainService
					.findList(hqlInfo);
			if (!listControl.isEmpty()) {
				// 如果已存在，取出传出参数，取第一个
				String exportParam = (String)listControl.get(0);
				map.put("exportParamXml", exportParam);
				rtnList.add(map);
				return rtnList;
			}
			backXml = (String) tibSysSapJcoFunctionUtil.getXMltoFunction(xml).getResult();
			Document doc = ControlXmlDataParseUtil.stringToDoc(backXml);
			Node exportNode = ControlXmlDataParseUtil.selectNode("/jco/export", doc).item(0);
			String exportParamXml = ControlXmlDataParseUtil.DocToString(exportNode);
			
			conn = this.getSession().connection();
			conn.setAutoCommit(false);
			String sql = "insert into tib_sap_mapping_list_control" +
					"(fd_id, doc_create_time, fd_key,  fd_export_param,fd_show_data) values (?, ?, ?, ?, ?)";
			ps = conn.prepareStatement(sql);
			NodeList recordNodeList = ControlXmlDataParseUtil.selectNode("/jco/tables/table[@isin='0']/records", doc);
			if (recordNodeList.getLength() > 0) {
//				String tableJson = "[";
				// 循环记录record列表
				for (int i = 0, len = recordNodeList.getLength(); i < len; i++) {
					Node recordNode = recordNodeList.item(i);
					Node firstRecordNode = recordNodeList.item(0);
					NodeList fieldNodeList = recordNode.getChildNodes();
					NodeList firstFieldNodeList = firstRecordNode.getChildNodes();
					int lenJ = fieldNodeList.getLength();
					if (lenJ > 0) {
//						tableJson += "{col:";
						// 需要存的列数据Json
						StringBuffer colJson = new StringBuffer("[");
						// 循环field列表
						for (int j = 0; j < lenJ; j++) {
							Node fieldNode = fieldNodeList.item(j);
							Node firstRecordFieldNode = firstFieldNodeList.item(j);
							if (fieldNode.getNodeType() == Node.ELEMENT_NODE) {
								String fieldText = "";
								// 获取text节点拿节点内容
								Node textNode = fieldNode.getFirstChild();
								if (textNode != null) {
									fieldText = textNode.getNodeValue();
								}
								// 获取name属性值
								String name = ControlXmlDataParseUtil.findAttrValue(firstRecordFieldNode, "name");
								String title = ControlXmlDataParseUtil.findAttrValue(firstRecordFieldNode, "title");
//								showValueJson = showValueJson.replaceAll("'", "\"");
//								JSONObject json = (JSONObject) JSONValue.parse(showValueJson);
//								JSONArray jsonArray = (JSONArray)json.get("TABLE_DocList");
								colJson.append("{");
								colJson.append("th:'").append(title).append("',");
								colJson.append("td:'").append(fieldText).append("',");
								colJson.append("value:'").append(name).append("'");
								colJson.append("},");
							}
						}
						if (colJson.indexOf(",") != -1) {
							colJson.deleteCharAt(colJson.length() - 1);
						}
						colJson.append("]");
//						tableJson += colJson.toString() +"},";
						// 添加fdId
						ps.setString(1, IDGenerator.generateID());
						ps.setTimestamp(2, new Timestamp(new java.util.Date().getTime()));
						ps.setString(3, fdKey);
						String cloStr=colJson.toString();
						//ps.setCharacterStream(4, new StringReader(exportParamXml),exportParamXml.length()+1);
						//ps.setCharacterStream(5, new StringReader(cloStr),cloStr.length()+1);
						ps.setString(4, exportParamXml);
						ps.setString(5, colJson.toString());
						ps.addBatch();
					}
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
//				tableJson = tableJson.substring(0, tableJson.length() - 1);
//				tableJson += "]";
			}
			map.put("exportParamXml", exportParamXml);
		} catch (Exception e) {
			e.printStackTrace();
			map.put("message", "服务器出现异常");
		} finally {
			if (conn != null) {
				conn.close();
			}
			if (ps != null) {
				ps.close();
			}
		}
		rtnList.add(map);
		return rtnList;
	}
	
}


