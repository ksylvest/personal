import { Application } from "@hotwired/stimulus";

import { GalleryController } from "./gallery_controller";

const application = Application.start();
application.register("gallery", GalleryController);
