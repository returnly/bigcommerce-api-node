curl \
  -X POST \
  -H "Authorization: Token token=\"$BUILDKITE_TEST_ANALYTICS_TOKEN\"" \
  -F "data=@coverage/results.xml" \
  -F "format=junit" \
  -F "run_env[CI]=buildkite" \
  -F "run_env[key]=$BUILDKITE_BUILD_ID" \
  -F "run_env[url]=$BUILDKITE_BUILD_URL" \
  -F "run_env[branch]=$BUILDKITE_BRANCH" \
  -F "run_env[commit_sha]=$BUILDKITE_COMMIT" \
  -F "run_env[number]=$BUILDKITE_BUILD_NUMBER" \
  -F "run_env[job_id]=$BUILDKITE_JOB_ID" \
  -F "run_env[message]=$BUILDKITE_MESSAGE" \
  https://analytics-api.buildkite.com/v1/uploads

printf '<h3>Summary</h2>\n\n' | buildkite-agent annotate --style 'info' --append --context 'ctx-summary'

printf '<h5>Code Coverage</h5>\n\n' | buildkite-agent annotate --style 'info' --append --context 'ctx-summary'
COVERAGE=$(npm run coverage)
printf '```term%s\n```\n\n' "$COVERAGE" | buildkite-agent annotate --style 'info' --append --context 'ctx-summary'

printf 'Read the <a href="artifact://coverage/index.html"> uploaded coverage report</a>' | buildkite-agent annotate --style 'info' --append --context 'ctx-summary'