package business.application.demo.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import business.application.demo.repo.AlbumRepository;
import business.application.demo.repo.ImageRepository;
import business.application.demo.repo.entity.AlbumDao;
import business.application.demo.repo.entity.ImageDao;
import business.application.demo.repo.request.AlbumBody;

import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;

@Service("album_service")
public class AlbumService {

    @Autowired
    private AlbumRepository albumRepository;

    @Autowired
    private ImageRepository imageRepository;

    public void addNewAlbum(AlbumBody album) {
        var albumDao = new AlbumDao();
        albumDao.setDescription(album.getDescription());
        albumDao.setName(album.getName());
        albumDao.setRestrictMode(album.getRestrictMode());
        albumRepository.save(albumDao);
    }

    public void deleteAlbumById(Long id) throws Exception {
        albumRepository.deleteById(id);
    }

    // ~todo transaction
    public void moveImages(Long fromId, Long toId, List<Long> ids) throws NoSuchElementException {
        // todo secur check
        AlbumDao from = albumRepository.findById(fromId).orElseThrow();
        AlbumDao to = albumRepository.findById(toId).orElseThrow();
        List<ImageDao> toMove = imageRepository.findByAlbum(from);
        toMove.forEach(image -> image.setAlbum(to));
        List<ImageDao> toMoveFiltered = new ArrayList<>();
        for (ImageDao imageDao : toMove) {
            if (ids.contains(imageDao.getId())) {
                toMoveFiltered.add(imageDao);
            }
        }
        // transaction emulation -> add by one
        imageRepository.saveAll(toMoveFiltered);

    }

    public AlbumDao getAlbum(Long id) throws NoSuchElementException {
        return albumRepository.findById(id).orElseThrow();
    }
}
