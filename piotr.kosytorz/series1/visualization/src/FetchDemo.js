import React from 'react';
import axios from 'axios';

class FetchDemo extends React.Component {
    constructor(props) {
        super(props);

        this.state = {
            posts: []
        };

    }

    componentDidUpdate() {
        axios.get(`http://www.reddit.com/r/${this.props.subreddit}.json`)
            .then(res => {
                const posts = res.data.data.children.map(obj => obj.data);
                this.setState({ posts });
            })
            .catch(error => {
                console.log(error.response)
            });
    }

    render() {
        return (
            <div>
                <h1>{`/r/${this.props.subreddit}`}</h1>
                <ul>
                    {this.state.posts.map(post =>
                        <li key={post.id}>{post.title}</li>
                    )}
                </ul>
            </div>
        );
    }
}

export default FetchDemo;