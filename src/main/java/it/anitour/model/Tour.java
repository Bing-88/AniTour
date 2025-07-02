package it.anitour.model;
import java.sql.Date;
import java.util.List;

public class Tour {
    private int id;
    private String name;
    private String description;
    private double price;
    private Date startDate;
    private Date endDate;
    private String imagePath;
    private List<Stop> stops;
    private String slug;
    
    // Getter e Setter per id
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    // Getter e Setter per name
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    // Getter e Setter per description
    public String getDescription() {
        return description;
    }
    public void setDescription(String description) {
        this.description = description;
    }

    // Getter e Setter per price
    public double getPrice() {
        return price;
    }
    public void setPrice(double price) {
        this.price = price;
    }

    // Getter e Setter per startDate
    public Date getStartDate() {
        return startDate;
    }
    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    // Getter e Setter per endDate
    public Date getEndDate() {
        return endDate;
    }
    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    // Getter e Setter per imagePath
    public String getImagePath() {
        return imagePath;
    }
    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    // Getter e Setter per stops
    public List<Stop> getStops() {
        return stops;
    }
    public void setStops(List<Stop> stops) {
        this.stops = stops;
    }

    // Getter e Setter per slug
    public String getSlug() {
        return slug;
    }

    // Setter per slug
    public void setSlug(String slug) {
        this.slug = slug;
    }
}