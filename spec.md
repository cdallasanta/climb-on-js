#Rails App with JavaScript Frontend Spec

##Project Specs:
[x] Must have a Rails Backend and new requirements implemented through JavaScript.
[] Makes use of ES6 features as much as possible(e.g Arrow functions, Let & Const, Constructor Functions)
[x] Must translate the JSON responses into Javascript Model Objects using either ES6 class or constructor syntax. 
  - class PeriodicInspection
[x] Must render at least one index page (index resource - 'list of things') via JavaScript and an Active Model Serialization JSON Backend.
  - elements/:id, "show all periodic inspections"
[x] Must render at least one show page (show resource - 'one specific thing') via JavaScript and an Active Model Serialization JSON Backend.
  - elements/:id/periodic_inspections/:id/new, when selecting a date, performs a get call
[x] Your Rails application must reveal at least one `has-many` relationship through JSON that is then rendered to the page.
  - periodic has many comments
[x] Must use your Rails application to render a form for creating a resource that is submitted dynamically through JavaScript.
  - creating/updating periodic inspections
[x] At least one of the JS Model Objects must have a method on the prototype.
  - Periodic Inspecions has many for updating the page

##Project Repo Specs:
[x] Read Me file contains:
  [x] Application Description
  [x] Installation guide (e.g. fork and clone repo, migrate db, bundle install, etc)
  [x] Contributors guide (e.g. file an issue, file an issue with a pull request, etc)
  [x] Licensing statement at the bottom (e.g. This project has been licensed under the MIT open source license.)
[x] Repo General
  [x] You have a large number of small Git commits
  [x] Your commit messages are meaningful
  [x] You made the changes in a commit that relate to the commit message
  [x] You don't include changes in a commit that aren't related to the commit message