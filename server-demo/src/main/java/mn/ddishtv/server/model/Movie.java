package mn.ddishtv.server.model;

import java.time.LocalDateTime;
import java.util.Set;

import javax.persistence.ElementCollection;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;

@Entity
public class Movie {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String title;

    private Double rating;

    private Long duration;

    private LocalDateTime startDateTime;

    @ElementCollection(fetch = FetchType.EAGER)
    private Set<String> genres;

    @Lob
    private String overview;

    private Long rental;
    
    private String posterUrl;

    public Movie() {
        // TODO Auto-generated constructor stub
    }

    public Long getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public Double getRating() {
        return rating;
    }

    public Long getDuration() {
        return duration;
    }

    public LocalDateTime getStartDateTime() {
        return startDateTime;
    }

    public Set<String> getGenres() {
        return genres;
    }

    public String getOverview() {
        return overview;
    }

    public Long getRental() {
        return rental;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public void setRating(Double rating) {
        this.rating = rating;
    }

    public void setDuration(Long duration) {
        this.duration = duration;
    }

    public void setStartDateTime(LocalDateTime startDateTime) {
        this.startDateTime = startDateTime;
    }

    public void setGenres(Set<String> genres) {
        this.genres = genres;
    }

    public void setOverview(String overview) {
        this.overview = overview;
    }

    public void setRental(Long rental) {
        this.rental = rental;
    }

    public String getPosterUrl() {
        return posterUrl;
    }

    public void setPosterUrl(String posterUrl) {
        this.posterUrl = posterUrl;
    }
}
