import { Controller } from "stimulus";

const DEFAULT_INDEX = 0;

export class SectionedController extends Controller {
  public static targets = ["tab", "panel"];

  public tabTargets: HTMLElement[];
  public panelTargets: HTMLElement[];

  public initialize(): void {
    this.index = DEFAULT_INDEX;
  }

  public tab(event: Event): void {
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

  private reset(): void {
    this.activate(this.tabTargets, "tab--active");
    this.activate(this.panelTargets, "panel--active");
  }

  private activate(entries: HTMLElement[], active: string): void {
    const { index } = this;
    for (let current = 0; current < entries.length; current++) {
      const tabTarget = entries[current];
      tabTarget.classList.toggle(active, index === current);
    }
  }
}
