import * as React from 'react';
import logo from './logo.svg';
import './App.css';
import './bootstrap.min.css';
import { SideMenuModel } from './side_menu/SideMenuModel';
import { SideMenuItem } from './side_menu/SideMenuItem';
import SideMenu from './side_menu/SideMenu';


class App extends React.Component {
  /// Model for side menu
  private sideMenuModel: SideMenuModel;

  constructor(props: any) {
    super(props);

    this.sideMenuModel = new SideMenuModel(
      [
        new SideMenuItem("Classes", "Classes", "power", true),
        new SideMenuItem("Instances", "Instances", "place")        
      ]
    );
  }

  public render() {
    return (
      <div id="app-inner">
        <nav className="navbar">
          <a className="navbar-brand" href="#">
            <img id="logo-img" src={logo} />
            <span>VortexDB</span>
          </a>
        </nav>

        <div id="app-content">
          <div id="left-panel">
            <SideMenu model={this.sideMenuModel} />
          </div>
          <div id="right-panel">
            <p>Right panel</p>
          </div>
        </div>
      </div>
    );
  }
}

export default App;
