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
                <NavItem eventKey={2} href="#/">General statistics</NavItem>
                <NavItem eventKey={2} href="#/list">Details</NavItem>
                <NavItem eventKey={3} href="#/heatmap-single">Visualization: Heatmap 1</NavItem>
                <NavItem eventKey={4} href="#/heatmap-cross">Visualization: Heatmap 2</NavItem>
                <NavItem eventKey={5} href="#/biblewiz">Visualization: Arcs</NavItem>
            </Nav>
        );
    }
}

export default NavigationMenu;