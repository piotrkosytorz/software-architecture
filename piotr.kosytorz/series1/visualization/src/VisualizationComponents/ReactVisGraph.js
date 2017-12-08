import React from 'react';
import axios from 'axios';
import {InteractiveForceGraph, ForceGraphNode, ForceGraphLink} from 'react-vis-force';
import _ from 'lodash';

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
            links: []
        };

        // this.showModal = this.showModal.bind(this);
        // this.hideModal = this.hideModal.bind(this);
        // this.onRowClickHandler = this.onRowClickHandler.bind(this);
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

// , label: data[entry].locations[loc].Location.file.split(/[// ]+/).pop() }

                    // const locationArray = Array.from(new Set(data[entry].locations.map(obj => obj.Location.file)));
                    // const linesCount = data[entry].locations[0].Location.lineEnd - data[entry].locations[0].Location.lineStart + 1;
                    // data[entry].locationsString = locationArray.join(",");
                    // data[entry].linesCount = linesCount;
                    // data[entry].numberOfFiles = locationArray.length;
                }

                let combo = [];

                for(let l in links) {
                    combo.push(links[l].source);
                    combo.push(links[l].target);
                }

                this.setState({linksPerFile: _.countBy(combo, _.identity)});

                nodes = _.uniq(nodes);
                this.setState({nodes});
                this.setState({links});
            })
            .catch(error => {
                console.log(error.response)
            });
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

        const i = Math.min(Math.floor(val/2),7);
        return colors[i];
    }

    render() {


        return (
            <InteractiveForceGraph
                simulationOptions={{height: 500, width: 900, animate: true}}
                labelAttr="label"
                onSelectNode={
                    (node) => console.log(node)
                }
                highlightDependencies
                zoomable
            >
                {this.state.nodes.map((item, index) => (
                    <ForceGraphNode key={index} node={{id: item, label: item.split(/[// ]+/).pop()}} fill={this.getColor(this.state.linksPerFile[item])}/>
                ))}

                {this.state.links.map((item, index) => (
                    <ForceGraphLink key={index} link={item}/>
                ))}

            </InteractiveForceGraph>
        );
    }
}

export default ReactVisGraph;