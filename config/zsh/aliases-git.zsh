# aliases-git.zsh
# Aliases follow a simple pattern of {Object}{Verb}{Argument}.
# Original idea taken from
# http://floatboth.com/where-i-set-up-my-git-and-hg-aliases-like-a-boss

# [b]ranches {{{
alias vbM='git-branch-merge'
alias vbRr='git-branch-remove-remote'
alias vbR='git-branch-remove'
alias vbc='git branch-create'
alias vbla='git branch-list -a'
alias vblr='git branch-list-remote'
alias vbl='git branch-list'
alias vbmd='vbm develop'
alias vbmi='git branch-merge-interactive'
alias vbmm='vbm master'
alias vbmv='git-branch-rename'
alias vbm='git-branch-rebase'
alias vbpl='git branch-pull'
alias vbpsh='git branch-push-heroku'
alias vbps='git branch-push'
alias vbsd='git checkout develop'
alias vbsm=' git checkout master'
alias vbsqd='git-branch-squash develop'
alias vbsqm='git-branch-squash master'
alias vbsq='git-branch-squash'
alias vbs-='git checkout -'
alias vbs='git-branch-switch'
alias vbu='git branch-update'
alias vb.='git branch-current'
alias vb?='git branch-exists'
# }}}
# [c]ommits {{{
alias vcRa='git commit-remove-all'
alias vcR='git commit-remove'
alias vca='git commit-all'
alias vcc='git commit -v'
alias vce='git commit-edit'
alias vcf='git commit-search'
alias vcla='git peek -p -D'
alias vcl+='git peek --stat'
alias vcl='git peek'
alias vcri='git rebase -i'
alias vcv='git show'
alias vcz='git commit-cancel'
alias vc.='git commit-current'
# }}}
# [c]herry [p]ick {{{
alias vcp='git cherry-pick'
# }}}
# working [d]irectory {{{
alias vdc='git-directory-create'
alias vdcl='git tabula-rasa'
alias vde='vim $(git root)/.git/config'
alias vdl='git status --short'
alias vdr='cd $(git root)'
alias vdrr='vdr && cd .. && vdr'
# }}}
# [f]iles {{{
alias vfR='git rm -r'
alias vfa='git-file-add'
alias vfd='git diff -w --color-words'
alias vfdc='git diff -w --color-words --cached'
alias vfds='git diff-staged --'
alias vffc='git fix-conflicts'
alias vffj='git fix-jshint'
alias vfmv='git mv'
alias vfr='git-file-revert'
alias vfrez='git resurrect'
alias vfu='git-file-unstage'
alias vfua='git reset'
# }}}
# [g]it {{{
alias vgv='git git-version'
# }}}
# [p]ull [r]equests {{{
alias vprcd='git-pullrequest-create develop'
alias vprcm='git-pullrequest-create master'
alias vprc='git-pullrequest-create'
# }}}
# [re]base {{{
alias vrea='git rebase --abort'
alias vrec='git rebase --continue'
alias vres='git rebase --skip'
# }}}
# [r]emote {{{
alias vrR='git-remote-remove'
alias vrc='git remote-create'
alias vrl='git remote-list'
alias vrmv='git-remote-rename'
alias vrs='git-remote-switch'
alias vru='git-remote-url'
alias vro='git-remote-owner'
alias vr.='git remote-current'
alias vr?='git remote-exists'
# }}}
# [t]ags {{{
alias vtRr='git-tag-remove-remote'
alias vtR='git-tag-remove'
alias vtc='git tag-create'
alias vtlr='git tag-list-remote'
alias vtl='git tag-list'
alias vtpl='git fetch --tags'
alias vtps='git tag-push'
alias vts='git-tag-switch'
alias vt.a='git tag-current-all'
alias vt.='git tag-current'
alias vt?r='git tag-exists-remote'
alias vt?='git tag-exists'
# }}}
# [s]tashes {{{
alias vst='git stash-create'
alias vstR='git stash drop'
alias vstRa='git stash clear'
alias vsta='git stash-apply'
alias vstl='git stash list'
# }}}
# [s]ub-[m]odules {{{
alias vsmc='git submodule-create'
alias vsmi='git submodule init'
alias vsmu='git submodule update'
alias vsmR='git-submodule-remove'
alias vsm?='git-is-submodule'
# }}}
# [p]rivate [s]ub-[m]odule {{{
alias vcsmp='git commit-private-submodule'
alias vpsmu='git commit-private-submodule'
alias vsmcp='git commit-private-submodule'
alias vsmpu='git commit-private-submodule'
# }}}
