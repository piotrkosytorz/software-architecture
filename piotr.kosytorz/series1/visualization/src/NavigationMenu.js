import React from 'react';
import {Nav, NavItem} from 'react-bootstrap';

class NavigationMenu extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            activeKey: 0
        };
        this.handleSelect = this.handleSelect.bind(this);
    }

    handleSelect(eventKey) {
        this.setState({activeKey: eventKey});
        }

    render() {
        return (
            <Nav bsStyle="pills" stacked activeKey={this.state.activeKey} >
                <NavItem eventKey={1} href="#/">General statistics</NavItem>
                <NavItem eventKey={2} href="#/list">Detailed data table</NavItem>
                <NavItem eventKey={3} href="#/vis-force-graph">Visualization: Constellations</NavItem>
                {/*<NavItem eventKey={4} href="#/biblewiz">Visualization: Arcs</NavItem>*/}
            </Nav>
        );
    }
}

export default NavigationMenu;