package it.anitour.model;

public class User {
    private int id;
    private String username;
    private String password;
    private String email;
    private String type;

    public User() {
    }

    public User(int id, String username, String password, String email, String type) {
        this.id = id;
        this.username = username;
        this.password = password;
        this.email = email;
        this.type = type;
    }

    // Getter e Setter per id
    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    // Getter e Setter per username
    public String getUsername() {
        return username;
    }
    public void setUsername(String username) {
        this.username = username;
    }

    // Getter e Setter per password
    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }

    // Getter e Setter per email
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    // Getter e Setter per type
    public String getType() {
        return type;
    }
    public void setType(String type) {
        this.type = type;
    }
}
