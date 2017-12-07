import React from 'react'
import { Switch, Route } from 'react-router-dom'
import DataList from './VisualizationComponents/DataList/DataList'
import HeatmapSingle from './VisualizationComponents/HeatmapSingle'
import HeatmapCross from './VisualizationComponents/HeatmapCross'
import BibleWiz from './VisualizationComponents/BibleWiz'
import GeneralStats from "./VisualizationComponents/GeneralStats";

class MainContainer extends React.Component {

    render() {
        return (
            <main>
                <Switch>
                    <Route exact path='/' component={GeneralStats}/>
                    <Route exact path='/list' component={DataList}/>
                    <Route path='/heatmap-single' component={HeatmapSingle}/>
                    <Route path='/heatmap-cross' component={HeatmapCross}/>
                    <Route path='/biblewiz' component={BibleWiz}/>
                </Switch>
            </main>
        );
    }
}

export default MainContainer;