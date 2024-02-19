package business.application.demo.service;
import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import business.application.demo.repo.AlbumRepository;
import business.application.demo.repo.ImageRepository;
import business.application.demo.repo.entity.AlbumDao;
import business.application.demo.repo.entity.ImageDao;

import java.util.List;

@Service("album")
public class AlbumService {

    @Autowired
    private AlbumRepository albumRepository;

    @Autowired
    private ImageRepository  imageRepository;

    public void addNewAlbum(AlbumDao album){
        albumRepository.save(album);
    }

    public void deleteAlbumById(Long id){
        albumRepository.deleteById(id);
    }

    //~todo transaction
    public void moveImages(Long fromId, Long toId){
        //todo secur check
        AlbumDao from = albumRepository.findById(fromId).orElseThrow();
        AlbumDao to = albumRepository.findById(toId).orElseThrow();
        List<ImageDao> toMove = imageRepository.findByAlbum(from);
        toMove.forEach(image -> image.setAlbum(to));
        imageRepository.saveAll(toMove);

    }
}
