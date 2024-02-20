package business.application.demo.repo.entity;

import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToOne;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.NonNull;

@Entity
@Data
@NoArgsConstructor
public class CommentDao {
    @Id
    @GeneratedValue
    private Long id;

    @NonNull
    private String text;

    @OneToOne
    @JoinColumn(name = "user_id")
    @OnDelete(action = OnDeleteAction.SET_NULL)
    @JsonIgnoreProperties("hashedPasswd")
    private UserDao user;

    @ManyToOne
    @JoinColumn(name = "pic_id")
    @OnDelete(action = OnDeleteAction.CASCADE)
    @JsonIgnore
    private ImageDao image;
}
