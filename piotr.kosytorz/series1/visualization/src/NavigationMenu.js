import React from 'react';
import {Nav, NavItem} from 'react-bootstrap';

class NavigationMenu extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            activeKey: 1
        };
    }

    handleSelect() {
   //     console.log(this);
        //this= selectedKey;
        }

    render() {
        return (
            <Nav bsStyle="pills" stacked activeKey={1}>
                <NavItem eventKey={1} href="#/list">Data list</NavItem>
                <NavItem eventKey={2} href="#/heatmap-single">Clones within one file</NavItem>
                <NavItem eventKey={3} href="#/heatmap-cross">Cross files clones</NavItem>
                <NavItem eventKey={4} href="#/biblewiz">Arcs</NavItem>
            </Nav>
        );
    }
}

export default NavigationMenu;