package mn.ddishtv.demo.server;

import java.util.stream.Stream;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import mn.ddishtv.demo.server.domain.User;
import mn.ddishtv.demo.server.domain.repo.UserRepo;

@SpringBootApplication
public class AuthServerApplication {

    @Bean
    CommandLineRunner commandLineRunner(UserRepo repo) {
        return strings -> {
            Stream.of("user1", "user2", "user3").forEach(u -> {
                User user = new User();
                user.setUsername(u);
                user.setPassword(new BCryptPasswordEncoder().encode("pass"));
                repo.saveAndFlush(user);
            });
        };
    }

    public static void main(String[] args) {
        SpringApplication.run(AuthServerApplication.class, args);
    }

}
