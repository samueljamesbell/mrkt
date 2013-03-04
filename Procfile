/*run this first: python /opt/graphite/bin/carbon-cache.py start*/
graphite: python /opt/graphite/bin/run-graphite-devel-server.py /opt/graphite 2>/dev/null
giraffe: serve 5200 lib/giraffe 2>/dev/null
simulation: jruby --1.9 --server --headless -Xcompile.invokedynamic=true -J-Xmx1024m mrkt.rb
