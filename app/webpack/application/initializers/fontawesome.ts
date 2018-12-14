import { dom, library } from "@fortawesome/fontawesome";

import * as faDribbble from "@fortawesome/fontawesome-free-brands/faDribbble";
import * as faFacebook from "@fortawesome/fontawesome-free-brands/faFacebook";
import * as faGithub from "@fortawesome/fontawesome-free-brands/faGithub";
import * as faGoogle from "@fortawesome/fontawesome-free-brands/faGoogle";
import * as faLinkedin from "@fortawesome/fontawesome-free-brands/faLinkedin";
import * as faStackOverflow from "@fortawesome/fontawesome-free-brands/faStackOverflow";
import * as faTwitter from "@fortawesome/fontawesome-free-brands/faTwitter";
import * as faVimeo from "@fortawesome/fontawesome-free-brands/faVimeo";
import * as faArrows from "@fortawesome/fontawesome-pro-light/faArrows";
import * as faClock from "@fortawesome/fontawesome-pro-light/faClock";
import * as faComments from "@fortawesome/fontawesome-pro-light/faComments";
import * as faExclamation from "@fortawesome/fontawesome-pro-light/faExclamation";
import * as faEye from "@fortawesome/fontawesome-pro-light/faEye";
import * as faFilter from "@fortawesome/fontawesome-pro-light/faFilter";
import * as faFire from "@fortawesome/fontawesome-pro-light/faFire";
import * as faFlask from "@fortawesome/fontawesome-pro-light/faFlask";
import * as faGavel from "@fortawesome/fontawesome-pro-light/faGavel";
import * as faGlobe from "@fortawesome/fontawesome-pro-light/faGlobe";
import * as faImages from "@fortawesome/fontawesome-pro-light/faImages";
import * as faKey from "@fortawesome/fontawesome-pro-light/faKey";
import * as faLink from "@fortawesome/fontawesome-pro-light/faLink";
import * as faMagic from "@fortawesome/fontawesome-pro-light/faMagic";
import * as faPaperclip from "@fortawesome/fontawesome-pro-light/faPaperclip";
import * as faRandom from "@fortawesome/fontawesome-pro-light/faRandom";
import * as faServer from "@fortawesome/fontawesome-pro-light/faServer";
import * as faSpinner from "@fortawesome/fontawesome-pro-light/faSpinner";
import * as faTachometer from "@fortawesome/fontawesome-pro-light/faTachometer";
import * as faTags from "@fortawesome/fontawesome-pro-light/faTags";
import * as faTh from "@fortawesome/fontawesome-pro-light/faTh";

library.add(
  faArrows,
  faClock,
  faComments,
  faDribbble,
  faExclamation,
  faEye,
  faFacebook,
  faFilter,
  faFire,
  faFlask,
  faGavel,
  faGithub,
  faGlobe,
  faGoogle,
  faImages,
  faKey,
  faLink,
  faLinkedin,
  faMagic,
  faPaperclip,
  faRandom,
  faServer,
  faSpinner,
  faStackOverflow,
  faStackOverflow,
  faTachometer,
  faTags,
  faTh,
  faTwitter,
  faVimeo,
);

document.addEventListener("turbolinks:load", () => {
  (dom as any).i2svg();
});
