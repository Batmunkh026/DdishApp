package mn.ddishtv.server;

import java.util.stream.Stream;

import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import mn.ddishtv.server.model.User;
import mn.ddishtv.server.model.repo.UserRepo;

@SpringBootApplication
public class ServerApplication {

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
        SpringApplication.run(ServerApplication.class, args);
    }

}
