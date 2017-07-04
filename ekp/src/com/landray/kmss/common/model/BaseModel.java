package com.landray.kmss.common.model;

import java.io.Serializable;
import java.lang.reflect.Method;

import net.sf.cglib.transform.impl.InterceptFieldCallback;

import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.commons.lang.builder.ToStringStyle;

import com.landray.kmss.common.convertor.ModelToFormPropertyMap;
import com.landray.kmss.sys.config.dict.SysDictModel;
import com.landray.kmss.util.IDGenerator;
import com.landray.kmss.util.ModelUtil;
import com.landray.kmss.util.ObjectUtil;

/**
 * 域模型的基类，建议大部分的域模型继承，只有域模型继承了该类，后面的Dao、Service、Action等才能继承通用的相应的实现。<br>
 * 使用限制条件：<br>
 * 1、对应数据库表必须为单主键，主键的数据类型为long类型，名称必须为f_id；<br>
 * 2、域模型中对主键的映射为fdId（全系统内置，继承后不需要在域模型中添加该域的声明）
 * 
 * @author 叶中奇
 * @version 1.0 2006-04-02
 */
public abstract class BaseModel implements IBaseModel, Serializable {
	private transient InterceptFieldCallback $CGLIB_READ_WRITE_CALLBACK;

	protected SysDictModel sysDictModel;

	protected String fdId;

	public String getFdId() {
		if (fdId == null) {
			fdId = IDGenerator.generateID();
		}
		return fdId;
	}

	public void setFdId(String id) {
		this.fdId = id;
	}

	public void recalculateFields() {

	}

	public ModelToFormPropertyMap getToFormPropertyMap() {
		return new ModelToFormPropertyMap();
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
		rtnVal.append(getFdId());
		return rtnVal.toHashCode();
	}

	protected Object readLazyField(String fieldName, Object oldValue) {
		if (getInterceptFieldCallback() == null) {
			return oldValue;
		}
		return getInterceptFieldCallback()
				.readObject(this, fieldName, oldValue);
	}

	protected Object writeLazyField(String fieldName, Object oldValue,
			Object newValue) {
		if (getInterceptFieldCallback() == null) {
			return newValue;
		}
		return getInterceptFieldCallback().writeObject(this, fieldName,
				oldValue, newValue);
	}

	public InterceptFieldCallback getInterceptFieldCallback() {
		return $CGLIB_READ_WRITE_CALLBACK;
	}

	public void setInterceptFieldCallback(
			InterceptFieldCallback interceptfieldcallback) {
		$CGLIB_READ_WRITE_CALLBACK = interceptfieldcallback;
	}

	public SysDictModel getSysDictModel() {
		return sysDictModel;
	}

	public void setSysDictModel(SysDictModel sysDictModel) {
		this.sysDictModel = sysDictModel;
	}
}
