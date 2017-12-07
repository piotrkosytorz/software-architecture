import React from 'react';
import {Navbar, FormGroup, FormControl, Button, ControlLabel} from 'react-bootstrap';

class TopNavbar extends React.Component {

    handleSubmit(event) {
        alert(`submitted ${event}`);
    }

    render() {
        return (
            <Navbar className="text-center navbar navbar-toggleable-md navbar-inverse fixed-top bg-inverse">
                <Navbar.Header>

                    <Navbar.Toggle/>
                </Navbar.Header>
                <Navbar.Collapse>
                    <Navbar.Form>
                        <FormGroup>
                            <FormGroup controlId="formControlsSelect">
                                <ControlLabel>Select</ControlLabel>
                                <FormControl componentClass="select" placeholder="Project">
                                    <option value="smallSQL">smallSQL</option>
                                    <option value="hsqlDB">hsqlDB</option>
                                </FormControl>
                            </FormGroup>
                            <FormControl type="number" placeholder="Threshold" defaultValue="20"/>
                        </FormGroup>
                        {' '}
                        <Button type="submit">Run analyzer</Button>
                    </Navbar.Form>
                </Navbar.Collapse>
            </Navbar>
        );
    }
}

export default TopNavbar;
