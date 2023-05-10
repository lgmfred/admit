## Seeding database with a larger random dataset
alias Inspect.Admit.Accounts
alias Admit.Accounts
alias Admit.Adverts
alias Admit.Adverts.Advert
alias Admit.Applications.Application
alias Admit.Classes.Class
alias Admit.Repo
alias Admit.Schools.School
alias Admit.Students.Student

levels = ["nursery", "primary", "secondary"]

classes = %{
  "nursery" => ["Baby", "Middle", "Top"],
  "primary" => Enum.map(1..7, fn x -> "P.#{x}" end),
  "secondary" => Enum.map(1..6, fn x -> "S.#{x}" end)
}

application_statuses = ["submitted", "review", "interview", "accepted", "rejected"]

## Create 30 random system users
rand_sys_users =
  Enum.map(1..30, fn _ ->
    {:ok, user} =
      %{email: Faker.Internet.safe_email(), password: "Hello World!"}
      |> Accounts.register_user()

    user
  end)

## Create 30 schools with users 1 to 3o as admins
Enum.zip_reduce(1..30, rand_sys_users, [], fn _, user, _acc ->
  # Create the school and the classes
  school =
    %School{
      address: Faker.Address.street_address(),
      email: Faker.Internet.safe_email(),
      level: Enum.random(levels),
      name: Faker.Team.name() <> " School",
      telephone: Faker.Phone.EnGb.landline_number()
    }
    |> Repo.insert!()

  ## Create classes in the school
  _school_classes =
    Map.get(classes, school.level, [])
    |> Enum.map(fn class_name ->
      %Class{
        school_id: school.id,
        name: class_name,
        description: Faker.Lorem.sentence(10)
      }
      |> Repo.insert!()
    end)

    ## Create adverts for 3 random classes
    |> Enum.shuffle()
    |> Enum.take(3)
    |> Enum.each(fn class ->
      %Advert{
        school_id: school.id,
        class_id: class.id,
        deadline: Date.add(Date.utc_today(), Enum.random(2..42)),
        description: "#{school.name} #{class.name} class vacancy advert"
      }
      |> Repo.insert!()
    end)
end)

# Create 30 normal user acting as a parent

parent_users =
  Enum.map(1..30, fn _ ->
    {:ok, user} =
      %{email: Faker.Internet.safe_email(), password: "Hello World!"}
      |> Accounts.register_user()

    user
  end)

## Each user has a random number of students between 1 and 6
new_students =
  Enum.map(parent_users, fn user ->
    Enum.to_list(1..Enum.random(1..6))
    |> Enum.map(fn _ ->
      %Student{
        name: Faker.Person.Fr.name(),
        email: Faker.Internet.safe_email(),
        user_id: user.id,
        birth_date: Faker.Date.between(~D[2005-08-16], ~D[2015-08-16])
      }
      |> Repo.insert!()
    end)
  end)

shuffled_students = List.flatten(new_students) |> Enum.shuffle()
shuffled_adverts = Adverts.list_adverts() |> Enum.shuffle()

Enum.zip_reduce(shuffled_students, shuffled_adverts, [], fn student, advert, _acc ->
  %Application{
    user_id: student.user_id,
    student_id: student.id,
    advert_id: advert.id,
    school_id: advert.school_id,
    status: Enum.random(application_statuses),
    documents: ["/uploads/#{student.name}_documents"]
  }
  |> Repo.insert!()
end)
