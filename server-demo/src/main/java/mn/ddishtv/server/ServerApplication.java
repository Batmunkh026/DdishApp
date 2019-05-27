package mn.ddishtv.server;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Stream;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

import mn.ddishtv.server.model.Movie;
import mn.ddishtv.server.model.repo.MovieRepo;

@SpringBootApplication
@EnableAutoConfiguration
public class ServerApplication {

    @Bean
    CommandLineRunner commandLineRunner(MovieRepo repo) {
        return strings -> {
            Stream.of("Avengers: Endgame", "The Curious Case of Benjamin Button", "Life of Pi", "Se7en").forEach(s -> {
                Movie movie = new Movie();
                movie.setTitle(s);
                movie.setDuration(120l);
                movie.setOverview(
                        "After the devastating events of Avengers: Infinity War (2018), the universe is in ruins. With the help of remaining allies, the Avengers assemble once more in order to undo Thanos' actions and restore order to the universe.");
                movie.setRating(8.0);
                movie.setRental(5000l);
                movie.setStartDateTime(LocalDateTime.of(2019, 06, 01, 12, 00));
                Set<String> genres = new HashSet<>();
                genres.add("Action");
                genres.add("Sci-Fi");
                genres.add("Adventure");
                movie.setGenres(genres);
                repo.saveAndFlush(movie);
            });
        };
    }

    public static void main(String[] args) {
        SpringApplication.run(ServerApplication.class, args);
    }

}
