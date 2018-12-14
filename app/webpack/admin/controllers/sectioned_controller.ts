import { Controller } from "stimulus";

const DEFAULT_INDEX = 0;

class SectionedController extends Controller {
  public static targets = [
    "tab",
    "panel",
  ];

  public tabTargets: HTMLElement[];
  public panelTargets: HTMLElement[];

  public initialize() {
    this.index = DEFAULT_INDEX;
  }

  public tab(event: Event) {
    event.preventDefault();
    event.stopPropagation();
    const target = event.target as HTMLElement;
    this.index = Number(target.dataset.index);
  }

  private get index(): number {
    return Number(this.data.get("index"));
  }

  private set index(value: number) {
    this.data.set("index", String(value));
    this.reset();
  }

  private reset() {
    const { index } = this;

    for (let current = 0; current < this.tabTargets.length; current++) {
      const tabTarget = this.tabTargets[current];
      tabTarget.classList.toggle("tab--active", index === current);
    }

    for (let current = 0; current < this.panelTargets.length; current++) {
      const panelTarget = this.panelTargets[current];
      panelTarget.classList.toggle("panel--active", index === current);
    }
  }
}

export { SectionedController };
