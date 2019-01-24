import { dom, library } from "@fortawesome/fontawesome-svg-core";

import {
  faEnvelope,
  faFile,
  faFileAudio,
  faFileImage,
  faFileVideo,
  faLock,
  faTags,
  faUser,
} from "@fortawesome/pro-light-svg-icons";

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
