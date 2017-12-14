import React from 'react';
import axios from 'axios';
import {ButtonGroup, Button, Panel} from 'react-bootstrap';
import {saveAs} from 'file-saver';

class Downloads extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            data: [{}]
        };
    }

    statisticsDownloadHandler(event) {
        axios.get(`http://localhost:5433/scores/`)
            .then(res => {
                const file = new File([JSON.stringify(res.data)], "statistics.json", {type: "application/json;charset=utf-8"});
                saveAs(file);
            })
            .catch(error => {
                console.log(error.response)
            });
    }

    clonesDownloadHandler(event) {
        axios.get(`http://localhost:5433/duplications/`)
            .then(res => {
                const file = new File([JSON.stringify(res.data)], "clones.json", {type: "application/json;charset=utf-8"});
                saveAs(file);
            })
            .catch(error => {
                console.log(error.response)
            });
    }

    render() {
        return (
            <div>
                <Panel header="Project downloads" bsStyle="primary">
                    <ButtonGroup vertical>
                        <Button onClick={this.statisticsDownloadHandler}>Statistics</Button>
                        <Button onClick={this.clonesDownloadHandler}>Clones</Button>
                    </ButtonGroup>
                </Panel>
            </div>
        );
    }
}

export default Downloads;