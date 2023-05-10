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
alias Admit.Adverts
alias Admit.Adverts.Advert
alias Admit.Applications
alias Admit.Applications.Application
alias Admit.Classes
alias Admit.Classes.Class
alias Admit.Repo
alias Admit.Schools
alias Admit.Schools.School
alias Admit.Students
alias Admit.Students.Student

users_params = [
  {"test@test.com", "password123!"},
  {"email@email.com", "password123!"},
  {"admit@admit.com", "password123!"}
]

schools = [
  {"nursery", "Fancy-schmancy Nursery School"},
  {"primary", "Hoity-toity Primary School"},
  {"secondary", "The Usual Suspects School"}
]

classes = %{
  "nursery" => ["Baby", "Middle", "Top"],
  "primary" => Enum.map(1..7, fn x -> "P.#{x}" end),
  "secondary" => Enum.map(1..6, fn x -> "S.#{x}" end)
}

application_statuses = ["submitted", "review", "interview", "accepted", "rejected"]

## Create 3 system users
users =
  Enum.map(users_params, fn {email, password} ->
    {:ok, user} =
      case Repo.get_by(User, email: email) do
        %User{} = user ->
          IO.inspect(user.email, label: "User Already Created")
          {:ok, user}

        nil ->
          user_attrs = %{email: email, password: password}
          Accounts.register_user(user_attrs)
      end

    user
  end)

## Create 3 schools with users 1 to 3 as admins
# {"nursery", "Fancy-schmancy Nursery School"}

school_user_zip = Enum.zip(users, schools)

Enum.each(school_user_zip, fn {user, {level, name}} ->
  # Create school
  {:ok, school} =
    case Repo.get_by(School, name: name) do
      %School{} = school ->
        IO.inspect(school.name, label: "School Already Created")
        {:ok, school}

      nil ->
        school_attrs = %{
          address: Faker.Address.street_address(),
          email: level <> "@mail.com",
          level: level,
          name: name,
          telephone: Faker.Phone.EnGb.landline_number()
        }

        Schools.create_school(school_attrs, user)
    end

  # Add classes to the school

  school_classes = Map.get(classes, school.level, [])

  Enum.map(school_classes, fn class_name ->
    {:ok, class} =
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

    class
  end)

  # Add 3 adverts for 3 random classes
  |> Enum.shuffle()
  |> Enum.take(3)
  |> Enum.each(fn class ->
    advert_description = class.name <> " class vacancy advert"

    {:ok, _advert} =
      case Repo.get_by(Advert, description: advert_description) do
        %Advert{} = advert ->
          IO.inspect(advert.description, label: "Advert Already Created")
          {:ok, advert}

        nil ->
          advert_params = %{
            school_id: school.id,
            class_id: class.id,
            deadline: Date.add(Date.utc_today(), Enum.random(2..42)),
            description: advert_description
          }

          Adverts.create_advert(advert_params)
      end
  end)
end)

## Create a normal user acting as a parent

{:ok, user} =
  case Repo.get_by(User, email: "lgmfred@ayikoyo.com") do
    %User{} = user ->
      IO.inspect(user.email, label: "User Already Created")
      {:ok, user}

    nil ->
      user_attrs = %{email: "lgmfred@ayikoyo.com", password: "password123!"}
      Accounts.register_user(user_attrs)
  end

## Normal user creates students

student_names = [
  "Keyser Söze",
  "Roger Verbal Kint",
  "Fred Fenster",
  "Dean Keaton",
  "Michael McManus",
  "Lawyer Kobayashi"
]

students =
  Enum.map(student_names, fn name ->
    {:ok, student} =
      case Repo.get_by(Student, name: name) do
        %Student{} = student ->
          IO.inspect(student.email, label: "Student Already Created")
          {:ok, student}

        nil ->
          student_attrs = %{
            name: name,
            email: Faker.Internet.safe_email(),
            user_id: user.id,
            birth_date: Faker.Date.between(~D[2005-08-16], ~D[2015-08-16])
          }

          Students.create_student(student_attrs)
      end

    student
  end)
  |> Enum.shuffle()

adverts = Adverts.list_adverts() |> Enum.shuffle()

Enum.zip_reduce(students, adverts, [], fn student, advert, acc ->
  {:ok, application} =
    case Repo.get_by(Application, student_id: student.id) do
      %Application{} = application ->
        IO.inspect(application.status, label: "Application Already Created")
        {:ok, student}

      nil ->
        application_params = %{
          user_id: user.id,
          student_id: student.id,
          advert_id: advert.id,
          school_id: advert.school_id,
          status: Enum.random(application_statuses),
          documents: ["/uploads/#{student.name}_documents"]
        }

        Applications.create_application(application_params)
    end

  [application | acc]
end)
