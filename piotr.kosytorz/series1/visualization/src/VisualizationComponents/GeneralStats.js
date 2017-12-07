import React from 'react';
import axios from 'axios';
import {Table} from 'react-bootstrap';

class GeneralStats extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            data: [{}]
        };
    }

    componentDidMount() {
        axios.get(`http://localhost:5433/scores/`)
            .then(res => {
                const data = res.data;
                this.setState({data});
                console.log(data);
            })
            .catch(error => {
                console.log(error.response)
            });
    }

    render() {
        return (
            <div>
                <h1>Some raw data</h1>
                <h2>General stats</h2>
                <Table striped bordered condensed hover>
                    <thead>
                    <tr>
                        <td>
                            Metric
                        </td>
                        <td>
                            Result
                        </td>
                        <td>
                            Score
                        </td>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>
                            Volume
                        </td>
                        <td>
                            {this.state.data.volume} LOCs
                        </td>
                        <td>
                            {this.state.data.volumeS ? this.state.data.volumeS[1] : ""}
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Unit Complexity
                        </td>
                        <td>
                            Low: {
                                this.state.data.unitCCS ? 100-this.state.data.unitCCS[0]-this.state.data.unitCCS[1]-this.state.data.unitCCS[2] : ""
                            }%

                            Medium: {
                                this.state.data.unitCCS ? this.state.data.unitCCS[0] : ""
                            }%

                            High: {
                                this.state.data.unitCCS ? this.state.data.unitCCS[1] : ""
                            }%

                            Very High: {
                                this.state.data.unitCCS ? this.state.data.unitCCS[2] : ""
                            }%
                        </td>
                        <td>
                            {this.state.data.unitCCS ? this.state.data.unitCCS[3][1] : ""}
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Unit Size
                        </td>
                        <td>
                            Low: {
                            this.state.data.unitSS ? 100-this.state.data.unitSS[0]-this.state.data.unitSS[1]-this.state.data.unitSS[2] : ""
                        }%

                            Medium: {
                            this.state.data.unitSS ? this.state.data.unitSS[0] : ""
                        }%

                            High: {
                            this.state.data.unitSS ? this.state.data.unitSS[1] : ""
                        }%

                            Very High: {
                            this.state.data.unitSS ? this.state.data.unitSS[2] : ""
                        }%
                        </td>
                        <td>
                            {this.state.data.unitSS ? this.state.data.unitSS[3][1] : ""}
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Unit Interfacing
                        </td>
                        <td>
                            Low: {
                            this.state.data.interfaceS ? 100-this.state.data.interfaceS[0]-this.state.data.interfaceS[1]-this.state.data.interfaceS[2] : ""
                        }%

                            Medium: {
                            this.state.data.interfaceS ? this.state.data.interfaceS[0] : ""
                        }%

                            High: {
                            this.state.data.interfaceS ? this.state.data.interfaceS[1] : ""
                        }%

                            Very High: {
                            this.state.data.interfaceS ? this.state.data.interfaceS[2] : ""
                        }%
                        </td>
                        <td>
                            {this.state.data.interfaceS ? this.state.data.interfaceS[3][1] : ""}
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <strong>Units</strong>
                        </td>
                        <td>
                            <strong>{this.state.data.numberOfUnits ? this.state.data.numberOfUnits : ""}</strong>
                        </td>
                        <td>

                        </td>
                    </tr>
                    <tr>
                        <td>
                            Testing
                        </td>
                        <td>
                            {this.state.data.testingS ? this.state.data.testingS[0] : ""}%
                        </td>
                        <td>
                            {this.state.data.testingS ? this.state.data.testingS[1][1] : ""}
                        </td>
                    </tr>
                    </tbody>
                </Table>

                <h2>SIG rating</h2>
                <Table striped bordered condensed hover>
                    <thead>
                    <tr>
                        <td>
                            SIG Rating
                        </td>
                        <td>
                            Score
                        </td>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>
                            Maintainability
                        </td>
                        <td>
                            {this.state.data.maintainability ? this.state.data.maintainability[1] : ""}
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Analysability
                        </td>
                        <td>
                            {this.state.data.analysability ? this.state.data.analysability[1] : ""}
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Changeability
                        </td>
                        <td>
                            {this.state.data.changeability ? this.state.data.changeability[1] : ""}
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Testability
                        </td>
                        <td>
                            {this.state.data.testability ? this.state.data.testability[1] : ""}
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Stability
                        </td>
                        <td>
                            {this.state.data.stability ? this.state.data.stability[1] : ""}
                        </td>
                    </tr>
                    </tbody>
                </Table>
            </div>
        );
    }
}

export default GeneralStats;