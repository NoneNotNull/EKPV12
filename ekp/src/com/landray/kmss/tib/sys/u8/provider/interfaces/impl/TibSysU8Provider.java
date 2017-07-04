package com.landray.kmss.tib.sys.u8.provider.interfaces.impl;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Savepoint;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.component.dbop.model.CompDbcp;
import com.landray.kmss.component.dbop.service.ICompDbcpService;
import com.landray.kmss.tib.sys.core.provider.process.provider.interfaces.impl.TibSysBaseProvider;
import com.landray.kmss.tib.sys.core.provider.util.ProviderXmlOperation;
import com.landray.kmss.tib.sys.core.provider.vo.TibSysCoreStore;
import com.landray.kmss.util.ResourceUtil;
import com.landray.kmss.util.StringUtil;

public class TibSysU8Provider extends TibSysBaseProvider {

	private static final Log logger = LogFactory.getLog(TibSysU8Provider.class);

	private static Object lock = new Object();

	private ICompDbcpService compDbcpService;

	CompDbcp compDbcps = null;

	public void setCompDbcpService(ICompDbcpService compDbcpService) {
		this.compDbcpService = compDbcpService;
	}

	@Override
	public Object executeData(TibSysCoreStore coreStore, Object data)
			throws Exception {
		System.out.println("进行写凭证方法：");
		logger.warn("进行写凭证方法：");
		String backXml = "";
		String tibRootStr = "<tib key='' id='' control='' modelname='' tagdb=''>";
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		// 记录有问题的凭证
		String outXml = "";
		boolean successFlag = false;
		boolean failFlag = false;
		try {
			Document doc = ProviderXmlOperation.stringToDoc((String) data);
			Element inEle = ProviderXmlOperation.selectElement("/tib/in", doc)
					.get(0);
			// 数据源
			Element rootEle = (Element) inEle.getParentNode();
			String tagdb = rootEle.getAttribute("tagdb");
			logger.warn("获取到的数据源：" + tagdb);
			// 记录需要插入的凭证
			List<List<Map<String, String>>> listListMap = new ArrayList<List<Map<String, String>>>();
			// 遍历凭证，把信息装入集合
			for (int i = 0, lenI = inEle.getChildNodes().getLength(); i < lenI; i++) {
				Node accvouchNode = inEle.getChildNodes().item(i);
				if (Node.ELEMENT_NODE == accvouchNode.getNodeType()) {
					List<Map<String, String>> listMap = new ArrayList<Map<String, String>>();
					// 凭证记录行（行项目）
					for (int j = 0, lenJ = accvouchNode.getChildNodes()
							.getLength(); j < lenJ; j++) {
						Node recordNode = accvouchNode.getChildNodes().item(j);
						if (Node.ELEMENT_NODE == recordNode.getNodeType()) {
							Map<String, String> map = new HashMap<String, String>();
							// 对应数据库的一些列字段
							for (int k = 0, lenK = recordNode.getChildNodes()
									.getLength(); k < lenK; k++) {
								Node node = recordNode.getChildNodes().item(k);
								if (Node.ELEMENT_NODE == node.getNodeType()) {
									map.put(node.getNodeName(),
											getContentByNode(node));
								}
							}
							listMap.add(map);
						}
					}
					listListMap.add(listMap);
				}
			}
			boolean flag = true;
			String requiredField = "";
			String recoredCtext1 = "";
			// 记录必填问题
			Document templateDoc = ProviderXmlOperation.stringToDoc(coreStore
					.getIfaceXml());
			Node templateNode = ProviderXmlOperation.selectNode(
					"//in/accvouch/record", templateDoc).item(0);
			for (int i = 0, lenI = templateNode.getChildNodes().getLength(); i < lenI; i++) {
				Node node = templateNode.getChildNodes().item(i);
				if (node.getNodeType() == Node.ELEMENT_NODE) {
					Element ele = (Element) node;
					String required = ele.getAttribute("required");
					if (required.equals("1")) {
						String nodeName = node.getNodeName();
						for (Iterator<List<Map<String, String>>> it = listListMap
								.iterator(); it.hasNext();) {
							List<Map<String, String>> accvouchList = it.next();
							for (Map<String, String> map : accvouchList) {
								// 判断是否存在有空值，有则记录下来
								if (!(map.containsKey(nodeName) && StringUtil
										.isNotNull(map.get(nodeName)))) {
									flag = false;
									requiredField = nodeName;
									recoredCtext1 = map.get("ctext1");
									break;
								}
							}
							// 发现字段不存在或空数据
							if (!flag) {
								// 失败，有一条记录中必填字段 不存在或空数据
								String failRequired_lang = ResourceUtil
										.getString("tibSysU8.failRequired",
												"tib-sys-u8");
								String notExistOrEmpty_lang = ResourceUtil
										.getString("tibSysU8.notExistOrEmpty",
												"tib-sys-u8");
								outXml += "<accvouch><ino_id/><ctext1>"
										+ recoredCtext1 + "</ctext1>"
										+ "<result>0</result><message>"
										+ failRequired_lang + requiredField
										+ notExistOrEmpty_lang
										+ "</message></accvouch>";
								logger.warn(outXml);
								it.remove();
								// 全局标记存在失败记录
								failFlag = true;
								// 还原验证非空数据开关，以便继续下一个凭证验证
								flag = true;
							}
						}
					}
				}
			}
			// 同步块
			synchronized (lock) {
				// 执行数据库操作
				conn = getU8Conn(tagdb);
				conn.setAutoCommit(false);
				Savepoint sp = null;
				couter: for (Iterator<List<Map<String, String>>> it = listListMap
						.iterator(); it.hasNext();) {
					List<Map<String, String>> accvouchList = it.next();
					// conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
					// 创建保存点
					sp = conn.setSavepoint();
					Integer ino_id = null;
					// 费控凭证号（取第一条记录）
					String ctext1One = accvouchList.get(0).get("ctext1");
					boolean isSuccess = true;
					try {
						// 判断此费控凭证号下是否已经存在财务凭证号
						String checkSql = "SELECT distinct ino_id FROM GL_accvouch WHERE ctext1 = ?";
						ps = conn.prepareStatement(checkSql);
						ps.setString(1, ctext1One);
						rs = ps.executeQuery();
						if (rs.next()) {
							ino_id = rs.getInt(1);
							// 失败，凭证号已存在
							String certificateExist_lang = ResourceUtil
									.getString("tibSysU8.certificateExist",
											"tib-sys-u8");
							outXml += "<accvouch><ino_id>" + ino_id
									+ "</ino_id><ctext1>" + ctext1One
									+ "</ctext1>"
									+ "<result>0</result><message>"
									+ certificateExist_lang
									+ "</message></accvouch>";
							// 全局标记存在失败记录
							failFlag = true;
							continue;
						}
						// 如果不存在凭证号，则找出最大值+1
						String sql = "SELECT distinct ino_id FROM GL_accvouch WHERE (ino_id=(SELECT MAX(ino_id) "
								+ "FROM GL_accvouch WHERE iperiod = ? AND csign = ? AND iyear = ?))";
						ps = conn.prepareStatement(sql);
						ps.setInt(1, Integer.parseInt(accvouchList.get(0).get(
								"iperiod")));
						ps.setString(2, accvouchList.get(0).get("csign"));
						ps.setString(3, accvouchList.get(0).get("iyear"));
						rs = ps.executeQuery();
						if (rs.next()) {
							ino_id = rs.getInt(1);
							ino_id++;
						} else {
							ino_id = 1;
						}

						for (int i = 0, lenI = accvouchList.size(); i < lenI; i++) {
							Map<String, String> map = accvouchList.get(i);
							recoredCtext1 = map.get("ctext1");
							if (!ctext1One.equals(recoredCtext1)) {
								// 同一财务凭证下填写的费控号不一致
								String certificateDisaccord_lang = ResourceUtil
										.getString(
												"tibSysU8.certificateDisaccord",
												"tib-sys-u8");
								String fail_lang = ResourceUtil.getString(
										"tibSysU8.fail", "tib-sys-u8");
								String message = certificateDisaccord_lang
										+ " 0-ctext1:" + ctext1One + "，" + i
										+ "-ctext1:" + recoredCtext1;
								outXml += "<accvouch><ino_id>" + ino_id
										+ "</ino_id><ctext1>" + ctext1One
										+ "</ctext1>"
										+ "<result>0</result><message>"
										+ fail_lang + message
										+ "</message></accvouch>";
								logger.warn(outXml);
								// 全局标记存在失败记录
								failFlag = true;
								continue couter;
								// throw new Exception(message);
							}
							// 插入凭证
							String insertSql = "INSERT INTO GL_accvouch(iperiod,csign,isignseq,"
									+ "ino_id,inid,dbill_date,idoc,cbill,ctext1,ctext2,cdigest,ccode,"
									+ "md,mc,ccode_equal,md_f,mc_f,nfrat,nd_s,nc_s,ibook,cdept_id,"
									+ "cperson_id,ccus_id,csup_id,citem_id,citem_class,iyear,Iyperiod) "
									+ "VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
							logger
									.warn("INSERT INTO GL_accvouch(iperiod,csign,isignseq,"
											+ "ino_id,inid,dbill_date,idoc,cbill,ctext1,ctext2,cdigest,ccode,"
											+ "md,mc,ccode_equal,md_f,mc_f,nfrat,nd_s,nc_s,ibook,cdept_id,"
											+ "cperson_id,ccus_id,csup_id,citem_id,citem_class,iyear,Iyperiod) "
											+ "VALUES("
											+ Integer
													.parseInt(map
															.get("iperiod") == null ? "0"
															: map
																	.get("iperiod"))
											+ ","
											+ map.get("csign")
											+ ","
											+ Integer
													.parseInt(map
															.get("isignseq") == null ? "0"
															: map
																	.get("isignseq"))
											+ ","
											+ ino_id
											+ ","
											+ Integer
													.parseInt(map.get("inid") == null ? "0"
															: map.get("inid"))
											+ ","
											+ new Timestamp(
													new SimpleDateFormat(
															"yyyy-MM-dd HH:mm:ss")
															.parse(
																	map
																			.get("dbill_date"))
															.getTime())
											+ ","
											+ Integer
													.parseInt(map.get("idoc") == null ? "0"
															: map.get("idoc"))
											+ ","
											+ map.get("cbill")
											+ ","
											+ map.get("ctext1")
											+ ","
											+ map.get("ctext2")
											+ ","
											+ map.get("cdigest")
											+ ","
											+ map.get("ccode")
											+ ""
											+ ","
											+ BigDecimal
													.valueOf(Double
															.parseDouble(map
																	.get("md") == null ? "0.0"
																	: map
																			.get("md")))
											+ ","
											+ BigDecimal
													.valueOf(Double
															.parseDouble(map
																	.get("mc") == null ? "0.0"
																	: map
																			.get("mc")))
											+ ","
											+ map.get("ccode_equal")
											+ ","
											+ BigDecimal
													.valueOf(Double
															.parseDouble(map
																	.get("mc_f") == null ? "0.0"
																	: map
																			.get("mc_f")))
											+ ","
											+ BigDecimal
													.valueOf(Double
															.parseDouble(map
																	.get("md_f") == null ? "0.0"
																	: map
																			.get("md_f")))
											+ ","
											+ Float
													.parseFloat(map
															.get("nfrat") == null ? "0.0"
															: map.get("nfrat"))
											+ ","
											+ Float
													.parseFloat(map.get("nd_s") == null ? "0.0"
															: map.get("nd_s"))
											+ ","
											+ Float
													.parseFloat(map.get("nc_s") == null ? "0.0"
															: map.get("nc_s"))
											+ ","
											+ Integer
													.parseInt(map.get("ibook") == null ? "0"
															: map.get("ibook"))
											+ ","
											+ map.get("cdept_id")
											+ ","
											+ map.get("cperson_id")
											+ ","
											+ map.get("ccus_id")
											+ ","
											+ map.get("csup_id")
											+ ","
											+ map.get("citem_id")
											+ ","
											+ map.get("citem_class")
											+ ","
											+ map.get("iyear")
											+ ","
											+ map.get("Iyperiod") + ")");
							ps = conn.prepareStatement(insertSql);
							ps.setInt(1, Integer
									.parseInt(map.get("iperiod") == null ? "0"
											: map.get("iperiod")));
							ps.setString(2, map.get("csign"));
							ps.setInt(3, Integer
									.parseInt(map.get("isignseq") == null ? "0"
											: map.get("isignseq")));
							ps.setInt(4, ino_id);
							ps.setInt(5, Integer
									.parseInt(map.get("inid") == null ? "0"
											: map.get("inid")));
							ps.setTimestamp(6, new Timestamp(
									new SimpleDateFormat("yyyy-MM-dd HH:mm:ss")
											.parse(map.get("dbill_date"))
											.getTime()));
							ps.setInt(7, Integer
									.parseInt(map.get("idoc") == null ? "0"
											: map.get("idoc")));
							ps.setString(8, map.get("cbill"));
							ps.setString(9, map.get("ctext1"));
							ps.setString(10, map.get("ctext2"));
							ps.setString(11, map.get("cdigest"));
							ps.setString(12, map.get("ccode"));
							ps.setBigDecimal(13, BigDecimal.valueOf(Double
									.parseDouble(map.get("md") == null ? "0.0"
											: map.get("md"))));
							ps.setBigDecimal(14, BigDecimal.valueOf(Double
									.parseDouble(map.get("mc") == null ? "0.0"
											: map.get("mc"))));
							ps.setString(15, map.get("ccode_equal"));
							ps.setBigDecimal(16,
									BigDecimal.valueOf(Double.parseDouble(map
											.get("md_f") == null ? "0.0" : map
											.get("md_f"))));
							ps.setBigDecimal(17,
									BigDecimal.valueOf(Double.parseDouble(map
											.get("mc_f") == null ? "0.0" : map
											.get("mc_f"))));
							ps
									.setFloat(18, Float.parseFloat(map
											.get("nfrat") == null ? "0.0" : map
											.get("nfrat")));
							ps.setFloat(19, Float
									.parseFloat(map.get("nd_s") == null ? "0.0"
											: map.get("nd_s")));
							ps.setFloat(20, Float
									.parseFloat(map.get("nc_s") == null ? "0.0"
											: map.get("nc_s")));
							ps.setInt(21, Integer
									.parseInt(map.get("ibook") == null ? "0"
											: map.get("ibook")));
							ps.setString(22, map.get("cdept_id"));
							ps.setString(23, map.get("cperson_id"));
							ps.setString(24, map.get("ccus_id"));
							ps.setString(25, map.get("csup_id"));
							ps.setString(26, map.get("citem_id"));
							ps.setString(27, map.get("citem_class"));
							logger.warn("获取到的citem_class值："
									+ map.get("citem_class"));
							ps.setString(28, map.get("iyear"));
							logger.warn("获取到的新增的iyear值：" + map.get("iyear"));
							ps.setString(29, map.get("Iyperiod"));
							logger.warn("获取到的新增的Iyperiod值："
									+ map.get("Iyperiod"));
							isSuccess = !(ps.execute());
						}
						// 一个凭证中两个记录行都成功了，则打印成功信息
						if (isSuccess) {
							logger.warn("凭证写入成功！");
							String success_lang = ResourceUtil.getString(
									"tibSysU8.success", "tib-sys-u8");
							outXml += "<accvouch><ino_id>" + ino_id
									+ "</ino_id><ctext1>" + recoredCtext1
									+ "</ctext1>"
									+ "<result>1</result><message>"
									+ success_lang + "</message></accvouch>";
							logger.warn(outXml);
							// 全局标记存在成功记录
							successFlag = true;
						}
					} catch (Exception e) {
						logger.error(e);
						e.printStackTrace();
						String fail_lang = ResourceUtil.getString(
								"tibSysU8.fail", "tib-sys-u8");
						outXml += "<accvouch><ino_id>" + ino_id
								+ "</ino_id><ctext1>" + ctext1One + "</ctext1>"
								+ "<result>0</result><message>" + fail_lang
								+ e.toString() + "</message></accvouch>";
						logger.warn(outXml);
						// 全局标记存在失败记录
						failFlag = true;
						if (conn != null && sp != null) {
							// 回滚到上一个保存点
							conn.rollback(sp);
						}
					}
					// 提交事务
					conn.commit();
				}
				// 提交事务
				conn.commit();
			}
		} catch (Exception e) {
			logger.error(e);
			e.printStackTrace();
			if (StringUtil.isNotNull(outXml)) {
				backXml = tibRootStr + "<out>" + outXml
						+ "</out><return><result>0</result><message>"
						+ e.toString() + "</message></return></tib>";
			} else {
				backXml = tibRootStr
						+ "<out/><return><result>0</result><message>"
						+ e.toString() + "</message></return></tib>";
			}
			return backXml;
		} finally {
			try {
				if (rs != null) {
					rs.close();
					rs = null;
				}
				if (ps != null) {
					ps.close();
					ps = null;
				}
				if (conn != null) {
					conn.close();
					conn = null;
				}
			} catch (Exception e) {
				logger.error(e);
				e.printStackTrace();
				if (StringUtil.isNotNull(outXml)) {
					backXml = tibRootStr + "<out>" + outXml
							+ "</out><return><result>0</result><message>"
							+ e.toString() + "</message></return></tib>";
				} else {
					backXml = tibRootStr
							+ "<out/><return><result>0</result><message>"
							+ e.toString() + "</message></return></tib>";
				}
				return backXml;
			}
		}
		String resultStatus = "1";
		if (failFlag) {
			resultStatus = "0";
			if (successFlag) {
				resultStatus = "2";
			}
		}
		if (StringUtil.isNotNull(outXml)) {
			backXml = tibRootStr + "<out>" + outXml + "</out><return><result>"
					+ resultStatus + "</result><message/></return></tib>";
		} else {
			backXml = tibRootStr + "<out/><return><result>" + resultStatus
					+ "</result><message/></return></tib>";
		}
		return backXml;
	}

