/*
 * Lighten
 * Copyright 2018 Kevin Sylvestre
 * 1.0.0
 */

/* global document, Image */

import $ from "jquery";

const TRANSITIONS = {
  webkitTransition: "webkitTransitionEnd",
  mozTransition: "mozTransitionEnd",
  oTransition: "oTransitionEnd",
  transition: "transitionend",
};

const ESC_KEY = 27;

class Animation {
  static transition($el) {
    const [el] = $el;
    const key = Object.keys(TRANSITIONS).find(
      (type) => el.style[type] !== null
    );
    return TRANSITIONS[key];
  }

  static execute($el, callback) {
    const transition = this.transition($el);
    if (transition != null) {
      $el.one(transition, callback);
    } else {
      callback();
    }
  }
}

class Slide {
  constructor(url) {
    this.url = url;
  }

  type() {
    if (this.url.match(/\.(webp|jpeg|jpg|jpe|gif|png|bmp)$/i)) return "image";
    return "unknown";
  }

  preload(callback) {
    const image = new Image();
    image.src = this.url;
    image.onload = () => {
      callback(image);
    };
  }
}

class Lighten {
  static init() {
    this.namespace = "lighten";

    this.prototype.defaults = {
      loading: "#{Lighten.namespace}--loading",
      fetched: "#{Lighten.namespace}--fetched",
      template: `
        <div class='${Lighten.namespace} ${Lighten.namespace}--fade'>
          <div class='${Lighten.namespace}__overlay'>
          </div>
          <div class='${Lighten.namespace}__spinner'>
            <div class='${Lighten.namespace}__dot'></div>
            <div class='${Lighten.namespace}__dot'></div>
            <div class='${Lighten.namespace}__dot'></div>
          </div>
          <div class='${Lighten.namespace}__container'>
            <span class='${Lighten.namespace}__content'></span>
            <a class='${Lighten.namespace}__close'>&times;</a>
          </div>
        </div>
      `,
    };
  }

  static setup($target, options) {
    let data = $target.data("_lighten");
    if (!data) {
      $target.data("_lighten", (data = new Lighten($target, options)));
    }
    return data;
  }

  $(selector) {
    return this.$el.find(selector);
  }

  constructor($target, settings) {
    this.close = this.close.bind(this);
    this.type = this.type.bind(this);
    this.process = this.process.bind(this);
    this.keyup = this.keyup.bind(this);
    this.observe = this.observe.bind(this);
    this.hide = this.hide.bind(this);
    this.show = this.show.bind(this);
    this.$target = $target;

    this.settings = Object.assign({}, this.defaults, settings);

    this.$el = $(this.settings.template);

    this.$overlay = this.$(`.${Lighten.namespace}__overlay`);
    this.$content = this.$(`.${Lighten.namespace}__content`);
    this.$container = this.$(`.${Lighten.namespace}__container`);
    this.$close = this.$(`.${Lighten.namespace}__close`);
    this.$body = this.$(`.${Lighten.namespace}__body`);

    this.process();
  }

  close(event) {
    if (event != null) {
      event.preventDefault();
      event.stopPropagation();
    }
    this.hide();
  }

  type(href = this.href()) {
    return (
      this.settings.type ||
      (href.match(/\.(webp|jpeg|jpg|jpe|gif|png|bmp)$/i) ? "image" : undefined)
    );
  }

  process() {
    const fetched = () => {
      this.$el
        .removeClass(`${Lighten.namespace}--loading`)
        .addClass(`${Lighten.namespace}--fetched`);
    };

    const loading = () => {
      this.$el
        .removeClass(`${Lighten.namespace}--fetched`)
        .addClass(`${Lighten.namespace}--loading`);
    };

    this.slide = new Slide(this.$target.attr("href"));

    loading();

    this.slide.preload((content) => {
      this.$content.html(content);
      fetched();
    });
  }

  keyup(event) {
    if (event.target.form) {
      return;
    }
    if (event.which === ESC_KEY) {
      this.close();
    }
  }

  observe(method = "on") {
    $(document)[method]("keyup", this.keyup);
    this.$overlay[method]("click", this.close);
    this.$close[method]("click", this.close);
  }

  hide() {
    this.observe("off");
    this.$el.position();
    this.$el.addClass(`${Lighten.namespace}--fade`);
    Animation.execute(this.$el, () => this.$el.remove());
  }

  show() {
    $(document.body).append(this.$el);
    this.$el.position();
    this.$el.removeClass(`${Lighten.namespace}--fade`);
    Animation.execute(this.$el, () => this.observe("on"));
  }
}

Lighten.init();

$(document).on("click", "[data-lighten]", function fn(event) {
  event.preventDefault();
  event.stopPropagation();

  const $element = $(this);
  const lighten = Lighten.setup($element);

  lighten.show();
});
