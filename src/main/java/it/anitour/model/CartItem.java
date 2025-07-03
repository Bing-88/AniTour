package it.anitour.model;

public class CartItem {
    private int id;
    private Tour tour;
    private int quantity;
    private double price;  // Prezzo al momento dell'aggiunta al carrello
    
    public CartItem() {}
    
    public CartItem(Tour tour, int quantity) {
        this.tour = tour;
        this.quantity = quantity;
        this.price = tour.getPrice();
    }
    
    public int getId() {
        return id;
    }
    
    public void setId(int id) {
        this.id = id;
    }
    
    public Tour getTour() {
        return tour;
    }
    
    public void setTour(Tour tour) {
        this.tour = tour;
    }
    
    public int getQuantity() {
        return quantity;
    }
    
    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }
    
    public double getPrice() {
        return price;
    }
    
    public void setPrice(double price) {
        this.price = price;
    }
    
    public double getTotal() {
        return price * quantity;
    }
}