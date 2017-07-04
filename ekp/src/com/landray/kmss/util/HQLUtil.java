package com.landray.kmss.util;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicLong;

import org.hibernate.Query;
import org.hibernate.Session;

import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.dao.HQLParameter;
import com.landray.kmss.common.dao.HQLWrapper;
import com.landray.kmss.common.exception.KmssRuntimeException;
import com.landray.kmss.common.model.IBaseModel;
import com.landray.kmss.sys.config.dict.SysDataDict;
import com.landray.kmss.sys.config.dict.SysDictCommonProperty;
import com.landray.kmss.sys.config.dict.SysDictListProperty;

/**
 * HQL语句拼装的常用类。<br>
 * 作用范围：所有代码，直接调用静态方法。
 * 
 * @author 叶中奇
 * @version 1.0 2006-6-16
 */
public class HQLUtil {

	private static final AtomicLong atomicLong = new AtomicLong(0);

	/**
	 * @return 自增的ID号
	 */
	public static long getFieldIndex() {
		atomicLong.compareAndSet(10000, 0); // 如果累加到了10000，重置为0
		return atomicLong.getAndIncrement();
	}

	/**
	 * 获取自动fetch的信息，当使用order by时经常需要调用该函数fetch相关信息
	 * 
	 * @param hqlInfo
	 * @return
	 */
	public static String getAutoFetchInfo(HQLInfo hqlInfo) {
		if (!hqlInfo.isAutoFetch())
			return "";
		if (StringUtil.isNull(hqlInfo.getOrderBy()))
			return "";
		String[] info = hqlInfo.getOrderBy().split("[^A-Za-z0-9_\\.]+");
		StringBuffer rtnVal = new StringBuffer();
		for (int i = 0; i < info.length; i++) {
			info[i] = info[i].trim();
			if (info[i].length() == 0)
				continue;
			int j = info[i].indexOf(" ");
			if (j > -1)
				info[i] = info[i].substring(0, j);
			String[] infoArr = info[i].split("\\.");
			info[i] = infoArr[0];
			for (j = 1; j < infoArr.length - 1; j++) {
				info[i] = info[i] + "." + infoArr[j];
				if (rtnVal.indexOf("left join fetch " + info[i] + " ")>=0) {
					continue;
				}
				rtnVal.append("left join fetch " + info[i] + " ");
			}
		}
		return rtnVal.toString();
	}

	/**
	 * 
	 * 构造in 预编译语句，若valueList超过1000时，该函数会自动拆分成多个in语句
	 * 
	 * @param item
	 * @param valueList
	 * @return item in (valueList)
	 */
	public static HQLWrapper buildPreparedLogicIN(String item, List<?> valueList) {
		List<?> valueCopy = new ArrayList<Object>(valueList);
		HQLWrapper hqlWrapper = new HQLWrapper();
		int n = (valueCopy.size() - 1) / 1000;
		StringBuffer whereBlockTmp = new StringBuffer();
		List<?> tmpList;
		for (int k = 0; k <= n; k++) {
			int size = k == n ? valueCopy.size() : (k + 1) * 1000;
			if (k > 0) {
				whereBlockTmp.append(" or ");
			}
			String para = "kmss_hql_in_para_" + getFieldIndex();
			whereBlockTmp.append(item + " in (:" + para + ")");
			tmpList = valueCopy.subList(k * 1000, size);
			HQLParameter hqlParameter = new HQLParameter(para, tmpList);
			hqlWrapper.setParameter(hqlParameter);
		}
		if (n > 0) {
			hqlWrapper.setHql("(" + whereBlockTmp.toString() + ")");
		} else {
			hqlWrapper.setHql(whereBlockTmp.toString());
		}
		return hqlWrapper;
	}

	/**
	 * 构造in语句，若valueList超过1000时，该函数会自动拆分成多个in语句
	 * 
	 * @param item
	 * @param valueList
	 * @return item in (valueList)
	 */
	public static String buildLogicIN(String item, List valueList) {
		int n = (valueList.size() - 1) / 1000;
		StringBuffer rtnStr = new StringBuffer();
		Object obj = valueList.get(0);
		boolean isString = false;
		if (obj instanceof Character || obj instanceof String)
			isString = true;
		String tmpStr;
		for (int i = 0; i <= n; i++) {
			int size = i == n ? valueList.size() : (i + 1) * 1000;
			if (i > 0)
				rtnStr.append(" or ");
			rtnStr.append(item + " in (");
			if (isString) {
				StringBuffer tmpBuf = new StringBuffer();
				for (int j = i * 1000; j < size; j++) {
					tmpStr = valueList.get(j).toString().replaceAll("'", "''");
					tmpBuf.append(",'").append(tmpStr).append("'");
				}
				tmpStr = tmpBuf.substring(1);
			} else {
				tmpStr = valueList.subList(i * 1000, size).toString();
				tmpStr = tmpStr.substring(1, tmpStr.length() - 1);
			}
			rtnStr.append(tmpStr);
			rtnStr.append(")");
		}
		if (n > 0)
			return "(" + rtnStr.toString() + ")";
		else
			return rtnStr.toString();
	}

