import * as loadjs from "loadjs";
import { Controller } from "stimulus";

interface IRecaptcha {
  ready(callback: () => void): void;
  execute(key: string, options: { action: string }): Promise<string>;
}

declare const grecaptcha: IRecaptcha;

export class RecaptchaController extends Controller {
  public static targets = ["field"];

  public initialize() {
    const key = this.data.get("key");
    const action = this.data.get("action");

    if (!key) { return; }

    loadjs(`https://www.google.com/recaptcha/api.js?render=${key}`, () => {
      grecaptcha.ready(() => {
        grecaptcha
        .execute(key, { action })
        .then((token) => {
          const input = this.targets.find("field") as HTMLInputElement;
          input.value = token;
        });
      });
    });
  }
}
