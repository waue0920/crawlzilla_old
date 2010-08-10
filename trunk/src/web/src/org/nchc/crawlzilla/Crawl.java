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

	void go_sh() throws IOException, InterruptedException {
		// my code begin
		String local_urls = "/home/crawler/crawlzilla/urls";
		String nutch_archieve_path = "/home/crawler/crawlzilla";
		String hadoop_path = "/opt/crawlzilla/nutch/bin";
		String path_name = "AA";
		String crawlDepth = "3";
		int exit_id = 0;
		// source /opt/crawlzilla/nutch/conf/hadoop-env.sh
		// 暫時先不用作，看不用hadoop-env.sh 是否匯出錯
		// rm -rf /home/crawler/crawlzilla/search
		// 已經討論過此目錄僅為連結，而新建立的搜尋會放在 crawler/crawlzilla/archieve

		// /opt/crawlzilla/nutch/bin/hadoop dfs -rmr urls search
		// 加入錯誤判斷
		System.out.println("begin");
		String cmd1 = hadoop_path + "/hadoop dfs -rmr urls search ";
		Process nutchService = Runtime.getRuntime().exec(cmd1);
		
		exit_id = nutchService.waitFor();
		
		System.out.println(cmd1);
		// /opt/crawlzilla/nutch/bin/hadoop dfs -put /home/crawler/crawlzilla/urls
		// urls
		
		
		String cmd2 = hadoop_path + "/hadoop dfs -put " + local_urls
				+ " /user/crawler/urls";
		if (exit_id == 0){
			nutchService = Runtime.getRuntime().exec(cmd2);
			System.out.println(cmd2);
			exit_id = nutchService.waitFor();
		}


		// /opt/crawlzilla/nutch/bin/nutch crawl urls -dir search -depth $crawl_dep
		// -topN 5000 -threads 1000
		String cmd3 = hadoop_path + "/nutch crawl urls -dir search -depth "
				+ crawlDepth + " -topN 5000 -threads 1000";
		nutchService = Runtime.getRuntime().exec(cmd3);
		System.out.println(cmd3);

		// /opt/crawlzilla/nutch/bin/hadoop dfs -get search
		// /home/crawler/crawlzilla/search
		String cmd4 = hadoop_path + "/hadoop dfs -get search "
				+ nutch_archieve_path + "/" + path_name;
		nutchService = Runtime.getRuntime().exec(cmd4);
		System.out.println(cmd4);
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
		String urlFile = "/home/crawler/crawlzilla/urls/urls.txt";
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

			Runtime.getRuntime().exec(
					"/home/crawler/crawlzilla/system/go.sh " + crawlDepth + " " + crawlDB);
			// 原本要換成go_sh()但發現問題會比用go.sh還多，因此註解掉
			// go_sh();  
			request.getRequestDispatcher("crawlstatus.jsp").forward(request,response);
			// BufferedReader in = new BufferedReader(new
			// InputStreamReader(nutchService.getInputStream()));
			// String line = null;
			// line = in.readLine();
			// line = "test haha";
			// request.setAttribute("line", line);
			// request.setAttribute("test", "test");
			// # Test process
			// Process nutchService =
			// Runtime.getRuntime().exec("/home/rock/test.sh " + crawlDepth);
			// PrintWriter out = response.getWriter();
			// out.println(line);
			// OutputStream nutchServiceS = nutchService.getOutputStream();

			// while ((line = in.readLine()) != null) {
			// out.println(line);
			// }

			// BufferedReader br = new BufferedReader(nutchServiceS);
			// out.println(nutchServiceS);
			// out.println(nutchService.getErrorStream().toString());
			// out.println(nutchService.exitValue());

		} else {
			//PrintWriter out = response.getWriter();
			// out.println("Error: Can't find /home/crawler/crawlzilla/system/go.sh");
			request.getRequestDispatcher("crawlerror.jsp").forward(request,response);
		}
		
	}

}
