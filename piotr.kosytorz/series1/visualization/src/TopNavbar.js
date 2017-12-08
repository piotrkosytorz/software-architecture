import React from 'react';
import {Panel, FormGroup, Button} from 'react-bootstrap';
import axios from 'axios';
import moment from 'moment';

class TopNavbar extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            status: 'none',
            projectValue: 'smallSQL',
            thresholdValue: 20,
            executionStart: 0,
            executionEnd: 0,
            executionTime: 0
        };

        this.handleProjectChange = this.handleProjectChange.bind(this);
        this.handleThresholdChange = this.handleThresholdChange.bind(this);
        this.handleSubmit = this.handleSubmit.bind(this);
    }

    handleProjectChange(event) {
        this.setState({projectValue: event.target.value});
    }

    handleThresholdChange(event) {
        this.setState({thresholdValue: event.target.value});
    }

    handleSubmit(event) {
        event.preventDefault();
        this.setState({status: 'waiting for reascal to analyze the project...'});
        this.setState({executionStart: Date.now()});
        axios.get(`http://localhost:5433/analyze/?project=${this.state.projectValue}&threshold=${this.state.thresholdValue}`)
            .then(res => {
                this.setState({executionEnd: Date.now()});
                this.setState({status: 'Finished in ' + (moment(this.state.executionEnd - this.state.executionStart)).format('mm:ss')});
                console.log(res);
            })
            .catch(error => {
                console.log(error.response)
                alert("Error: unable to reach the server.");
            });
    }

    render() {
        return (
            <Panel header="Request data" bsStyle="success">
                <form onSubmit={this.handleSubmit} className="form-inline">
                    <FormGroup>
                        <FormGroup controlId="formControlsSelect">
                            <label>Select</label>
                            <select value={this.state.projectValue} onChange={this.handleProjectChange}>
                                <option value="smallSQL">smallSQL</option>
                                <option value="hsqlDB">hsqlDB</option>
                            </select>
                        </FormGroup>
                        <input type="number"  value={this.state.thresholdValue} onChange={this.handleThresholdChange} />
                    </FormGroup>
                    {' '}
                    <Button type="submit">Run analyzer</Button>
                </form>
                <span>Status: {this.state.status}</span>
            </Panel>
        );
    }
}

export default TopNavbar;
