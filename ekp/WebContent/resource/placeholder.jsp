<%@page import="java.awt.Font"%>
<%@page import="java.awt.Color"%>
<%@page import="java.io.OutputStream"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="java.awt.Transparency,java.awt.Graphics2D,java.awt.image.BufferedImage"%>
<%@ page language="java" pageEncoding="UTF-8" contentType="image/png"%>
<%
	int width = 300;
	int height = 21;
	String text = request.getParameter("text");
	// 创建BufferedImage对象
	BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
	// 获取Graphics2D
	Graphics2D g2d = image.createGraphics();
	// ---------- 增加下面的代码使得背景透明 -----------------
	image = g2d.getDeviceConfiguration().createCompatibleImage(width,
			height, Transparency.TRANSLUCENT);
	g2d.dispose();
	g2d = image.createGraphics();
	// ---------- 背景透明代码结束 -----------------
	g2d.setColor(new Color(167, 167, 167));
	g2d.setFont(new Font("Microsoft YaHei", Font.PLAIN, 12));// 输出的
	g2d.drawString(text, 5, 15);
	// 释放对象
	g2d.dispose();
	
	
	OutputStream outStream = response.getOutputStream();
	ImageIO.write(image, "png", outStream);
	out.clear();  
	out=pageContext.pushBody(); 
%>