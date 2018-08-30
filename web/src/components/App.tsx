import * as React from 'react';
import './App.css';
import './bootstrap.min.css'

import logo from './logo.svg';

class App extends React.Component {
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
            <p>Left panel</p>
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
