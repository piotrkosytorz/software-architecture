import React from 'react';
import ReactTable from 'react-table'
import matchSorter from 'match-sorter';
import "react-table/react-table.css";
import axios from 'axios';
import {Button, Modal} from 'react-bootstrap';
import ModalBody from "./ModalBody";

class DataList extends React.Component {

    constructor() {
        super();
        this.state = {
            currentCloneId: 0,
            originalData: [{}],
            data: [{}],
            show: false
        };

        this.showModal = this.showModal.bind(this);
        this.hideModal = this.hideModal.bind(this);
        this.onRowClickHandler = this.onRowClickHandler.bind(this);
    }

    componentDidMount() {
        axios.get(`http://localhost:5433/duplications/`)
            .then(res => {
                const originalData = res.data;
                let data = res.data.map(obj => obj.Duplication);
                for (let entry in data) {
                    const locationArray = Array.from(new Set(data[entry].locations.map(obj => obj.Location.file)));
                    if (typeof data[entry] !== "undefined" && data[entry].locations.length) {
                        const linesCount = data[entry].locations[0].Location.lineEnd - data[entry].locations[0].Location.lineStart + 1;
                        data[entry].locationsString = locationArray.join(",");
                        data[entry].linesCount = linesCount;
                        data[entry].numberOfFiles = locationArray.length;
                    }
                }
                this.setState({originalData, data});
            })
            .catch(error => {
                console.log(error)
            });
    }

    showModal() {
        this.setState({ show: true });
    }

    hideModal() {
        this.setState({ show: false });
    }


    onRowClickHandler = (state, rowInfo, column, instance) => {
        return {
            onClick: e => {
                this.setState({
                    currentCloneId: rowInfo.row.cloneId
                });
                this.showModal();
                // console.log('A Td Element was clicked!')
                // console.log('it produced this event:', e)
                // console.log('It was in this column:', column)
                // console.log('It was in this row:', rowInfo)
                // console.log('It was in this table instance:', instance)
            }
        }
    }



    renderFileNames(str) {
        if (typeof str !== "undefined") {
            const arr = str.split(",");
            const component = arr.map((elem, index) => <li key={index}>{elem}</li>);
            return (<ul>{component}</ul>);
        }
        return <span>-</span>;
    }

    render() {
        const {data} = this.state;
        return (
            <div>
                <ReactTable
                    getTrProps={this.onRowClickHandler}
                    data={data}
                    filterable
                    defaultFilterMethod={(filter, row) =>
                        String(row[filter.id]) === filter.value}
                    columns={[
                        {
                            Header: "Parameters",
                            columns: [
                                {
                                    Header: "CloneID",
                                    accessor: "cloneId",
                                    maxWidth: 100,
                                    filterMethod: (filter, row) =>
                                        row[filter.id].startsWith(filter.value) &&
                                        row[filter.id].endsWith(filter.value)
                                },
                                {
                                    Header: "Clone types",
                                    accessor: "cloneType",
                                    maxWidth: 100,
                                    filterMethod: (filter, row) => {
                                        if (filter.value === "all") {
                                            return true;
                                        }
                                        if (filter.value === "type-1") {
                                            return row[filter.id] === 1;
                                        }
                                        if (filter.value === "type-2") {
                                            return row[filter.id] === 2;
                                        }
                                        return false;
                                    },
                                    Filter: ({filter, onChange}) =>
                                        <select
                                            onChange={event => onChange(event.target.value)}
                                            style={{width: "100%"}}
                                            value={filter ? filter.value : "all"}
                                        >
                                            <option value="all">All</option>
                                            <option value="type-1">Type-1</option>
                                            <option value="type-2">Type-2</option>
                                        </select>
                                },
                                {
                                    Header: "Lines",
                                    accessor: "linesCount",
                                    maxWidth: 100,
                                },
                                {
                                    Header: "# of files",
                                    accessor: "numberOfFiles",
                                    maxWidth: 100,
                                }
                            ]
                        }
                        ,
                        {
                            Header: "Files",
                            columns: [
                                {
                                    Header: "Files",
                                    accessor: "locationsString",
                                    Cell: props =>
                                        <span>{this.renderFileNames(props.value)}</span>,
                                    filterMethod: (filter, rows) =>
                                        matchSorter(rows, filter.value, {keys: ["locationsString"]}),
                                    filterAll: true
                                }
                            ]
                        }
                    ]}
                    defaultPageSize={10}
                    className="-striped -highlight"
                />
                <br/>
                <Modal
                    {...this.props}
                    bsSize="large"
                    show={this.state.show}
                    onHide={this.hideModal}
                    dialogClassName="custom-modal"
                >
                    <Modal.Header closeButton>
                        <Modal.Title id="contained-modal-title-lg">Clone details</Modal.Title>
                    </Modal.Header>
                    <Modal.Body>
                        <ModalBody currentCloneId={this.state.currentCloneId}/>
                    </Modal.Body>
                    <Modal.Footer>
                        <Button onClick={this.hideModal}>Close</Button>
                    </Modal.Footer>
                </Modal>
            </div>
        );

    }
}

export default DataList;