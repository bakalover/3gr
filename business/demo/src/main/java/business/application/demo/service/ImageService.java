package business.application.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import business.application.demo.repo.AlbumRepository;
import business.application.demo.repo.ImageRepository;
import business.application.demo.repo.entity.ImageDao;

@Service("image")
public class ImageService {
    @Autowired
    private ImageRepository imageRepository;

    @Autowired
    private AlbumRepository albumRepository;

    public void addNewImage(Long albumId, ImageDao image) {
        image.setAlbum(albumRepository.findById(albumId).orElseThrow());
        imageRepository.save(image);
    }
}
