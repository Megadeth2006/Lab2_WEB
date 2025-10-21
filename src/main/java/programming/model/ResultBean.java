package programming.model;

import javax.enterprise.context.ApplicationScoped;
import javax.enterprise.inject.Default;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;


@ApplicationScoped
@Default
public class ResultBean implements Serializable {
    private static final long serialVersionUID = 1L;
    

    private final List<ResultData> results;
    
    public ResultBean() {
        this.results = new CopyOnWriteArrayList<>();
    }
    

    public synchronized void addResult(double x, double y, double r, boolean hit, long executionTime) {
        ResultData result = new ResultData(x, y, r, hit, executionTime);
        this.results.add(result);
    }
    

    public synchronized List<ResultData> getResults() {
        return new ArrayList<>(results);
    }
    

    public synchronized int getResultsCount() {
        return results.size();
    }
    

    public synchronized void clearResults() {
        this.results.clear();
    }

    public static class ResultData implements Serializable {
        private static final long serialVersionUID = 1L;
        
        private double x;
        private double y;
        private double r;
        private boolean hit;
        private String timestamp;
        private long executionTime;
        
        public ResultData() {
        }
        
        public ResultData(double x, double y, double r, boolean hit, long executionTime) {
            this.x = x;
            this.y = y;
            this.r = r;
            this.hit = hit;
            this.executionTime = executionTime;
            this.timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        }
        

        public double getX() { return x; }
        public void setX(double x) { this.x = x; }
        
        public double getY() { return y; }
        public void setY(double y) { this.y = y; }
        
        public double getR() { return r; }
        public void setR(double r) { this.r = r; }
        
        public boolean isHit() { return hit; }
        public void setHit(boolean hit) { this.hit = hit; }
        
        public String getTimestamp() { return timestamp; }
        public void setTimestamp(String timestamp) { this.timestamp = timestamp; }
        
        public long getExecutionTime() { return executionTime; }
        public void setExecutionTime(long executionTime) { this.executionTime = executionTime; }
        
        @Override
        public String toString() {
            return "ResultData{" +
                    "x=" + x +
                    ", y=" + y +
                    ", r=" + r +
                    ", hit=" + hit +
                    ", timestamp='" + timestamp + '\'' +
                    ", executionTime=" + executionTime +
                    '}';
        }
    }
}

