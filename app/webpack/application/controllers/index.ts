import { Application } from "stimulus";

import { RecaptchaController } from "./recaptcha_controller";

const application = Application.start();
application.register("recaptcha", RecaptchaController);
