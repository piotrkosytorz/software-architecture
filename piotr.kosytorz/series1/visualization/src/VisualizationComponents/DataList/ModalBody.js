import React from 'react';
import "react-table/react-table.css";
import axios from 'axios';
import {Table} from 'react-bootstrap';

class ModalBody extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            data: [{}]
        };
    }

    componentDidMount() {
        axios.get(`http://localhost:5433/duplications/`)
            .then(res => {
                const data = res.data.map(obj => obj.Duplication);
                this.setState({data});
            })
            .catch(error => {
                console.log(error.response)
            });
    }

    extractCloneDetails(data, cloneId) {

        const clone = data.find(function(el) {
            return el.cloneId === cloneId;
        })

        return clone;

    }

    render() {

        const clone = this.extractCloneDetails(this.state.data, this.props.currentCloneId);

        if (typeof clone === "undefined") {
            return(<div></div>);
        }
        console.log("x", clone);
        return (
            <div>
                <ul>
                    <li>Clone ID: {this.props.currentCloneId}</li>
                    <li>Clone type-{clone.cloneType}</li>
                    <li>Clone size (lines): {clone.locations[0].Location.lineEnd - clone.locations[0].Location.lineStart + 1}</li>
                </ul>

                {clone.locations.map((item, index) => (

                    <Table striped bordered condensed hover>
                        <thead>
                        <tr>
                            <th style={{color: "#b50a0a"}}>{item.Location.file}</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>Start line: {item.Location.lineStart}</td>
                        </tr>
                        <tr>
                            <td>End line: {item.Location.lineEnd}</td>
                        </tr>
                        <tr>
                            <td><pre>{item.Location.code}</pre></td>
                        </tr>
                        </tbody>
                    </Table>

                ))}

            </div>
        );
    }

}

export default ModalBody;