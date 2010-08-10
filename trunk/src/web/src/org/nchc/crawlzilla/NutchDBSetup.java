package org.nchc.crawlzilla;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class NutchDBSetup
 */
public class NutchDBSetup extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public NutchDBSetup() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.setContentType("text/html; charset=UTF-8");
		request.setCharacterEncoding("UTF-8");
		String name = request.getParameter("fileName");
		String target = "/home/nutchuser/nutchez/archieve/"+name;
		String newLink = "/home/nutchuser/nutchez/search";
		// remove old link
		File oldLn = new File("/home/nutchuser/nutchez/search");
		oldLn.delete();
		
		// # setup path
		Process process = Runtime.getRuntime().exec("ln -s /home/nutchuser/nutchez/archieve/"+name+" /home/nutchuser/nutchez/search");
		try {
			process.waitFor();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		process.destroy();
		
		//PrintWriter out = response.getWriter();
		//out.println(name);
		
		//request.getRequestDispatcher("nutch_DB_status.jsp").forward(request,response);
				
		response.sendRedirect("nutch_DB_status.jsp");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		

	}

}
