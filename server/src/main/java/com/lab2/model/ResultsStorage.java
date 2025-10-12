package com.lab2.model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 * Bean-компонент для хранения списка результатов проверки в HTTP-сессии
 */
public class ResultsStorage implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private List<Result> results;
    
    public ResultsStorage() {
        this.results = new ArrayList<>();
    }
    
    public List<Result> getResults() {
        return results;
    }
    
    public void setResults(List<Result> results) {
        this.results = results;
    }
    
    public void addResult(Result result) {
        this.results.add(result);
    }
    
    public void clearResults() {
        this.results.clear();
    }
    
    public int getResultsCount() {
        return results.size();
    }
}

