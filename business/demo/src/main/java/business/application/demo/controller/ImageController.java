package business.application.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import business.application.demo.repo.entity.CommentDao;
import business.application.demo.repo.entity.ImageDao;
import business.application.demo.repo.request.CommentBody;
import business.application.demo.service.ImageService;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;

@RestController
@RequestMapping("/image")
public class ImageController {

    @Autowired
    private ImageService imageService;

    @PostMapping("/add")
    public ResponseEntity<String> addImage(@RequestParam("path") MultipartFile file,
            @RequestParam("albumId") Long albumId,
            @RequestParam("face") Boolean face) {
        try {
            imageService.addNewImage(file, albumId, face);
            return ResponseEntity.ok().body("OK");
        } catch (IOException e) {
            return ResponseEntity.badRequest().body("Cannot read file!");
        } catch (NoSuchElementException e) {
            return ResponseEntity.badRequest().body("Cannot find specified album!");
        }
    }

    @PostMapping("/comment")
    public ResponseEntity<String> postMethodName(@RequestBody CommentBody comment) {
        try {
            imageService.addComment(comment);
            return ResponseEntity.ok().body("OK");

        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Invalid User or picture!");
        }
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<String> deleteImage(@PathVariable Long id) {
        try {
            imageService.deleteById(id);
            return ResponseEntity.ok().body("OK");

        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Cannot find specified image!");
        }
    }

    @GetMapping("/{id}")
    public ResponseEntity<ImageDao> getImage(@PathVariable Long id) {
        try {
            return ResponseEntity.ok().body(imageService.findById(id));
        } catch (NoSuchElementException e) {
            // Dummy
            return ResponseEntity.badRequest().body(new ImageDao());
        }
    }

    @GetMapping("/{id}/comments")
    public ResponseEntity<List<CommentDao>> getImageComments(@PathVariable Long id) {
        try {
            return ResponseEntity.ok().body(imageService.getComments(id));
        } catch (NoSuchElementException e) {
            // Dummy
            return ResponseEntity.badRequest().body(new ArrayList<>());
        }
    }

}
