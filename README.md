# Learn Create

This gem is designed to aid in the creation of learn lessons.

## Installation and Setup

Before using `learn_create`, you must install `hub`, GitHub's extended CLI API.

```sh
brew install hub
```

Once `hub` is installed, you'll need to get it configured before running
`learn_create`. The best way to do this is to use `hub` once to create a
repository on learn-co-curriculum. In the shell:

- Create a new, empty folder and `cd` into it
- `git init` to create an initial git repo
- Run `hub create learn-co-curriculum/<whatever name you've chosen>`
  - You should be prompted to sign into GitHub
  - **Note:** If you have set up two-factor identification on GitHub, when
    prompted for your password, you have two options:
    - If Github SMS' you a one-time password, use it!
    - Otherwise, instead of using your normal password, you
      need to enter a personal access token. You can create a token in your
      GitHub settings page.
- If everything works as expected you should now have an empty `learn-co-curriculum` repo.
- Delete the repo. Everything should be set up now.

Install the `learn_create` gem:

```sh
gem install learn_create
```

## Usage

To create a new learn repository, navigate to the folder where you'd like your
repo to be created locally. Type:

```sh
learn_create
```

Follow the command line prompts for setting up and naming your repository. The
repo will be created locally and pushed to GitHub. When finished, you can `cd`
into the local folder or open it on github to start working.

## Resources

- [Hub]

[hub]: https://hub.github.com/hub.1.html
