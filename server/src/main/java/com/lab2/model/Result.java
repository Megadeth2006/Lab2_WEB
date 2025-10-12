package com.lab2.model;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Bean-компонент для хранения результата проверки попадания точки в область
 */
public class Result implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private double x;
    private double y;
    private double r;
    private boolean hit;
    private String timestamp;
    private long executionTime; // в наносекундах
    
    public Result() {
    }
    
    public Result(double x, double y, double r, boolean hit, long executionTime) {
        this.x = x;
        this.y = y;
        this.r = r;
        this.hit = hit;
        this.executionTime = executionTime;
        this.timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
    }
    
    // Getters and Setters
    public double getX() {
        return x;
    }
    
    public void setX(double x) {
        this.x = x;
    }
    
    public double getY() {
        return y;
    }
    
    public void setY(double y) {
        this.y = y;
    }
    
    public double getR() {
        return r;
    }
    
    public void setR(double r) {
        this.r = r;
    }
    
    public boolean isHit() {
        return hit;
    }
    
    public void setHit(boolean hit) {
        this.hit = hit;
    }
    
    public String getTimestamp() {
        return timestamp;
    }
    
    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
    }
    
    public long getExecutionTime() {
        return executionTime;
    }
    
    public void setExecutionTime(long executionTime) {
        this.executionTime = executionTime;
    }
    
    @Override
    public String toString() {
        return "Result{" +
                "x=" + x +
                ", y=" + y +
                ", r=" + r +
                ", hit=" + hit +
                ", timestamp='" + timestamp + '\'' +
                ", executionTime=" + executionTime +
                '}';
    }
}

