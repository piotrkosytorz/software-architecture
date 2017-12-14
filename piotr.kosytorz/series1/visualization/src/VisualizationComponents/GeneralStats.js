import React from 'react';
import axios from 'axios';
import {Table} from 'react-bootstrap';

class GeneralStats extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            data: [{}],
            duplications: [],
            cloneClassesCount: 0,
            clonesCount: 0,
            biggestCloneClass: {locations: [], cloneId: 0},
            biggestClone: {cloneClass: {}, size: 0}
        }
    }

    componentDidMount() {
        axios.get(`http://localhost:5433/scores/`)
            .then(res => {
                const data = res.data;
                this.setState({data});
            })
            .catch(error => {
                console.log(error.response)
            });

        axios.get(`http://localhost:5433/duplications/`)
            .then(res => {
                const duplications = res.data;
                this.setState({duplications});

                // count clone classes
                this.setState({
                    cloneClassesCount: duplications.length
                });

                // count clones
                const clones = res.data.map(obj => obj.Duplication.locations).reduce((a, b) => a.concat(b), []);
                this.setState({
                    clonesCount: clones.length
                });

                // biggest clone
                let biggestClone = {
                    cloneClass: {},
                    size: 0
                };
                for (let cClass in res.data) {
                    for (let cClone in res.data[cClass]) {
                        const cc = res.data[cClass].Duplication;
                        for (let cLoc in cc.locations) {
                            const size = cc.locations[cLoc].Location.lineEnd - cc.locations[cLoc].Location.lineStart + 1;
                            if (size > biggestClone.size) {
                                biggestClone.size = size;
                                biggestClone.cloneClass = cc;
                            }
                        }
                    }
                }
                this.setState({biggestClone});

                // biggest clone class
                let biggestCloneClass = {locations:[]};
                for (let cClass in res.data) {
                    if (res.data[cClass].Duplication.locations.length > biggestCloneClass.locations.length) {
                        biggestCloneClass = res.data[cClass].Duplication;
                    }
                }
                this.setState({biggestCloneClass});
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
                            Duplicated lines
                        </td>
                        <td>
                            {this.state.data.duplications ? this.state.data.duplications : ""}
                            ({this.state.data.volume && this.state.data.duplications ? (Math.round(100 * this.state.data.duplications / this.state.data.volume)) + "%" : ''})
                        </td>
                        <td>
                            {this.state.data.dupS ? this.state.data.dupS[1][1] : ""}
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Unit Complexity
                        </td>
                        <td>
                            Low: {
                            this.state.data.unitCCS ? 100 - this.state.data.unitCCS[0] - this.state.data.unitCCS[1] - this.state.data.unitCCS[2] : ""
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
                            this.state.data.unitSS ? 100 - this.state.data.unitSS[0] - this.state.data.unitSS[1] - this.state.data.unitSS[2] : ""
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
                            this.state.data.interfaceS ? 100 - this.state.data.interfaceS[0] - this.state.data.interfaceS[1] - this.state.data.interfaceS[2] : ""
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

                <h2>Clones stats</h2>
                <Table striped bordered condensed hover>
                    <thead>
                    <tr>
                        <td>
                            Metric
                        </td>
                        <td>
                            value
                        </td>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>
                            Number of clones
                        </td>
                        <td>
                            {this.state.clonesCount}
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Number of clone classes
                        </td>
                        <td>
                            {this.state.cloneClassesCount}
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Biggest clone
                        </td>
                        <td>
                            {this.state.biggestClone.size} (Class with ID: {this.state.biggestClone.cloneClass.cloneId})
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Biggest clone class
                        </td>
                        <td>
                            {this.state.biggestCloneClass.locations.length} (Class with ID: {this.state.biggestCloneClass.cloneId})
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