	/**
	 * 取得Model列表的HQL的In查询格式数据
	 * 
	 * @param modelList
	 * @return
	 */
	public static String buildModelIds(List modelList) {
		if (modelList != null && !modelList.isEmpty()) {
			StringBuffer rtnVal = new StringBuffer();
			for (int i = 0; i < modelList.size(); i++) {
				IBaseModel baseModel = (IBaseModel) modelList.get(i);
				rtnVal.append("'").append(baseModel.getFdId());
				if (i != modelList.size() - 1) {
					rtnVal.append("',");
				} else {
					rtnVal.append("'");
				}
			}
			return rtnVal.toString();
		} else {
			return null;
		}
	}

	/**
	 * 从数据库中读取ManyToMany的映射表
	 * 
	 * @param hbmSession
	 *            Hibernate的Session
	 * @param sql
	 *            SQL语句
	 * @return 映射表，可提供给fetchManyToManyIDList使用
	 */
	public static Map buildManyToManyIDMap(Session hbmSession, String sql) {
		Map rtnMap = new HashMap();
		List rtnList = hbmSession.createSQLQuery(sql).list();
		for (int i = 0; i < rtnList.size(); i++) {
			Object[] ids = (Object[]) rtnList.get(i);
			if (rtnMap.containsKey(ids[0])) {
				List valueList = (List) rtnMap.get(ids[0]);
				if (!valueList.contains(ids[1]))
					valueList.add(ids[1]);
			} else {
				List valueList = new ArrayList();
				valueList.add(ids[1]);
				rtnMap.put(ids[0], valueList);
			}
		}
		return rtnMap;
	}

	/**
	 * 从数据库中读取ManyToMany的映射表，并构造双向的映射表
	 * 
	 * @param hbmSession
	 *            Hibernate的Session
	 * @param sql
	 *            SQL语句
	 * @return [0]正向映射表，[1]反向映射表
	 */
	public static Map[] buildManyToManyIDBidirectionalMap(Session hbmSession,
			String sql) {
		Map[] rtnMap = { new HashMap(), new HashMap() };
		List rtnList = hbmSession.createSQLQuery(sql).list();
		for (int i = 0; i < rtnList.size(); i++) {
			Object[] ids = (Object[]) rtnList.get(i);
			if (rtnMap[0].containsKey(ids[0])) {
				List valueList = (List) rtnMap[0].get(ids[0]);
				if (!valueList.contains(ids[1]))
					valueList.add(ids[1]);
			} else {
				List valueList = new ArrayList();
				valueList.add(ids[1]);
				rtnMap[0].put(ids[0], valueList);
			}
			if (rtnMap[1].containsKey(ids[1])) {
				List valueList = (List) rtnMap[1].get(ids[1]);
				if (!valueList.contains(ids[0]))
					valueList.add(ids[0]);
			} else {
				List valueList = new ArrayList();
				valueList.add(ids[0]);
				rtnMap[1].put(ids[1], valueList);
			}
		}
		return rtnMap;
	}

	/**
	 * 将相关的ID从ManyToMany的映射表中读出，再添加到ID列表中
	 * 
	 * @param idList
	 *            原ID列表
	 * @param idMap
	 *            ManyToMany的映射表，可用buildManyToManyIDMap获取
	 * @return 原ID列表+从ManyToMany映射表中扩充的ID列表
	 */
	public static List fetchManyToManyIDList(List idList, Map idMap) {
		List results = new ArrayList();
		for (int i = 0; i < idList.size(); i++)
			fetchManyToManyIDList((String) idList.get(i), results, idMap);
		ArrayUtil.concatTwoList(idList, results);
		return results;
	}

	/**
	 * 将id以及id相关的ID列表（从ManyToMany的映射表中查出）添加到results列表中
	 * 
	 * @param id
	 *            需要添加的ID
	 * @param results
	 *            已有的ID列表
	 * @param idMap
	 *            ManyToMany的映射表，可用buildManyToManyIDMap获取
	 */
	private static void fetchManyToManyIDList(String id, List results, Map idMap) {
		if (results.contains(id))
			return;
		results.add(id);
		if (idMap.containsKey(id)) {
			List idList = (List) idMap.get(id);
			for (int i = 0; i < idList.size(); i++)
				fetchManyToManyIDList((String) idList.get(i), results, idMap);
		}
	}

