### To remove a submodule you need to:
1. Delete the relevant section from the .gitmodules file.
1. Stage the .gitmodules changes git add .gitmodules
1. Delete the relevant section from .git/config.
1. Run git rm --cached path_to_submodule (no trailing slash).
1. Run rm -rf .git/modules/path_to_submodule (no trailing slash).
1. Commit git commit -m "Removed submodule "
1. Delete the now untracked submodule files rm -rf path_to_submodule
  ~~~sh
      git submodule deinit <path_to_submodule>
      git rm <path_to_submodule>
      git commit-m "Removed submodule "
      rm -rf .git/modules/<path_to_submodule>
  ~~~
-----
## References
1. https://gist.github.com/myusuf3/7f645819ded92bda6677
1. https://www.vogella.com/tutorials/GitSubmodules/article.html
