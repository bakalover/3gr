package business.application.demo.repo.entity;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import java.util.List;

import lombok.Data;
import lombok.NonNull;

@Entity
@Data
public class AlbumDao{
    @Id
    @GeneratedValue
    private Long id;

    @NonNull
    private String name;

    @NonNull
    private String description;

    @NonNull
    private UserRestriction restrictMode; 

    @OneToMany(mappedBy = "album", cascade = CascadeType.ALL)
    private List<ImageDao> images;
}