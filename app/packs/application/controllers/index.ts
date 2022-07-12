import { Application } from "@hotwired/stimulus";

import { GalleryController } from "./gallery_controller";
import { RecaptchaController } from "./recaptcha_controller";

const application = Application.start();
application.register("gallery", GalleryController);
application.register("recaptcha", RecaptchaController);
