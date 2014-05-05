Passport Redirect Loop
======================
The code here implements Facebook authentication using the examples provided by [Passport.js](http://passportjs.org/guide/facebook/). Though the examples were followed, the code results in an infinite loop of HTTP redirects. What has been overlooked that would cause this issue?

## Here's What Happens
First, we get the server up and running:

    npm install
    foreman start

Then, we hit the `/auth/facebook` endpoint. As expected, this sends us to Facebook to login, and redirects us back to the `/auth/facebook/callback` route when completed.

```sh
passport-redirect-loop(master) » http 0.0.0.0:5000/auth/facebook

HTTP/1.1 302 Moved Temporarily
Connection: keep-alive
Content-Length: 0
Date: Mon, 05 May 2014 02:08:20 GMT
Location: https://www.facebook.com/dialog/oauth?response_type=code&redirect_uri=http%3A%2F%2F0.0.0.0%3A5000%2Fauth%2Ffacebook%2Fcallback&scope=read_stream&client_id=123456789ABCDEF
```

However, when we hit the `/auth/facebook/callback` route, we're redirected back to Facebook *again*! The cycle continues, and we loop infinitely.

```sh
passport-redirect-loop(master) » http 0.0.0.0:5000/auth/facebook/callback

HTTP/1.1 302 Moved Temporarily
Connection: keep-alive
Content-Length: 0
Date: Mon, 05 May 2014 02:14:08 GMT
Location: https://www.facebook.com/dialog/oauth?response_type=code&redirect_uri=http%3A%2F%2F0.0.0.0%3A5000%2Fauth%2Ffacebook%2Fcallback&client_id=123456789ABCDEF
```

The code for handling each of these routes is straight out of the [Passport documentation](http://passportjs.org/guide/facebook/). What is missing from the documentation's example that would prevent this from happening?

