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
  faBrush,
  faClock,
  faComments,
  faDatabase,
  faExclamation,
  faExpand,
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
  faCogs,
  faTags,
  faTh,
} from "@fortawesome/free-solid-svg-icons";

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
  faBrush,
  faClock,
  faCogs,
  faComments,
  faDatabase,
  faExclamation,
  faExpand,
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
  faTags,
  faTh,
);

document.addEventListener("turbo:load", () => {
  dom.i2svg();
});
