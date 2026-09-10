# Run using bin/ci

CI.run do
  step "oxlint", "npm run lint"
  step "oxfmt", "npm run fmt"
  step "knip", "npm run knip"
  step "tsc", "npm run typecheck"
  step "rubocop", "bin/rubocop"
  step "brakeman", "bin/brakeman"
  step "rspec", "bundle exec rspec"
end
