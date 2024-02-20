package business.application.demo.repo.request;

import business.application.demo.repo.entity.UserRestriction;
import lombok.NonNull;
import lombok.Data;

@Data
public class AlbumBody {
    @NonNull
    private String name;

    @NonNull
    private String description;

    @NonNull
    private UserRestriction restrictMode;
}