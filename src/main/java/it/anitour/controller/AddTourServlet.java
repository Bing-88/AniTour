package it.anitour.controller;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
import java.util.UUID;
import java.io.File;

import it.anitour.model.Stop;
import it.anitour.model.Tour;
import it.anitour.model.TourDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1 MB
    maxFileSize = 1024 * 1024 * 10,  // 10 MB
    maxRequestSize = 1024 * 1024 * 15 // 15 MB
)
public class AddTourServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIRECTORY = "images";
    
    public AddTourServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("type");
        
        if (userType == null || !userType.equals("admin")) {
            response.sendRedirect("/AniTour/profile?error=unauthorized");
            return;
        }
        
        try {
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            Date startDate = Date.valueOf(request.getParameter("startDate"));
            Date endDate = Date.valueOf(request.getParameter("endDate"));
            
            String imagePath = "/AniTour/images/default-tour.jpg";
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = UUID.randomUUID().toString() + getFileExtension(filePart);
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }
                
                filePart.write(uploadPath + File.separator + fileName);
                imagePath = "/AniTour/images/" + fileName;
            }
            
            Tour tour = new Tour();
            tour.setName(name);
            tour.setDescription(description);
            tour.setPrice(price);
            tour.setStartDate(startDate);
            tour.setEndDate(endDate);
            tour.setImagePath(imagePath);
            
            TourDAO tourDAO = new TourDAO();
            tourDAO.insert(tour);
            
            List<Stop> stops = new ArrayList<>();
            Enumeration<String> parameterNames = request.getParameterNames();
            int stopCounter = 1;
            
            while (parameterNames.hasMoreElements()) {
                String paramName = parameterNames.nextElement();
                if (paramName.startsWith("stopName")) {
                    String stopNumberStr = paramName.substring(8);
                    String stopDescParam = "stopDescription" + stopNumberStr;
                    
                    String stopName = request.getParameter(paramName);
                    String stopDesc = request.getParameter(stopDescParam);
                    
                    if (stopName != null && !stopName.trim().isEmpty()) {
                        Stop stop = new Stop();
                        stop.setTourId(tour.getId());
                        stop.setName(stopName);
                        stop.setDescription(stopDesc);
                        stop.setStopOrder(stopCounter++);
                        stops.add(stop);
                    }
                }
            }
            
            for (Stop stop : stops) {
                tourDAO.insertStop(stop);
            }
            
            response.sendRedirect("/AniTour/profile?success=tour_added");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("/AniTour/profile?error=add_tour_failed");
        }
    }
    
    private String getFileExtension(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String item : items) {
            if (item.trim().startsWith("filename")) {
                String fileName = item.substring(item.indexOf("=") + 2, item.length() - 1);
                return fileName.substring(fileName.lastIndexOf("."));
            }
        }
        return "";
    }
}