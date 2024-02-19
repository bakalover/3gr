package business.application.demo.repo.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import lombok.Data;
import lombok.NonNull;

@Entity
@Data
public class UserDao {
    @Id
    @GeneratedValue
    private Long id;

    @NonNull
    private String username;

    @NonNull
    private byte[] passwd;

}