	/**
	 * 根据节点对象取出该节点内容
	 * 
	 * @param nodeName
	 * @return
	 */
	public String getContentByNode(Node node) {
		String content = "";
		Node firstChild = node.getFirstChild();
		if (firstChild != null && firstChild.getNodeType() == Node.TEXT_NODE) {
			content = firstChild.getNodeValue();
		}
		Pattern pt = Pattern.compile("(\r\n|\r|\n|\n\r)");
		Matcher matcher = pt.matcher(content);
		content = matcher.replaceAll("").trim();
		if (content.equals("")) {
			content = null;
		}
		return content;
	}

	/**
	 * 获取外部数据库的连接对象
	 * 
	 * @param sqlResource
	 * @return
	 * @throws Exception
	 */
	private Connection getU8Conn(String tagdb) throws Exception {
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setWhereBlock("compDbcp.fdName = :fdName");
		hqlInfo.setParameter("fdName", tagdb);
		this.compDbcps = (CompDbcp) compDbcpService.findList(hqlInfo).get(0);
		Class.forName(compDbcps.getFdDriver());
		return DriverManager.getConnection(compDbcps.getFdUrl(), compDbcps
				.getFdUsername(), compDbcps.getFdPassword());
	}

	@Override
	public Object transformFinishData(TibSysCoreStore coreStore, Object data)
			throws Exception {
		String finishData = ((String) data).replace("key=''",
				"key='" + coreStore.getKey() + "'").replace("id=''",
				"id='" + coreStore.getId() + "'").replace("modelname=''",
				"modelname='" + coreStore.getModelName() + "'").replace(
				"tagdb=''", "tagdb='" + coreStore.getTagdb() + "'").replace(
				"control=''", "control='" + coreStore.getControl() + "'");
		return finishData;
	}

}
