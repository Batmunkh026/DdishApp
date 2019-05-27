package mn.ddishtv.server.model.repo;

import mn.ddishtv.server.model.Movie;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@RepositoryRestResource(path = "movies", exported = true)
public interface MovieRepo extends JpaRepository<Movie, Long> {

}
