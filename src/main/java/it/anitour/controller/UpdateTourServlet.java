package it.anitour.controller;

import java.io.IOException;
import java.sql.Date;
import java.sql.SQLException;
import java.util.Enumeration;
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
public class UpdateTourServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private TourDAO tourDAO;
    
    public void init() {
        tourDAO = new TourDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("type");
        
        if (userType == null || !userType.equals("admin")) {
            response.sendRedirect("/AniTour/login");
            return;
        }
        
        // Gestisci richieste AJAX per ottenere i dati del tour
        String action = request.getParameter("action");
        if ("getTourData".equals(action)) {
            String tourIdStr = request.getParameter("tourId");
            if (tourIdStr != null && !tourIdStr.isEmpty()) {
                try {
                    int tourId = Integer.parseInt(tourIdStr);
                    Tour tour = tourDAO.findById(tourId);
                    
                    if (tour != null) {
                        response.setContentType("application/json");
                        response.setCharacterEncoding("UTF-8");
                        
                        StringBuilder json = new StringBuilder();
                        json.append("{");
                        json.append("\"id\":").append(tour.getId()).append(",");
                        json.append("\"name\":\"").append(escapeJson(tour.getName())).append("\",");
                        json.append("\"description\":\"").append(escapeJson(tour.getDescription())).append("\",");
                        json.append("\"price\":").append(tour.getPrice()).append(",");
                        json.append("\"startDate\":\"").append(tour.getStartDate()).append("\",");
                        json.append("\"endDate\":\"").append(tour.getEndDate()).append("\",");
                        json.append("\"imagePath\":\"").append(escapeJson(tour.getImagePath() != null ? tour.getImagePath() : "")).append("\",");
                        json.append("\"stops\":[");
                        
                        if (tour.getStops() != null) {
                            for (int i = 0; i < tour.getStops().size(); i++) {
                                Stop stop = tour.getStops().get(i);
                                if (i > 0) json.append(",");
                                json.append("{");
                                json.append("\"name\":\"").append(escapeJson(stop.getName())).append("\",");
                                json.append("\"description\":\"").append(escapeJson(stop.getDescription())).append("\"");
                                json.append("}");
                            }
                        }
                        
                        json.append("]");
                        json.append("}");
                        
                        response.getWriter().write(json.toString());
                        return;
                    }
                } catch (NumberFormatException | SQLException e) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\":\"Tour non trovato\"}");
                    return;
                }
            }
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"ID tour non valido\"}");
            return;
        }
        
        response.sendRedirect("/AniTour/profile");
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("type");
        
        if (userType == null || !userType.equals("admin")) {
            response.sendRedirect("/AniTour/login");
            return;
        }
        
        try {
            // Prova a ottenere tourId dai parametri POST (multipart/form-data)
            String tourIdStr = request.getParameter("tourId");
            
            // Se non è nei parametri POST, prova nei parametri GET (query string)
            if (tourIdStr == null || tourIdStr.isEmpty()) {
                // Estrai dalla query string dell'URL
                String queryString = request.getQueryString();
                if (queryString != null && queryString.contains("tourId=")) {
                    String[] params = queryString.split("&");
                    for (String param : params) {
                        if (param.startsWith("tourId=")) {
                            tourIdStr = param.substring("tourId=".length());
                            // Decodifica URL se necessario
                            tourIdStr = java.net.URLDecoder.decode(tourIdStr, "UTF-8");
                            break;
                        }
                    }
                }
            }
            
            if (tourIdStr == null || tourIdStr.isEmpty()) {
                // Debug: stampa tutti i parametri disponibili
                System.out.println("=== DEBUG: Parametri disponibili ===");
                System.out.println("Query String: " + request.getQueryString());
                System.out.println("Method: " + request.getMethod());
                System.out.println("Content Type: " + request.getContentType());
                System.out.println("Content Length: " + request.getContentLength());
                
                Enumeration<String> paramNames = request.getParameterNames();
                boolean hasParams = false;
                while (paramNames.hasMoreElements()) {
                    hasParams = true;
                    String paramName = paramNames.nextElement();
                    String paramValue = request.getParameter(paramName);
                    System.out.println("Parametro: " + paramName + " = " + paramValue);
                }
                
                if (!hasParams) {
                    System.out.println("NESSUN PARAMETRO TROVATO!");
                }
                
                // Prova a leggere le Part multipart
                try {
                    System.out.println("=== DEBUG: Part multipart ===");
                    
                    // Prova direttamente a ottenere la parte tourId
                    Part tourIdPart = request.getPart("tourId");
                    if (tourIdPart != null) {
                        System.out.println("Trovata part tourId!");
                        System.out.println("Part size: " + tourIdPart.getSize());
                        
                        if (tourIdPart.getSize() > 0) {
                            java.io.BufferedReader reader = new java.io.BufferedReader(
                                new java.io.InputStreamReader(tourIdPart.getInputStream())
                            );
                            String value = reader.readLine();
                            reader.close();
                            
                            if (value != null && !value.trim().isEmpty()) {
                                tourIdStr = value.trim();
                                System.out.println("Valore da part tourId: " + tourIdStr);
                            }
                        }
                    } else {
                        System.out.println("Part tourId non trovata!");
                        
                        // Lista tutte le parti disponibili
                        for (Part part : request.getParts()) {
                            System.out.println("Part disponibile: " + part.getName() + 
                                             " (size: " + part.getSize() + 
                                             ", content-type: " + part.getContentType() + ")");
                        }
                    }
                } catch (Exception partEx) {
                    System.out.println("Errore leggendo le part: " + partEx.getMessage());
                    partEx.printStackTrace();
                }
                
                System.out.println("=== Fine DEBUG ===");
                
                if (tourIdStr == null || tourIdStr.isEmpty()) {
                    response.sendRedirect("/AniTour/profile?updateTourError=missing_id_not_found");
                    return;
                }
            }
            
            int tourId = Integer.parseInt(tourIdStr);
            Tour existingTour = tourDAO.findById(tourId);
            
            if (existingTour == null) {
                response.sendRedirect("/AniTour/profile?updateTourError=tour_not_found");
                return;
            }
            
            // Ottieni i parametri del form
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            
            // Validazione base
            if (name == null || name.trim().isEmpty() ||
                description == null || description.trim().isEmpty() ||
                priceStr == null || priceStr.trim().isEmpty() ||
                startDateStr == null || startDateStr.trim().isEmpty() ||
                endDateStr == null || endDateStr.trim().isEmpty()) {
                
                response.sendRedirect("/AniTour/profile?updateTourError=missing_fields");
                return;
            }
            
            double price = Double.parseDouble(priceStr);
            Date startDate = Date.valueOf(startDateStr);
            Date endDate = Date.valueOf(endDateStr);
            
            // Validazione date
            if (endDate.before(startDate)) {
                response.sendRedirect("/AniTour/profile?updateTourError=invalid_dates");
                return;
            }
            
            // Aggiorna il tour esistente
            existingTour.setName(name.trim());
            existingTour.setDescription(description.trim());
            existingTour.setPrice(price);
            existingTour.setStartDate(startDate);
            existingTour.setEndDate(endDate);
            
            // Gestione dell'upload dell'immagine (opzionale per l'aggiornamento)
            Part imagePart = request.getPart("image");
            if (imagePart != null && imagePart.getSize() > 0) {
                String fileName = imagePart.getSubmittedFileName();
                if (fileName != null && !fileName.isEmpty()) {
                    String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                    String uniqueFileName = UUID.randomUUID().toString() + fileExtension;
                    
                    String uploadPath = getServletContext().getRealPath("/images/");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    
                    String filePath = uploadPath + uniqueFileName;
                    imagePart.write(filePath);
                    
                    existingTour.setImagePath("/AniTour/images/" + uniqueFileName);
                }
            }
            
            // Mantieni le tappe esistenti (non le modifichiamo più)
            // Le tappe rimangono quelle già presenti nel database
            
            // Aggiorna il tour nel database (senza modificare le tappe)
            tourDAO.updateBasicInfo(existingTour);
            
            // Usa redirect con parametro di successo
            response.sendRedirect("/AniTour/profile?updateTourSuccess=true");
            return;
            
        } catch (NumberFormatException e) {
            response.sendRedirect("/AniTour/profile?updateTourError=format");
            return;
        } catch (SQLException e) {
            response.sendRedirect("/AniTour/profile?updateTourError=database");
            return;
        } catch (Exception e) {
            response.sendRedirect("/AniTour/profile?updateTourError=unexpected");
            return;
        }
    }
    
    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\b", "\\b")
                   .replace("\f", "\\f")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r")
                   .replace("\t", "\\t");
    }
}
