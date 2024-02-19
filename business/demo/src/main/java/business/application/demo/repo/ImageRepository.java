package business.application.demo.repo;

import org.springframework.data.jpa.repository.JpaRepository;

import business.application.demo.repo.entity.AlbumDao;
import business.application.demo.repo.entity.ImageDao;
import java.util.List;

public interface ImageRepository extends JpaRepository<ImageDao ,Long> {
    List<ImageDao> findByAlbum(AlbumDao album);
}