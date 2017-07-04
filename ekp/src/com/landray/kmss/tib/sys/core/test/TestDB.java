package com.landray.kmss.tib.sys.core.test;

import java.sql.Connection;
import java.sql.Date;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

public class TestDB {

	/**
	 * @param args
	 * @throws SQLException 
	 * @throws Exception 
	 */
	public static void main(String[] args) throws SQLException {
		long start=System.currentTimeMillis();
		Connection conn = null;
		PreparedStatement ps = null;
		try {
			Class.forName("net.sourceforge.jtds.jdbc.Driver");
			conn = DriverManager.getConnection("jdbc:jtds:sqlserver://localhost:1433/ekp_sap", "sa", "1");
			conn.setAutoCommit(false);
			String sql = "insert into z_test(curr_time) values (?)";
			ps = conn.prepareStatement(sql);
			for (int j = 0; j < 10; j++) {
				for (int i = 0; i < 1000; i++) {
					ps.setTimestamp(1, new Timestamp(new java.util.Date().getTime())); 
					ps.addBatch();
				}
				ps.executeBatch();
				conn.commit();
				ps.clearBatch();
			}
			
			long end=System.currentTimeMillis();
			System.out.println("------耗时-----"+ (end - start));
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			conn.close();
			ps.close();
		}
	}

}
