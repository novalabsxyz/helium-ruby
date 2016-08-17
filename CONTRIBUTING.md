## Contributing

We value contributions from the community and will do everything we can go get them reviewed in a timely fashion. If you have code to send our way or a bug to report:

* Contributing Code: If you have new code or a bug fix, fork this repo, create a logically-named branch, and submit a PR against this repo. Include a write up of the PR with details on what it does.

* Reporting Bugs: Open an issue against this repo with as much detail as you can. At the very least you'll include steps to reproduce the problem.

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the Contributor Covenant](http://contributor-covenant.org) Code of Conduct.

Above all, thank you for taking the time to be a part of the Helium community.

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
10. Run bundle exec rake doc:yard. If your changes are not 100% documented, go back to step 9.
11. Add, commit, and push your changes. For documentation-only fixes, please
    add "[ci skip]" to your commit message to avoid needless CI builds.
12. [Submit a pull request.][pr]

[development]: https://github.com/helium/helium-ruby#development
[fork]: https://help.github.com/articles/fork-a-repo
[branch]: https://help.github.com/articles/creating-and-deleting-branches-within-your-repository/
[pr]: https://help.github.com/articles/using-pull-requests
