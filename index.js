#!/usr/bin/env node --harmony

require('coffee-script');
require('coffee-errors');

process.env.DEBUG = 'ranpha*';

var ranpha = require('./lib/ranpha');
var app = ranpha();

app.enable('qs');
app.use(ranpha.logger());
app.use(ranpha.static('./public'));
app.use(ranpha.session());

app.get('/ranpha', function*(){
  this.body = 'hello, ranpha.';
});

app.listen(3000);
