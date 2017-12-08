import React from 'react';
import * as d3 from 'd3';
import "../bibwiz.css";

class BibleWiz extends React.Component {

  constructor(props) {
      super(props);

      var files = [];
      d3.json('http://localhost:5433/files/', function (err, json) {
          if (err) { console.log(err); }

          var svg = d3.select('#chart');

          for (var x = 0; x < json.length; x++) {
            files.push(json[x].Location);
          }

          svg.selectAll('rect')
              .data(files)
              .enter().append('rect')
                  .attr('x', function (d, i) { x =  i*4;
                      d.x = x;
                      return x;
                    })
                  .attr('y', 400)
                  .attr('width', 4)
                  .attr('height', function (d, i) {return d.lineEnd / 10;})
                  .attr("id", function(d) { return d.file; })
                  .on('click', function (d) {
                      // TODO
                  })
                  .on('mouseover', function (d) {
                    d3.select('#selected')
                        .html(d.file);
                  });
      });

      d3.json('http://localhost:5433/duplications/', function (err, json) {
          if (err) { console.log(err); }

          var svg = d3.select('#chart');

          var duplications = [];

          for (var x = 0; x < json.length; x++) {
            duplications.push(json[x].Duplication);
          }

          svg.selectAll('.arc')
              .data(duplications)
              .enter().append('g')
              .attr('class', 'arc')
              .on('click', function (d) {

              })
              .on('mouseover', function (d) {
                var html = "";
                for (var x = 0; x < d.locations.length; x++) {
                  var location = d.locations[x].Location;
                  html += location.file + "<br/>";
                }
                d3.select('#selected')
                    .html(html);
              })
              .each(function (d, i) {
                var group = d3.select(this);
                var locations = [];

                for (var x = 0; x < d.locations.length; x++) {
                  locations.push(d.locations[x].Location);
                }

                for (var x = 0; x < locations.length - 2; x++) {
                  var start1 = locations[x];
                  var end1 = locations[x+1];
                  if(start1 != end1){
                    var start2 = files
                        .filter(function(d) { return d.file == start1.file });
                    var end2 = files
                        .filter(function(d) { return d.file == end1.file });

                    var start = start2[0].x;
                    var end = end2[0].x;

                    if (start > end) {
                        var tmp = end;
                        end = start;
                        start = tmp;
                    }

                    var r = (end - start) * 0.51;
                    var ry = Math.min(r, 490);
                    var path = 'M ' + start + ',399 A ' + r + ',' + ry + ' 0 0,1 ' + end + ',399 ';

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
            var color = 'crimson';
            var distance;

            if (color == 'Rainbow') {
                distance = Math.abs(end - start);
                color = d3.hsl(distance / 1189 * 360, 0.7, 0.35);
            }

            return color;
        }

  }

    render() {
        return (
            <div>
                <svg id="chart" width="1200" height="500"></svg>
                <div id="selected"></div>
            </div>

        );
    }
}

export default BibleWiz;
