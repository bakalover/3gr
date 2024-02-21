package business.application.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import business.application.demo.repo.AlbumRepository;
import business.application.demo.repo.CommentRepositoty;
import business.application.demo.repo.ImageRepository;
import business.application.demo.repo.UserRepository;
import business.application.demo.repo.entity.AlbumDao;
import business.application.demo.repo.entity.CommentDao;
import business.application.demo.repo.entity.ImageDao;
import business.application.demo.repo.request.CommentBody;

import java.io.IOException;
import java.util.List;
import java.util.NoSuchElementException;

@Service("image_service")
public class ImageService {
    @Autowired
    private ImageRepository imageRepository;

    @Autowired
    private AlbumRepository albumRepository;

    @Autowired
    private CommentRepositoty commentRepositoty;

    @Autowired
    private UserRepository userRepositoty;

    // ~todo transaction
    public void addNewImage(MultipartFile file, Long albumId, Boolean face) throws IOException, NoSuchElementException {
        var imageDao = new ImageDao();
        var album = albumRepository.findById(albumId).orElseThrow();
        imageDao.setAlbum(album);
        imageDao.setName(file.getOriginalFilename());
        imageDao.setData(file.getBytes());
        imageDao.setFace(face);
        var images = imageRepository.findByAlbum(album);
        images.forEach(image -> {
            if (image.getFace()) {
                image.setFace(false);
                imageRepository.save(image);
            }
        });
        imageRepository.save(imageDao);
    }

    public ImageDao findById(Long id) throws NoSuchElementException {
        return imageRepository.findById(id).orElseThrow();
    }

    public List<ImageDao> findByAlbum(AlbumDao albumDao) {
        return imageRepository.findByAlbum(albumDao);
    }

    public void deleteById(Long id) throws Exception {
        imageRepository.deleteById(id);
    }

    public void addComment(CommentBody comment) throws NoSuchElementException {
        var dao = new CommentDao();
        dao.setImage(imageRepository.findById(comment.getPicId()).orElseThrow());
        dao.setText(comment.getText());
        dao.setUser(userRepositoty.findById(comment.getUsername()).orElseThrow());
        commentRepositoty.save(dao);
    }

    public List<CommentDao> getComments(Long picId) {
        return commentRepositoty.findByImage(imageRepository.findById(picId).orElseThrow());
    }
}
