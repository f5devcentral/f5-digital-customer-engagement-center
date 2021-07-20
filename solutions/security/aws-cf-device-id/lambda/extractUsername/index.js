'use strict';

const querystring = require('querystring');

exports.handler = (event, context, callback) => {
    const request = event.Records[0].cf.request;

    if (request.method === 'POST') {
        /* HTTP body is always passed as base64-encoded string. Decode it. */
        const body = Buffer.from(request.body.data, 'base64').toString();
        /* HTML forms send the data in query string format. Parse it. */
        var jsonBody = JSON.parse(body);
        // extract the username field based on your app format
        const username = jsonBody.username;
        const headerName = 'username';
        request.headers[headerName.toLowerCase()] = [{ key: headerName, value: username }];
        console.log(username)
    }
    return callback(null, request);
};
