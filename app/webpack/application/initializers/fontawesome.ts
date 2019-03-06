import { dom, library } from "@fortawesome/fontawesome-svg-core";

import {
  faDribbble,
  faFacebook,
  faGithub,
  faGoogle,
  faLinkedin,
  faStackOverflow,
  faTwitter,
  faVimeo,
} from "@fortawesome/free-brands-svg-icons";

import {
  faArrows,
  faClock,
  faComments,
  faExclamation,
  faEye,
  faFilter,
  faFire,
  faFlask,
  faGavel,
  faGlobe,
  faImages,
  faKey,
  faLink,
  faMagic,
  faPaperclip,
  faRandom,
  faServer,
  faSpinner,
  faTachometer,
  faTags,
  faTh,
} from "@fortawesome/pro-light-svg-icons";

library.add(
  faDribbble,
  faFacebook,
  faGithub,
  faGoogle,
  faLinkedin,
  faStackOverflow,
  faTwitter,
  faVimeo,
);

library.add(
  faArrows,
  faClock,
  faComments,
  faExclamation,
  faEye,
  faFilter,
  faFire,
  faFlask,
  faGavel,
  faGlobe,
  faImages,
  faKey,
  faLink,
  faMagic,
  faPaperclip,
  faRandom,
  faServer,
  faSpinner,
  faTachometer,
  faTags,
  faTh,
);

document.addEventListener("turbolinks:load", () => {
  dom.i2svg();
});
