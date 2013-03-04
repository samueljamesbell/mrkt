var graphite_url = "http://0.0.0.0:8080";  // enter your graphite url, e.g. http://your.graphite.com

var dashboards = 
[
  { "name": "Mrkt",  // give your dashboard a name (required!)
    "refresh": 5000,  // each dashboard has its own refresh interval (in ms)
    // add an (optional) dashboard description. description can be written in markdown / html.
    "description": "Mrkt analystics dashboard",
    "metrics":  // metrics is an array of charts on the dashboard
    [
      {
        "alias": "Transactions",
        "target": "sumSeries(mrkt.transactions.prices)",
        "description": "Transaction prices over time",
        "summary": "last",
        "renderer": "line",
        "summary_formatter": d3.format(".2f")
      }
    ]
  },
];

var scheme = [
              '#423d4f',
              '#4a6860',
              '#848f39',
              '#a2b73c',
              '#ddcb53',
              '#c5a32f',
              '#7d5836',
              '#963b20',
              '#7c2626',
              ].reverse();

function relative_period() { return (typeof period == 'undefined') ? 1 : parseInt(period / 7) + 1; }
function entire_period() { return (typeof period == 'undefined') ? 1 : period; }
function at_least_a_day() { return entire_period() >= 1440 ? entire_period() : 1440; }
