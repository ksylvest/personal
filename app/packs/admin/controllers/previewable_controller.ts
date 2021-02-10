import * as marked from "marked";
import { Controller } from "stimulus";

export class PreviewableController extends Controller {
  public static targets = ["field", "result"];

  private get field(): HTMLTextAreaElement {
    return this.targets.find("field") as HTMLTextAreaElement;
  }

  private get result(): Element {
    return this.targets.find("result");
  }

  public initialize(): void {
    this.reset();
  }

  public change(): void {
    this.reset();
  }

  private reset() {
    this.result.innerHTML = marked(this.field.value);
  }
}
