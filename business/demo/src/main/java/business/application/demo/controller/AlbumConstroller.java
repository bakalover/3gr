package business.application.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import business.application.demo.repo.entity.AlbumDao;
import business.application.demo.service.AlbumService;

@RestController
public class AlbumConstroller {

    @Autowired
    private AlbumService albumService;

    @PostMapping("/album/add")
    public void addAlbum(@RequestBody AlbumDao album) {
        albumService.addNewAlbum(album);
    }

    @PostMapping("/album/delete")
    public void deleteAlbum(@RequestParam Long id) {
        albumService.deleteAlbumById(id);
    }

    @PostMapping("/album/move")
    public void movePics(@RequestParam Long from, @RequestParam Long to) {
        albumService.moveImages(from, to);
    }
}
