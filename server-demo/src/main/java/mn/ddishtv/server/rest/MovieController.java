package mn.ddishtv.server.rest;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import mn.ddishtv.server.model.Movie;
import mn.ddishtv.server.model.repo.MovieRepo;

@RestController(value = "/movies")
public class MovieController {

    @Autowired
    private MovieRepo repo;

    @GetMapping(produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
    public List<Movie> findAll() {
        return repo.findAll();
    }
}
