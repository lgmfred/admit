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

levels = ["Nursery", "Primary", "Secondary"]

classes = %{
  "Nursery" => ["Baby", "Middle", "Top"],
  "Primary" => Enum.map(1..7, fn x -> "P.#{x}" end),
  "Secondary" => Enum.map(1..6, fn x -> "S.#{x}" end)
}

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

## Create A school with user1

{:ok, school} =
  case Repo.get_by(School, name: "simibili primary school") do
    %School{} = school ->
      IO.inspect(school.name, label: "School Already Created")
      {:ok, school}

    nil ->
      school_attrs = %{
        address: Faker.Address.street_address(),
        email: Faker.Internet.safe_email(),
        level: "Primary",
        name: "simibili primary school",
        telephone: Faker.Phone.EnGb.landline_number()
      }

      Schools.create_school(school_attrs, user1)
  end

# Add classes to the school
school_classes = Map.get(classes, school.level, [])

Enum.each(school_classes, fn class_name ->
  case Repo.get_by(Class, name: class_name) do
    %Class{} = class ->
      IO.inspect(class.name, label: "Class Already Created")
      {:ok, school}

    nil ->
      class_attrs = %{
        school_id: school.id,
        name: class_name,
        description: Faker.Lorem.sentence(3)
      }

      Classes.create_class(class_attrs)
  end
end)

## Create A school with user2 as admin

{:ok, school} =
  case Repo.get_by(School, name: "St. Joseph's College Paranga") do
    %School{} = school ->
      IO.inspect(school.name, label: "School Already Created")
      {:ok, school}

    nil ->
      school_attrs = %{
        address: Faker.Address.street_address(),
        email: Faker.Internet.safe_email(),
        level: "Secondary",
        name: "St. Joseph's College Paranga",
        telephone: Faker.Phone.EnGb.landline_number()
      }

      Schools.create_school(school_attrs, user2)
  end

# Add classes to the school
school_classes = Map.get(classes, school.level, [])

Enum.each(school_classes, fn class_name ->
  case Repo.get_by(Class, name: class_name) do
    %Class{} = class ->
      IO.inspect(class.name, label: "Class Already Created")
      {:ok, school}

    nil ->
      class_attrs = %{
        school_id: school.id,
        name: class_name,
        description: Faker.Lorem.sentence(3)
      }

      Classes.create_class(class_attrs)
  end
end)
