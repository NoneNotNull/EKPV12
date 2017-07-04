/**
 * 配置样例
	<bean
		id="nativeJdbcExtractor"
		class="org.springframework.jdbc.support.nativejdbc.SimpleNativeJdbcExtractor" />
	
	<bean
		id="oracleLobHandler"
		class="com.landray.kmss.common.dao.OracleLobHandler"
		lazy-init="true">

		<property name="nativeJdbcExtractor">

			<ref bean="nativeJdbcExtractor" />

		</property>
		<property name="hibernateDialect">

			<value>${hibernate.dialect}</value>

		</property>

	</bean>
	
	<bean
		id="sessionFactory"
		class="com.landray.kmss.sys.config.loader.KmssHibernateLocalSessionFactoryBean">
		<property name="hibernateProperties">
			<props>
				<prop key="hibernate.dialect">
					${hibernate.dialect}
				</prop>
			</props>
		</property>
		<property name="dataSource">
			<ref bean="dataSource" />
		</property>
		
		<property name="lobHandler">

			<ref bean="oracleLobHandler" />

		</property>
		 
	</bean>
 */
package com.landray.kmss.common.dao;

import java.io.IOException;
import java.io.Reader;
import java.io.StringReader;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;

import javax.transaction.TransactionManager;

import org.hibernate.HibernateException;
import org.hibernate.usertype.UserType;
import org.springframework.jdbc.support.lob.LobCreator;
import org.springframework.jdbc.support.lob.LobHandler;
/**
 * 
 * @author Administrator
 *
 */
public class ClobStringType extends AbstractLobType implements UserType {
	public ClobStringType() {
		super();
	}

	/**
	 * Constructor used for testing: takes an explicit LobHandler
	 * and an explicit JTA TransactionManager (can be <code>null</code>).
	 */
	protected ClobStringType(LobHandler lobHandler, TransactionManager jtaTransactionManager) {
		super(lobHandler, jtaTransactionManager);
	}

	public int[] sqlTypes() {
		return new int[] {Types.CLOB};
	}

	public Class returnedClass() {
		return String.class;
	}

	protected Object nullSafeGetInternal(
			ResultSet rs, String[] names, Object owner, LobHandler lobHandler)
			throws SQLException {
		return lobHandler.getClobAsString(rs, names[0]);
	}

	protected void nullSafeSetInternal(
			PreparedStatement ps, int index, Object value, LobCreator lobCreator)
			throws SQLException {
		lobCreator.setClobAsString(ps, index, (String) value);
	}

	protected Object nullSafeGetDefault(ResultSet rs, String[] names, Object owner) throws SQLException, IOException, HibernateException {
		try {
			Object value = get(rs,names[0]);
			if ( value == null || rs.wasNull() ) {

				return null;
			}
			else {

				return value;
			}
		}
		catch ( RuntimeException re ) {
			throw re;
		}
		catch ( SQLException se ) {
			throw se;
		}

	}

	protected void nullSafeSetDefault(PreparedStatement ps, int index, Object value) throws SQLException, IOException, HibernateException {
		try {
			if ( value == null ) {

				ps.setNull( index, sqlType() );
			}
			else {

				set( ps, value, index );
			}
		}
		catch ( RuntimeException re ) {
			throw re;
		}
		catch ( SQLException se ) {
			throw se;
		}
		
	}
	public int sqlType() {
		return Types.CLOB; //or Types.LONGVARCHAR?
	}
	public void set(PreparedStatement st, Object value, int index) throws HibernateException, SQLException {
		String str = (String) value;
		st.setCharacterStream( index, new StringReader(str), str.length() );
	}

	public Object get(ResultSet rs, String name) throws HibernateException, SQLException {

			// Retrieve the value of the designated column in the current row of this
			// ResultSet object as a java.io.Reader object
			Reader charReader = rs.getCharacterStream(name);

			// if the corresponding SQL value is NULL, the reader we got is NULL as well
			if (charReader==null) return null;

			// Fetch Reader content up to the end - and put characters in a StringBuffer
			StringBuffer sb = new StringBuffer();
			try {
				char[] buffer = new char[2048];
				while (true) {
					int amountRead = charReader.read(buffer, 0, buffer.length);
					if ( amountRead == -1 ) break;
					sb.append(buffer, 0, amountRead);
				}
			}
			catch (IOException ioe) {
				throw new HibernateException( "IOException occurred reading text", ioe );
			}
			finally {
				try {
					charReader.close();
				}
				catch (IOException e) {
					throw new HibernateException( "IOException occurred closing stream", e );
				}
			}

			// Return StringBuffer content as a large String
			return sb.toString();
	}
}
