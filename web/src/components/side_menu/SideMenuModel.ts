import { SideMenuItem } from "./SideMenuItem";

// Model for side menu
export class SideMenuModel {
    /// Side menu item
    public readonly items: SideMenuItem[];

    /// On item change
    public onChange: (key: SideMenuItem) => void;

    constructor(items: SideMenuItem[]) {
        this.items = items;
    }
}