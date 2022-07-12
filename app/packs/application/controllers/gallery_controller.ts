import { Controller } from "@hotwired/stimulus";

const ESC_KEY = 27;

export class GalleryController extends Controller {
  fieldTarget: HTMLInputElement;
  public static targets = ["dialog", "content"];

  public zoom(event): void {
    this.content.src = event.params.url;
    this.show();
  }

  public close(): void {
    this.content.src = "";
    this.hide();
  }

  private show(): void {
    this.dialog.style.display = "flex";
    document.addEventListener("keyup", this.keyup);
  }

  private hide(): void {
    this.dialog.style.display = "none";
    document.removeEventListener("keyup", this.keyup);
  }

  private get dialog(): HTMLDivElement {
    return this.targets.find("dialog") as HTMLDivElement;
  }

  private get content(): HTMLImageElement {
    return this.targets.find("content") as HTMLImageElement;
  }

  private keyup = (event: KeyboardEvent): void => {
    if (event.which === ESC_KEY) {
      this.close();
    }
  };
}
