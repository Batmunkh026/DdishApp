package mn.ddishtv.demo.server.domain.repo;

import org.springframework.data.jpa.repository.JpaRepository;

import mn.ddishtv.demo.server.domain.User;

public interface UserRepo extends JpaRepository<User, Long> {

    User findByUsername(String username);

}
