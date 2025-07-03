package it.anitour.model;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

public class Cart {
    private Map<Integer, CartItem> items;
    
    public Cart() {
        this.items = new HashMap<>();
    }
    
    public void addItem(Tour tour, int quantity) {
        int tourId = tour.getId();
        
        if (items.containsKey(tourId)) {
            CartItem existingItem = items.get(tourId);
            existingItem.setQuantity(existingItem.getQuantity() + quantity);
        } else {
            CartItem newItem = new CartItem(tour, quantity);
            items.put(tourId, newItem);
        }
    }
    
    public void updateItemQuantity(int tourId, int quantity) {
        if (items.containsKey(tourId)) {
            if (quantity <= 0) {
                removeItem(tourId);
            } else {
                items.get(tourId).setQuantity(quantity);
            }
        }
    }
    
    public void removeItem(int tourId) {
        items.remove(tourId);
    }
    
    public void clear() {
        items.clear();
    }
    
    public Collection<CartItem> getItems() {
        return items.values();
    }
    
    public boolean isEmpty() {
        return items.isEmpty();
    }
    
    public int getTotalItems() {
        return items.values().stream().mapToInt(CartItem::getQuantity).sum();
    }
    
    public double getTotalPrice() {
        return items.values().stream().mapToDouble(CartItem::getTotal).sum();
    }
    
    public CartItem getItem(int tourId) {
        return items.get(tourId);
    }
    
    public boolean containsItem(int tourId) {
        return items.containsKey(tourId);
    }
}