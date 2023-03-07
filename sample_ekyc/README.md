## HD Saison Mobile Project (Readme version \_\_\_)

### Libraries & Tools Used

- [dio]()
- [flutter_bloc]()
- [shared_preferences]()
- [firebase_core]()
- [firebase_remote_config]()
- [firebase_messaging]()
- ...

### Folder Structure

Here is the core folder structure:

```terminal
flutter-app/
|- android
|- assets
|- build
|- ios
|- lib
|- test
```

Here is the folder structure we have been using in this project:

```terminal
lib/
|- src/
  |- BLOC/
  |- configs/
  |- constants/
  |- data/
  |- helper/
  |- navigations/
  |- UI
|- main.dart
```

Now, lets dive into the lib folder which has the main code for the application's src.

```terminal
1- BLOC - All Back End logic of app is defined here
2- configs - Define configs
3- constants - Constants used in app
4- data - Include local data and remote data repositories
5- helpers - Define some simple service
6- navigations - Define Routes, Screens, Navigator Animation,...
7- UI - All design, ui and Front-End logic is defined in here
```

#### Documents of Project

### How can I maintain the project?

[Update Later]()

# --------------- GIT CONVENTION ---------------

### Rules of commiting code

- Commit message must has a type-prefix (noun), e.g: feat, fix,... which bringing a scope (if it's exist),
  a colon and a space and a description in its tail.
  For Example: git commit -m "feat(eKYC): update full-face scanning feature"
- Commit breaking change must has the UPPERCASE type-prefix by "BREAKING CHANGE" and a colon follow it.
  And a certain desription which telling about the changing of API.
  For Example: BREAKING CHANGE: environment variables now take precedence over config files.
- ...

### Some popular type-prefix

    1.1. feat: Adding a new feature

    1.2. fix: Fixing bugs

    1.3. refactor: Refacting code but it's not equal to both fixing and adding new feat

    1.4. docs: adding/mofifing documents

    1.5. chore: some small modification which is not making big impact for code

    1.6. style: some modification which is not change the logic of code

    1.7. perf: performance-improvement code

    1.8. vendor: version-update (updating about dependencies, packages,...)
