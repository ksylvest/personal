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
} from "@fortawesome/free-solid-svg-icons";

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

document.addEventListener("turbo:load", () => {
  dom.i2svg();
});
