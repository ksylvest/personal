import { Application } from "stimulus";

import { PreviewableController } from "./previewable_controller";
import { SectionedController } from "./sectioned_controller";

const application = Application.start();
application.register("previewable", PreviewableController);
application.register("sectioned", SectionedController);
