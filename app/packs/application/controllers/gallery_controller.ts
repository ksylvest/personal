import { Controller } from "@hotwired/stimulus";

const ESC_KEY = 27;

export class GalleryController extends Controller {
  public static targets = ["dialog", "content"];

  public zoom(event): void {
    const link = event.target.closest("a");
    this.content.src = link.href;
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
    console.log(event.key);
    if (event.which === ESC_KEY) {
      this.close();
    }
  };
}
