import { dom, library } from "@fortawesome/fontawesome";

import * as faEnvelope from "@fortawesome/fontawesome-pro-light/faEnvelope";
import * as faFile from "@fortawesome/fontawesome-pro-light/faFile";
import * as faFileAudio from "@fortawesome/fontawesome-pro-light/faFileAudio";
import * as faFileImage from "@fortawesome/fontawesome-pro-light/faFileImage";
import * as faFileVideo from "@fortawesome/fontawesome-pro-light/faFileVideo";
import * as faLock from "@fortawesome/fontawesome-pro-light/faLock";
import * as faTags from "@fortawesome/fontawesome-pro-light/faTags";
import * as faUser from "@fortawesome/fontawesome-pro-light/faUser";

library.add(
  faEnvelope,
  faFile,
  faFileAudio,
  faFileImage,
  faFileVideo,
  faLock,
  faTags,
  faUser,
);

/* global document */
document.addEventListener("turbolinks:load", () => {
  (dom as any).i2svg();
});
