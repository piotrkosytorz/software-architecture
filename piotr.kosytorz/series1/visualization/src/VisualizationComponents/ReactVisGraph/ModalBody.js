import React from 'react';
import "react-table/react-table.css";
import {Table} from 'react-bootstrap';
import _ from 'lodash';

class ModalBody extends React.Component {

    constructor(props) {
        super(props);

    }

    componentDidMount() {
        console.log(this.props.currentClones);
    }

    getFiles(list) {
        let files = [];
        for (let elem in list) {
            for (let fi in list[elem].locations) {
                files.push(list[elem].locations[fi].Location.file);
            }
        }
        return _.uniq(files);
    }

    countFiles(list) {
        return this.getFiles(list).length;
    }

    render() {

        /**
         * File X
         *
         * Statistics:
         * - file X clones m different units that were also found in other k+l different files
         * - type-1 clones: k
         * - type-2 clones: l
         *
         * Clones per file:
         * Table: file name (different than original), type-1 clones, type-2 clones
         *
         * Details + code (already done)
         */

        return (
            <div>

                <pre>{this.props.currentFileLoc}</pre>
                <p>Clones <strong>{this.props.currentClones.length}</strong> different units that were found in
                    total {this.countFiles(this.props.currentClones)} different files.</p>

                <p><strong>Files overview:</strong></p>
                <ul>
                    {this.getFiles(this.props.currentClones).map((file, index) => (
                        <li>{file}</li>
                    ))}
                </ul>

                <p><strong>Clones details:</strong></p>
                {this.props.currentClones.map((clone, index) => (
                    <div>
                        <h4>Clone ID: {clone.cloneId}</h4>
                        <ul>
                            <li>Clone type-{clone.cloneType}</li>
                            <li>Clone size
                                (lines): {clone.locations[0].Location.lineEnd - clone.locations[0].Location.lineStart + 1}</li>
                        </ul>

                        {clone.locations.map((item, index) => (

                            <Table striped bordered condensed hover key={index}>
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
                                    <td>
                                        <pre>{item.Location.code}</pre>
                                    </td>
                                </tr>
                                </tbody>
                            </Table>

                        ))}
                    </div>

                ))
                }

            </div>
        );
    }

}

export default ModalBody;