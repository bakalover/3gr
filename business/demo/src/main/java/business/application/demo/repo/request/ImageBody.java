package business.application.demo.repo.request;

import io.micrometer.common.lang.NonNull;
import lombok.Data;

@Data
public class ImageBody {

    @NonNull
    private String name;

    @NonNull
    private Long albumId;
}
