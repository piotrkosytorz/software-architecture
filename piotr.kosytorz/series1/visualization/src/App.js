import React, {Component} from 'react';
import NavigationMenu from './NavigationMenu';
import TopNavbar from './TopNavbar'
import MainContainer from "./MainContainer";

import 'bootstrap/dist/css/bootstrap.css';
import 'bootstrap/dist/css/bootstrap-theme.css';
import './App.css';

class App extends Component {

    constructor(props) {

        super(props);
        this.state = {selectedThreshold: ''};

        this.handleThreshold = this.handleThreshold.bind(this);
    }

    handleThreshold = (thresholdValue) => {
        this.setState({selectedThreshold: thresholdValue});
    };

    render() {
        return (
            <div className="App">
                <TopNavbar/>
                <div className="row">
                    <div className="col-sm-3 col-md-2 hidden-xs-down bg-faded sidebar">
                        <NavigationMenu/>
                    </div>
                    <div className="col-sm-9 offset-sm-3 col-md-10 offset-md-2 pt-3">
                        <MainContainer className="container"/>
                    </div>
                </div>
            </div>
        );
    }
}

export default App;
