# React Mixin Manip



I have created a simple [React Mixin](https://gist.github.com/forbesmyester/8469940) which enables you to use the power of [Manip](https://github.com/forbesmyester/manip) with the awsomeness of [React](http://facebook.github.io/).

When you want to alter data within React you can use the `component.setState()` or `component.setProps()` methods. This is wonderful if you want to modify top level data... But that is not always the case, consider how the following data may be rendered with React:

```
{
    jack: { hair: 'brown', eyes: 'blue', age: 4 },
    jane: { hair: 'blonde', eyes: 'brown', age: 2 },
    jill: { hair: 'red', eyes: 'blue', age: 7 }
}
```

This would probably be outputted using the following code:

```
React.renderComponent(
    <Output data={data}/>,
    document.getElementById('...')
);
```

Now suppose that somehow you know Jill's age is now 8, or maybe only that her age has increased by one. It may be, depending on where you are in the code that you still have access to all the data, but it is also quite possible you do not.

In this situation it is impossible for you to use `component.setProps()` because it will also overwrite all information about everyone else! Infact given the documented external API's of a React component it is impossible for you to perform the required manipulation without significant bespoke work. The aim of React\_Mixin\_Manip is to make this job much more simple....

See the example below:

```
// Create a React class to show nested data and which uses the
// React_Mixin_Manip mixin.
var Output = React.createClass({

    mixins: [React_Mixin_Manip],

    render: function() {

        var nodes = [];
        for (var k in this.props.peopleData) {
            if (this.props.peopleData.hasOwnProperty(k)) {
                nodes.push(<dt>{k}</dt>);
                nodes.push(<dd>{JSON.stringify(this.props.peopleData[k])}</dd>);
            }
        }

        return (
            <div>
                <dl>{nodes}</dl>
            </div>
        );
    }
});

var getData = function() {
    return {
        jack: { hair: 'brown', eyes: 'blue', age: 4 },
        jane: { hair: 'blonde', eyes: 'brown', age: 2 },
        jill: { hair: 'red', eyes: 'blue', age: 7 }
    };
};

// Render the above component into the HTML
var output = React.renderComponent(
        <Output peopleData={getData()} />,
        document.getElementById('example')
    );

// After 1.5 seconds fiddle with the data within the component using
// manip... Note that this is impossible to write using the React
// `setProps()` method.
setTimeout(function() {
    output.manip(
        false,
        {'$inc': {'peopleData.jill.age': 1}},
        function() {
            console.log("Manipulation Done!");
        }
    );
}, 1500);
```

After 1.5 seconds the age of Jill will be increased by one. In this situation it is impossible to access the original data from within the `setTimeout()` call. Using React\_Mixin\_Manip has provided a reasonably clean way to perform the required manipulation with very little work.

Note: The reason this has been released as a Gist instead of a full GitHub repository is that I am not sure on a sensible way to test it... It will become a repository when I either figure out the testing or when I need it as a repository to use with [NPM](https://npmjs.org) or [Bower](http://bower.io/).

