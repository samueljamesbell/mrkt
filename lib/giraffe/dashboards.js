var graphite_url = "http://0.0.0.0:8080";

var dashboards = 
[
  { "name": "Live",
    "refresh": 5000,
    "metrics":
    [
      {
        "alias": "Transactions",
        "target": "mrkt.transactions.prices",
        "summary": "last",
        "renderer": "line",
        "interpolation": "basis",
        "summary_formatter": d3.format(".2f"),
        "colspan": 3
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
        "interpolation": "basis",
        "summary_formatter": d3.format(",f")
      },
      {
        "alias": "Discrete Crossover Optimiser",
        "target": "sumSeries(mrkt.optimisers.discrete_crossover.performance)",
        "summary": "last",
        "renderer": "line",
        "interpolation": "basis",
        "summary_formatter": d3.format(",f")
      },
      {
        "alias": "Mean Crossover Optimiser",
        "target": "sumSeries(mrkt.optimisers.mean_crossover.performance)",
        "summary": "last",
        "renderer": "line",
        "interpolation": "basis",
        "summary_formatter": d3.format(",f")
      },
      {
        "alias": "Weighted Discrete Crossover Optimiser",
        "target": "sumSeries(mrkt.optimisers.weighted_discrete_crossover.performance)",
        "summary": "last",
        "renderer": "line",
        "interpolation": "basis",
        "summary_formatter": d3.format(",f")
      },
      {
        "alias": "Weighted Mean Crossover Optimiser",
        "target": "sumSeries(mrkt.optimisers.weighted_mean_crossover.performance)",
        "summary": "last",
        "renderer": "line",
        "interpolation": "basis",
        "summary_formatter": d3.format(",f")
      },
      {
        "alias": "Triple Parent Optimiser",
        "target": "sumSeries(mrkt.optimisers.triple_crossover.performance)",
        "summary": "last",
        "renderer": "line",
        "interpolation": "basis",
        "summary_formatter": d3.format(",f")
      },
    ]
  },
  { "name": "Traders",
    "refresh": 5000,
    "metrics":
    [
      {
        "alias": "Zero-Intelligence Trader Performance",
        "target": "mrkt.traders.zero.*.performance",
        "summary": "avg",
        "renderer": "line",
        "interpolation": "basis",
        "summary_formatter": d3.format(",.2f")
      },
      {
        "alias": "Discrete Crossover Trader Performance",
        "target": "mrkt.traders.discrete_crossover.*.performance",
        "summary": "avg",
        "renderer": "line",
        "interpolation": "basis",
        "summary_formatter": d3.format(",.2f")
      },
      {
        "alias": "Mean Crossover Trader Performance",
        "target": "mrkt.traders.mean_crossover.*.performance",
        "summary": "avg",
        "renderer": "line",
        "interpolation": "basis",
        "summary_formatter": d3.format(",.2f")
      },
      {
        "alias": "Weighted Discrete Crossover Trader Performance",
        "target": "mrkt.traders.weighted_discrete_crossover.*.performance",
        "summary": "avg",
        "renderer": "line",
        "interpolation": "basis",
        "summary_formatter": d3.format(",.2f")
      },
      {
        "alias": "Weighted Mean Crossover Trader Performance",
        "target": "mrkt.traders.weighted_mean_crossover.*.performance",
        "summary": "avg",
        "renderer": "line",
        "interpolation": "basis",
        "summary_formatter": d3.format(",.2f")
      },
      {
        "alias": "Triple Parent Trader Performance",
        "target": "mrkt.traders.triple_parent.*.performance",
        "summary": "avg",
        "renderer": "line",
        "interpolation": "basis",
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
