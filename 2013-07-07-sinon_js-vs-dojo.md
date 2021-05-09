# Sinon.js Vs Dojo


## Problem...

I was coding along quite happily on a project (soon to be unveiled) and got to testing my code that interacts with the server. I was intending to using Sinon.js to mock this, but the response was never coming back... My code was like this:

```

xhr("/dataset", {
    handleAs: "json"
}).then(function(data) {
    //doSomething
},function(err) {
 //throw err
});

```

Except that my code it never entered the success or failure... I figured it must still be waiting for a response, and this was correct because putting in a timeout:

```

xhr("/dataset", {
    handleAs: "json",
    timeout: 2000
}).then(function(data) {
    //doSomething
},function(err) {
 //throw err
});

```

Caused it to call the error function after 2 seconds, but that does not explain why Sinon.js still did not respond.

## Solution!

In the end I discovered [these posts](https://groups.google.com/forum/?fromgroups=#!msg/sinonjs/HdsD4CL1Jq8/2rwpQx2_s5MJ) detailing that Dojo had moved onto the XHR2 spec, which is new and that is not supported by Sinon.

In the end it seems the answer is to use a new "has" in your \`dojoConfig\`:

```

<script type="text/javascript">
    dojoConfig = {
        async:true,
        parseOnLoad: false,
        cacheBust: false,
        baseUrl: '/js',
        has: {
            'native-xhr2': false // Sinon.JS does not support XHR2
        },
    };
</script>
<script src="/js/vendor/dojo/dojo.js"></script>

```

Which solved my problem, I was sooo happy when I found this!

