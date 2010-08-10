package org.nchc.crawlzilla;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.nchc.crawlzilla.NutchDBNumBean;

/**
 * Servlet implementation class Crawl
 */
public class Crawl extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Crawl() {
		super();
		// TODO Auto-generated constructor stub
	}


	
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("text/html; charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		String crawlDepth = request.getParameter("name_crawl_depth");
		String crawlURL = request.getParameter("name_crawl_url");
		String urlFile = "/home/crawler/crawlzilla/urls/urls.txt ";
		String crawlDB = request.getParameter("name_crawl_db");
		NutchDBNumBean nutchDBNum = new NutchDBNumBean();
		
		// # print message.
		 PrintWriter out = response.getWriter();
		 out.println(crawlDB);
		// out.println("Depth is: " + crawlDepth);
		// out.println("URLs is: " + crawlURL);
		// out.println("URLs Length is: " +crawlURL.length());

		// # check duplicate name
		nutchDBNum.setFiles("/home/crawler/crawlzilla/archieve/");
		nutchDBNum.setNum("/home/crawler/crawlzilla/archieve/");
		File files[] = nutchDBNum.getFiles();
		int num=nutchDBNum.getNum();
		
		for (int i=0 ; i<num; i++){
			if (files[i].getName().equalsIgnoreCase(crawlDB)){
				request.getRequestDispatcher("crawl_dup_filename.jsp").forward(request,response);
				return;
			}
		}
		//
		try {
			FileWriter writeURLFile = new FileWriter(urlFile);
			writeURLFile.write("");
			writeURLFile.append(crawlURL);
			writeURLFile.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

		File goFile = new File("/home/crawler/crawlzilla/system/go.sh");

		if (goFile.exists()) {

			Runtime.getRuntime().exec("/home/crawler/crawlzilla/system/go.sh " + crawlDepth + " " + crawlDB);

			request.getRequestDispatcher("crawlstatus.jsp").forward(request,response);

		} else {
			//PrintWriter out = response.getWriter();
			// out.println("Error: Can't find /home/nutchuser/nutchez/system/go.sh");
			request.getRequestDispatcher("crawlerror.jsp").forward(request,response);
		}
		
	}

}
