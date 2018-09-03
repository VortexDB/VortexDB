import * as React from 'react';
import logo from './logo.svg';
import './App.css';
import './bootstrap.min.css';
import { SideMenuModel } from '../side_menu/SideMenuModel';
import { SideMenuItem } from '../side_menu/SideMenuItem';
import SideMenu from '../side_menu/SideMenu';
import ClassesPage from '../pages/classes_page/ClassesPage';
import InstancesPage from '../pages/instances_page/InstancesPage';

class App extends React.Component {
  /// Model for side menu
  private sideMenuModel: SideMenuModel;

  /// Side menu selected item key
  private sideMenuKey: string = ClassesPage.PAGE_NAME;

  constructor(props: any) {
    super(props);

    this.sideMenuModel = new SideMenuModel(
      [
        new SideMenuItem(ClassesPage.PAGE_NAME, ClassesPage.PAGE_NAME, "power", true),
        new SideMenuItem(InstancesPage.PAGE_NAME, InstancesPage.PAGE_NAME, "place")
      ]
    );

    this.sideMenuModel.onChange = (item) => { this.onMenuChange(item) };
  }

  /// Render app
  public render() {
    let page: JSX.Element;

    switch (this.sideMenuKey) {
      case ClassesPage.PAGE_NAME:
        page = this.renderClassesPage();
        break;
      case InstancesPage.PAGE_NAME:
        page = this.renderInstancesPage();
        break;
      default:
        throw new Error("Wrong menu key");
    }

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
            {page}
          </div>
        </div>
      </div>
    );
  }

  /// On side menu change
  private onMenuChange(item: SideMenuItem) {
    this.sideMenuKey = item.key.toString();
    this.setState({});
  }

  /// Render device page
  private renderClassesPage() {
    return <ClassesPage />
  }

  /// Render device page
  private renderInstancesPage() {
    return <InstancesPage />
  }
}

export default App;
