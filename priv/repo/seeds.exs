# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Admit.Repo.insert!(%Admit.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Admit.Accounts
alias Admit.Accounts.User
alias Admit.Classes
alias Admit.Classes.Class
alias Admit.Repo
alias Admit.Schools
alias Admit.Schools.School
alias Admit.Students
alias Admit.Students.Student

## Create 3 default users to be used as school admins
{:ok, user1} =
  case Repo.get_by(User, email: "test@test.com") do
    %User{} = user ->
      IO.inspect(user.email, label: "User Already Created")
      {:ok, user}

    nil ->
      user_attrs = %{email: "test@test.com", password: "password123!"}
      Accounts.register_user(user_attrs)
  end

{:ok, user2} =
  case Repo.get_by(User, email: "email@email.com") do
    %User{} = user ->
      IO.inspect(user.email, label: "User Already Created")
      {:ok, user}

    nil ->
      user_attrs = %{email: "email@email.com", password: "password123!"}
      Accounts.register_user(user_attrs)
  end

{:ok, _user3} =
  case Repo.get_by(User, email: "admit@admit.com") do
    %User{} = user ->
      IO.inspect(user.email, label: "User Already Created")
      {:ok, user}

    nil ->
      user_attrs = %{email: "admit@admit.com", password: "password123!"}
      Accounts.register_user(user_attrs)
  end

## Create A school with user1 and user2 as admins

{:ok, school} =
  case Repo.get_by(School, name: "Abcd highschool ituri") do
    %School{} = school ->
      IO.inspect(school.name, label: "School Already Created")
      {:ok, school}

    nil ->
      school_attrs = %{
        address: "Plot 617 Ituri street",
        email: "abcd@ituri.com",
        level: "highschool",
        name: "Abcd highschool ituri",
        telephone: "0987654321"
      }

      Schools.create_school(school_attrs, user1)
  end

# Add user2 as the second admin for the school
{:ok, _school} =
  if user2.school_id == school.id do
    {:ok, school}
  else
    Schools.add_admin(school.id, user2.email)
  end
