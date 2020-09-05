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
  faUser
);

document.addEventListener("turbolinks:load", () => {
  dom.i2svg();
});