	/**
	 * 根据域模型名称和查询的属性，判断是否应该添加left join语句 <br>
	 * 样例：输入<br>
	 * modelName=com.landray.kmss.sys.organization.model.SysOrgPerson
	 * propertyName=hbmPosts.fdName<br>
	 * 返回：<br>
	 * [0]="kmss_list_field_0.fdName";<br>
	 * [1]=" left join sysOrgPerson.hbmPosts kmss_list_field_0"
	 * 
	 * @param modelName
	 * @param propertyName
	 * @return 返回值中[0]是left join语句，[1]是封装后的属性
	 */
	public static String[] formatPropertyWithJoin(String modelName,
			String propertyName) {
		return formatPropertyWithJoin(modelName, propertyName, null);
	}

	/**
	 * 根据域模型名称和查询的属性，判断是否应该添加left join语句 <br>
	 * 样例：输入<br>
	 * modelName=com.landray.kmss.sys.organization.model.SysOrgPerson
	 * propertyName=hbmPosts.fdName<br>
	 * startProperty=sysOrgPerson<br>
	 * 返回：<br>
	 * [0]="kmss_list_field_0.fdName";<br>
	 * [1]=" left join sysOrgPerson.hbmPosts kmss_list_field_0"
	 * 
	 * @param modelName
	 * @param propertyName
	 * @param startProperty
	 * @return 返回值中[0]是left join语句，[1]是封装后的属性
	 */
	public static String[] formatPropertyWithJoin(String modelName,
			String propertyName, String startProperty) {
		String[] rtnVal = { "", "" };
		SysDataDict dataDict = SysDataDict.getInstance();
		String[] propertyArray = propertyName.split("\\.");
		String orgModelName = modelName;
		String tmpProperty = startProperty == null ? ModelUtil
				.getModelTableName(modelName) : startProperty;
		for (int i = 0; i < propertyArray.length; i++) {
			SysDictCommonProperty property = (SysDictCommonProperty) dataDict
					.getModel(modelName).getPropertyMap().get(propertyArray[i]);
			if (property == null)
				throw new KmssRuntimeException(new KmssMessage(
						"error.datadict.propertyUndefined", orgModelName,
						propertyName));
			if (property instanceof SysDictListProperty) {
				long index = getFieldIndex();
				rtnVal[1] += " left join " + tmpProperty + "."
						+ propertyArray[i] + " kmss_list_field_" + index + " ";
				tmpProperty = "kmss_list_field_" + index;
			} else {
				tmpProperty += "." + propertyArray[i];
			}
			modelName = property.getType();
		}
		rtnVal[0] = tmpProperty;
		return rtnVal;
	}

	/**
	 * 将“aaa,bbb,ccc”或“aaa;bbb;ccc”的字符串转换为SQL使用的“'aaa','bbb','ccc'”
	 * 
	 * @param str
	 * @return
	 */
	public static String replaceToSQLString(String str) {
		if (str == null)
			return null;
		String rtnVal = str.trim();
		if (rtnVal.length() == 0)
			return str;
		rtnVal = rtnVal.replaceAll("\\s*[,;]\\s*", "','");
		return "'" + rtnVal + "'";
	}

	/**
	 * 返回当前使用数据库的uuid生成函数
	 * 
	 * @return
	 */
	public static String getSqlIDGenerationFunction() {
		String retval = "sys_guid()"; // default oracle
		String sqlDialet = ResourceUtil
				.getKmssConfigString("hibernate.dialect");
		if (sqlDialet.contains("SQLServer")) {
			retval = "newid()";
		} else if (sqlDialet.contains("Oracle")) {
			retval = "sys_guid()";
		} else if (sqlDialet.contains("DB2")) {
			retval = "GENERATE_UNIQUE()";
		} else if (sqlDialet.contains("MySQL")) {
			retval = "UUID()";
		}
		return retval;
	}

	/**
	 * 设置query的预编译参数
	 * 
	 * @param query
	 * @param parameterList
	 */
	public static Query setParameters(Query query,
			List<HQLParameter> parameterList) {
		for (HQLParameter parameter : parameterList) {
			if (parameter.getType() == null) {
				if (parameter.getValue() instanceof Collection<?>) {
					Collection<?> value = (Collection<?>) parameter.getValue();
					query.setParameterList(parameter.getName(), value);
				} else {
					query.setParameter(parameter.getName(), parameter
							.getValue());
				}
			} else {
				if (parameter.getValue() instanceof Collection<?>) {
					Collection<?> value = (Collection<?>) parameter.getValue();
					query.setParameterList(parameter.getName(), value,
							parameter.getType());
				} else {
					query.setParameter(parameter.getName(), parameter
							.getValue(), parameter.getType());
				}
			}
		}
		return query;
	} 
}