// Side menu item
export class SideMenuItem {
    public readonly key: string;
    public readonly name: string;
    public readonly icon: string;
    public isActive: boolean;

    constructor(key: string, name: string, icon: string, isActive: boolean = false) {
        this.key = key;
        this.name = name;
        this.icon = icon;
        this.isActive = isActive;
    }
}