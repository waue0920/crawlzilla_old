package org.nchc.nutchez;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class TomcatRestart
 */
public class TomcatRestart extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public TomcatRestart() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		Process processShutdown = Runtime.getRuntime().exec("/home/nutchuser/nutchez/system/tomcat_restart.sh");
		try {
			processShutdown.waitFor();
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		processShutdown.destroy();
		
		try{  
			  Thread.sleep(5000);          
	        }
		catch(InterruptedException   ex){
	        ex.printStackTrace();
			}
		
		response.sendRedirect("nutch_DB.jsp");
		
//		PrintWriter out = response.getWriter();
//		out.println("haha");
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
