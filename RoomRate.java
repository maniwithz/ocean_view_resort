package com.oceanview.model;

import java.math.BigDecimal;

public class RoomRate {
    private int id;
    private String category;
    private String type;
    private BigDecimal price;

    public RoomRate() {
    }

    public RoomRate(int id, String category, String type, BigDecimal price) {
        this.id = id;
        this.category = category;
        this.type = type;
        this.price = price;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }
}
