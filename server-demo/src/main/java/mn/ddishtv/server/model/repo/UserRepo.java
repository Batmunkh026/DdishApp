package mn.ddishtv.server.model.repo;

import org.springframework.data.jpa.repository.JpaRepository;

import mn.ddishtv.server.model.User;

public interface UserRepo extends JpaRepository<User, Long> {

    User findByUsername(String username);

}
