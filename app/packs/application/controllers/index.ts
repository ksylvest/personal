import { Application } from "@hotwired/stimulus";

import { RecaptchaController } from "./recaptcha_controller";

const application = Application.start();
application.register("recaptcha", RecaptchaController);
