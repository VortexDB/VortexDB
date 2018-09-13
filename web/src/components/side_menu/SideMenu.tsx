import * as React from "react";
import { SideMenuItem } from "./SideMenuItem";
import { ISideMenuProps } from "./ISideMenuProps";

/// Side menu component
class SideMenu extends React.Component<ISideMenuProps, {}> {    
    /// Render menu
    public render() {
        return <ul className="nav flex-column">
            <li key="divider_1" className="divider">Menu</li>
            {this.createChildren()}
        </ul>
    }    

    /// Create menu items
    private createChildren(): JSX.Element[] {
        const items = this.props.model.items.map((entry) => {
            let activeStr = "nav-link";
            if (entry.isActive) {
                activeStr += " active";
            }

            const localItemClick = () => { this.onItemClick(entry) };

            return <li key={entry.key} className="nav-item" onClick={localItemClick}>
                <a className={activeStr} href="#">
                    <i className="material-icons">{entry.icon}</i>
                    <span>{entry.name}</span>
                </a>
            </li>
        });

        return items;
    }

    // On item click
    private onItemClick(item: SideMenuItem) {
        this.props.model.items.forEach((it) => it.isActive = false);
        item.isActive = true;
        this.props.model.onChange(item);
    }
}

export default SideMenu;