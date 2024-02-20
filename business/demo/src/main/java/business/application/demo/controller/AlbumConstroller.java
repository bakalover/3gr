package business.application.demo.controller;

import java.util.ArrayList;
import java.util.NoSuchElementException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import business.application.demo.repo.entity.AlbumDao;
import business.application.demo.repo.request.AlbumBody;
import business.application.demo.service.AlbumService;
import business.application.demo.service.ImageService;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;

@RestController
@RequestMapping("/album")
public class AlbumConstroller {

    @Autowired
    private AlbumService albumService;

    @Autowired
    private ImageService imageService;

    @PostMapping("/add")
    public ResponseEntity<String> addAlbum(@RequestBody AlbumBody album) {
        albumService.addNewAlbum(album);
        return ResponseEntity.ok().body("OK");
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<String> deleteAlbum(@PathVariable Long id) {
        try {
            albumService.deleteAlbumById(id);
            return ResponseEntity.ok().body("OK");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Cannot find specified album!");
        }
    }

    @PostMapping("/move")
    public ResponseEntity<String> movePics(@RequestParam Long from, @RequestParam Long to,
            @RequestBody ArrayList<Long> ids) {
        try {
            albumService.moveImages(from, to, ids);
            return ResponseEntity.ok().body("OK");

        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Cannot elements!");

        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<AlbumDao> getMethodName(@PathVariable Long id) {
        AlbumDao album;
        try {
            album = albumService.getAlbum(id);
            album.setImages(imageService.findByAlbum(album));
            return ResponseEntity.ok().body(album);

        } catch (NoSuchElementException e) {
            // Dummy
            return ResponseEntity.badRequest().body(new AlbumDao());
        }
    }

}
