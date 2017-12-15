import React from 'react';
import * as d3 from 'd3';
import "../bibwiz.css";

class BibleWiz extends React.Component {

    constructor(props) {
        super(props);

        let files = [];
        d3.json('http://localhost:5433/files/', function (err, json) {
            if (err) {
                console.log(err);
            }

            let svg = d3.select('#chart');

            for (let x = 0; x < json.length; x++) {
                files.push(json[x].Location);
            }

            svg.selectAll('rect')
                .data(files)
                .enter().append('rect')
                .attr('x', function (d, i) {
                    let x = i * 4;
                    d.x = x;
                    return x;
                })
                .attr('y', 400)
                .attr('width', 4)
                .attr('height', function (d, i) {
                    return d.lineEnd / 10;
                })
                .attr("id", function (d) {
                    return d.file;
                })
                .on('click', function (d) {
                    // TODO
                })
                .on('mouseover', function (d) {
                    d3.select('#selected')
                        .html(d.file);
                });
        });

        d3.json('http://localhost:5433/duplications/', function (err, json) {
            if (err) {
                console.log(err);
            }

            let svg = d3.select('#chart');

            let duplications = [];

            for (let x = 0; x < json.length; x++) {
                duplications.push(json[x].Duplication);
            }

            svg.selectAll('.arc')
                .data(duplications)
                .enter().append('g')
                .attr('class', 'arc')
                .on('click', function (d) {

                })
                .on('mouseover', function (d) {
                    let html = "";
                    for (let x = 0; x < d.locations.length; x++) {
                        let location = d.locations[x].Location;
                        html += location.file + "<br/>";
                    }
                    d3.select('#selected')
                        .html(html);
                })
                .each(function (d, i) {
                    let group = d3.select(this);
                    let locations = [];

                    for (let x = 0; x < d.locations.length; x++) {
                        locations.push(d.locations[x].Location);
                    }

                    for (let x = 0; x < locations.length - 2; x++) {
                        let start1 = locations[x];
                        let end1 = locations[x + 1];
                        if (start1 !== end1) {
                            let start2 = files
                                .filter(function (d) {
                                    return d.file === start1.file
                                });
                            let end2 = files
                                .filter(function (d) {
                                    return d.file === end1.file
                                });

                            let start = start2[0].x;
                            let end = end2[0].x;

                            if (start > end) {
                                let tmp = end;
                                end = start;
                                start = tmp;
                            }

                            let r = (end - start) * 0.51;
                            let ry = Math.min(r, 490);
                            let path = 'M ' + start + ',399 A ' + r + ',' + ry + ' 0 0,1 ' + end + ',399 ';

                            group.append('path')
                                .attr('d', path)
                                .style('stroke', function (start, end) {
                                    return colorize(start, end);
                                }(start, end));

                        }
                    }


                });
        });

        // Chooses a color for an arc from start to end
        function colorize(start, end) {
            let color = 'crimson';
            let distance;

            if (color === 'Rainbow') {
                distance = Math.abs(end - start);
                color = d3.hsl(distance / 1189 * 360, 0.7, 0.35);
            }

            return color;
        }

    }

    render() {
        return (
            <div>
              <svg id="chart" width="1200" height="500" style={{float: 'left'}}/>
              <div style={{width: '400px', position: 'fixed', right: '100px'}}>
                  <h4>Legend:</h4>
                  <ul>
                      <li><strong>blue bars</strong> represent a single file, the length of the bar represents the file length</li>
                      <li><strong>bar hover</strong> shows the selected file name </li>
                      <li><strong>crimson arcs</strong> represent the relations of clone class elements from different files</li>
                      <li><strong>arc hover</strong> shows the files from the clone class</li>

                  </ul>
              </div>


                <div id="selected"/>
            </div>
        );
    }
}

export default BibleWiz;
