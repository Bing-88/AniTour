package it.anitour.controller;

import it.anitour.model.User;
import it.anitour.model.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Servlet implementation class SignupServlet
 */

public class SignupServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public SignupServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String password2 = request.getParameter("password2");

        if (!password.equals(password2)) {
            response.sendRedirect("signup.jsp?error=password");
            return;
        }

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(password); // In produzione, cifra la password!
        user.setType("user");

        try {
            UserDAO dao = new UserDAO();
            if (dao.findByUsername(username) != null) {
                response.sendRedirect("signup.jsp?error=exists");
                return;
            }
            dao.insertUser(user);
            response.sendRedirect("login.jsp?registered=1");
        } catch (Exception e) {
            e.printStackTrace(); // AGGIUNGI QUESTA RIGA
            response.sendRedirect("signup.jsp?error=server");
        }
    }

}
