import * as marked from "marked";
import { Controller } from "stimulus";

export class PreviewableController extends Controller {
  public initialize() {
    this.reset();
  }

  public change() {
    this.reset();
  }

  private reset() {
    const field = this.targets.find("field") as HTMLTextAreaElement;
    this.targets.find("result").innerHTML = marked(field.value);
  }
}
