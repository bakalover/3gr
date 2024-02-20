package business.application.demo.repo;

import org.springframework.data.jpa.repository.JpaRepository;

import business.application.demo.repo.entity.UserDao;

public interface UserRepository extends JpaRepository<UserDao, String> {

}
