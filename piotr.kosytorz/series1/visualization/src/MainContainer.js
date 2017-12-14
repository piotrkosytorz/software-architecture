import React from 'react'
import { Switch, Route } from 'react-router-dom'
import DataList from './VisualizationComponents/DataList/DataList'
import ReactVisGraph from './VisualizationComponents/ReactVisGraph/ReactVisGraph'
import BibleWiz from './VisualizationComponents/BibleWiz'
import GeneralStats from "./VisualizationComponents/GeneralStats";
import Downloads from "./VisualizationComponents/Downloads";

class MainContainer extends React.Component {

    render() {
        return (
            <main>
                <Switch>
                    <Route exact path='/' component={GeneralStats}/>
                    <Route path='/list' component={DataList}/>
                    <Route path='/vis-force-graph' component={ReactVisGraph}/>
                    <Route path='/biblewiz' component={BibleWiz}/>
                    <Route path='/downloads' component={Downloads}/>
                </Switch>
            </main>
        );
    }
}

export default MainContainer;