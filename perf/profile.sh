rm -rf perf/results
mkdir perf/results

CPUPROFILE_REALTIME=1 CPUPROFILE_FREQUENCY=1000 bundle exec ruby perf/profile.rb

for f in perf/results/*.profile
do
  echo "Creating pdf for $f..."
  pprof.rb --pdf $f > "$f.pdf"
done
