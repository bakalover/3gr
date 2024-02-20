package business.application.demo.repo;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import business.application.demo.repo.entity.CommentDao;
import business.application.demo.repo.entity.ImageDao;

public interface CommentRepositoty extends JpaRepository<CommentDao, Long> {
    List<CommentDao> findByImage(ImageDao image);
}
