package mn.ddishtv.server.model.repo;

import org.springframework.data.jpa.repository.JpaRepository;

import mn.ddishtv.server.model.Movie;

public interface MovieRepo extends JpaRepository<Movie, Long> {

}
