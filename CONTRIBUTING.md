## Submitting a Pull Request

1. Check out [the Development section][development] in the README for instructions on setting up the project for local development.
2. [Fork the repository.][fork]
3. [Create a topic branch.][branch]
4. Add specs for your unimplemented feature or bug fix.
5. Run `rake spec`. If your specs pass, return to step 4.
6. Implement your feature or bug fix.
7. Run `rake spec`. If your specs fail, return to step 6.
8. Run `open coverage/index.html`. If your changes are not completely covered
   by your tests, return to step 4.
9. Add documentation for your feature or bug fix.
10. Add, commit, and push your changes. For documentation-only fixes, please
    add "[ci skip]" to your commit message to avoid needless CI builds.
11. [Submit a pull request.][pr]

[development]: https://github.com/helium/helium-ruby#development
[fork]: https://help.github.com/articles/fork-a-repo
[branch]: https://help.github.com/articles/creating-and-deleting-branches-within-your-repository/
[pr]: https://help.github.com/articles/using-pull-requests
