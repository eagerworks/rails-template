// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")

import JQuery from 'jquery';
window.$ = window.JQuery = JQuery;

import 'bootstrap';
import '@fortawesome/fontawesome-free/js/all';

import Chart from 'chart.js';

require('./dashboard.js')
require('./demo/chart_area_demo.js')
require('./demo/chart_bar_demo.js')
require('./demo/chart_pie_demo.js')

require('../stylesheets/application.scss')
