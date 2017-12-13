import React from 'react';
import axios from 'axios';
import {InteractiveForceGraph, ForceGraphNode, ForceGraphLink} from 'react-vis-force';
import _ from 'lodash';
import {Modal, Button} from 'react-bootstrap';
import ModalBody from "./ModalBody";

/**
 * Use this:
 * https://github.com/uber/react-vis-force
 * More here:
 * https://github.com/uber/react-vis-force/blob/master/docs/InteractiveForceGraph.md
 */

class ReactVisGraph extends React.Component {

    constructor() {
        super();
        this.state = {
            linksPerFile: [],
            nodes: [],
            links: [],
            clones: [],
            show: false,
            currentClones: [],
            currentFileLoc: ''
        };

        this.showModal = this.showModal.bind(this);
        this.hideModal = this.hideModal.bind(this);
        this.handleNodeSelect = this.handleNodeSelect.bind(this);
    }

    componentDidMount() {
        axios.get(`http://localhost:5433/duplications/`)
            .then(res => {
                let nodes = [];
                let links = [];
                let data = res.data.map(obj => obj.Duplication);
                for (let entry in data) {
                    for (let loc in data[entry].locations) {
                        for (let loc2 in data[entry].locations) {

                            if (!links.some(function (e) {
                                    return (
                                        (e.source === data[entry].locations[loc].Location.file && e.target === data[entry].locations[loc2].Location.file)
                                        ||
                                        (e.source === data[entry].locations[loc2].Location.file && e.target === data[entry].locations[loc].Location.file)
                                    )
                                })) {
                                links.push({
                                    source: data[entry].locations[loc].Location.file,
                                    target: data[entry].locations[loc2].Location.file
                                })
                            }
                        }
                        nodes.push(data[entry].locations[loc].Location.file);
                    }
                }

                let combo = [];

                for (let l in links) {
                    combo.push(links[l].source);
                    combo.push(links[l].target);
                }

                this.setState({linksPerFile: _.countBy(combo, _.identity)});

                nodes = _.uniq(nodes);
                this.setState({nodes});
                this.setState({links});
                this.setState({clones: data});
            })
            .catch(error => {
                console.log(error.response)
            });
    }

    showModal() {
        this.setState({show: true});
    }

    hideModal() {
        this.setState({show: false});
    }

    getColor(val) {
        const colors = [
            "#ffc7c6",
            "#f4bcbb",
            "#e97b7c",
            "#de3636",
            "#90181a",
            "#621110",
            "#420b0c",
            "#2c0808"
        ];

        const i = Math.min(Math.floor(val / 2), 7);
        return colors[i];
    }

    handleNodeSelect(proxy, node) {

        const locations = this.state.clones.filter(
            element => element.locations.some(
                loc => loc.Location.file === node.id
            )
        );

        this.setState({currentClones: locations});
        this.setState({currentFileLoc: node.id});
        this.setState({show: true});

    }

    render() {
        return (
            <div>
                <InteractiveForceGraph
                    simulationOptions={{height: 500, width: 500, animate: true}}
                    labelAttr="label"
                    onSelectNode={this.handleNodeSelect}
                    highlightDependencies
                    zoomable
                >
                    {this.state.nodes.map((item, index) => (
                        <ForceGraphNode key={index} node={{id: item, label: item.split(/[// ]+/).pop()}}
                                        fill={this.getColor(this.state.linksPerFile[item])}/>
                    ))}

                    {this.state.links.map((item, index) => (
                        <ForceGraphLink key={index} link={item}/>
                    ))}

                </InteractiveForceGraph>
                <div style={{width: '400px', float: 'right', 'margin-right': '100px'}}>
                    <h4>Legend:</h4>
                    <ul>
                        <li><strong>single node</strong> represents a file</li>
                        <li><strong>connection between nodes</strong> represent the relations of cloned elements from different files</li>
                        <li><strong>color of a node</strong> represents number of related files with which the considered node shares clones
                            <ul className="color-legend">
                                <li className="l1">1-2 related files</li>
                                <li className="l2">3-4 related files</li>
                                <li className="l3">5-6 related files</li>
                                <li className="l4">7-8 related files</li>
                                <li className="l5">9-10 related files</li>
                                <li className="l6">11-12 related files</li>
                                <li className="l7">13-14 related files</li>
                                <li className="l8">15+ related files</li>
                            </ul>
                        </li>

                    </ul>
                </div>
                <Modal
                    {...this.props}
                    bsSize="large"
                    show={this.state.show}
                    onHide={this.hideModal}
                    dialogClassName="custom-modal"
                >
                    <Modal.Header closeButton>
                        <Modal.Title id="contained-modal-title-lg">File details</Modal.Title>
                    </Modal.Header>
                    <Modal.Body>
                        <ModalBody currentClones={this.state.currentClones} currentFileLoc={this.state.currentFileLoc} />
                    </Modal.Body>
                    <Modal.Footer>
                        <Button onClick={this.hideModal}>Close</Button>
                    </Modal.Footer>
                </Modal>
            </div>
        );
    }
}

export default ReactVisGraph;