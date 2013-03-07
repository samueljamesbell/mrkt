var graphite_url = "http://0.0.0.0:8080";

var dashboards = 
[
  { "name": "Live",
    "refresh": 5000,
    "metrics":
    [
      {
        "alias": "Transactions",
        "target": "sumSeries(mrkt.transactions.prices)",
        "summary": "last",
        "renderer": "line",
        "summary_formatter": d3.format(".2f")
      },
    ]
  },
  { "name": "Optimisers",
    "refresh": 5000,
    "metrics":
    [
      {
        "alias": "Zero-Intelligence Optimiser",
        "target": "sumSeries(mrkt.optimisers.zero.performance)",
        "summary": "last",
        "renderer": "line",
        "summary_formatter": d3.format(",f")
      },
      {
        "alias": "Discrete Crossover Optimiser",
        "target": "sumSeries(mrkt.optimisers.discrete_crossover.performance)",
        "summary": "last",
        "renderer": "line",
        "summary_formatter": d3.format(",f")
      },
      {
        "alias": "Mean Crossover Optimiser",
        "target": "sumSeries(mrkt.optimisers.mean_crossover.performance)",
        "summary": "last",
        "renderer": "line",
        "summary_formatter": d3.format(",f")
      },
      {
        "alias": "Weighted Discrete Crossover Optimiser",
        "target": "sumSeries(mrkt.optimisers.weighted_discrete_crossover.performance)",
        "summary": "last",
        "renderer": "line",
        "summary_formatter": d3.format(",f")
      },
      {
        "alias": "Weighted Mean Crossover Optimiser",
        "target": "sumSeries(mrkt.optimisers.weighted_mean_crossover.performance)",
        "summary": "last",
        "renderer": "line",
        "summary_formatter": d3.format(",f")
      },
      {
        "alias": "Triple Parent Mean Crossover Optimiser",
        "target": "sumSeries(mrkt.optimisers.triple_crossover.performance)",
        "summary": "last",
        "renderer": "line",
        "summary_formatter": d3.format(",f")
      },
    ]
  },
  { "name": "Traders",
    "refresh": 5000,
    "metrics":
    [
      {
        "alias": "Noise Trader Performance",
        "target": "sumSeries(mrkt.traders.zero.prices)",
        "summary": "last",
        "renderer": "line",
        "summary_formatter": d3.format(",.2f")
      },
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
