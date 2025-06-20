package it.anitour.model;

public class Booking {
    private int id;
    private int userId;
    private int tourId;
    private double price;

    public Booking() {
    }

    public Booking(int id, int userId, int tourId, double price) {
        this.id = id;
        this.userId = userId;
        this.tourId = tourId;
        this.price = price;
    }

    // Getter e Setter per id
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    // Getter e Setter per userId
    public int getUserId() {
        return userId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }

    // Getter e Setter per tourId
    public int getTourId() {
        return tourId;
    }
    public void setTourId(int tourId) {
        this.tourId = tourId;
    }

    // Getter e Setter per price
    public double getPrice() {
        return price;
    }
    public void setPrice(double price) {
        this.price = price;
    }
}
