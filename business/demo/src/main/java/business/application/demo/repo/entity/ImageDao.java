package business.application.demo.repo.entity;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import lombok.Data;
import lombok.NonNull;

import java.util.List;

@Entity
@Data
public class ImageDao {
    @Id
    @GeneratedValue
    private Long id;

    @NonNull
    private String name;

    // @NonNull
    // private byte[] data;

    @ManyToOne
    @JoinColumn(name = "album_id")
    private AlbumDao album;

    @OneToMany(mappedBy = "image", cascade = CascadeType.ALL)
    private List<CommentDao> comments;

}
