# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Lurnex** is a Rails 8 LMS (Learning Management System) foundation that validates native Rails 8 capabilities without external dependencies (no Devise, no Redis, no Sidekiq).

## Common Commands

All commands run inside Docker:

```bash
make setup          # First-time: build images, create & migrate DB
make start          # Start containers
make bash           # Shell into web container
make rails-console  # Open Rails console
make test           # Run full test suite
make db-migrate     # Run pending migrations
make db-rollback    # Revert the last migration
make db-seed        # Run db/seeds.rb
make db-reset       # Drop and recreate database (dev only)
make logs-web       # Tail web container logs
make down           # Stop and remove containers
make generate ARGS="model Foo bar:string"  # Run rails generate
```

**Running tests:**
```bash
docker compose exec web rails test                              # Full suite
docker compose exec web rails test test/models/user_test.rb    # Single file
docker compose exec web rails test test/models/user_test.rb:5  # Specific line
docker compose exec web rails test:system                      # Capybara system tests
```

**Linting:**
```bash
bin/rubocop -f github   # Check (GitHub format, used in CI)
bin/rubocop --fix       # Auto-fix
```

## Architecture

### Rails 8 Native Stack

This project deliberately avoids external infrastructure dependencies by using Rails 8's built-in alternatives:

| Concern | Solution | Gem |
|---|---|---|
| Authentication | Custom (`has_secure_password` + signed cookies) | `bcrypt` |
| Background jobs | Solid Queue (database-backed) | `solid_queue` |
| Caching | Solid Cache (database-backed) | `solid_cache` |
| WebSockets | Solid Cable (database-backed) | `solid_cable` |
| Assets | Propshaft + Importmap | built-in |

### Authentication

No Devise. Authentication lives in [app/controllers/concerns/authentication.rb](app/controllers/concerns/authentication.rb) and is included in `ApplicationController`.

- `has_secure_password` on `User` (bcrypt)
- Sessions are database rows (`Session` model), stored via a signed cookie (`session_id`)
- Thread-local context via `Current < ActiveSupport::CurrentAttributes` — access `Current.user`, `Current.membership`, `Current.organization` anywhere (`Current.user` is delegated through `Current.session`)
- `allow_unauthenticated_access` skips the before-action for public endpoints
- `require_admin!` redirects to student dashboard if current membership is not admin
- On every authenticated request, `set_current_organization_context` resolves the active org from `session[:current_organization_id]`, falling back to the user's first admin membership, then oldest membership

### Multi-Organization Model

Users belong to multiple organizations through `Membership`. The key relationships:

```
User --< Session
User --< Membership >-- Organization
                |
                +--< Enrollment >-- Course
                |         \-- CourseProgress
                +--< Invite
```

- `Membership#role` enum: `admin` (0) or `student` (1)
- `Current.organization` is set from the session; users can switch via `PATCH /organization/switch`
- `Enrollment` denormalizes `organization_id` (same org as both its membership and course). A validation enforces this three-way consistency.
- `Enrollment` validates that the membership's role is `:student`
- `CourseProgress` (has_one on Enrollment) tracks `percentage` (0–100) and `completed_at`

### Registration Flow

`UsersController#create` handles two paths in a single transaction:

1. **With invite token** — accepts the invite (`Invite#accept_for!`), which does `find_or_create_by!` on `Membership`
2. **Without invite token** — creates a new `Organization` from `params[:organization_name]` and an admin `Membership` for the new user

After either path, `start_new_session_for` is called and the user lands on their dashboard.

### Controller Namespaces

- `Admin::BaseController < ApplicationController` — adds `before_action :require_admin!`; all admin controllers inherit from it
- `Student::BaseController < ApplicationController` — no extra restrictions; student controllers inherit from it
- `DashboardController#index` redirects to the correct namespace based on current role

### Routes

```ruby
root "dashboard#index"
resource :session                              # login/logout
resource :registration, controller: :users    # signup (UsersController)
resources :passwords, param: :token
get "invites/:token", to: "invites#show"

namespace :admin do
  resource :dashboard, only: :show
  resources :courses, only: %i[index new create]
  resources :enrollments, only: :create
  resources :invites, only: %i[index create]
end

namespace :student do
  resource :dashboard, only: :show
  resource :profile, only: %i[edit update]
end

resource :organization, only: [] do
  patch :switch
end
```

## Testing

- Framework: Minitest (Rails default), parallel execution enabled
- Fixtures in `test/fixtures/`
- `test/test_helpers/session_test_helper.rb` — `sign_in_as(user)` sets `Current.session` and the `session_id` cookie; it does **not** set `Current.membership` or `Current.organization` (those are resolved by `set_current_organization_context` on the next request)
- CI runs Brakeman (security), Bundler-audit (gem CVEs), RuboCop, unit tests, and system tests

## CI/CD

GitHub Actions at [.github/workflows/ci.yml](.github/workflows/ci.yml) runs five jobs: `scan_ruby` (Brakeman + bundler-audit), `scan_js` (importmap audit), `lint` (RuboCop), `test`, and `system-test`. Screenshots are archived on system-test failures.

## Database

PostgreSQL 17. Connection via `DATABASE_URL` env var or individual `DATABASE_*` vars. The `docker-compose.yml` sets `POSTGRES_USER=postgres / POSTGRES_PASSWORD=postgres`.
