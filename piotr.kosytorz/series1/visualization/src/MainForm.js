import React from 'react';

class MainForm extends React.Component {
    constructor(props) {
        super(props);
        this.state = {thresholdValue: ''};

        this.handleChange = this.handleChange.bind(this);
        this.handleSubmit = this.handleSubmit.bind(this);
    }

    handleChange(event) {
        this.setState({thresholdValue: event.target.value});
    }

    handleSubmit(event) {
        //alert('Call Rascal programme passing the following threshold: ' + this.state.value);
        this.props.onThresholdChange(this.state.thresholdValue);
        event.preventDefault();
    }

    render() {
        return (
            <form onSubmit={this.handleSubmit}>
                <label>
                    Threshold:
                    <input type="text" value={this.state.thresholdValue} onChange={this.handleChange} />
                </label>
                <input type="submit" value="Submit" />
            </form>
        );
    }
}

export default MainForm;