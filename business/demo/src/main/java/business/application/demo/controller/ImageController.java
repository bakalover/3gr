package business.application.demo.controller;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import business.application.demo.repo.entity.ImageDao;
import business.application.demo.service.ImageService;

@RestController
public class ImageController {

    @Autowired
    private ImageService imageService;

    @PostMapping("/image/add")
    @ResponseBody
    public String addImage(@RequestParam Optional<Long> albumId, @RequestBody ImageDao image) {
        if (albumId.isEmpty()) {
            return "NO";
        }
        imageService.addNewImage(albumId.orElseThrow(), image);
        return "OK";
    }
}
