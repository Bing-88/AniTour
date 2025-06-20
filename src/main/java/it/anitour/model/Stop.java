package it.anitour.model;

public class Stop {
    private int id;
    private int tourId;
    private String name;
    private String description;
    private int stopOrder;

    public Stop() {
    }

    public Stop(int id, int tourId, String name, String description, int stopOrder) {
        this.id = id;
        this.tourId = tourId;
        this.name = name;
        this.description = description;
        this.stopOrder = stopOrder;
    }

    // Getter e Setter per id
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    // Getter e Setter per tourId
    public int getTourId() {
        return tourId;
    }
    public void setTourId(int tourId) {
        this.tourId = tourId;
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

    // Getter e Setter per stopOrder
    public int getStopOrder() {
        return stopOrder;
    }
    public void setStopOrder(int stopOrder) {
        this.stopOrder = stopOrder;
    }

}
