/*
 * 创建日期 2006-三月-19
 *
 */
package com.landray.kmss.common.model;

import java.io.Serializable;
import java.lang.reflect.Method;

import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.commons.lang.builder.ToStringStyle;

import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.ObjectUtil;

/**
 * 区间
 * 
 * @author 孙真
 */
public class PeriodModel implements Serializable {

	/*
	 * 名称
	 */
	private java.lang.String fdName;

	/*
	 * 开始时间
	 */
	private java.util.Date fdStart;

	/*
	 * 结束时间
	 */
	private java.util.Date fdEnd;

	/*
	 * 区间类型
	 */
	private PeriodTypeModel periodType = null;

	public PeriodModel() {
		super();
	}

	/**
	 * @return 返回 名称
	 */
	public java.lang.String getFdName() {
		return fdName;
	}

	/**
	 * @param fname
	 *            要设置的 名称
	 */
	public void setFdName(java.lang.String fdName) {
		this.fdName = fdName;
	}

	/**
	 * @return 返回 开始时间
	 */
	public java.util.Date getFdStart() {
		return fdStart;
	}

	/**
	 * @param fstart
	 *            要设置的 开始时间
	 */
	public void setFdStart(java.util.Date fdStart) {
		this.fdStart = fdStart;
	}

	/**
	 * @return 返回 结束时间
	 */
	public java.util.Date getFdEnd() {
		return fdEnd;
	}

	/**
	 * @param fend
	 *            要设置的 结束时间
	 */
	public void setFdEnd(java.util.Date fdEnd) {
		this.fdEnd = fdEnd;
	}

	/**
	 * @return 返回 区间类型
	 */
	public PeriodTypeModel getPeriodType() {
		return periodType;
	}

	/**
	 * @param periodType
	 *            要设置的 区间类型
	 */
	public void setPeriodType(PeriodTypeModel periodType) {
		this.periodType = periodType;
	}

	private static long hashCodeIndex = 0;

	protected Long fdId;

	public Long getFdId() {
		return fdId;
	}

	public void setFdId(Long id) {
		this.fdId = id;
	}

	/**
	 * 覆盖toString方法，使用列出域模型中的所有get方法返回的值（不获取返回值类型为非java.lang.*的值）
	 * 
	 * @see java.lang.Object#toString()
	 */
	public String toString() {
		try {
			Method[] methodList = this.getClass().getMethods();
			ToStringBuilder rtnVal = new ToStringBuilder(this,
					ToStringStyle.MULTI_LINE_STYLE);
			for (int i = 0; i < methodList.length; i++) {
				String methodName = methodList[i].getName();
				if (methodList[i].getParameterTypes().length > 0
						|| !methodName.startsWith("get")
						|| methodName.equals("getClass"))
					continue;
				methodName = methodList[i].getReturnType().toString();
				if ((methodName.startsWith("class") || methodName
						.startsWith("interface"))
						&& !(methodName.startsWith("class java.lang.") || methodName
								.startsWith("interface java.lang.")))
					continue;
				try {
					rtnVal.append(methodList[i].getName().substring(3),
							methodList[i].invoke(this, null));
				} catch (Exception e) {
				}
			}
			return rtnVal.toString().replaceAll("@[^\\[]+\\[\\r\\n", "[\r\n");
		} catch (Exception e) {
			return super.toString();
		}
	}

	/**
	 * 覆盖equals方法，仅比较类型是否相等以及关键字是否相等
	 * 
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	public boolean equals(Object object) {
		if (this == object)
			return true;
		if (object == null)
			return false;
		if (!ModelUtil.getModelClassName(object).equals(
				ModelUtil.getModelClassName(this)))
			return false;
		BaseModel objModel = (BaseModel) object;
		return ObjectUtil.equals(objModel.getFdId(), this.getFdId(), false);
	}

	/**
	 * 覆盖hashCode方法，通过模型中类名和ID构建哈希值
	 * 
	 * @see java.lang.Object#hashCode()
	 */
	public int hashCode() {
		HashCodeBuilder rtnVal = new HashCodeBuilder(-426830461, 631494429);
		rtnVal.append(ModelUtil.getModelClassName(this));
		long id = 0;
		if (getFdId() == null) {
			hashCodeIndex++;
			if (hashCodeIndex > 100000000)
				hashCodeIndex = 0;
			id = hashCodeIndex;
		} else {
			id = getFdId().longValue() + 100000000;
		}
		rtnVal.append(new Long(id));
		return rtnVal.toHashCode();
	}

}
